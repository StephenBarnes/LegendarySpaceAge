-- This file creates the "shielding" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local shieldingItem = table.deepcopy(data.raw.item["steel-plate"])
shieldingItem.name = "shielding"
shieldingItem.subgroup = "shielding"
shieldingItem.order = "01"
shieldingItem.icon = nil
shieldingItem.icons = {{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/shielding.png", icon_size = 64, scale = 0.5}}
data:extend{shieldingItem}

-- Create recipe: 8 iron plate -> 1 shielding
local recipeFromIron = table.deepcopy(data.raw.recipe["iron-stick"])
recipeFromIron.name = "shielding-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-plate", amount = 8},
}
recipeFromIron.results = {{type = "item", name = "shielding", amount = 1}}
recipeFromIron.enabled = true
recipeFromIron.subgroup = "shielding"
recipeFromIron.order = "02"
recipeFromIron.energy_required = 6
recipeFromIron.category = "crafting"
recipeFromIron.icon = nil
recipeFromIron.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/shielding.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/iron-plate.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
data:extend{recipeFromIron}

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?