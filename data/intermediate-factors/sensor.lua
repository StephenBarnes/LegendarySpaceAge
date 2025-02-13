-- This file creates the "sensor" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local sensorItem = copy(ITEM["electronic-circuit"])
sensorItem.name = "sensor"
Icon.set(sensorItem, "LSA/intermediate-factors/sensor")
extend{sensorItem}

-- Create recipe: 4 green circuit + 2 glass + 1 frame -> 1 sensor
local greenCircuitRecipe = copy(RECIPE["electronic-circuit"])
greenCircuitRecipe.name = "sensor-from-green-circuit"
greenCircuitRecipe.ingredients = {
	{type = "item", name = "electronic-circuit", amount = 5},
	{type = "item", name = "glass", amount = 3},
	{type = "item", name = "frame", amount = 1}
}
greenCircuitRecipe.results = {{type = "item", name = "sensor", amount = 1}}
greenCircuitRecipe.enabled = false
greenCircuitRecipe.energy_required = 5
Icon.set(greenCircuitRecipe, {"sensor", "electronic-circuit"})
greenCircuitRecipe.allow_as_intermediate = true
greenCircuitRecipe.allow_decomposition = true
extend{greenCircuitRecipe}
Tech.addRecipeToTech("sensor-from-green-circuit", "automation")

-- Create redCircuitRecipe: 2 red circuit + 1 glass + 1 frame -> 1 sensor
local redCircuitRecipe = copy(greenCircuitRecipe)
redCircuitRecipe.name = "sensor-from-red-circuit"
redCircuitRecipe.ingredients = {
	{type = "item", name = "advanced-circuit", amount = 2},
	{type = "item", name = "glass", amount = 1},
	{type = "item", name = "frame", amount = 1}
}
redCircuitRecipe.enabled = false
Icon.set(redCircuitRecipe, {"sensor", "advanced-circuit"})
redCircuitRecipe.allow_as_intermediate = false
redCircuitRecipe.allow_decomposition = false
redCircuitRecipe.energy_required = 2.5
extend{redCircuitRecipe}
Tech.addRecipeToTech("sensor-from-red-circuit", "advanced-circuit")

-- Create blueCircuitRecipe: 1 blue circuit + 1 glass + 1 frame -> 2 sensors
local blueCircuitRecipe = copy(greenCircuitRecipe)
blueCircuitRecipe.name = "sensor-from-blue-circuit"
blueCircuitRecipe.ingredients = {
	{type = "item", name = "processing-unit", amount = 1},
	{type = "item", name = "glass", amount = 1},
	{type = "item", name = "frame", amount = 1}
}
blueCircuitRecipe.results = {{type = "item", name = "sensor", amount = 2}}
blueCircuitRecipe.enabled = false
Icon.set(blueCircuitRecipe, {"sensor", "processing-unit"})
blueCircuitRecipe.allow_as_intermediate = false
blueCircuitRecipe.allow_decomposition = false
blueCircuitRecipe.energy_required = 1
extend{blueCircuitRecipe}
Tech.addRecipeToTech("sensor-from-blue-circuit", "processing-unit")

-- Create sencytiumRecipe: 1 green circuit + 1 sencytium + 1 frame -> 1 sensor
local sencytiumRecipe = copy(greenCircuitRecipe)
sencytiumRecipe.name = "sensor-from-sencytium"
sencytiumRecipe.ingredients = {
	{type = "item", name = "electronic-circuit", amount = 1},
	{type = "item", name = "sencytium", amount = 1},
	{type = "item", name = "frame", amount = 1}
}
sencytiumRecipe.results = {{type = "item", name = "sensor", amount = 1}}
sencytiumRecipe.enabled = false
Icon.set(sencytiumRecipe, {"sensor", "sencytium"})
sencytiumRecipe.allow_as_intermediate = false
sencytiumRecipe.allow_decomposition = false
sencytiumRecipe.energy_required = 2
extend{sencytiumRecipe}

-- TODO make more recipes, and add them to techs.

Gen.order({
	sensorItem,
	greenCircuitRecipe,
	redCircuitRecipe,
	blueCircuitRecipe,
	sencytiumRecipe,
}, "sensor")