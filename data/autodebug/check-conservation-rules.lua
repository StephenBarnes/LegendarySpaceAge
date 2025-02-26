--[[ This file checks that conservation rules are followed.
Currently conservation rules are:
	* water - check that steam/ice/water is never created or destroyed.
	* carbon - we assume there's a certain amount of carbon in each item/fluid, and then check that no recipes are net-positive. (This is important eg on Vulcanus, where there's lots of energy and fuel (sulfur) but we still want to make carbon scarce.)
	* "fuel potential" - we assign a "fuel potential" to each item/fluid, measuring how much fuel it's equivalent to. The item's actual fuel value, if it has one, should be at most this. Some fluids (eg tar) will have fuel value lower than their potential, but can be converted to other items/fluids to realize that fuel potential. This ensures there's no loop of recipes you can do that will produce infinite fuel.
]]

-- TODO get table from recipe to machines that support it, then use that (plus efficiency and speed bonuses, etc.) to compute fuel? Eg for syngas.

local Util = require("data.autodebug.util")

------------------------------------------------------------------------
--- GENERAL FUNCTIONS FOR ALL CONSERVATION CHECKS.

---@param content table<string, number>
---@param side data.IngredientPrototype[]|data.ProductPrototype[]
---@param includeProd boolean
---@param maxProd number?
---@return number
---Counts how much of some conserved quantity is on one side (ingredients or results) of a recipe. Prod should only be included for results, not ingredients.
local function countRecipeSide(content, side, includeProd, maxProd)
	local total = 0
	for _, item in pairs(side) do
		local itemContent = content[item.name]
		if itemContent ~= nil then
			local amount
			if item.amount ~= nil then
				amount = item.amount
			elseif item.amount_min then
				assert(item.amount == nil)
				amount = (item.amount_min + item.amount_max) * 0.5
			else
				error("Invalid recipe side item: " .. serpent.block(item))
			end

			if item.probability ~= nil then
				amount = amount * item.probability
			end

			if item.extra_count_fraction ~= nil then
				amount = amount + item.extra_count_fraction
			end

			if includeProd then
				local amountExcluded = item.ignored_by_productivity or 0
				amountExcluded = math.min(amountExcluded, amount)
				local amountIncluded = amount - amountExcluded
				amount = amountIncluded * (1 + maxProd) + amountExcluded
			end

			total = total + amount * itemContent
		end
	end
	return total
end

---@param conservedName string
---@param recipe data.RecipePrototype
---@param contentTable table<string, number>
---@param nonConservingRecipes table<string, boolean>
---@return boolean
---Checks that a conservation rule is followed for a recipe.
local function checkConservationRule(conservedName, recipe, contentTable, nonConservingRecipes)
	if nonConservingRecipes[recipe.name] then
		return true
	end
	local totalIn = countRecipeSide(contentTable, recipe.ingredients, false)
	local totalOut = countRecipeSide(contentTable, recipe.results, false)
	if totalOut > totalIn then
		if recipe.allow_productivity then
			log("Recipe " .. recipe.name .. " consumes " .. totalIn .. " " .. conservedName .. " but produces " .. totalOut .. " even before prod bonus.")
		else
			log("Recipe " .. recipe.name .. " consumes " .. totalIn .. " " .. conservedName .. " but produces " .. totalOut .. ". (Prod disabled.)")
		end
		return false
	end
	if recipe.allow_productivity then
		local maxProd = recipe.maximum_productivity
		if maxProd == nil then maxProd = 3 end
		local totalOutWithProd = countRecipeSide(contentTable, recipe.results, true, maxProd)
		if totalOutWithProd > totalIn then
			log("Recipe " .. recipe.name .. " consumes " .. totalIn .. " " .. conservedName .. " and produces " .. totalOut .. ", but with +" .. maxProd * 100 .. "% prod bonus produces " .. totalOutWithProd .. ".")
			return false
		end
	end
	return true
end

---@param content table<string, number>
---Given table of contents (eg how much water is in each fluid/item), add entries for barrels of each item.
local function addBarrelContent(content)
	local newEntries = {}
	for name, amount in pairs(content) do
		newEntries[name .. "-barrel"] = amount * FLUID_PER_BARREL
	end
	for name, amount in pairs(newEntries) do
		content[name] = amount
	end
end

------------------------------------------------------------------------
--- WATER CONSERVATION.

