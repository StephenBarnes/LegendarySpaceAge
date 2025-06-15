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
		{"panel", 1},
		{"pitch", 2},
		{"ammonia", 5},
		{"sulfuric-acid", 5},
	},
	time = 5,
	category = "chemistry",
}
Recipe.edit{
	recipe = "slowdown-capsule",
	ingredients = {
		{"panel", 1},
		{"resin", 2},
		{"tar", 5},
		{"water", 5},
	},
	time = 5,
	category = "chemistry",
}
Recipe.edit{
	recipe = "land-mine",
	ingredients = {
		{"panel", 2},
		--{"gunpowder", 1},
		{"explosives", 1},
	},
	resultCount = 2,
	time = 1,
}
Recipe.edit{
	recipe = "poison-land-mine",
	ingredients = {
		{"panel", 1},
		{"explosives", 1},
		{"pitch", 2},
		{"ammonia", 5},
		{"sulfuric-acid", 5},
	},
	resultCount = 1,
	time = 5,
	category = "chemistry",
}
Recipe.edit{
	recipe = "slowdown-land-mine",
	ingredients = {
		{"panel", 1},
		{"explosives", 1},
		{"resin", 2},
		{"tar", 5},
		{"water", 5},
	},
	resultCount = 1,
	time = 5,
	category = "chemistry",
}

-- TODO adjust recipes for robot capsules - remove nesting.

-- Add subscript icons to poison/slowdown capsules and landmines.
for _, vals in pairs{
	{"capsule", "poison-capsule", "skull"},
	{"capsule", "slowdown-capsule", "hourglass"},
	{"land-mine", "poison-land-mine", "skull"},
	{"land-mine", "slowdown-land-mine", "hourglass"},
	{"item", "poison-land-mine", "skull"},
	{"item", "slowdown-land-mine", "hourglass"},
} do
	local proto = RAW[vals[1]][vals[2]]
	proto.icons = {
		{icon = proto.icon, icon_size = 64, scale = .4, shift = {4, -4}},
		{icon = "__base__/graphics/icons/signal/signal-" .. vals[3] .. ".png", icon_size = 64, scale = .25, shift = {-8, 7}},
	}
	proto.icon = nil
end