-- This file creates the "frame" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local frame = copy(ITEM["steel-plate"])
frame.name = "frame"
frame.icon = "__LegendarySpaceAge__/graphics/intermediate-factors/frame/frame.png"
frame.subgroup = "frame"
frame.order = "01"
frame.stack_size = 50
frame.weight = 1e6 / 500
data:extend{frame}

-- Create recipe: 2 wood + 1 resin -> 1 frame
local recipeFromWood = copy(RECIPE["iron-stick"])
recipeFromWood.name = "frame-from-wood"
recipeFromWood.ingredients = {
	{type = "item", name = "wood", amount = 2},
	{type = "item", name = "resin", amount = 1}
}
recipeFromWood.results = {{type = "item", name = "frame", amount = 1}}
recipeFromWood.enabled = true
recipeFromWood.subgroup = "frame"
recipeFromWood.order = "03"
recipeFromWood.energy_required = 10
recipeFromWood.category = "crafting"
recipeFromWood.allow_as_intermediate = false
recipeFromWood.icon = nil
recipeFromWood.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/frame/wooden-frame.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
	--{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale = 0.25, shift = {8, -8}},
}
data:extend{recipeFromWood}

-- Create recipe: 12 iron rods -> 1 frame
local recipeFromIron = copy(RECIPE["iron-stick"])
recipeFromIron.name = "frame-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-stick", amount = 10}
}
recipeFromIron.results = {{type = "item", name = "frame", amount = 1}}
recipeFromIron.enabled = true
recipeFromIron.subgroup = "frame"
recipeFromIron.order = "04"
recipeFromIron.energy_required = 5
recipeFromIron.category = "crafting"
recipeFromIron.allow_as_intermediate = true
recipeFromIron.icon = nil
recipeFromIron.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/frame/frame.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/iron-stick.png", icon_size = 64, scale = 0.27, shift = {-5, -5}},
}
data:extend{recipeFromIron}

-- Create recipe from tubules: 8 tubules + 20 slime -> 1 frame
local recipeFromTubules = copy(recipeFromIron)
recipeFromTubules.name = "frame-from-tubules"
recipeFromTubules.ingredients = {
	{type = "item", name = "tubule", amount = 5},
	{type = "fluid", name = "slime", amount = 20}
}
recipeFromTubules.enabled = false
recipeFromTubules.order = "05"
recipeFromTubules.energy_required = 5
recipeFromTubules.category = "crafting-with-fluid"
recipeFromTubules.allow_as_intermediate = false
recipeFromTubules.icons[2].icon = "__LegendarySpaceAge__/graphics/gleba/tubule/1.png"
data:extend{recipeFromTubules}

-- TODO create recipes for rigid structure
-- TODO add recipes to techs