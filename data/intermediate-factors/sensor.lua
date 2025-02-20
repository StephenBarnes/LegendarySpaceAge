-- This file creates the "sensor" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local sensorItem = copy(ITEM["electronic-circuit"])
sensorItem.name = "sensor"
Icon.set(sensorItem, "LSA/intermediate-factors/sensor")
extend{sensorItem}

-- Create recipe: 4 green circuit + 2 glass + 1 frame -> 1 sensor
local greenCircuitRecipe = Recipe.make{
	copy = "electronic-circuit",
	recipe = "sensor-from-green-circuit",
	ingredients = {
		{"electronic-circuit", 5},
		{"glass", 3},
		{"frame", 1},
	},
	results = {{"sensor", 1}},
	enabled = false,
	time = 5,
	icons = {"sensor", "electronic-circuit"},
	allow_as_intermediate = true,
	allow_decomposition = true,
	auto_recycle = false,
}
Tech.addRecipeToTech("sensor-from-green-circuit", "automation")

-- Create redCircuitRecipe: 2 red circuit + 1 glass + 1 frame -> 1 sensor
local redCircuitRecipe = Recipe.make{
	copy = greenCircuitRecipe,
	recipe = "sensor-from-red-circuit",
	ingredients = {
		{"advanced-circuit", 2},
		{"glass", 1},
		{"frame", 1},
	},
	results = {{"sensor", 1}},
	time = 2,
	icons = {"sensor", "advanced-circuit"},
	allow_as_intermediate = false,
	allow_decomposition = false,
}
Tech.addRecipeToTech("sensor-from-red-circuit", "advanced-circuit")

-- Create blueCircuitRecipe: 1 blue circuit + 1 glass + 1 frame -> 2 sensors
local blueCircuitRecipe = Recipe.make{
	copy = redCircuitRecipe,
	recipe = "sensor-from-blue-circuit",
	ingredients = {
		{"processing-unit", 1},
		{"glass", 1},
		{"frame", 1},
	},
	results = {{"sensor", 1}},
	icons = {"sensor", "processing-unit"},
	time = 1,
}
Tech.addRecipeToTech("sensor-from-blue-circuit", "processing-unit")

-- Create sencytiumRecipe: 1 green circuit + 1 sencytium + 1 frame -> 1 sensor
local sencytiumRecipe = Recipe.make{
	copy = redCircuitRecipe,
	recipe = "sensor-from-sencytium",
	ingredients = {
		{"electronic-circuit", 1},
		{"sencytium", 1},
		{"frame", 1},
	},
	results = {{"sensor", 1}},
	icons = {"sensor", "sencytium"},
	time = 2,
}

-- TODO more recipes?

Gen.order({
	sensorItem,
	greenCircuitRecipe,
	redCircuitRecipe,
	blueCircuitRecipe,
	sencytiumRecipe,
}, "sensor")