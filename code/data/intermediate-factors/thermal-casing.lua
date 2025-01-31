-- This file creates the "thermal casing" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- TODO create some icons in Midjourney, maybe, so I can have variants.

local Tech = require("code.util.tech")

-- Create item.
local thermalCasingItem = table.deepcopy(data.raw.item["steel-plate"])
thermalCasingItem.name = "thermal-casing"
thermalCasingItem.subgroup = "thermal-casing"
thermalCasingItem.order = "01"
thermalCasingItem.icon = nil
thermalCasingItem.icons = {{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/thermal-casing.png", icon_size = 64, scale = 0.5}}
data:extend{thermalCasingItem}

-- Create recipe: 4 stone brick + 4 steel -> 1 thermal casing
local recipeFromSteel = table.deepcopy(data.raw.recipe["stone-brick"])
recipeFromSteel.name = "thermal-casing-from-steel"
recipeFromSteel.ingredients = {
	{type = "item", name = "steel-plate", amount = 4},
	{type = "item", name = "stone-brick", amount = 4},
}
recipeFromSteel.results = {{type = "item", name = "thermal-casing", amount = 1}}
recipeFromSteel.enabled = false
recipeFromSteel.subgroup = "thermal-casing"
recipeFromSteel.order = "02"
recipeFromSteel.energy_required = 8
recipeFromSteel.category = "crafting"
recipeFromSteel.icon = nil
recipeFromSteel.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/thermal-casing.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/steel-plate.png", icon_size = 64, scale = 0.2, shift = {-8, -8}},
	{icon = "__base__/graphics/icons/stone-brick.png", icon_size = 64, scale = 0.2, shift = {8, -8}},
}
data:extend{recipeFromSteel}
Tech.addRecipeToTech("thermal-casing-from-steel", "advanced-material-processing")

-- TODO make more recipes, and add them to techs.