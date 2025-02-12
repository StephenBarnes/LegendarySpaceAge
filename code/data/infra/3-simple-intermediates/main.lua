--[[Engine units.
Original recipe: 1 gear wheel + 1 steel plate + 2 pipe, which is around 2 + 5 + 2 = 9 iron plates.
I want a bunch of intermediates including factor intermediates.
New recipe: 1 shielding + 2 fluid fitting + 1 mechanism -> 1 engine.
Using basic recipes for the factors, that's 32 metal plate + 4 resin. So it's  like 4x the cost.
So, I've also reduced the number of engine units needed for other recipes to balance that. Which is more intuitively satisfying anyway, eg a car shouldn't need 8 combustion engines.
]]
RECIPE["engine-unit"].ingredients = {
	{type = "item", name = "shielding", amount = 1},
	{type = "item", name = "fluid-fitting", amount = 2},
	{type = "item", name = "mechanism", amount = 1},
}

RECIPE["flying-robot-frame"].ingredients = {
	{type = "item", name = "battery", amount = 2},
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "sensor", amount = 1},
	{type = "item", name = "electric-engine-unit", amount = 1},
}