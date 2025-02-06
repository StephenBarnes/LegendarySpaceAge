-- This file creates the "mechanism" intermediate, and its multiple recipes. See main.lua in this folder for more info.

local Tech = require "code.util.tech"

-- Create item.
local mechanismItem = table.deepcopy(data.raw.item["steel-plate"])
mechanismItem.name = "mechanism"
mechanismItem.subgroup = "mechanism"
mechanismItem.order = "01"
mechanismItem.icon = nil
mechanismItem.icons = {{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/mechanism.png", icon_size = 64, scale = 0.5}}
data:extend{mechanismItem}

-- Create recipe: 8 machine parts + 1 frame -> 1 mechanism
local basicRecipe = table.deepcopy(data.raw.recipe["iron-stick"])
basicRecipe.name = "mechanism-from-basic"
basicRecipe.ingredients = {
	{type = "item", name = "iron-gear-wheel", amount = 8},
	{type = "item", name = "frame", amount = 1},
}
basicRecipe.results = {{type = "item", name = "mechanism", amount = 1}}
basicRecipe.enabled = true
basicRecipe.subgroup = "mechanism"
basicRecipe.order = "02"
basicRecipe.energy_required = 4
basicRecipe.category = "crafting"
basicRecipe.icon = nil
basicRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/mechanism.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-2.png", icon_size = 64, scale=0.2, mipmap_count=4, shift={-8, -7}},
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/plain/spring-2.png", icon_size = 64, scale=0.2, mipmap_count=4, shift={-7, -8}},
}
basicRecipe.allow_as_intermediate = true
data:extend{basicRecipe}

-- Create recipe: 4 advanced parts + 1 frame -> 1 mechanism
local advancedRecipe = table.deepcopy(basicRecipe)
advancedRecipe.name = "mechanism-from-advanced"
advancedRecipe.ingredients = {
	{type = "item", name = "advanced-parts", amount = 4},
	{type = "item", name = "frame", amount = 1},
}
advancedRecipe.order = "03"
advancedRecipe.energy_required = 2
advancedRecipe.icons[2] = {icon = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-3.png", icon_size = 64, scale=0.25, mipmap_count=4, shift={-8, -8}}
advancedRecipe.icons[3] = nil
advancedRecipe.allow_as_intermediate = false
advancedRecipe.enabled = false
data:extend{advancedRecipe}
Tech.addRecipeToTech("mechanism-from-advanced", "electric-engine")

-- Create recipe: 1 frame + 3 appendage -> 1 mechanism
local appendageRecipe = table.deepcopy(basicRecipe)
appendageRecipe.name = "mechanism-from-appendage"
appendageRecipe.ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "appendage", amount = 3},
}
appendageRecipe.order = "04"
appendageRecipe.energy_required = 4
appendageRecipe.icons[2] = {icon = "__LegendarySpaceAge__/graphics/gleba/appendage/1.png", icon_size = 64, scale=0.25, mipmap_count=4, shift={-8, -8}}
appendageRecipe.icons[3] = nil
appendageRecipe.allow_as_intermediate = false
appendageRecipe.enabled = false
appendageRecipe.category = "organic-or-assembling"
data:extend{appendageRecipe}

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?