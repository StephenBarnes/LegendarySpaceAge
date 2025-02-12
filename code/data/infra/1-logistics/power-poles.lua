local recipes = data.raw.recipe

-- Electric poles
recipes["small-electric-pole"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
}
recipes["medium-electric-pole"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 1},
}
recipes["big-electric-pole"].ingredients = {
	{type = "item", name = "structure", amount = 1},
	{type = "item", name = "frame", amount = 3},
	{type = "item", name = "wiring", amount = 2},
}
recipes["substation"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 4},
	{type = "item", name = "advanced-circuit", amount = 4},
}
recipes["po-transformer"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 2},
	{type = "item", name = "electronic-circuit", amount = 2},
}