-- Vehicles
Recipe.edit{
	recipe = "car",
	ingredients = {
		{"engine-unit", 1},
		{"rubber", 5},
		{"frame", 5},
		{"shielding", 10},
	},
	time = 5,
}
Recipe.edit{
	recipe = "tank",
	ingredients = {
		{"engine-unit", 5},
		{"frame", 10},
		{"shielding", 50},
		{"advanced-circuit", 50},
	},
	time = 10,
}
Recipe.edit{
	recipe = "spidertron",
	ingredients = {
		{"low-density-structure", 20},
		{"exoskeleton-equipment", 4},
		{"radar", 2},
		{"rocket-turret", 1},
		{"sensor", 8},
		-- No pentapod-egg -- Makes sense lore-wise, but I'd rather not force players to build them on Gleba, it's a pain to ship them.
		-- No fission-reactor-equipment -- Can't require this, because nuclear is now late-game.
	},
	time = 20,
}