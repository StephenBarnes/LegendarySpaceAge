-- This file creates the "sensor" intermediate, and its multiple recipes. See main.lua in this folder for more info.

local Tech = require("code.util.tech")

-- Create item.
local sensorItem = table.deepcopy(data.raw.item["electronic-circuit"])
sensorItem.name = "sensor"
sensorItem.icon = "__LegendarySpaceAge__/graphics/intermediate-factors/sensor.png"
sensorItem.subgroup = "sensor"
sensorItem.order = "01"
data:extend{sensorItem}

-- Create recipe: 4 green circuit + 2 glass + 1 frame -> 1 sensor
local greenCircuitRecipe = table.deepcopy(data.raw.recipe["electronic-circuit"])
greenCircuitRecipe.name = "sensor-from-green-circuit"
greenCircuitRecipe.ingredients = {
	{type = "item", name = "electronic-circuit", amount = 5},
	{type = "item", name = "glass", amount = 2},
	{type = "item", name = "frame", amount = 1}
}
greenCircuitRecipe.results = {{type = "item", name = "sensor", amount = 1}}
greenCircuitRecipe.enabled = false
greenCircuitRecipe.subgroup = "sensor"
greenCircuitRecipe.order = "02"
greenCircuitRecipe.energy_required = 6
greenCircuitRecipe.icon = nil
greenCircuitRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/sensor.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/electronic-circuit.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
greenCircuitRecipe.allow_as_intermediate = true
data:extend{greenCircuitRecipe}
Tech.addRecipeToTech("sensor-from-green-circuit", "automation")

-- Create redCircuitRecipe: 2 red circuit + 1 glass + 1 frame -> 1 sensor
local redCircuitRecipe = table.deepcopy(greenCircuitRecipe)
redCircuitRecipe.name = "sensor-from-red-circuit"
redCircuitRecipe.ingredients = {
	{type = "item", name = "advanced-circuit", amount = 2},
	{type = "item", name = "glass", amount = 1},
	{type = "item", name = "frame", amount = 1}
}
redCircuitRecipe.order = "03"
redCircuitRecipe.enabled = false
redCircuitRecipe.icons[2] = {icon = "__base__/graphics/icons/advanced-circuit.png", icon_size = 64, scale = 0.25, shift = {-8, -8}}
redCircuitRecipe.allow_as_intermediate = false
redCircuitRecipe.energy_required = 2
data:extend{redCircuitRecipe}
Tech.addRecipeToTech("sensor-from-red-circuit", "advanced-circuit")

-- Create blueCircuitRecipe: 1 blue circuit + 1 glass + 1 frame -> 1 sensor
local blueCircuitRecipe = table.deepcopy(greenCircuitRecipe)
blueCircuitRecipe.name = "sensor-from-blue-circuit"
blueCircuitRecipe.ingredients = {
	{type = "item", name = "processing-unit", amount = 1},
	{type = "item", name = "glass", amount = 1},
	{type = "item", name = "frame", amount = 1}
}
blueCircuitRecipe.order = "04"
blueCircuitRecipe.enabled = false
blueCircuitRecipe.icons[2] = {icon = "__base__/graphics/icons/processing-unit.png", icon_size = 64, scale = 0.25, shift = {-8, -8}}
blueCircuitRecipe.allow_as_intermediate = false
blueCircuitRecipe.energy_required = 1
data:extend{blueCircuitRecipe}
Tech.addRecipeToTech("sensor-from-blue-circuit", "processing-unit")

-- TODO make more recipes, and add them to techs.