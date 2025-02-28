Recipe.edit{
	recipe = "lab",
	ingredients = {
		{"frame", 2},
		{"mechanism", 5},
		{"sensor", 5},
	},
	time = 5,
}
Recipe.edit{
	recipe = "glebalab",
	ingredients = {
		{"frame", 10},
		{"electric-engine-unit", 10},
		{"sensor", 20},
		{"geoplasm", 100, type = "fluid"},
	},
	time = 20,
	category = "crafting-with-fluid",
}
Recipe.edit{ -- TODO edit this after I do Nauvis part 2. Eg should require meat paste, etc.
	recipe = "biolab",
	ingredients = {
		{"low-density-structure", 50},
		{"white-circuit", 50},
		{"uranium-fuel-cell", 5},
		{"biter-egg", 5},
	},
	time = 20,
}