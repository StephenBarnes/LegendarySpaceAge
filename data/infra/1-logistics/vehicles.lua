-- Vehicles
RECIPE["car"].ingredients = {
	{type="item", name="engine-unit", amount=1},
	{type="item", name="rubber", amount=4},
	{type="item", name="frame", amount=4},
	{type="item", name="shielding", amount=4},
}
RECIPE["tank"].ingredients = {
	{type="item", name="engine-unit", amount=4},
	{type="item", name="frame", amount=8},
	{type="item", name="shielding", amount=20},
	{type="item", name="advanced-circuit", amount=20},
}
RECIPE["spidertron"].ingredients = {
	{type="item", name="low-density-structure", amount=20},
	{type="item", name="exoskeleton-equipment", amount=4},
	{type="item", name="radar", amount=2},
	{type="item", name="rocket-turret", amount=1},
	{type="item", name="sensor", amount=8},
	--{type="item", name="pentapod-egg", amount=1}, -- Makes sense lore-wise, but I'd rather not force players to build them on Gleba, it's a pain to ship them.
	--{type="item", name="fission-reactor-equipment", amount=2}, -- Can't require this, because nuclear is now late-game.
}