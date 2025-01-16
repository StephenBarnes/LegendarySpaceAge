local Table = require("code.util.table")
local Tech = require("code.util.tech")

-- Edit some of the barrelling recipes to instead have the icon for the gas tank, and use gas tank ingredient and result.
local gases = Table.listToSet{
	"steam",
	"petroleum-gas",
	"dry-gas",
	"natural-gas",
	"syngas",
	"thruster-oxidizer",
	"thruster-fuel",
	"ammonia",
	"fluorine",
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
for gasName, _ in pairs(gases) do
	local barrelRecipe = data.raw.recipe[gasName.."-barrel"]
	local emptyRecipe = data.raw.recipe["empty-"..gasName.."-barrel"]
	local item = data.raw.item[gasName.."-barrel"]
	local fluid = data.raw.fluid[gasName]

	-- Edit barrelling recipe's ingredients
	for _, ingredient in pairs(barrelRecipe.ingredients) do
		if ingredient.name == "barrel" then
			ingredient.name = "gas-tank"
		else
			ingredient.amount = 200
		end
	end

	-- Edit emptying recipe's results.
	for _, result in pairs(emptyRecipe.results) do
		if result.name == "barrel" then
			result.name = "gas-tank"
		else
			result.amount = 200
		end
	end

	-- Edit item's icons.
	item.icons = makeGasTankIcons(fluid, true)

	-- Edit tank-filling recipe icons
	barrelRecipe.icons = makeGasTankFillingIcons(fluid, true, {-8,-8})

	-- Edit tank-emptying recipe icons
	emptyRecipe.icons = makeGasTankFillingIcons(fluid, false, {7,8})

	-- Edit localised names
	barrelRecipe.localised_name = {"recipe-name.fill-gas-tank", {"fluid-name."..gasName}}
	emptyRecipe.localised_name = {"recipe-name.empty-filled-gas-tank", {"fluid-name."..gasName}}

	-- Edit subgroups.
	barrelRecipe.subgroup = "fill-gas-tank"
	emptyRecipe.subgroup = "empty-gas-tank"
end

-- Go through fluid handling tech, remove all barrelling recipes, add to new tech.
local fluidHandlingTech = data.raw.technology["fluid-handling"]
local barrellingRecipes = {}
local unbarrellingRecipes = {}
local gasFillingRecipes = {}
local gasEmptyingRecipes = {}
local newEffectsFluidHandling = {}
for _, effect in pairs(fluidHandlingTech.effects) do
	if effect.type == "unlock-recipe" then
		local recipe = data.raw.recipe[effect.recipe]
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
		table.insert(data.raw.technology["fluid-containers"].effects, {type = "unlock-recipe", recipe = recipeName})
	end
end
Tech.removeRecipeFromTech("barrel", "fluid-handling")