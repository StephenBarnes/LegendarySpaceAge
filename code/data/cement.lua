--[[ This file adds cement fluid, tech, and recipes. Cement is used to make concrete, refined concrete, shielding (with stone brick), etc.
Also adds sulfur concrete recipes.
Cement:
	5 stone + 5 sand + 100 water -> 100 cement
Main route to concrete:
	100 cement -> 10 concrete blocks
	100 cement + 1 resin + 2 hot steel -> 10 refined concrete
And then there's alternative recipes using sulfur, and no water, in a foundry:
	30 sulfur + 30 sand + -> 20 concrete
	30 sulfur + 30 sand + 1 resin + 40 molten steel -> 20 refined concrete
Original game recipes were:
	1 iron ore + 5 stone brick + 100 water -> 10 concrete
	8 iron rod + 1 steel plate + 20 concrete + 100 water -> 10 refined concrete
]]

local Table = require("code.util.table")
local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

local newData = {}

-- Create new "cement" fluid.
local cementFluid = Table.copyAndEdit(data.raw.fluid["lubricant"], {
	name = "cement",
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/fluids/cement-fluid.png", scale = .5, icon_size = 64}},
	auto_barrel = false,
	base_color = {.33, .33, .33, 1},
	flow_color = {.6, .6, .6, 1},
	visualization_color = {.43, .43, .43, 1},
})
table.insert(newData, cementFluid)

-- Create recipe for cement.
local cementRecipe = Table.copyAndEdit(data.raw.recipe["lubricant"], {
	name = "make-cement", -- Must be different from cement so it appears in factoriopedia correctly.
	localised_name = {"fluid-name.cement"},
	subgroup = "terrain",
	order = "b[a]",
	ingredients = {
		{type = "item", name = "stone", amount = 5},
		{type = "item", name = "sand", amount = 5},
		{type = "fluid", name = "water", amount = 100},
	},
	results = {
		{type = "fluid", name = "cement", amount = 100},
	},
	main_product = "cement",
	auto_barrel = false,
	category = "crafting-with-fluid",
})
table.insert(newData, cementRecipe)

-- Create tech for cement.
local cementTech = table.deepcopy(data.raw.technology.concrete)
cementTech.name = "cement"
cementTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "make-cement",
	},
}
cementTech.prerequisites = {"filtration-lake-water"}
cementTech.research_trigger = nil
cementTech.unit = {
	count = 15,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
	},
}
cementTech.icon = "__LegendarySpaceAge__/graphics/fluids/cement-tech.png"
data:extend{cementTech}

-- Adjust recipes for concrete and refined concrete.
data.raw.recipe["concrete"].ingredients = {
	{type = "fluid", name = "cement", amount = 100},
	{type = "item", name = "stone", amount = 8},
	{type = "item", name = "iron-stick", amount = 4},
}
data.raw.recipe["refined-concrete"].ingredients = {
	{type = "fluid", name = "cement", amount = 100},
	{type = "item", name = "resin", amount = 2},
	{type = "item", name = "steel-plate", amount = 4},
}

-- Create sulfur concrete recipes for foundries.
-- TODO
local concreteCastingRecipe = Table.copyAndEdit(data.raw.recipe["concrete-from-molten-iron"], {
	name = "sulfur-concrete",
	ingredients = {
		{type = "item", name = "sulfur", amount = 30},
		{type = "item", name = "sand", amount = 30},
	},
	results = {
		{type = "item", name = "concrete", amount = 20},
	},
	icon = "nil",
	icons = {
		--[[
		{icon = "__base__/graphics/icons/concrete.png", icon_size = 64, scale=0.5, mipmap_count=4},
		{icon = "__space-age__/graphics/icons/fluid/lava.png", icon_size = 64, scale=0.27, mipmap_count=4, shift={-6, -7}},
		{icon = "__base__/graphics/icons/sulfur.png", icon_size = 64, scale=0.3, mipmap_count=4, shift={6, -6}},
		]]

		{icon = "__base__/graphics/icons/concrete.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={-4, 4}},
		{icon = "__LegendarySpaceAge__/graphics/vulcanus/sulfur-cast.png", icon_size = 64, scale = 0.5, mipmap_count = 4, shift = {4, -4}},
	},
})
table.insert(newData, concreteCastingRecipe)
local refinedConcreteCastingRecipe = Table.copyAndEdit(data.raw.recipe["concrete-from-molten-iron"], {
	name = "sulfur-refined-concrete",
	ingredients = {
		{type = "item", name = "sulfur", amount = 30},
		{type = "item", name = "sand", amount = 30},
		{type = "item", name = "resin", amount = 1},
		{type = "fluid", name = "molten-steel", amount = 40},
	},
	results = {
		{type = "item", name = "refined-concrete", amount = 20},
	},
	icon = "nil",
	icons = {
		{icon = "__base__/graphics/icons/refined-concrete.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={-4, 4}},
		{icon = "__LegendarySpaceAge__/graphics/vulcanus/sulfur-cast.png", icon_size = 64, scale = 0.5, mipmap_count = 4, shift = {4, -4}},
	},
})
table.insert(newData, refinedConcreteCastingRecipe)

-- Hide old concrete foundry recipe completely.
Recipe.hide("concrete-from-molten-iron")

-- Create sulfur concrete tech.
local sulfurConcreteTech = Table.copyAndEdit(data.raw.technology["concrete"], {
	name = "sulfur-concrete",
	effects = {
		{
			type = "unlock-recipe",
			recipe = "sulfur-concrete",
		},
		{
			type = "unlock-recipe",
			recipe = "sulfur-refined-concrete",
		},
	},
	prerequisites = {
		"foundry",
	},
	icon = "nil",
	icons = {
		{icon = "__base__/graphics/technology/concrete.png", icon_size = 256, scale = 1},
		{icon = "__base__/graphics/technology/sulfur-processing.png", icon_size = 256, scale = 0.7, shift = {0, -40}},
	},
	unit = {
		count = 250,
		time = 30,
		ingredients = {
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
		},
	},
})
table.insert(newData, sulfurConcreteTech)

data:extend(newData)