-- This file creates the "sensor" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local sensorItem = table.deepcopy(data.raw.item["electronic-circuit"])
sensorItem.name = "sensor"
sensorItem.icon = "__LegendarySpaceAge__/graphics/intermediate-factors/sensor.png"
sensorItem.subgroup = "sensor"
sensorItem.order = "01"
data:extend{sensorItem}

-- Create recipe: 2 electronic circuit + 2 glass + 1 rigid structure -> 1 sensor
local basicRecipe = table.deepcopy(data.raw.recipe["electronic-circuit"])
basicRecipe.name = "sensor-from-basic"
basicRecipe.ingredients = {
	{type = "item", name = "electronic-circuit", amount = 2},
	{type = "item", name = "glass", amount = 2},
	{type = "item", name = "frame", amount = 1}
}
basicRecipe.results = {{type = "item", name = "sensor", amount = 1}}
basicRecipe.enabled = true
basicRecipe.subgroup = "sensor"
basicRecipe.order = "02"
basicRecipe.energy_required = 6
basicRecipe.icon = nil
basicRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/sensor.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/electronic-circuit.png", icon_size = 64, scale = 0.2, shift = {-8, -8}},
}
data:extend{basicRecipe}

-- TODO make more recipes, and add them to techs.