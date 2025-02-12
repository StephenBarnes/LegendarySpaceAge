local recipes = data.raw.recipe

-- Lamp
recipes["small-lamp"].ingredients = {
	{ type = "item", name = "glass",  amount = 1 },
	{ type = "item", name = "wiring", amount = 1 },
	{ type = "item", name = "frame",  amount = 1 },
}
recipes["arithmetic-combinator"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="wiring", amount=2},
	{type="item", name="electronic-circuit", amount=1},
}
recipes["decider-combinator"].ingredients = data.raw.recipe["arithmetic-combinator"].ingredients
recipes["selector-combinator"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 4},
	{type = "item", name = "electronic-circuit", amount = 4},
}
recipes["constant-combinator"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 2},
}
recipes["power-switch"].ingredients = data.raw.recipe["po-transformer"].ingredients
recipes["programmable-speaker"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "panel", amount = 1},
}
recipes["display-panel"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "glass", amount = 1},
}