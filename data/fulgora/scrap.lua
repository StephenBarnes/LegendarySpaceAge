-- Change scrap recycling outputs.
local scrapRecyclingResults = {
	{ "rusty-iron-gear-wheel", 1, probability = 0.10,   show_details_in_recipe_tooltip = false },
	{ "carbon",                1, probability = 0.10,   show_details_in_recipe_tooltip = false },
		-- Valuable for filters.
	{ "battery",               1, probability = 0.10,   show_details_in_recipe_tooltip = false },
		-- Needed for sulfuric acid.

	{ "low-density-structure", 1, probability = 0.05,   show_details_in_recipe_tooltip = false },
	{ "advanced-circuit",      1, probability = 0.05,   show_details_in_recipe_tooltip = false },
		-- No blue circuits, only reds - so you have to get circuit boards from the reds and spend stone and sulfuric acid to make blues.
	{ "electric-engine-unit",  1, probability = 0.02,   show_details_in_recipe_tooltip = false },

	{ "concrete",              1, probability = 0.05,   show_details_in_recipe_tooltip = false },

	{ "resin",                 1, probability = 0.05,   show_details_in_recipe_tooltip = false },

	{ "copper-cable",          1, probability = 0.05,   show_details_in_recipe_tooltip = false },
	{ "rubber",                1, probability = 0.05,   show_details_in_recipe_tooltip = false },
	{ "holmium-battery",       1, probability = 0.0005, show_details_in_recipe_tooltip = false },
	{ "holmium-ore",           1, probability = 0.005,  show_details_in_recipe_tooltip = false },

	{ "ice",                   1, probability = 0.01,   show_details_in_recipe_tooltip = false },

	-- TODO stuff to add maybe: energy-shield-equipment, mechanism, electric-engine-unit, sensors, LDS, panels, wiring, frames, structures, 

	-- Rather don't produce fulgorite shards - should need to grow them to continue everything.
}
assert(#scrapRecyclingResults <= FURNACE["recycler"].result_inventory_size, "Recycler needs more result slots for scrap recycling - " .. #scrapRecyclingResults .. " > " .. FURNACE["recycler"].result_inventory_size)
Recipe.edit{
	recipe = "scrap-recycling",
	results = scrapRecyclingResults,
}