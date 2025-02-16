-- Burner mining drill shouldn't need stone.
Recipe.edit{
	recipe = "burner-mining-drill",
	ingredients = {
		{"mechanism", 1},
		{"frame", 1},
	},
	time = 1,
}
Recipe.edit{
	recipe = "electric-mining-drill",
	ingredients = {
		{"mechanism", 2},
		{"electronic-circuit", 2},
		{"frame", 2},
	},
	time = 2,
}
Recipe.edit{
	recipe = "big-mining-drill",
	ingredients = {
		{"electric-engine-unit", 10},
		{"processing-unit", 10},
		{"tungsten-carbide", 20},
		{"molten-steel", 200, type = "fluid"},
	},
	time = 20,
}

Recipe.edit{
	recipe = "pumpjack",
	ingredients = {
		{"mechanism", 10},
		{"frame", 5},
		{"sensor", 1},
		{"fluid-fitting", 20},
	},
	time = 10,
}

-- Ag tower - shouldn't need steel, or landfill, or spoilage. Moving it to early game on Nauvis.
Recipe.edit{
	recipe = "agricultural-tower",
	ingredients = {
		{"mechanism", 2},
		{"frame", 2},
		{"sensor", 1},
		{"glass", 2},
	},
	time = 10,
}