local recipes = data.raw.recipe

-- Pipes
recipes["pipe"].ingredients = {
	{type = "item", name = "fluid-fitting", amount = 1},
	{type = "item", name = "panel", amount = 4},
}
recipes["pipe"].results = {{type = "item", name = "pipe", amount = 4}}
recipes["pipe-to-ground"].ingredients = {
	{type = "item", name = "pipe", amount = 12},
}
-- Pump
recipes["pump"].ingredients = {
	{type="item", name="frame", amount=2},
	{type="item", name="fluid-fitting", amount=4},
	{type="item", name="mechanism", amount=2},
}