--[[ This file adds rubber item and recipes, and adds rubber as ingredient to some recipes.
Rubber can be made from wood:
	In biochamber or chemical plant: 5 wood + 2 water -> 5 latex (fluid)
	Coagulation and finishing: 5 latex + 1 sulfuric acid + 1 carbon -> 5 rubber
Later, rubber can also be made from petrochems:
	In chem plant: 5 light oil + 2 steam + 1 sulfuric acid + 1 carbon -> 5 rubber + 2 tar
		Represents cracking to make butadiene, followed by rubber synthesis.
Rubber is used in many recipes like belts, tires, engines, inserters, robots, and vehicles.
]]

local Table = require("code.util.table")
local Tech = require("code.util.tech")

local newData = {}

-- Create rubber item.
local rubberIcons = {}
for i = 1, 3 do
	table.insert(rubberIcons, {filename = "__LegendarySpaceAge__/graphics/rubber/rubber-"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local rubberItem = Table.copyAndEdit(data.raw.item["plastic-bar"], {
	name = "rubber",
	icon = "nil",
	icons = {{icon = rubberIcons[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}},
	pictures = rubberIcons,
})
table.insert(newData, rubberItem)

-- Create latex fluid.
local latexColor = {r = .812, g = .761, b = .675, a=1}
local latexFluid = Table.copyAndEdit(data.raw.fluid["lubricant"], {
	name = "latex",
	icon = "__LegendarySpaceAge__/graphics/rubber/latex.png",
	icon_size = 64,
	flow_color = latexColor,
	base_color = latexColor,
	visualization_color = latexColor,
})
table.insert(newData, latexFluid)

-- Create recipe for latex fluid.
local latexRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "latex",
	ingredients = {
		{type="item", name="wood", amount=5},
		{type="fluid", name="water", amount=20},
	},
	results = {{type="fluid", name="latex", amount=50}},
	category = "organic-or-chemistry",
	subgroup = "complex-fluid-recipes",
	order = "b[chemistry]-a1",
})
table.insert(newData, latexRecipe)

-- Create recipe for latex to rubber.
local rubberFromLatexRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "rubber-from-latex",
	ingredients = {
		{type="fluid", name="latex", amount=50},
		{type="fluid", name="sulfuric-acid", amount=10},
		{type="item", name="carbon", amount=1},
	},
	results = {{type="item", name="rubber", amount=5}},
	category = "organic-or-chemistry",
	subgroup = "complex-fluid-recipes",
	order = "b[chemistry]-a2",
	icon = "nil",
	icons = {
		rubberItem.icons[1],
		{icon = latexFluid.icon, icon_size = 64, scale=0.27, mipmap_count=4, shift={-6, -7}},
	},
})
table.insert(newData, rubberFromLatexRecipe)

-- Create recipe for synthetic rubber.
local rubberFromPetrochemRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "rubber-from-oil",
	ingredients = {
		{type="fluid", name="light-oil", amount=50},
		{type="fluid", name="steam", amount=20},
		{type="fluid", name="sulfuric-acid", amount=10},
		{type="item", name="carbon", amount=1},
	},
	results = {
		{type="item", name="rubber", amount=5},
		{type="fluid", name="tar", amount=20},
	},
	main_product = "rubber",
	category = "organic-or-chemistry",
	subgroup = "complex-fluid-recipes",
	order = "b[chemistry]-a3",
	icon = "nil",
	icons = {
		rubberItem.icons[1],
		{icon = data.raw.fluid["light-oil"].icon, icon_size = 64, scale=0.27, mipmap_count=4, shift={-6, -7}},
	},
})
table.insert(newData, rubberFromPetrochemRecipe)

-- Create tech for natural rubber.
local naturalRubberTech = Table.copyAndEdit(data.raw.technology["plastics"], {
	name = "rubber-1",
	effects = {
		{
			type = "unlock-recipe",
			recipe = "latex",
		},
		{
			type = "unlock-recipe",
			recipe = "rubber-from-latex",
		},
		{
			type = "unlock-recipe",
			recipe = "sulfuric-acid",
		},
	},
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/rubber/tech.png", icon_size = 256, scale=0.5, mipmap_count=4}},
	localised_description = {"technology-description.rubber-1"},
	prerequisites = {"automation"},
	unit = data.raw.technology["automation"].unit,
})
table.insert(newData, naturalRubberTech)

-- Create tech for synthetic rubber.
local syntheticRubberTech = Table.copyAndEdit(data.raw.technology["plastics"], {
	name = "rubber-2",
	effects = {
		{
			type = "unlock-recipe",
			recipe = "rubber-from-oil",
		},
	},
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/rubber/tech.png", icon_size = 256, scale=0.5, mipmap_count=4}},
	localised_description = {"technology-description.rubber-2"},
	prerequisites = {"oil-processing", "rubber-1"},
})
table.insert(newData, syntheticRubberTech)

data:extend(newData)