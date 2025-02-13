-- Electric poles
RECIPE["small-electric-pole"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
}
RECIPE["medium-electric-pole"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 1},
}
RECIPE["big-electric-pole"].ingredients = {
	{type = "item", name = "structure", amount = 1},
	{type = "item", name = "frame", amount = 3},
	{type = "item", name = "wiring", amount = 2},
}
RECIPE["substation"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "electronic-components", amount = 5},
	{type = "item", name = "advanced-circuit", amount = 5},
}
RECIPE["substation"].energy_required = 2
RECIPE["po-transformer"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 2},
	{type = "item", name = "electronic-circuit", amount = 2},
}