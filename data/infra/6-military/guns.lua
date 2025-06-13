Recipe.edit{
	recipe = "shotgun",
	ingredients = {"mechanism", "frame"},
	time = 5,
}
Recipe.edit{
	recipe = "submachine-gun",
	ingredients = {
		{"mechanism", 2},
		{"frame", 1},
	},
}
Recipe.edit{
	recipe = "combat-shotgun",
	ingredients = {
		{"mechanism", 2},
		{"frame", 1},
		{"shielding", 1},
	},
}
Recipe.edit{
	recipe = "flamethrower",
	ingredients = {
		{"mechanism", 1},
		{"frame", 1},
		{"fluid-fitting", 2},
	},
}
Recipe.edit{
	recipe = "rocket-launcher",
	ingredients = {
		{"mechanism", 1},
		{"frame", 1},
		{"sensor", 1},
		{"shielding", 1},
	},
}
Recipe.edit{
	recipe = "railgun",
	category = "crafting-with-fluid", -- Not cryo plant.
	-- TODO edit ingredients later when I've figured out Aquilo.
}

-- Hide the pistol.
Item.hide(RAW.gun["pistol"])