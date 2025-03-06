-- This file changes some barrelling recipes to use pressurized tanks instead of barrels.
-- Note that I renamed the tank to just "pressurized tank" so it's not necessarily for gases, more just for anything that doesn't seem right in an ordinary barrel.

-- Edit some of the barrelling recipes to instead have the icon for the pressurized tank, and use pressurized tank ingredient and result.
local pressurizedFluids = Table.listToSet{
	--"steam", -- Not barrellable.
	"petroleum-gas",
	"dry-gas",
	"natural-gas",
	"syngas",
	"ammonia",
	"spore-gas",

	"liquid-nitrogen",
	"thruster-oxidizer",
	"thruster-fuel",

	"nitrogen-gas",
	"compressed-nitrogen-gas",
	"oxygen-gas",
	"hydrogen-gas",

	"fluorine",
	"hydrofluoric-acid",
}
local function makeGasTankIcons(fluid, straight)
	local kind = straight and "straight" or "angled"
	return {
		{icon = "__LegendarySpaceAge__/graphics/gas-tanks/"..kind.."/tank.png", icon_size = 64, scale = 0.5},
		{
			icon = "__LegendarySpaceAge__/graphics/gas-tanks/"..kind.."/overlay-side.png",
			icon_size = 64,
			scale = 0.5,
			tint = util.get_color_with_alpha(fluid.base_color, 0.75, true),
		},
		{
			icon = "__LegendarySpaceAge__/graphics/gas-tanks/"..kind.."/overlay-top.png",
			icon_size = 64,
			scale = 0.5,
			tint = util.get_color_with_alpha(fluid.flow_color, 0.75, true),
		},
	}
end
local function makeGasTankFillingIcons(fluid, straight, shift)
	local icons = makeGasTankIcons(fluid, straight)
	if fluid.icon then
		table.insert(icons, {
				icon = fluid.icon,
				icon_size = (fluid.icon_size or defines.default_icon_size),
				scale = 16.0 / (fluid.icon_size or defines.default_icon_size), -- scale = 0.5 * 32 / icon_size simplified
				shift = shift,
			}
		)
	elseif fluid.icons then
		icons = util.combine_icons(icons, fluid.icons, {scale = 0.5, shift = shift}, fluid.icon_size)
	end
	return icons
end
for gasName, _ in pairs(pressurizedFluids) do
	local barrelRecipe = RECIPE[gasName.."-barrel"]
	assert(barrelRecipe ~= nil, "barrel recipe for "..gasName.." not found")
	local emptyRecipe = RECIPE["empty-"..gasName.."-barrel"]
	assert(emptyRecipe ~= nil, "empty recipe for "..gasName.." not found")
	local item = ITEM[gasName.."-barrel"]
	assert(item ~= nil, "item for "..gasName.." not found")
	local fluid = FLUID[gasName]
	assert(fluid ~= nil, "fluid for "..gasName.." not found")

	-- Edit filling recipe's ingredients
	for _, ingredient in pairs(barrelRecipe.ingredients) do
		if ingredient.name == "barrel" then
			ingredient.name = "gas-tank"
		else
			ingredient.amount = FLUID_PER_BARREL
		end
	end

	-- Edit emptying recipe's results.
	for _, result in pairs(emptyRecipe.results) do
		if result.name == "barrel" then
			result.name = "gas-tank"
		else
			result.amount = FLUID_PER_BARREL
		end
	end

	-- Edit icons for item, filling recipe, emptying recipe.
	item.icons = makeGasTankIcons(fluid, true)
	barrelRecipe.icons = makeGasTankFillingIcons(fluid, true, {-8,-8})
	emptyRecipe.icons = makeGasTankFillingIcons(fluid, false, {7,8})

	-- Edit localised names
	item.localised_name = {"item-name.filled-gas-tank", {"fluid-name."..gasName}}
	barrelRecipe.localised_name = {"recipe-name.fill-gas-tank", {"fluid-name."..gasName}}
	emptyRecipe.localised_name = {"recipe-name.empty-filled-gas-tank", {"fluid-name."..gasName}}

	-- Edit subgroups.
	barrelRecipe.subgroup = "fill-gas-tank"
	emptyRecipe.subgroup = "empty-gas-tank"

	-- Increase stack size for the gas tank. Barrels are 10, tanks at 20 seems reasonable.
	--item.stack_size = 20
	-- Actually rather not, since it increases energy density by a lot.
