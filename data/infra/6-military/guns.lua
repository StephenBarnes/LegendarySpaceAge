RECIPE["submachine-gun"].ingredients = {
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "frame", amount = 1},
}

Gen.order({
	RECIPE["submachine-gun"],
	RECIPE["shotgun"],
	RECIPE["combat-shotgun"],
	RECIPE["flamethrower"],
	RECIPE["rocket-launcher"],
	RECIPE["teslagun"],
	RECIPE["railgun"],
}, "gun")
Gen.order({
	RAW.gun["pistol"],
	RAW.gun["submachine-gun"],
	RAW.gun["shotgun"],
	RAW.gun["combat-shotgun"],
	RAW.gun["flamethrower"],
	RAW.gun["rocket-launcher"],
	RAW.gun["teslagun"],
	RAW.gun["railgun"],
}, "gun")