--[[ This file checks that conservation rules are followed.

Currently conservation rules are:
	* water - check that steam/ice/water is never created by any recipe (except if the recipe ingredients involve at least that much water).
	* carbon - we assume there's a certain amount of carbon in each item/fluid, and then check that no recipes are net-positive. (This is important eg on Vulcanus, where there's lots of energy and fuel (sulfur) but we still want to make carbon scarce.)
	* "fuel potential" - we assign a "fuel potential" to each item/fluid, measuring how much fuel it "could be made into". The item's actual fuel value, if it has one, should be at most this potential. Some fluids (eg tar) will have fuel value much lower than their potential, but can be converted to other items/fluids to realize that fuel potential. This ensures there's no loop of recipes you can do that will produce infinite fuel. TODO this is not implemented yet.
	* TODO planning to implement similar checks for various elements like nitrogen, oxygen, hydrogen, phosphorus, etc.

It's pretty easy to write recipes that follow all these conservation rules BUT then prod bonuses screw it all up. Often the way to fix this is to just limit the prod bonus for a recipe or for some of a recipe's products. I'm noting ALL of these prod limits in recipe/entity descriptions so players don't have to be surprised.
]]

local Util = require("data.autodebug.util")

------------------------------------------------------------------------
--- GENERAL FUNCTIONS FOR ALL CONSERVATION CHECKS.

---@param content table<string, number>
---@param side data.IngredientPrototype[]|data.ProductPrototype[]
---@param includeProd boolean
---@param maxProd number?
---@param recipeName string?
---@return number
---Counts how much of some conserved quantity is on one side (ingredients or results) of a recipe. Prod should only be included for results, not ingredients.
local function countRecipeSide(content, side, includeProd, maxProd, recipeName)
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
				error("Invalid recipe side item recipe " .. recipeName .. ": " .. serpent.block(item))
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

---@param conservedName string Used for logging.
---@param recipe data.RecipePrototype
---@param contentTable table<string, number> Maps item/fluid name to amount of conserved quantity in it.
---@param nonConservingRecipes table<string, boolean>
---@param recipeAdditions table<string, (data.FluidIngredientPrototype|data.ItemIngredientPrototype)[]>? List of additional ingredients to add to the recipe because they're needed to fuel the entity that crafts the recipe.
---@return boolean
---Checks that a conservation rule is followed for a recipe.
local function checkConservationRule(conservedName, recipe, contentTable, nonConservingRecipes, recipeAdditions)
	if nonConservingRecipes[recipe.name] then
		return true
	end

	local totalIn
	if recipeAdditions == nil or recipeAdditions[recipe.name] == nil then
		totalIn = countRecipeSide(contentTable, recipe.ingredients, false, nil, recipe.name)
	else
		local ingredients = copy(recipe.ingredients or {})
		for _, addition in pairs(recipeAdditions[recipe.name]) do
			table.insert(ingredients, addition)
		end
		totalIn = countRecipeSide(contentTable, ingredients, false)
	end

	local totalOut = countRecipeSide(contentTable, recipe.results, false, nil, recipe.name)
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
		local totalOutWithProd = countRecipeSide(contentTable, recipe.results, true, maxProd, recipe.name)
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
	["steam"] = 1,
	["ice"] = 10,
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
	["raw-seawater"] = 4,
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
	"air-separation-vulcanus",
	"air-separation-nauvis",
	"air-separation-gleba",
	"air-separation-fulgora",
	"air-separation-aquilo",
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
	["carbon"] = .5,
	["pitch"] = 1,
	["ash"] = 1,
	["syngas"] = (5 * .22 + 20 * .2) / 100,
	["resin"] = .4,
	["solid-fuel"] = 6.6,

	["spoilage"] = .25,
	["nutrients"] = .25,
	["sugar"] = .25,
	["marrow"] = .25,
	["appendage"] = .25,
	["sencytium"] = .25,
	["petrophage"] = 1,
	["agricultural-science-pack"] = .25,
	["slime"] = 2,
	["raw-seawater"] = 1,

	["diesel"] = 0.3,
	["tar"] = .32,
	["heavy-oil"] = .22,
	["light-oil"] = .2,
	["petroleum-gas"] = .2,
	["dry-gas"] = .2,

	-- Raw materials, can set these to high numbers.
	["coal"] = 10,
	["crude-oil"] = 1,
	["natural-gas"] = 1,
	["volcanic-gas"] = 1,
	["scrap"] = 10,
	["fulgoran-sludge"] = 10,
	["ammoniacal-solution"] = 10,
	["carbonic-asteroid-chunk"] = 1000,
	["metallic-asteroid-chunk"] = 1000,
	["oxide-asteroid-chunk"] = 1000,
	["geoplasm"] = 2,

	-- Materials that can be produced via farming, without carbon input, but that's intended.
	["wood"] = 100,
	["tree-seed"] = 1600,
	["sapling"] = 400,
	["slipstack-pearl"] = 100,
	["boomsac"] = 200,
	["sprouted-boomnut"] = .25,
	["boomnut"] = 1,
	["yumako-seed"] = 10,
	["fertilized-yumako-seed"] = 10,
	["yumako-mash"] = 10000,
	["yumako"] = 100000,
	["jelly"] = 10000,
	["jellynut-seed"] = 10,
	["fertilized-jellynut-seed"] = 10,
	["jellynut"] = 200000,
	["biter-egg"] = 1000,
	["pentapod-egg"] = 1000,
	["activated-pentapod-egg"] = 100,
	["bioflux"] = 10000, -- Can be used to multiply pentapod eggs, which are carbon-based fuel.
	["neurofibril"] = 1000,
	["raw-fish"] = 5,
}

