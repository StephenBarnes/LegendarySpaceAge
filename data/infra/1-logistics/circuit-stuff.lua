-- Lamp
RECIPE["small-lamp"].ingredients = {
	{ type = "item", name = "glass",  amount = 1 },
	{ type = "item", name = "wiring", amount = 1 },
	{ type = "item", name = "frame",  amount = 1 },
}
RECIPE["arithmetic-combinator"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="wiring", amount=2},
	{type="item", name="electronic-circuit", amount=1},
}
RECIPE["decider-combinator"].ingredients = RECIPE["arithmetic-combinator"].ingredients
RECIPE["selector-combinator"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 4},
	{type = "item", name = "electronic-circuit", amount = 4},
}
RECIPE["constant-combinator"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 2},
}
RECIPE["power-switch"].ingredients = RECIPE["po-transformer"].ingredients
RECIPE["power-switch"].energy_required = RECIPE["po-transformer"].energy_required
RECIPE["programmable-speaker"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "panel", amount = 1},
}
RECIPE["display-panel"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "glass", amount = 1},
}