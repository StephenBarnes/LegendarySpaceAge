-- This file creates the "cladding" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- TODO create some icons in Midjourney, maybe, so I can have variants.

local Tech = require("code.util.tech")

-- Create item.
local claddingItem = table.deepcopy(data.raw.item["steel-plate"])
claddingItem.name = "cladding"
claddingItem.subgroup = "cladding"
claddingItem.order = "01"
claddingItem.icon = nil
claddingItem.icons = {{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/cladding.png", icon_size = 64, scale = 0.5}}
data:extend{claddingItem}

-- Create recipe: 4 iron plate + 2 iron rod -> 1 cladding
local recipeFromIron = table.deepcopy(data.raw.recipe["iron-stick"])
recipeFromIron.name = "cladding-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-plate", amount = 4},
	{type = "item", name = "iron-stick", amount = 2},
}
recipeFromIron.results = {{type = "item", name = "cladding", amount = 1}}
recipeFromIron.enabled = true
recipeFromIron.subgroup = "cladding"
recipeFromIron.order = "02"
recipeFromIron.energy_required = 6
recipeFromIron.category = "crafting"
recipeFromIron.icon = nil
recipeFromIron.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/cladding.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/iron-plate.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
data:extend{recipeFromIron}

-- Create recipe: 2 steel + 4 iron rod -> 2 cladding
local recipeFromSteel = table.deepcopy(data.raw.recipe["stone-brick"])
recipeFromSteel.name = "cladding-from-steel"
recipeFromSteel.ingredients = {
	{type = "item", name = "steel-plate", amount = 2},
	{type = "item", name = "iron-stick", amount = 2},
}
recipeFromSteel.results = {{type = "item", name = "cladding", amount = 2}}
recipeFromSteel.enabled = false
recipeFromSteel.subgroup = "cladding"
recipeFromSteel.order = "03"
recipeFromSteel.energy_required = 6
recipeFromSteel.category = "crafting"
recipeFromSteel.icon = nil
recipeFromSteel.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/cladding.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/steel-plate.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
data:extend{recipeFromSteel}
Tech.addRecipeToTech("cladding-from-steel", "steel-processing")

-- TODO make more recipes, and add them to techs.