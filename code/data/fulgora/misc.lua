local Recipe = require("code.util.recipe")

-- Change scrap recycling outputs.
data.raw["recipe"]["scrap-recycling"].results = {
	{ type = "item", name = "processing-unit",       amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "advanced-circuit",      amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "low-density-structure", amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "steel-plate",           amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "concrete",              amount = 1, probability = 0.06, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "battery",               amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "holmium-battery",               amount = 1, probability = 0.0005, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "stone",                 amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "holmium-ore",           amount = 1, probability = 0.005, show_details_in_recipe_tooltip = false },
	-- Rather don't produce fulgorite shards - should need to grow them to continue everything.
	{ type = "item", name = "rocs-rusting-iron-iron-gear-wheel-rusty",       amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "rocs-rusting-iron-iron-gear-wheel-rusty", amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "copper-cable",          amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "plastic-bar",          amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
}

-- Change holmium solution recipe to not require water, since I'm making that scarce.
-- (In batteries file, I'm adding a recipe to get sulfuric acid from batteries, so sulfuric acid is available on Fulgora.)
Recipe.substituteIngredient("holmium-solution", "water", "sulfuric-acid")

-- Increase power consumption of EM plants and recyclers.
data.raw["assembling-machine"]["electromagnetic-plant"].energy_usage = "4MW" -- Doubling 2MW -> 4MW.
data.raw["furnace"]["recycler"].energy_usage = "400kW" -- Increasing 180kW -> 400kW.