-- Recipes where we're fine with them producing carbon out of nothing.
local nonCarbonConservingRecipes = Table.listToSet{
	"deep-drill-fulgora",
	"deep-drill-nauvis",
	"deep-drill-gleba",
	"deep-drill-vulcanus",
	"biter-egg", -- Recipe that creates biter eggs out of nothing in a captive spawner.
	"air-separation-vulcanus",
	"air-separation-nauvis",
	"air-separation-gleba",
	"air-separation-fulgora",
	"air-separation-aquilo",
}

-- Table from recipes to additional ingredients that should be added to the recipe to check conservation.
-- Using this for syngas recipes, since gasifier needs additional carbon for fuel.
local carbonRecipeAdditions = {}

local function initializeCarbonConservation()
	addBarrelContent(carbonContent)

	-- The gasifier turns steam into syngas (which contains carbon). It consumes fuel which contains carbon, so we need to find out the most carbon-efficient fuel it can be fed, to add that to the syngas recipe.
	-- Furnaces are similar, running the char recipe.
	local fuelCategoryAllowedInGasifier = Table.listToSet(ASSEMBLER["gasifier"].energy_source.fuel_categories)
	for _, effect in pairs{"consumption", "productivity"} do
		-- We can allow speed, since the speed modules give greater increase to energy consumption than to speed.
		for _, ent in pairs{
			{ASSEMBLER, "gasifier"},
			{ASSEMBLER, "fluid-fuelled-gasifier"},
			--{ASSEMBLER, "stone-furnace"},
			--{ASSEMBLER, "steel-furnace"},
		} do
			assert(not Gen.effectAllowed(ent[1][ent[2] ], effect), ent[2] .. " should not allow " .. effect .. " modules.")
		end
		-- Note we can ban consumption effect per-recipe, seems like it works. So, allowing consumption/prod for furnaces, but not for the char recipe.
	end
	local mostEfficientFuel = nil
	local mostEfficientFuelCarbonPerJoule = nil
	local mostEfficientFuelJoules = nil
	-- Look through all items, including subtypes, to find the most carbon-efficient fuel.
	Item.forAllIncludingSubtypes(function(item, itemType)
		if not Util.shouldIgnoreItem(item) then
			if item.fuel_category ~= nil and fuelCategoryAllowedInGasifier[item.fuel_category] then
				local joules = Gen.toJoules(item.fuel_value)
				local carbon = carbonContent[item.name] or 0
				local carbonPerJoule = carbon / joules

				if mostEfficientFuelCarbonPerJoule == nil or carbonPerJoule < mostEfficientFuelCarbonPerJoule then
					mostEfficientFuelCarbonPerJoule = carbonPerJoule
					mostEfficientFuel = {type = "item", name = item.name}
					mostEfficientFuelJoules = joules
				end
			end
		end
	end)
	for _, fluid in pairs(FLUID) do -- Look through all fuel fluids allowed in fluid-fuelled gasifier.
		if not fluid.parameter and fluid.fuel_value ~= nil and fluid.name ~= "thruster-fuel" then
			-- Note thruster-fuel is specifically allowed, since I can't block non-carbonic fluids. But it should be fine since it has extremely low fuel value.
			local joules = Gen.toJoules(fluid.fuel_value)
			local carbon = carbonContent[fluid.name] or 0
			local carbonPerJoule = carbon / joules
			if mostEfficientFuelCarbonPerJoule == nil or carbonPerJoule < mostEfficientFuelCarbonPerJoule then
				mostEfficientFuelCarbonPerJoule = carbonPerJoule
				mostEfficientFuel = {type = "fluid", name = fluid.name}
				mostEfficientFuelJoules = joules
			end
		end
	end
	log("Most carbon-efficient carbon-based fuel: " .. serpent.line(mostEfficientFuel) .. "  -- details: each item has " .. mostEfficientFuelJoules .. " joules of fuel value, and " .. (mostEfficientFuelCarbonPerJoule * mostEfficientFuelJoules) .. " carbon, so " .. mostEfficientFuelCarbonPerJoule .. " carbon per joule.")
	assert(mostEfficientFuel ~= nil, "No fuel found for gasifier.")
	assert(mostEfficientFuel.name ~= "carbon", "This code assumed that pure carbon wouldn't be most efficient; if it is' then the char furnace bit below doesn't work because char furnace can't burn carbon.")
	assert(ASSEMBLER["gasifier"].energy_usage == ASSEMBLER["fluid-fuelled-gasifier"].energy_usage, "Gasifier and fluid-fuelled gasifier should have the same energy usage.")
	assert(ASSEMBLER["gasifier"].crafting_speed == 1, "Gasifier should have speed 1.")
	assert(ASSEMBLER["fluid-fuelled-gasifier"].crafting_speed == 1, "Fluid-fuelled gasifier should have speed 1.")
	local gasifierJoulesPerSecond = Gen.toJoules(ASSEMBLER["gasifier"].energy_usage)
	local syngasRecipeSeconds = RECIPE["make-syngas"].energy_required
	local fuelPerRecipe = gasifierJoulesPerSecond * syngasRecipeSeconds / mostEfficientFuelJoules
	carbonRecipeAdditions["syngas"] = {{type = mostEfficientFuel.type, name = mostEfficientFuel.name, amount = fuelPerRecipe}}

	-- Do the same for the char furnace.
	-- TODO rewrite this now that I've removed char-furnace.
	--[[
	assert(ASSEMBLER["char-furnace"].crafting_speed == 1, "Char furnace should have speed 1.")
	local charFurnaceJoulesPerSecond = Gen.toJoules(ASSEMBLER["char-furnace"].energy_usage)
	local charFurnaceRecipeSeconds = RECIPE["char-carbon"].energy_required
	local fuelPerCharCarbonRecipe = charFurnaceJoulesPerSecond * charFurnaceRecipeSeconds / mostEfficientFuelJoules
	carbonRecipeAdditions["char-carbon"] = {{type = mostEfficientFuel.type, name = mostEfficientFuel.name, amount = fuelPerCharCarbonRecipe}}
	]]
