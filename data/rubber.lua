--[[ This file adds rubber item and recipes, and adds rubber as ingredient to some recipes.
Rubber can be made from wood:
	In biochamber or chemical plant: 5 wood + 2 water -> 5 latex (fluid)
	Coagulation and finishing: 5 latex + 1 sulfuric acid + 1 carbon -> 5 rubber
Later, rubber can also be made from petrochems:
	In chem plant: 5 light oil + 2 steam + 1 sulfuric acid + 1 carbon -> 5 rubber + 2 tar
		Represents cracking to make butadiene, followed by rubber synthesis.
Rubber is used in many recipes like belts, tires, engines, inserters, robots, and vehicles.
]]

-- Create rubber item.
local rubberIcons = {}
for i = 1, 3 do
	table.insert(rubberIcons, {filename = "__LegendarySpaceAge__/graphics/rubber/rubber-"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local rubberItem = table.deepcopy(ITEM["plastic-bar"])
rubberItem.name = "rubber"
rubberItem.icon = nil
rubberItem.icons = {{icon = rubberIcons[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}}
rubberItem.pictures = rubberIcons
rubberItem.order = "b[chemistry]-a3"
data:extend{rubberItem}

-- Create latex fluid.
local latexColor = {r = .812, g = .761, b = .675, a=1}
local latexFluid = table.deepcopy(FLUID["lubricant"])
latexFluid.name = "latex"
latexFluid.icon = "__LegendarySpaceAge__/graphics/rubber/latex.png"
latexFluid.icon_size = 64
latexFluid.base_color = latexColor
latexFluid.flow_color = {r = .9, g = .8, b = .7, a=1}
latexFluid.visualization_color = latexColor
data:extend{latexFluid}

-- Create recipe for latex fluid.
local latexRecipe = table.deepcopy(RECIPE["plastic-bar"])
latexRecipe.name = "latex"
latexRecipe.ingredients = {
	{type="item", name="wood", amount=5},
	{type="fluid", name="water", amount=20},
}
latexRecipe.results = {{type="fluid", name="latex", amount=50}}
latexRecipe.category = "chemistry"
latexRecipe.subgroup = "raw-material"
latexRecipe.order = "f1"
data:extend{latexRecipe}

-- Create recipe for latex to rubber.
local rubberFromLatexRecipe = table.deepcopy(RECIPE["plastic-bar"])
rubberFromLatexRecipe.name = "rubber-from-latex"
rubberFromLatexRecipe.ingredients = {
	{ type = "fluid", name = "latex",         amount = 50 },
	{ type = "fluid", name = "sulfuric-acid", amount = 10 },
	{ type = "item",  name = "carbon",        amount = 1 },
}
rubberFromLatexRecipe.results = {{type="item", name="rubber", amount=5}}
rubberFromLatexRecipe.category = "chemistry"
rubberFromLatexRecipe.subgroup = "raw-material"
rubberFromLatexRecipe.order = "f2"
rubberFromLatexRecipe.icon = nil
rubberFromLatexRecipe.icons = {
	rubberItem.icons[1],
	{icon = latexFluid.icon, icon_size = 64, scale=0.27, mipmap_count=4, shift={-6, -7}},
}
data:extend{rubberFromLatexRecipe}

-- Create recipe for synthetic rubber.
local rubberFromPetrochemRecipe = table.deepcopy(RECIPE["plastic-bar"])
rubberFromPetrochemRecipe.name = "rubber-from-oil"
rubberFromPetrochemRecipe.ingredients = {
	{type="fluid", name="light-oil", amount=50},
	{type="fluid", name="steam", amount=20},
	{type="fluid", name="sulfuric-acid", amount=10},
	{type="item", name="carbon", amount=1},
}
rubberFromPetrochemRecipe.results = {
	{type="item", name="rubber", amount=5},
	{type="fluid", name="tar", amount=20},
}
rubberFromPetrochemRecipe.main_product = "rubber"
rubberFromPetrochemRecipe.category = "chemistry"
rubberFromPetrochemRecipe.subgroup = "raw-material"
rubberFromPetrochemRecipe.order = "f3"
rubberFromPetrochemRecipe.icon = nil
rubberFromPetrochemRecipe.icons = {
	rubberItem.icons[1],
	{icon = FLUID["light-oil"].icon, icon_size = 64, scale=0.27, mipmap_count=4, shift={-6, -7}},
}
data:extend{rubberFromPetrochemRecipe}

-- Create tech for natural rubber.
local naturalRubberTech = table.deepcopy(TECH["plastics"])
naturalRubberTech.name = "rubber-1"
naturalRubberTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "latex",
	},
	{
		type = "unlock-recipe",
		recipe = "rubber-from-latex",
	},
}
naturalRubberTech.icon = nil
naturalRubberTech.icons = {{icon = "__LegendarySpaceAge__/graphics/rubber/tech.png", icon_size = 256, scale=0.5, mipmap_count=4}}
naturalRubberTech.localised_description = {"technology-description.rubber-1"}
naturalRubberTech.prerequisites = {"sulfur-processing"}
naturalRubberTech.unit = TECH["automation"].unit
data:extend{naturalRubberTech}

-- Create tech for synthetic rubber.
local syntheticRubberTech = table.deepcopy(TECH["plastics"])
syntheticRubberTech.name = "rubber-2"
syntheticRubberTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "rubber-from-oil",
	},
}
syntheticRubberTech.icon = nil
syntheticRubberTech.icons = {{icon = "__LegendarySpaceAge__/graphics/rubber/tech.png", icon_size = 256, scale=0.5, mipmap_count=4}}
syntheticRubberTech.localised_description = {"technology-description.rubber-2"}
syntheticRubberTech.prerequisites = {"oil-processing", "rubber-1"}
data:extend{syntheticRubberTech}