Recipe.edit{
	recipe = "rail",
	ingredients = {
		{"sand", 1},
		{"frame", 1},
		-- Stone in rail recipe represents the track ballast; makes sense to crush/process stone before using as ballast. So I'm putting sand as an ingredient here.
	},
	resultCount = 2,
	time = 0.5,
}
Recipe.edit{
	recipe = "rail-ramp",
	ingredients = {
		{"structure", 20},
		{"frame", 20},
		{"rail", 10},
	},
	time = 10,
}
Recipe.edit{
	recipe = "rail-support",
	ingredients = {
		{"structure", 5},
		{"frame", 5},
	},
	time = 5,
}
Recipe.edit{
	recipe = "train-stop",
	ingredients = {
		{"frame", 2},
		{"small-lamp", 2},
		{"sensor", 1},
	},
	time = 1,
}

Recipe.edit{
	recipe = "rail-signal",
	ingredients = {
		{"frame", 1},
		{"sensor", 1},
		{"small-lamp", 1},
	},
	time = 1,
}
Recipe.edit{
	recipe = "rail-chain-signal",
	ingredients = {
		{"frame", 1},
		{"sensor", 2},
		{"small-lamp", 1},
	},
	time = 1,
}
Recipe.edit{
	recipe = "locomotive",
	ingredients = {
		{"engine-unit", 5},
		{"sensor", 5},
		{"shielding", 5},
		{"frame", 5},
	},
	time = 5,
}
Recipe.edit{
	recipe = "cargo-wagon",
	ingredients = {
		{"frame", 5},
		{"mechanism", 2},
		{"panel", 20},
	},
	time = 5,
}
Recipe.edit{
	recipe = "artillery-wagon",
	ingredients = {
		{"frame", 5},
		{"shielding", 50},
		{"electric-engine-unit", 10},
	},
	time = 20,
}