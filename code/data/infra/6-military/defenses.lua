local recipes = data.raw.recipe

recipes["stone-wall"].ingredients = {
	{type = "item", name = "structure", amount = 1},
}

recipes["gate"].ingredients = {
	{type = "item", name = "shielding", amount = 4},
	{type = "item", name = "sensor", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
}
recipes["gate"].results = {{type = "item", name = "gate", amount = 4}}

recipes["radar"].ingredients = {
	{type = "item", name = "iron-stick", amount = 5},
	{type = "item", name = "iron-plate", amount = 10},
	{type = "item", name = "iron-gear-wheel", amount = 5},
	{type = "item", name = "electronic-circuit", amount = 5},
}