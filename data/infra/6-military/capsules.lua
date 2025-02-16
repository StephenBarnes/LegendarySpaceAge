Recipe.edit{
	recipe = "grenade",
	ingredients = {
		{"mechanism", 1},
		{"explosives", 1},
	},
	time = 10,
}
Recipe.edit{
	recipe = "cluster-grenade",
	ingredients = {
		{"mechanism", 1},
		{"grenade", 5},
	},
	time = 10,
}
Recipe.edit{
	recipe = "poison-capsule",
	ingredients = {
		{"mechanism", 1},
		{"pitch", 2},
		{"ammonia", 5},
		{"sulfuric-acid", 5},
	},
	time = 10,
	category = "chemistry",
}
Recipe.edit{
	recipe = "slowdown-capsule",
	ingredients = {
		{"mechanism", 1},
		{"resin", 2},
		{"tar", 5},
		{"water", 5},
	},
	time = 10,
	category = "chemistry",
}

-- TODO adjust robot capsules - remove nesting.