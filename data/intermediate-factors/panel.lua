-- This file creates the "panel" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local panelItem = copy(ITEM["steel-plate"])
panelItem.name = "panel"
panelItem.subgroup = "panel"
panelItem.order = "01"
panelItem.icon = "__LegendarySpaceAge__/graphics/intermediate-factors/panel/panel.png"
extend{panelItem}

-- Create recipe: 1 iron plate -> 1 panel
local recipeFromIron = copy(RECIPE["iron-stick"])
recipeFromIron.name = "panel-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-plate", amount = 1},
}
recipeFromIron.results = {{type = "item", name = "panel", amount = 1}}
recipeFromIron.enabled = true
recipeFromIron.subgroup = "panel"
recipeFromIron.order = "03"
recipeFromIron.energy_required = 0.25
recipeFromIron.category = "crafting"
recipeFromIron.icon = nil
recipeFromIron.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/panel/iron-panel.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/iron-plate.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
recipeFromIron.allow_as_intermediate = true
extend{recipeFromIron}

-- Create recipe: 1 copper plate -> 1 panel
local recipeFromCopper = copy(recipeFromIron)
recipeFromCopper.name = "panel-from-copper"
recipeFromCopper.ingredients = {
	{type = "item", name = "copper-plate", amount = 1},
}
recipeFromCopper.order = "04"
recipeFromCopper.allow_as_intermediate = false
recipeFromCopper.icons[1] = {icon = "__LegendarySpaceAge__/graphics/intermediate-factors/panel/copper-panel.png", icon_size = 64, scale = 0.5}
recipeFromCopper.icons[2] = {icon = "__base__/graphics/icons/copper-plate.png", icon_size = 64, scale = 0.25, shift = {-8, -8}}
recipeFromCopper.allow_as_intermediate = false
extend{recipeFromCopper}

-- Create recipe: 1 wood + 1 resin -> 1 panel
local recipeFromWood = copy(recipeFromIron)
recipeFromWood.name = "panel-from-wood"
recipeFromWood.ingredients = {
	{type = "item", name = "wood", amount = 1},
	{type = "item", name = "resin", amount = 1},
}
recipeFromWood.order = "02"
recipeFromWood.allow_as_intermediate = false
recipeFromWood.icons[1] = {icon = "__LegendarySpaceAge__/graphics/intermediate-factors/panel/wooden-panel.png", icon_size = 64, scale = 0.5}
recipeFromWood.icons[2] = {icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale = 0.25, shift = {-8, -8}}
recipeFromWood.allow_as_intermediate = false
extend{recipeFromWood}


-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?