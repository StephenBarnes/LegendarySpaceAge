Recipe.edit{
	recipe = "rocket-silo",
	ingredients = { -- Originally 1000 steel plate + 200 blue circuit + 100 pipe + 1000 concrete + 200 electric engine unit.
		{"fluid-fitting", 50},
		{"shielding", 100},
		{"structure", 250},
		{"electric-engine-unit", 250},
	},
	time = 50,
}
Recipe.edit{
	recipe = "cargo-landing-pad",
	ingredients = { -- Originally 25 steel plate + 10 blue circuit + 200 concrete.
		{"structure", 50},
		{"electric-engine-unit", 25},
		{"sensor", 25},
	},
	time = 25,
}
Recipe.edit{
	recipe = "cargo-bay",
	ingredients = { -- Originally 20 steel plate + 5 blue circuit + 20 LDS. I'm changing it to not be buildable on space platforms.
		{"structure", 10},
		{"electric-engine-unit", 10},
		{"sensor", 10},
	},
	time = 10,
}
Recipe.edit{
	recipe = "space-platform-starter-pack",
	ingredients = { -- Originally 20 steel plate + 20 blue circuit + 60 space platform foundation.
		{"electric-engine-unit", 20},
		{"space-platform-foundation", 50},
	},
	time = 50,
}

-- Make space platform tiles more complex and expensive to produce.
-- Originally 20 steel plate + 20 copper cable.
Recipe.edit{
	recipe = "space-platform-foundation",
	ingredients = {
		{"low-density-structure", 5},
			-- Effectively 80 copper plate, 8 steel plate, 12 plastic, 4 resin.
		{"electric-engine-unit", 2},
	},
	time = 5,
}
Recipe.edit{
	recipe = "asteroid-collector",
	ingredients = { -- Originally 5 blue circuit + 8 electric engine unit + 20 LDS.
		{"sensor", 5},
		{"electric-engine-unit", 5},
		{"low-density-structure", 20},
	},
	time = 10,
}
Recipe.edit{
	recipe = "crusher",
	ingredients = { -- Originally 10 steel plate + 10 electric engine unit + 20 LDS.
		{"electric-engine-unit", 10},
		{"low-density-structure", 20},
	},
	time = 10,
}
Recipe.edit{
	recipe = "thruster",
	ingredients = { -- Originally 10 steel plate + 10 blue circuit + 5 electric engine unit.
		{"fluid-fitting", 20},
		{"shielding", 10},
		{"low-density-structure", 5},
	},
}