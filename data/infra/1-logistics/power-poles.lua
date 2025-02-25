Recipe.edit{
	recipe = "small-electric-pole",
	ingredients = {
		{"frame", 1},
		{"wiring", 1},
	},
	time = 0.5,
}
Recipe.edit{
	recipe = "medium-electric-pole",
	ingredients = {
		{"frame", 2},
		{"wiring", 1},
	},
	time = 1,
}
Recipe.edit{
	recipe = "big-electric-pole",
	ingredients = {
		{"structure", 1},
		{"frame", 2},
		{"wiring", 2},
	},
	time = 2,
}
Recipe.edit{
	recipe = "substation",
	ingredients = {
		{"frame", 5},
		{"advanced-circuit", 5},
	},
	time = 5,
}
Recipe.edit{
	recipe = "po-transformer",
	ingredients = {
		{"frame", 1},
		{"wiring", 1},
		{"electronic-components", 5},
	},
	time = 2,
}

-- Reduce ingredients for fuses, since default is 20 times normal power pole which seems excessive. Rather just the pole plus a wiring.
for _, size in pairs{"small", "medium", "big"} do
	Recipe.edit{
		recipe = "po-"..size.."-electric-fuse",
		ingredients = {
			{"electronic-components", 2},
			{size.."-electric-pole", 1},
		},
		time = RECIPE[size.."-electric-pole"].energy_required,
	}
end