end

-- Go through fluid handling tech, remove all barrelling recipes, add to new tech.
local fluidHandlingTech = TECH["fluid-handling"]
local barrellingRecipes = {}
local unbarrellingRecipes = {}
local gasFillingRecipes = {}
local gasEmptyingRecipes = {}
local newEffectsFluidHandling = {}
for _, effect in pairs(fluidHandlingTech.effects) do
	if effect.type == "unlock-recipe" then
		local recipe = RECIPE[effect.recipe]
		assert(recipe ~= nil, "recipe "..effect.recipe.." not found")
		if recipe.subgroup == "fill-barrel" then
			table.insert(barrellingRecipes, effect.recipe)
		elseif recipe.subgroup == "empty-barrel" then
			table.insert(unbarrellingRecipes, effect.recipe)
		elseif recipe.subgroup == "fill-gas-tank" then
			table.insert(gasFillingRecipes, effect.recipe)
		elseif recipe.subgroup == "empty-gas-tank" then
			table.insert(gasEmptyingRecipes, effect.recipe)
		else
			table.insert(newEffectsFluidHandling, effect)
		end
	else
		table.insert(newEffectsFluidHandling, effect)
	end
end
fluidHandlingTech.effects = newEffectsFluidHandling
for _, recipeGroup in pairs{barrellingRecipes, unbarrellingRecipes, gasFillingRecipes, gasEmptyingRecipes} do
	for _, recipeName in pairs(recipeGroup) do
		table.insert(TECH["fluid-containers"].effects, {type = "unlock-recipe", recipe = recipeName})
	end
end
Tech.removeRecipeFromTech("barrel", "fluid-handling")

-- Disable prod and quality for all barrelling recipes.
for _, recipeGroup in pairs{barrellingRecipes, unbarrellingRecipes, gasFillingRecipes, gasEmptyingRecipes} do
	for _, recipeName in pairs(recipeGroup) do
		RECIPE[recipeName].allow_productivity = false
		RECIPE[recipeName].allow_quality = false
	end
end

-- Change fluid amount per barrel to 100, originally 50.
for _, recipeGroup in pairs{barrellingRecipes, gasFillingRecipes} do
	for _, recipeName in pairs(recipeGroup) do
		for _, ingredient in pairs(RECIPE[recipeName].ingredients) do
			if ingredient.name ~= "barrel" and ingredient.name ~= "gas-tank" then
				assert(ingredient.type == "fluid", "ingredient "..ingredient.name.." for "..recipeName.." is not a fluid")
				ingredient.amount = FLUID_PER_BARREL
			end
		end
	end
end
for _, recipeGroup in pairs{unbarrellingRecipes, gasEmptyingRecipes} do
	for _, recipeName in pairs(recipeGroup) do
		for _, result in pairs(RECIPE[recipeName].results) do
			if result.name ~= "barrel" and result.name ~= "gas-tank" then
				assert(result.type == "fluid", "result "..result.name.." for "..recipeName.." is not a fluid")
				result.amount = FLUID_PER_BARREL
			end
		end
	end
end

-- Add fuel values for barrels and gas tanks.
for fluidName, fuelValues in pairs(Const.fluidFuelValues) do
	if ITEM[fluidName.."-barrel"] then
		if fuelValues[1] ~= nil then
			local isGas = pressurizedFluids[fluidName]
			--local fluidNumMult = Gen.ifThenElse(isGas, GAS_TANK_FLUID_AMOUNT, BARREL_FLUID_AMOUNT)
			ITEM[fluidName.."-barrel"].fuel_value = Gen.multWithUnits(fuelValues[1], FLUID_PER_BARREL)
			ITEM[fluidName.."-barrel"].fuel_emissions_multiplier = fuelValues[2]
			ITEM[fluidName.."-barrel"].fuel_acceleration_multiplier = fuelValues[3]
			ITEM[fluidName.."-barrel"].fuel_top_speed_multiplier = fuelValues[4]
			ITEM[fluidName.."-barrel"].fuel_category = fuelValues[5]
			local remainingItem = Gen.ifThenElse(isGas, "gas-tank", "barrel")
			ITEM[fluidName.."-barrel"].burnt_result = remainingItem
			ITEM[fluidName.."-barrel"].fuel_glow_color = ITEM["coal"].fuel_glow_color
		end
	else
		log("WARNING: No item for "..fluidName.."-barrel")
	end
end