-- Table of how much water is contained in each item/fluid.
local waterContent = {
	["water"] = 1,
	["steam"] = 0.1,
	["ice"] = 20,
	["slime"] = 2,
	["chitin-broth"] = .5,
	["syngas"] = .04,

	["oxide-asteroid-chunk"] = 2000,
		-- If this is X, the crushing recipe is (X -> 400 + .8 X) so we need X >= 400 / .2 = 2000.
	["metallic-asteroid-chunk"] = 1600, -- Because can produce up to 80% chance of oxide chunk.
	["carbonic-asteroid-chunk"] = 1600, -- Same.

	-- Non-producible raw materials, should be fine.
	["scrap"] = 2.4,
	["fulgoran-sludge"] = 0.1,
	["ammoniacal-solution"] = 100,
	["lake-water"] = 4,
	["volcanic-gas"] = 1,

	["chitin-fragments"] = 20,
	--[[ There's a loop (water -> chitin broth -> tubules + slime -> water) that actually allows net positive water with +300% prod. But it requires chitin fragments as input, and that's a limited resource, so considering them to contain water for purposes of conservation.
	With +300% prod:
	* 100 water + 100 water in the chitin fragments -> 400 chitin broth (1:2)
	* 50 chitin broth -> 10 slime (5:1), prod disabled; or 400 -> 80.
	* 100 slime -> 200 water (1:2); or 80 -> 160.
	So with 20 water in each chitin fragment, this is 200 -> 160 water, so net negative.
	]]
}
-- Recipes where we're fine with them producing water out of nothing.
local nonWaterConservingRecipes = Table.listToSet{
	"deep-drill-fulgora",
	"deep-drill-nauvis",
	"deep-drill-gleba",
}

-- Function run before checking conservation rules for all recipes. This is in a separate function so we don't waste time running it if debug checks are disabled.
local function initializeWaterConservation()
	addBarrelContent(waterContent)
end

---@param recipe data.RecipePrototype
---@return boolean
---Checks that water conservation rule is followed for the given recipe.
local function checkWaterConservation(recipe)
	return checkConservationRule("water", recipe, waterContent, nonWaterConservingRecipes)
end

------------------------------------------------------------------------
--- CARBON CONSERVATION.

-- Table of how much carbon is contained in each item/fluid.
local carbonContent = {
	["carbon"] = 1,
	["pitch"] = 1,
	["ash"] = 1,
	["syngas"] = 7.5/10,
	["resin"] = .25,

	["tar"] = .16,
	["heavy-oil"] = .11,
	["light-oil"] = .1,
	["petroleum-gas"] = .1,
	["dry-gas"] = .1,

	-- Raw materials, can set these to high numbers.
	["coal"] = 10,
	["crude-oil"] = 1,
	["natural-gas"] = 1,
	["volcanic-gas"] = 1,
	["scrap"] = 10,
	["fulgoran-sludge"] = 10,
	["carbonic-asteroid-chunk"] = 1000,
	["metallic-asteroid-chunk"] = 1000,
	["oxide-asteroid-chunk"] = 1000,

	-- Materials that can be produced via farming, without carbon input, but that's intended.
	["wood"] = 100,
	["slipstack-pearl"] = 100,
	["boomsac"] = 200,

	-- End products not used to make carbon-containing items, so can set these to low numbers.
	["solid-fuel"] = 0,
}

-- Recipes where we're fine with them producing carbon out of nothing.
local nonCarbonConservingRecipes = Table.listToSet{
	"deep-drill-fulgora",
	"deep-drill-nauvis",
	"deep-drill-gleba",
	"deep-drill-vulcanus",
}

local function initializeCarbonConservation()
	addBarrelContent(carbonContent)
	-- The gasifier turns steam into syngas (which contains carbon). It consumes fuel which contains carbon, so we need to find out the most carbon-efficient fuel it can be fed, to add that to the syngas recipe.
	-- TODO
end

---@param recipe data.RecipePrototype
---@return boolean
local function checkCarbonConservation(recipe)
	return checkConservationRule("carbon", recipe, carbonContent, nonCarbonConservingRecipes)
end

------------------------------------------------------------------------
--- FUEL POTENTIAL CONSERVATION.

local function initializeFuelPotentialConservation()
	-- TODO implement.
end

---@param recipe data.RecipePrototype
---@return boolean
local function checkFuelPotentialConservation(recipe)
	-- TODO implement.
	return true
end

------------------------------------------------------------------------
--- MAIN.

---@return boolean
local function checkConservationRules()
	local success = true

	initializeWaterConservation()
	initializeCarbonConservation()
	initializeFuelPotentialConservation()

	for _, recipe in pairs(RECIPE) do
		if not Util.shouldIgnoreRecipe(recipe) then
			success = checkWaterConservation(recipe) and success
			success = checkCarbonConservation(recipe) and success
			success = checkFuelPotentialConservation(recipe) and success
		end
	end

	return success
end

return checkConservationRules
