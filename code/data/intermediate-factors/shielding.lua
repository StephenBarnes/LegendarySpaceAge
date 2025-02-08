-- This file creates the "shielding" intermediate, and its multiple recipes. See main.lua in this folder for more info.

local Tech = require "code.util.tech"

-- Create item.
local shieldingItem = table.deepcopy(data.raw.item["steel-plate"])
shieldingItem.name = "shielding"
shieldingItem.subgroup = "shielding"
shieldingItem.order = "01"
shieldingItem.icon = nil
shieldingItem.icons = {{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/shielding.png", icon_size = 64, scale = 0.5}}
data:extend{shieldingItem}

-- Create recipe: 12 iron plate -> 1 shielding
local recipeFromIron = table.deepcopy(data.raw.recipe["iron-stick"])
recipeFromIron.name = "shielding-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-plate", amount = 12},
}
recipeFromIron.results = {{type = "item", name = "shielding", amount = 1}}
recipeFromIron.enabled = true
recipeFromIron.subgroup = "shielding"
recipeFromIron.order = "02"
recipeFromIron.energy_required = 4
recipeFromIron.category = "crafting"
recipeFromIron.allow_as_intermediate = true
recipeFromIron.icon = nil
recipeFromIron.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/shielding.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/iron-plate.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
data:extend{recipeFromIron}

-- Create recipe: 4 steel plate + 2 iron rod -> 1 shielding
local recipeFromSteel = table.deepcopy(recipeFromIron)
recipeFromSteel.name = "shielding-from-steel"
recipeFromSteel.ingredients = {
	{type = "item", name = "steel-plate", amount = 4},
	{type = "item", name = "iron-stick", amount = 2},
}
recipeFromSteel.order = "03"
recipeFromSteel.allow_as_intermediate = false
recipeFromSteel.energy_required = 2
recipeFromSteel.icons[2] = {icon = "__base__/graphics/icons/steel-plate.png", icon_size = 64, scale = 0.25, shift = {-8, -8}}
recipeFromSteel.enabled = false
data:extend{recipeFromSteel}
Tech.addRecipeToTech("shielding-from-steel", "steel-processing")

-- Create recipe: 2 steel plate + 2 tungsten plate -> 2 shielding
local recipeFromTungsten = table.deepcopy(recipeFromSteel)
recipeFromTungsten.name = "shielding-from-tungsten"
recipeFromTungsten.ingredients = {
	{type = "item", name = "steel-plate", amount = 1},
	{type = "item", name = "tungsten-plate", amount = 2},
}
recipeFromTungsten.results = {{type = "item", name = "shielding", amount = 4}}
recipeFromTungsten.order = "04"
recipeFromTungsten.energy_required = 2
recipeFromTungsten.icons[2] = {icon = "__space-age__/graphics/icons/tungsten-plate.png", icon_size = 64, scale = 0.25, shift = {-8, -8}}
recipeFromTungsten.always_show_products = true
recipeFromTungsten.category = "metallurgy-or-assembling"
data:extend{recipeFromTungsten}
Tech.addRecipeToTech("shielding-from-tungsten", "tungsten-steel")

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?

-- TODO make sprites for shielding different for different recipes.