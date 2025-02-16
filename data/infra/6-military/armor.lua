-- Armour should be cheaper, and require rubber.
Recipe.edit{
	recipe = "light-armor",
	ingredients = { -- Originally 40 iron plate.
		{"panel", 10},
	},
}
Recipe.edit{
	recipe = "heavy-armor",
	ingredients = { -- Originally 100 copper plate, 50 steel plate.
		{"steel-plate", 10},
		{"rubber", 20},
	},
}
Tech.setPrereqs("heavy-armor", {"rubber-1", "steel-processing"})
Recipe.edit{
	recipe = "modular-armor",
	ingredients = { -- Originally 50 steel plate, 30 advanced circuits.
		{"steel-plate", 20},
		{"advanced-circuit", 20},
		{"rubber", 20},
	},
}
Recipe.edit{
	recipe = "power-armor",
	ingredients = { -- Originally 40 steel plate, 20 electric engine unit, 40 processing unit.
		{"steel-plate", 20},
		{"processing-unit", 20},
		{"electric-engine-unit", 20},
		{"rubber", 20},
	},
}