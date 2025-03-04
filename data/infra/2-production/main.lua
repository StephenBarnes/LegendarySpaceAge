require("assemblers-furnaces")
require("beacons-modules")
require("labs")
require("miners-etc")
require("boilers-heaters")

-- Repair pack
Recipe.edit{
	recipe = "repair-pack",
	ingredients = {
		{"mechanism", 1},
		{"sensor", 1},
	},
}

-- Solar panels.
Recipe.edit{
	recipe = "solar-panel",
	ingredients = {
		{"glass", 10},
		{"silicon", 10},
		{"processing-unit", 2},
		{"frame", 2},
	},
	time = 10,
}

RAW["solar-panel"]["solar-panel"].max_health = 50 -- From default 200. It's fragile.

-- Edit some recipes to not use cryo plants.
RECIPE["fusion-generator"].category = "crafting"
RECIPE["fusion-reactor"].category = "crafting"