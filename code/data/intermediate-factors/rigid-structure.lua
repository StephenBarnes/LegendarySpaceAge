-- This file creates the "rigid structure" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local rigidStructure = table.deepcopy(data.raw.item["steel-plate"])
rigidStructure.name = "rigid-structure"
rigidStructure.icon = "__LegendarySpaceAge__/graphics/intermediate-factors/rigid-structure.png"
rigidStructure.subgroup = "rigid-structure"
rigidStructure.order = "01"
data:extend{rigidStructure}

-- Create recipe: 8 stone brick -> 1 rigid structure
--[[ Removing this bc it doesn't quite make sense. Rigid structure is supposed to represent a kind of scaffolding / frame.
local recipeFromStone = table.deepcopy(data.raw.recipe["stone-brick"])
recipeFromStone.name = "rigid-structure-from-stone"
recipeFromStone.ingredients = {{type = "item", name = "stone-brick", amount = 8}}
recipeFromStone.results = {{type = "item", name = "rigid-structure", amount = 1}}
recipeFromStone.enabled = true
recipeFromStone.subgroup = "rigid-structure"
recipeFromStone.order = "02"
recipeFromStone.energy_required = 8
recipeFromStone.category = "crafting"
recipeFromStone.icon = nil
recipeFromStone.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/rigid-structure.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/stone-brick.png", icon_size = 64, scale = 0.29, shift = {-5, -5}},
}
data:extend{recipeFromStone}
]]

-- Create recipe: 2 wood + 2 iron rods -> 1 rigid structure
local recipeFromWood = table.deepcopy(data.raw.recipe["iron-stick"])
recipeFromWood.name = "rigid-structure-from-wood"
recipeFromWood.ingredients = {
	{type = "item", name = "wood", amount = 2},
	{type = "item", name = "iron-stick", amount = 4}
}
recipeFromWood.results = {{type = "item", name = "rigid-structure", amount = 1}}
recipeFromWood.enabled = true
recipeFromWood.subgroup = "rigid-structure"
recipeFromWood.order = "03"
recipeFromWood.energy_required = 6
recipeFromWood.category = "crafting"
recipeFromWood.icon = nil
recipeFromWood.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/rigid-structure.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale = 0.29, shift = {-5, -5}},
}
data:extend{recipeFromWood}

-- Create recipe: 2 iron plates + 2 iron rods -> 1 rigid structure
local recipeFromIron = table.deepcopy(data.raw.recipe["iron-stick"])
recipeFromIron.name = "rigid-structure-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-plate", amount = 4},
	{type = "item", name = "iron-stick", amount = 2}
}
recipeFromIron.results = {{type = "item", name = "rigid-structure", amount = 1}}
recipeFromIron.enabled = true
recipeFromIron.subgroup = "rigid-structure"
recipeFromIron.order = "04"
recipeFromIron.energy_required = 4
recipeFromIron.category = "crafting"
recipeFromIron.icon = nil
recipeFromIron.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/rigid-structure.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/iron-plate.png", icon_size = 64, scale = 0.29, shift = {-5, -5}},
}
data:extend{recipeFromIron}

-- TODO create recipes for rigid structure
-- TODO add recipes to techs