--[[Engine units.
Original recipe: 1 gear wheel + 1 steel plate + 2 pipe, which is around 2 + 5 + 2 = 9 iron plates.
I want a bunch of intermediates including factor intermediates.
New recipe: 1 shielding + 2 fluid fitting + 1 mechanism -> 1 engine.
Using basic recipes for the factors, that's 32 metal plate + 4 resin. So it's  like 4x the cost.
So, I've also reduced the number of engine units needed for other recipes to balance that. Which is more intuitively satisfying anyway, eg a car shouldn't need 8 combustion engines.
]]
Recipe.edit{
	recipe = "engine-unit",
	ingredients = {
		{"shielding", 1},
		{"fluid-fitting", 2},
		{"mechanism", 1},
	},
	time = 5, -- Originally 10, but I always thought that was too long.
}

Recipe.edit{
	recipe = "flying-robot-frame",
	ingredients = {
		{"battery", 2},
		{"frame", 1},
		{"sensor", 1},
		{"electric-engine-unit", 1},
	},
	time = 10, -- Originally 20, but I always thought that was too long.
}

Recipe.edit{
	recipe = "battery",
	ingredients = { -- Originally 1 iron plate + 1 copper plate + 20 sulfuric acid.
		{"panel", 2},
		{"electronic-components", 1},
		{"sulfuric-acid", 10},
	},
	time = 2,
}