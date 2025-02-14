-- Inserter recipes - rod is now enabled from the start.
RECIPE["burner-inserter"].ingredients = {
	{type = "item", name = "mechanism", amount = 1},
}
RECIPE["inserter"].ingredients = {
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 1},
}
RECIPE["long-handed-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 2},
	{type = "item", name = "sensor", amount = 1},
}
RECIPE["fast-inserter"].ingredients = {
	{type = "item", name = "electric-engine-unit", amount = 1},
	{type = "item", name = "sensor", amount = 1},
}
RECIPE["fast-inserter"].category = "crafting"
RECIPE["bulk-inserter"].ingredients = {
	{type = "item", name = "electric-engine-unit", amount = 2},
	{type = "item", name = "sensor", amount = 1},
}
RECIPE["bulk-inserter"].category = "crafting"
RECIPE["stack-inserter"].ingredients = {
	{type = "item", name = "bulk-inserter", amount = 1},
	{type = "item", name = "neurofibril", amount = 2},
}