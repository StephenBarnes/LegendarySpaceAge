-- Shotgun shells: I want these to be very cheap in raw materials.
Recipe.adjust{
	name = "shotgun-shell",
	ingredients = {
		{"iron-plate", 1},
		{"copper-plate", 1},
		{"gunpowder", 1},
	},
	resultCount = 1,
	time = 2,
}
-- Piercing shotgun shells: These are pretty late-game, so could make them complex.
Recipe.adjust{
	name = "piercing-shotgun-shell",
	ingredients = {
		{"copper-plate", 5},
		{"steel-plate", 1},
		{"gunpowder", 1},
	},
	time = 5,
}

Recipe.adjust{
	name = "firearm-magazine",
	ingredients = {
		{"iron-plate", 5},
		{"gunpowder", 1},
	},
	time = 2,
}
Recipe.adjust{ -- I want these to be more complex to produce than yellow mags, but not significantly more expensive, in fact cheaper with foundries.
	name = "piercing-rounds-magazine",
	ingredients = {
		{"steel-plate", 1},
		{"copper-plate", 2},
		{"gunpowder", 1},
	},
	resultCount = 1,
	time = 5,
}

Recipe.adjust{
	name = "flamethrower-ammo",
	ingredients = {
		{"fluid-fitting", 1},
		{"light-oil", 20},
	},
	time = 5,
}

-- Put shotgun shells before bullet magazines.
RAW.ammo["shotgun-shell"].order = "0-1"
RAW.ammo["piercing-shotgun-shell"].order = "0-2"