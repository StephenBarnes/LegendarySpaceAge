-- This file creates the "mechanism" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local mechanismItem = table.deepcopy(data.raw.item["steel-plate"])
mechanismItem.name = "mechanism"
mechanismItem.subgroup = "mechanism"
mechanismItem.order = "01"
mechanismItem.icon = nil
mechanismItem.icons = {{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/mechanism.png", icon_size = 64, scale = 0.5}}
data:extend{mechanismItem}

-- Create recipe: 4 machine parts + 1 frame -> 1 mechanism
local basicRecipe = table.deepcopy(data.raw.recipe["iron-stick"])
basicRecipe.name = "mechanism-from-basic"
basicRecipe.ingredients = {
	{type = "item", name = "iron-gear-wheel", amount = 4},
	{type = "item", name = "frame", amount = 1},
}
basicRecipe.results = {{type = "item", name = "mechanism", amount = 1}}
basicRecipe.enabled = true
basicRecipe.subgroup = "mechanism"
basicRecipe.order = "02"
basicRecipe.energy_required = 6
basicRecipe.category = "crafting"
basicRecipe.icon = nil
basicRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/mechanism.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/iron-plate.png", icon_size = 64, scale = 0.25, shift = {-8, -8}}, -- TODO
}
data:extend{basicRecipe}

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?