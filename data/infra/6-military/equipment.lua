Recipe.edit{
	recipe = "battery-equipment",
	ingredients = {
		{"battery", 5},
		{"processing-unit", 1},
	},
	time = 10,
}
Recipe.edit{
	recipe = "battery-mk2-equipment",
	ingredients = {
		{"battery-equipment", 10},
		{"processing-unit", 10},
		{"low-density-structure", 10},
	},
	time = 10,
}
Recipe.edit{
	recipe = "battery-mk3-equipment",
	ingredients = { -- Originally 10 supercapacitor + 5 personal battery mk2.
		{"holmium-battery", 10},
		{"battery-mk2-equipment", 5},
	},
}

Recipe.edit{
	recipe = "solar-panel-equipment",
	ingredients = {
		{"processing-unit", 2},
		{"solar-panel", 1},
		{"wiring", 1},
	},
	time = 10,
}

Recipe.edit{
	recipe = "fission-reactor-equipment",
	ingredients = { -- Originally 200 processing unit + 50 low density structure + 4 uranium fuel cell.
		{"white-circuit", 100},
		{"low-density-structure", 50},
		{"uranium-fuel-cell", 10},
	},
	time = 20,
}

Recipe.edit{
	recipe = "fusion-reactor-equipment",
	ingredients = { -- Originally 250 tungsten plate + 100 carbon fiber + 25 supercapacitor + 250 quantum processor + 10 fusion power cell + 1 fission reactor equipment.
		-- TODO edit this again after implementing Aquilo and Nauvis part 2.
		{"tungsten-plate", 250},
		{"carbon-fiber", 100},
		--{"supercapacitor", 25},
		{"quantum-processor", 250},
		{"fusion-power-cell", 10},
		{"fission-reactor-equipment", 1},
	},
	time = 50,
}

Recipe.edit{
	recipe = "belt-immunity-equipment",
	ingredients = { -- Originally 10 steel plate + 5 advanced circuit.
		{"electric-engine-unit", 5},
		{"sensor", 5},
	},
	time = 10,
}

Recipe.edit{
	recipe = "exoskeleton-equipment",
	ingredients = { -- Originally 20 steel plate + 10 processing unit + 30 electric engine unit.
		{"electric-engine-unit", 25},
		{"processing-unit", 10},
		{"frame", 10},
	},
	time = 10,
}

Recipe.edit{
	recipe = "personal-roboport-equipment",
	ingredients = { -- Originally 40 iron gear wheel + 20 steel plate + 45 battery + 10 advanced circuit.
		{"sensor", 10},
		{"battery", 25},
	},
	time = 10,
}
Recipe.edit{
	recipe = "personal-roboport-mk2-equipment",
	ingredients = { -- Originally 50 blue circuit + 50 superconductor + 5 personal roboport.
		{"white-circuit", 50},
		{"holmium-battery", 20},
		{"personal-roboport-equipment", 5},
	},
	time = 20,
}

Recipe.edit{
	recipe = "night-vision-equipment",
	ingredients = { -- Originally 10 steel plate + 5 advanced circuit.
		{"sensor", 2},
		{"processing-unit", 5},
	},
	time = 10,
}

Recipe.edit{
	recipe = "toolbelt-equipment",
	ingredients = { -- Originally 3 advanced circuit + 10 carbon fiber.
		{"electric-engine-unit", 1},
		{"carbon-fiber", 20},
	},
	time = 10,
}

Recipe.edit{
	recipe = "energy-shield-equipment",
	ingredients = { -- Originally 10 steel plate + 5 advanced circuit.
		{"sensor", 5},
		{"processing-unit", 5},
		{"electronic-components", 20},
	},
	time = 10,
}
Recipe.edit{
	recipe = "energy-shield-mk2-equipment",
	ingredients = { -- Originally 5 processing unit + 5 low density structure + 10 energy shield.
		{"white-circuit", 10},
		{"low-density-structure", 10},
		{"energy-shield-equipment", 10},
	},
	time = 10,
}

Recipe.edit{
	recipe = "personal-laser-defense-equipment",
	ingredients = { -- Originally 20 processing unit + 5 low-density structure + 5 laser turret.
		{"processing-unit", 10},
		{"low-density-structure", 10},
		{"laser-turret", 1},
	},
	time = 10,
}
Recipe.edit{
	recipe = "discharge-defense-equipment",
	ingredients = { -- Originally 20 steel plate + 5 processing unit + 10 laser turret.
		{"processing-unit", 5},
		{"shielding", 5},
		{"electronic-components", 20},
	},
	time = 10,
}