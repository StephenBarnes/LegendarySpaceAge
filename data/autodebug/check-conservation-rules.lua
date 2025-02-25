--[[ This file checks that conservation rules are followed.
Currently conservation rules are:
	* water - check that steam/ice/water is never created or destroyed.
	* carbon - we assume there's a certain amount of carbon in each item/fluid, and then check that no recipes are net-positive. (This is important eg on Vulcanus, where there's lots of energy and fuel (sulfur) but we still want to make carbon scarce.)
	* "fuel potential" - we assign a "fuel potential" to each item/fluid, measuring how much fuel it's equivalent to. The item's actual fuel value, if it has one, should be at most this. Some fluids (eg tar) will have fuel value lower than their potential, but can be converted to other items/fluids to realize that fuel potential. This ensures there's no loop of recipes you can do that will produce infinite fuel.
]]

-- TODO get table from recipe to machines that support it, then use that (plus efficiency and speed bonuses, etc.) to compute item input needed for recipes.
-- TODO take into account prod bonuses.

local Util = require("data.autodebug.util")

---@param content table<string, number>
---@param side data.IngredientPrototype[]|data.ProductPrototype[]
---@param includeProd boolean
---@param maxProd number?
---@return number
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

local waterContent = {
	["water"] = 1,
	["water-barrel"] = 1 * 50,
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
-- Add barrels.
local barrelWaterContent = {}
for name, amount in pairs(waterContent) do
	barrelWaterContent[name .. "-barrel"] = amount * FLUID_PER_BARREL
end
for name, amount in pairs(barrelWaterContent) do
	waterContent[name] = amount
end
-- Recipes where we're fine with them producing water out of nothing.
local nonWaterConservingRecipes = Table.listToSet{
	"deep-drill-fulgora",
	"deep-drill-nauvis",
	"deep-drill-gleba",
}

---@param recipe data.RecipePrototype
---@return boolean
local function checkWaterConservation(recipe)
	if nonWaterConservingRecipes[recipe.name] then
		return true
	end
	local waterIn = countRecipeSide(waterContent, recipe.ingredients, false)
	local waterOut = countRecipeSide(waterContent, recipe.results, false)
	if waterOut > waterIn then
		if recipe.allow_productivity then
			log("Recipe " .. recipe.name .. " consumes " .. waterIn .. " water but produces " .. waterOut .. " even before prod bonus.")
		else
			log("Recipe " .. recipe.name .. " consumes " .. waterIn .. " water but produces " .. waterOut .. ". (Prod disabled.)")
		end
		return false
	end
	if recipe.allow_productivity then
		local maxProd = recipe.maximum_productivity
		if maxProd == nil then maxProd = 3 end
		local waterOutWithProd = countRecipeSide(waterContent, recipe.results, true, maxProd)
		if waterOutWithProd > waterIn then
			log("Recipe " .. recipe.name .. " consumes " .. waterIn .. " water and produces " .. waterOut .. ", but with prod bonus produces " .. waterOutWithProd .. ".")
			return false
		end
	end
	return true
	-- TODO figure out why this isn't reporting barrelling recipes.
end

---@param recipe data.RecipePrototype
---@return boolean
local function checkCarbonConservation(recipe)
	-- TODO implement.
	return true
end

---@param recipe data.RecipePrototype
---@return boolean
local function checkFuelPotentialConservation(recipe)
	-- TODO implement.
	return true
end

---@return boolean
local function checkConservationRules()
	local success = true

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
