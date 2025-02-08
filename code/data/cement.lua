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

local Recipe = require("code.util.recipe")

-- Create new "cement" fluid.
local cementFluid = table.deepcopy(data.raw.fluid["lubricant"])
cementFluid.name = "cement"
cementFluid.icon = nil
cementFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/fluids/cement-fluid.png", scale = .5, icon_size = 64}}
cementFluid.auto_barrel = false
cementFluid.base_color = {.33, .33, .33, 1}
cementFluid.flow_color = {.6, .6, .6, 1}
cementFluid.visualization_color = {.43, .43, .43, 1}
data:extend{cementFluid}

-- Create recipe for cement.
local cementRecipe = table.deepcopy(data.raw.recipe["lubricant"])
cementRecipe.name = "make-cement" -- Must be different from cement so it appears in factoriopedia correctly.
cementRecipe.localised_name = {"fluid-name.cement"}
cementRecipe.subgroup = "terrain"
cementRecipe.order = "b[a]"
cementRecipe.ingredients = {
	{type = "item", name = "stone", amount = 2},
	{type = "item", name = "sand", amount = 2},
	{type = "fluid", name = "water", amount = 40},
}
cementRecipe.results = {
	{type = "fluid", name = "cement", amount = 40},
}
cementRecipe.main_product = "cement"
cementRecipe.category = "crafting-with-fluid"
cementRecipe.allow_decomposition = true
data:extend{cementRecipe}

-- Create tech for cement and brick structure.
local tech = table.deepcopy(data.raw.technology.concrete)
tech.name = "cement"
tech.effects = {
	{
		type = "unlock-recipe",
		recipe = "make-cement",
	},
}
tech.prerequisites = {"filtration-lake-water"}
tech.research_trigger = nil
tech.unit = {
	count = 15,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
	},
}
tech.icon = "__LegendarySpaceAge__/graphics/fluids/cement-tech.png"
data:extend{tech}

-- Adjust recipes for concrete and refined concrete.
data.raw.recipe["concrete"].ingredients = {
	{type = "fluid", name = "cement", amount = 100},
	{type = "item", name = "stone", amount = 8},
	{type = "item", name = "iron-stick", amount = 4},
}
data.raw.recipe["refined-concrete"].ingredients = {
	{type = "fluid", name = "cement", amount = 100},
	{type = "item", name = "resin", amount = 2},
	{type = "item", name = "ash", amount = 2},
	{type = "item", name = "steel-plate", amount = 4},
}

-- Create sulfur concrete recipes for foundries.
-- TODO
local concreteCastingRecipe = table.deepcopy(data.raw.recipe["concrete-from-molten-iron"])
concreteCastingRecipe.name = "sulfur-concrete"
concreteCastingRecipe.ingredients = {
	{type = "item", name = "sulfur", amount = 30},
	{type = "item", name = "sand", amount = 30},
}
concreteCastingRecipe.results = {
	{type = "item", name = "concrete", amount = 20},
}
concreteCastingRecipe.icon = nil
concreteCastingRecipe.icons = {
	{icon = "__base__/graphics/icons/concrete.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={-4, 4}},
	{icon = "__LegendarySpaceAge__/graphics/vulcanus/sulfur-cast.png", icon_size = 64, scale = 0.5, mipmap_count = 4, shift = {4, -4}},
}
data:extend{concreteCastingRecipe}

local refinedConcreteCastingRecipe = table.deepcopy(data.raw.recipe["concrete-from-molten-iron"])
refinedConcreteCastingRecipe.name = "sulfur-refined-concrete"
refinedConcreteCastingRecipe.ingredients = {
	{type = "item", name = "sulfur", amount = 30},
	{type = "item", name = "sand", amount = 30},
	{type = "item", name = "resin", amount = 1},
	{type = "fluid", name = "molten-steel", amount = 40},
}
refinedConcreteCastingRecipe.results = {
	{type = "item", name = "refined-concrete", amount = 20},
}
refinedConcreteCastingRecipe.icon = nil
refinedConcreteCastingRecipe.icons = {
	{icon = "__base__/graphics/icons/refined-concrete.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={-4, 4}},
	{icon = "__LegendarySpaceAge__/graphics/vulcanus/sulfur-cast.png", icon_size = 64, scale = 0.5, mipmap_count = 4, shift = {4, -4}},
}
data:extend{refinedConcreteCastingRecipe}

-- Hide old concrete foundry recipe completely.
Recipe.hide("concrete-from-molten-iron")

-- Create sulfur concrete tech.
local sulfurConcreteTech = table.deepcopy(data.raw.technology["concrete"])
sulfurConcreteTech.name = "sulfur-concrete"
sulfurConcreteTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "sulfur-concrete",
	},
	{
		type = "unlock-recipe",
		recipe = "sulfur-refined-concrete",
	},
}
sulfurConcreteTech.prerequisites = {
	"foundry",
}
sulfurConcreteTech.icon = nil
sulfurConcreteTech.icons = {
	{icon = "__base__/graphics/technology/concrete.png", icon_size = 256, scale = 1},
	{icon = "__base__/graphics/technology/sulfur-processing.png", icon_size = 256, scale = 0.7, shift = {0, -40}},
}
sulfurConcreteTech.unit = {
	count = 250,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
	},
}
data:extend{sulfurConcreteTech}