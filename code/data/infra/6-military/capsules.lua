local recipes = data.raw.recipe

-- Grenades: 8 gunpowder + 4 iron plate.
recipes["grenade"].ingredients = {
	{type = "item", name = "iron-plate", amount = 2},
	{type = "item", name = "explosives", amount = 1},
}
recipes["cluster-grenade"].ingredients = {
	{type = "item", name = "steel-plate", amount = 1},
	{type = "item", name = "explosives", amount = 1},
	{type = "item", name = "grenade", amount = 7},
}

-- 2 pitch + 5 ammonia + 5 sulfuric acid + 2 iron plate -> 1 poison capsule
recipes["poison-capsule"].ingredients = {
	{type = "item", name = "iron-plate", amount = 2},
	{type = "item", name = "pitch", amount = 2},
	{type = "fluid", name = "ammonia", amount = 5},
	{type = "fluid", name = "sulfuric-acid", amount = 5},
}
recipes["poison-capsule"].category = "chemistry"
-- 2 resin + 5 tar + 5 water + 2 iron plate -> 1 slowdown capsule
recipes["slowdown-capsule"].ingredients = {
	{type = "item", name = "iron-plate", amount = 2},
	{type = "item", name = "resin", amount = 2},
	{type = "fluid", name = "tar", amount = 5},
	{type = "fluid", name = "water", amount = 5},
}
recipes["slowdown-capsule"].category = "chemistry"