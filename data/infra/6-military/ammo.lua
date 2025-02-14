RECIPE["flamethrower-ammo"].ingredients = {
	{type = "item", name = "fluid-fitting", amount = 1},
	{type = "fluid", name = "light-oil", amount = 20},
}

-- Put shotgun shells before bullet magazines.
RAW.ammo["shotgun-shell"].order = "0-1"
RAW.ammo["piercing-shotgun-shell"].order = "0-2"