end

---@param recipe data.RecipePrototype
---@return boolean
local function checkCarbonConservation(recipe)
	return checkConservationRule("carbon", recipe, carbonContent, nonCarbonConservingRecipes, carbonRecipeAdditions)
end

------------------------------------------------------------------------
--- FUEL POTENTIAL CONSERVATION.

local function initializeFuelPotentialConservation()
	-- TODO implement.
	-- TODO we need to check that the fuel value of every item/fluid is at most its fuel potential.
end

---@param recipe data.RecipePrototype
---@return boolean
local function checkFuelPotentialConservation(recipe)
	-- TODO implement.
	return true
end

------------------------------------------------------------------------
--- MAIN.

---@param recipe data.RecipePrototype
---@return boolean
local function runChecks(recipe)
	local success = true
	success = checkWaterConservation(recipe) and success
	success = checkCarbonConservation(recipe) and success
	success = checkFuelPotentialConservation(recipe) and success
	return success
end

---@return boolean
local function checkConservationRules()
	local success = true

	initializeWaterConservation()
	initializeCarbonConservation()
	initializeFuelPotentialConservation()

	for _, recipe in pairs(RECIPE) do
		if not Util.shouldIgnoreRecipe(recipe) then
			success = runChecks(recipe) and success
		end
	end

	-- Look through all items that spoil into other items, and check them too as if they were recipes.
	Item.forAllIncludingSubtypes(function(item, itemType)
		if item.spoil_ticks ~= nil and item.spoil_result ~= nil then
			local spoilResult = Item.getIncludingSubtypes(item.spoil_result)
			assert(spoilResult ~= nil, "Invalid spoil result: " .. item.spoil_result)
			local spoilingRecipe = {
				type = "recipe",
				name = item.name .. "-spoil",
				ingredients = {{type = "item", name = item.name, amount = 1}},
				results = {{type = "item", name = item.spoil_result, amount = 1}},
				allow_productivity = false,
			}
			success = runChecks(spoilingRecipe) and success
		end
	end)

	return success
end

return checkConservationRules