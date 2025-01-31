-- This file creates the "thermal casing" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- TODO create some icons in Midjourney, maybe, so I can have variants.

-- Create item.
local thermalCasingItem = table.deepcopy(data.raw.item["stone-brick"])
thermalCasingItem.name = "thermal-casing"
thermalCasingItem.subgroup = "thermal-casing"
thermalCasingItem.order = "01"
thermalCasingItem.icon = nil
thermalCasingItem.icons = {{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/thermal-casing.png", icon_size = 64, scale = 0.5}}
data:extend{thermalCasingItem}

-- Create recipe: 4 stone brick + 4 steel -> 1 thermal casing
local recipeFromStone = table.deepcopy(data.raw.recipe["stone-brick"])
recipeFromStone.name = "thermal-casing-from-stone"
recipeFromStone.ingredients = {
	{type = "item", name = "stone-brick", amount = 4},
	{type = "item", name = "steel-plate", amount = 4}
}
recipeFromStone.results = {{type = "item", name = "thermal-casing", amount = 1}}
recipeFromStone.enabled = true
recipeFromStone.subgroup = "thermal-casing"
recipeFromStone.order = "02"
recipeFromStone.energy_required = 8
recipeFromStone.category = "crafting"
recipeFromStone.icon = nil
recipeFromStone.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/thermal-casing.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/stone-brick.png", icon_size = 64, scale = 0.2, shift = {-8, -8}},
	{icon = "__base__/graphics/icons/steel-plate.png", icon_size = 64, scale = 0.2, shift = {8, -8}},
}
data:extend{recipeFromStone}

-- TODO make more recipes, and add them to techs.