Recipe.edit{
	recipe = "roboport",
	ingredients = {
		{"frame", 2},
		{"panel", 10},
		{"electric-engine-unit", 5},
		{"sensor", 5},
	},
	time = 10,
}

-- Make bots faster. This makes them a bit ridiculous at full +6 bot speed tech, but that's fine.
RAW["construction-robot"]["construction-robot"].speed = 0.12 -- Was 0.06
RAW["logistic-robot"]["logistic-robot"].speed = 0.10 -- Was 0.05