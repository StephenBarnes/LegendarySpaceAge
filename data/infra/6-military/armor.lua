-- Armour should be cheaper, and require rubber.
Recipe.edit{
	recipe = "light-armor",
	ingredients = { -- Originally 40 iron plate.
		{"panel", 10},
		{"wiring", 2},
	},
	time = 5,
}
Recipe.edit{
	recipe = "heavy-armor",
	ingredients = { -- Originally 100 copper plate, 50 steel plate.
		{"steel-plate", 10},
		{"rubber", 20},
	},
	time = 10,
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
Recipe.edit{
	recipe = "power-armor-mk2",
	ingredients = { -- Originally 60 blue circuit + 100 speed module + 100 efficiency module + 40 actuator + 30 LDs. I need to remove the modules.
		{"processing-unit", 100},
		{"advanced-circuit", 100},
		{"electric-engine-unit", 50},
		{"low-density-structure", 50},
	},
	time = 20,
}
Recipe.edit{
	recipe = "mech-armor",
	ingredients = { -- Originally 100 blue circuit (replacing with white circuits), 50 supercapacitor (replacing with holmium batteries), 200 holmium plate (replaced with tungsten plate), 50 superconductor (removing), 1 power armor mk2.
		{"white-circuit", 100},
		{"holmium-battery", 50},
		{"tungsten-plate", 50},
		{"power-armor-mk2", 1},
	},
	time = 50, -- Originally 60.
}