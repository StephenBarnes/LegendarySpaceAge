Recipe.edit{
	recipe = "submachine-gun",
	ingredients = {"mechanism", "frame"},
}

Recipe.edit{
	recipe = "shotgun",
	ingredients = {"mechanism", "frame"},
}

-- Hide the pistol.
RAW.gun["pistol"].hidden = true
RAW.gun["pistol"].hidden_in_factoriopedia = true

Gen.order({
	RECIPE["shotgun"],
	RECIPE["combat-shotgun"],
	RECIPE["submachine-gun"],
	RECIPE["flamethrower"],
	RECIPE["rocket-launcher"],
	RECIPE["teslagun"],
	RECIPE["railgun"],
}, "gun")
Gen.order({
	--RAW.gun["pistol"],
	RAW.gun["shotgun"],
	RAW.gun["combat-shotgun"],
	RAW.gun["submachine-gun"],
	RAW.gun["flamethrower"],
	RAW.gun["rocket-launcher"],
	RAW.gun["teslagun"],
	RAW.gun["railgun"],
}, "gun")