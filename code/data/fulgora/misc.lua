-- Change scrap recycling outputs.
data.raw["recipe"]["scrap-recycling"].results = {
	{ type = "item", name = "processing-unit",       amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "advanced-circuit",      amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
		-- Increased 0.03 -> 0.04 for more plastic
	{ type = "item", name = "low-density-structure", amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
		-- Increased 0.01 -> 0.02 for more plastic
	{ type = "item", name = "solid-fuel",            amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
		-- Changed 0.07 -> 0.02
	{ type = "item", name = "steel-plate",           amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "concrete",              amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
		-- Reduced 0.06 -> 0.04, bc I'm adding stone bricks.
	{ type = "item", name = "stone-brick",           amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
		-- Added.
	{ type = "item", name = "battery",               amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
		-- Reduced 0.04 -> 0.02
	--{ type = "item", name = "ice",                   amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
		-- Removed this.
	{ type = "item", name = "stone",                 amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "holmium-ore",           amount = 1, probability = 0.005, show_details_in_recipe_tooltip = false },
		-- Reduced 0.01 -> 0.005, bc I'm adding holmium farming.
	{ type = "item", name = "rocs-rusting-iron-iron-gear-wheel-rusty",       amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
		-- Changed to rusty variant, and reduced 0.20 -> 0.08.
	{ type = "item", name = "rocs-rusting-iron-iron-stick-rusty",       amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
		-- Added.
	{ type = "item", name = "copper-cable",          amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "plastic-bar",          amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
		-- Added.
}

-- TODO increase power consumption of EM plants dramatically.

-- TODO in future, maybe allow mining and growing fulgorites?
--table.insert(data.raw["simple-entity"]["fulgurite"].minable.results, { -- The ID is fulgurite with a U, but the name is fulgorite with an O.
--table.insert(data.raw["simple-entity"]["fulgurite-small"].minable.results, {