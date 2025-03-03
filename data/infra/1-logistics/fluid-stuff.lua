-- Pipes
Recipe.edit{
	recipe = "pipe",
	ingredients = {
		{"fluid-fitting", 1},
		{"panel", 5},
	},
	time = 1,
	resultCount = 5,
}
Recipe.edit{
	recipe = "pipe-to-ground",
	ingredients = {{"pipe", 20}}, -- It's 12 pipes long, but making this higher so it's a regular number and since it's more convenient.
	resultCount = 2,
	time = 1,
}

Recipe.edit{
	recipe = "pump",
	ingredients = {
		{"frame", 2},
		{"fluid-fitting", 5},
		{"mechanism", 2},
	},
	time = 2,
}
local pump = RAW.pump.pump
pump.energy_usage = "40kW"
pump.energy_source.drain = "10kW"
pump.pumping_speed = 16.6667 -- This is 1000/60 per tick, so 1000 per second.

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