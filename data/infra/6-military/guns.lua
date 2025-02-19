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

-- Hide the pistol.
RAW.gun["pistol"].hidden = true
RAW.gun["pistol"].hidden_in_factoriopedia = true

local gunsInOrder = {
	"shotgun",
	"combat-shotgun",
	"submachine-gun",
	"flamethrower",
	"rocket-launcher",
	"teslagun",
	"railgun",
}
Gen.orderKinds("gun", {RECIPE, RAW.gun}, gunsInOrder)