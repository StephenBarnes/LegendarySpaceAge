-- This file creates the "panel" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local panelItem = table.deepcopy(data.raw.item["steel-plate"])
panelItem.name = "panel"
panelItem.subgroup = "panel"
panelItem.order = "01"
panelItem.icon = nil
panelItem.icons = {{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/panel.png", icon_size = 64, scale = 0.5}}
data:extend{panelItem}

-- Create recipe: 1 iron plate -> 1 panel
local recipeFromIron = table.deepcopy(data.raw.recipe["iron-stick"])
recipeFromIron.name = "panel-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-plate", amount = 1},
}
recipeFromIron.results = {{type = "item", name = "panel", amount = 1}}
recipeFromIron.enabled = true
recipeFromIron.subgroup = "panel"
recipeFromIron.order = "02"
recipeFromIron.energy_required = 6
recipeFromIron.category = "crafting"
recipeFromIron.icon = nil
recipeFromIron.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/panel.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/iron-plate.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
data:extend{recipeFromIron}

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?