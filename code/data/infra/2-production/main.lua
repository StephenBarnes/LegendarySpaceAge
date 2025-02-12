require("assemblers")
require("furnaces")
require("modules")
require("labs")
require("mining-drills")
require("boilers-heaters")

local recipes = data.raw.recipe

-- Repair pack
recipes["repair-pack"].ingredients = {
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}

-- Solar panels.
recipes["solar-panel"].ingredients = {
	{type = "item", name = "glass", amount = 10},
	{type = "item", name = "silicon", amount = 10},
	{type = "item", name = "electronic-circuit", amount = 2},
	{type = "item", name = "frame", amount = 2},
}
recipes["solar-panel"].energy_required = 10

-- Ag tower - shouldn't need steel, or landfill, or spoilage. Moving it to early game on Nauvis.
recipes["agricultural-tower"].ingredients = {
	{type="item", name="mechanism", amount=2},
	{type="item", name="frame", amount=1},
	{type="item", name="sensor", amount=1},
	{type="item", name="glass", amount=4},
}