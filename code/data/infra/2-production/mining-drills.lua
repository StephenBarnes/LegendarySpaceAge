-- Burner mining drill shouldn't need stone.
RECIPE["burner-mining-drill"].ingredients = {
	{type="item", name="mechanism", amount=1},
	{type="item", name="frame", amount=1},
}
RECIPE["burner-mining-drill"].energy_required = 1

RECIPE["big-mining-drill"].ingredients = {
	{type="item", name="electric-engine-unit", amount=8},
	{type="item", name="processing-unit", amount=10},
	{type="item", name="tungsten-carbide", amount=20},
	{type="fluid", name="molten-steel", amount=200},
}