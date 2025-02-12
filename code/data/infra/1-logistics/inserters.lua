local recipes = data.raw.recipe

-- Inserter recipes - rod is now enabled from the start.
recipes["burner-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
}
recipes["inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 1},
}
recipes["long-handed-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "mechanism", amount = 2},
	{type = "item", name = "sensor", amount = 1},
}
recipes["fast-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 1},
	{type = "fluid", name = "lubricant", amount = 20},
}
recipes["fast-inserter"].category = "crafting-with-fluid"
recipes["bulk-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "electric-engine-unit", amount = 1},
	{type = "item", name = "sensor", amount = 2},
	{type = "fluid", name = "lubricant", amount = 20},
}
recipes["bulk-inserter"].category = "crafting-with-fluid"
recipes["stack-inserter"].ingredients = {
	{type = "item", name = "bulk-inserter", amount = 1},
	{type = "item", name = "processing-unit", amount = 1},
	{type = "item", name = "carbon-fiber", amount = 2},
}