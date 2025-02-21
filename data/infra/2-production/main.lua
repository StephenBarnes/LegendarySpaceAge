require("assemblers")
require("furnaces")
require("data.infra.2-production.beacons-modules")
require("labs")
require("miners-etc")
require("boilers-heaters")

-- Repair pack
RECIPE["repair-pack"].ingredients = {
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}

-- Solar panels.
RECIPE["solar-panel"].ingredients = {
	{type = "item", name = "glass", amount = 10},
	{type = "item", name = "silicon", amount = 10},
	{type = "item", name = "electronic-circuit", amount = 2},
	{type = "item", name = "frame", amount = 2},
}
RECIPE["solar-panel"].energy_required = 10

RAW["solar-panel"]["solar-panel"].max_health = 50 -- From default 200. It's fragile.