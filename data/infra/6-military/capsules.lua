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

-- TODO adjust recipes for robot capsules - remove nesting.

-- Add subscript icons to poison/slowdown capsules.
RAW.capsule["poison-capsule"].icons = {
	{icon = RAW.capsule["poison-capsule"].icon, icon_size = 64, scale = .4, shift = {4, -4}},
	{icon = "__LegendarySpaceAge__/graphics/temp-delete/signal-skull.png", icon_size = 64, scale = .25, shift = {-8, 7}},
}
RAW.capsule["poison-capsule"].icon = nil
RAW.capsule["slowdown-capsule"].icons = {
	{icon = RAW.capsule["slowdown-capsule"].icon, icon_size = 64, scale = .4, shift = {4, -4}},
	{icon = "__LegendarySpaceAge__/graphics/temp-delete/signal-hourglass.png", icon_size = 64, scale = .25, shift = {-8, 7}},
}
RAW.capsule["slowdown-capsule"].icon = nil

-- Reorder. Put grenades after the poison/slowdown capsules, since I'm unlocking grenades later.
Gen.orderKinds("capsule", {RAW.capsule, RECIPE}, {
	"poison-capsule",
	"slowdown-capsule",
	"grenade",
	"cluster-grenade",
}, "1-")
Gen.orderKinds("capsule", {RAW.capsule, RECIPE}, {
	"defender-capsule",
	"distractor-capsule",
	"destroyer-capsule",
}, "2-")
Gen.orderKinds("capsule", {RAW["combat-robot"]}, {
	"defender",
	"distractor",
	"destroyer",
}, "2-")