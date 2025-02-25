-- Pipes
RECIPE["pipe"].ingredients = {
	{type = "item", name = "fluid-fitting", amount = 1},
	{type = "item", name = "panel", amount = 4},
}
RECIPE["pipe"].results = {{type = "item", name = "pipe", amount = 4}}
RECIPE["pipe-to-ground"].ingredients = {
	{type = "item", name = "pipe", amount = 12},
}
-- Pump
RECIPE["pump"].ingredients = {
	{type="item", name="frame", amount=2},
	{type="item", name="fluid-fitting", amount=4},
	{type="item", name="mechanism", amount=2},
}

Recipe.edit{
	recipe = "offshore-pump",
	ingredients = {
		{"fluid-fitting", 5},
		{"mechanism", 2},
	},
	time = 1,
}
Recipe.edit{
	recipe = "waste-pump",
	ingredients = {
		{"fluid-fitting", 5},
		{"mechanism", 2},
	},
	time = 1,
}
