-- Change scrap recycling outputs.
data.raw["recipe"]["scrap-recycling"].results = {
	{ type = "item", name = "processing-unit",       amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "advanced-circuit",      amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "low-density-structure", amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "steel-plate",           amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "concrete",              amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "battery",               amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "holmium-battery",       amount = 1, probability = 0.0005, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "ice",                   amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "stone",                 amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "holmium-ore",           amount = 1, probability = 0.004, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "rocs-rusting-iron-iron-gear-wheel-rusty", amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "rocs-rusting-iron-iron-stick-rusty", amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "copper-cable",          amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "plastic-bar",           amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "rubber",                amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
	-- Rather don't produce fulgorite shards - should need to grow them to continue everything.
}

-- Change holmium solution recipe to require sulfuric acid instead of water.
data.raw.recipe["holmium-solution"].ingredients = {
	{type = "fluid", name = "sulfuric-acid", amount = 10},
	{type = "item", name = "holmium-ore", amount = 2},
}

-- Change electrolyte solution - previously stone, heavy oil, holmium solution.
data.raw.recipe["electrolyte"].ingredients = {
	{type = "item", name = "sand", amount = 1},
	{type = "fluid", name = "holmium-solution", amount = 10},
	{type = "fluid", name = "water", amount = 10},
}

-- Increase power consumption of EM plants and recyclers.
data.raw["assembling-machine"]["electromagnetic-plant"].energy_usage = "4MW" -- Doubling 2MW -> 4MW.
data.raw["furnace"]["recycler"].energy_usage = "400kW" -- Increasing 180kW -> 400kW.