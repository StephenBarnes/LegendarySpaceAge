-- TODO most of this file should be deleted since I'm removing all modules.

-- Edit beacon recipes. Note beacons are also edited in data/beacons.lua, which creates the basic beacon etc.
Recipe.edit{
	recipe = "basic-beacon",
	ingredients = {
		{"electronic-components", 10},
		{"electronic-circuit-primed", 10},
		{"frame", 5},
		{"sensor", 5},
	},
	time = 10,
}
Recipe.edit{
	recipe = "beacon",
	ingredients = {
		{"frame", 5},
		{"processing-unit-primed", 20},
		{"sensor", 20},
	},
	time = 20,
}

-- Edit recipes for primer and superclocker.
Recipe.edit{
	recipe = "circuit-primer",
	ingredients = {
		{"electronic-components", 50},
		{"frame", 10},
		{"sensor", 10},
		{"mechanism", 10},
	},
	time = 10,
}
Recipe.edit{
	recipe = "superclocker",
	ingredients = {
		{"shielding", 20},
		{"white-circuit-primed", 50},
		{"electric-engine-unit", 50},
		{"electrolyte", 200},
	},
	time = 20,
	category = "electromagnetics",
}