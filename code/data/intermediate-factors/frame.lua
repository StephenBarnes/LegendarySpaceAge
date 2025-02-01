-- This file creates the "frame" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local frame = table.deepcopy(data.raw.item["steel-plate"])
frame.name = "frame"
frame.icon = "__LegendarySpaceAge__/graphics/intermediate-factors/frame.png"
frame.subgroup = "frame"
frame.order = "01"
data:extend{frame}

-- Create recipe: 2 wood + 1 resin -> 1 frame
local recipeFromWood = table.deepcopy(data.raw.recipe["iron-stick"])
recipeFromWood.name = "frame-from-wood"
recipeFromWood.ingredients = {
	{type = "item", name = "wood", amount = 2},
	{type = "item", name = "resin", amount = 1}
}
recipeFromWood.results = {{type = "item", name = "frame", amount = 1}}
recipeFromWood.enabled = true
recipeFromWood.subgroup = "frame"
recipeFromWood.order = "03"
recipeFromWood.energy_required = 6
recipeFromWood.category = "crafting"
recipeFromWood.icon = nil
recipeFromWood.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/frame.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
	{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale = 0.25, shift = {8, -8}},
}
data:extend{recipeFromWood}

-- Create recipe: 12 iron rods -> 1 frame
local recipeFromIron = table.deepcopy(data.raw.recipe["iron-stick"])
recipeFromIron.name = "frame-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-stick", amount = 8}
}
recipeFromIron.results = {{type = "item", name = "frame", amount = 1}}
recipeFromIron.enabled = true
recipeFromIron.subgroup = "frame"
recipeFromIron.order = "04"
recipeFromIron.energy_required = 4
recipeFromIron.category = "crafting"
recipeFromIron.icon = nil
recipeFromIron.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/frame.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/iron-stick.png", icon_size = 64, scale = 0.3, shift = {-5, -5}},
}
data:extend{recipeFromIron}

-- TODO create recipes for rigid structure
-- TODO add recipes to techs