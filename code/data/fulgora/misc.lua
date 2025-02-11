-- Change scrap recycling outputs.
data.raw["recipe"]["scrap-recycling"].results = {
	{ type = "item", name = "rusty-iron-gear-wheel", amount = 1, probability = 0.10, show_details_in_recipe_tooltip = false },

	{ type = "item", name = "low-density-structure", amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "advanced-circuit",      amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
		-- No blue circuits, only reds - so you have to get circuit boards from the reds and spend stone and sulfuric acid to make blues.

	{ type = "item", name = "resin",                 amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },

	{ type = "item", name = "concrete",              amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "ice",                   amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },

	{ type = "item", name = "copper-cable",          amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "rubber",                amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },

	{ type = "item", name = "battery",               amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "holmium-battery",       amount = 1, probability = 0.0005, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "holmium-ore",           amount = 1, probability = 0.004, show_details_in_recipe_tooltip = false },

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

-- Remove temperature stats from fluids (electrolyte and holmium-solution).
data.raw.fluid["holmium-solution"].max_temperature = nil
data.raw.fluid["holmium-solution"].heat_capacity = nil
data.raw.fluid["electrolyte"].max_temperature = nil
data.raw.fluid["electrolyte"].heat_capacity = nil

-- Adjust the ruins to just yield scrap. No need to yield stuff like cables, steel plate. And also yield electrophages.
for _, vals in pairs{
	{
		name = "fulgoran-ruin-small",
		scrapCount = 4,
		electrophages = nil,
	},
	{
		name = "fulgoran-ruin-medium",
		scrapCount = 10,
		electrophages = nil,
	},
	{
		name = "fulgoran-ruin-stonehenge",
		scrapCount = 20,
		electrophages = {0, 0, .2},
	},
	{
		name = "fulgoran-ruin-big",
		scrapCount = 20,
		electrophages = {0, 0, .3},
	},
	{
		name = "fulgoran-ruin-huge",
		scrapCount = 40,
		electrophages = {0, 0, .5},
	},
	{
		name = "fulgoran-ruin-colossal",
		scrapCount = 60,
		electrophages = {0, 0, .8},
	},
	{
		name = "fulgoran-ruin-vault",
		scrapCount = 200,
		electrophages = {2, 10, nil},
	},
	{
		name = "fulgoran-ruin-attractor",
		type = "lightning-attractor",
		scrapCount = 4,
		electrophages = {6, 12, nil},
	},
} do
	local ruin = data.raw[vals.type or "simple-entity"][vals.name]
	assert(ruin ~= nil, "Fulgoran ruin " .. vals.name .. " not found")
	local scrapHalf = math.floor(vals.scrapCount / 2)
	local scrapMin = vals.scrapCount - scrapHalf
	local scrapMax = vals.scrapCount + scrapHalf
	assert(ruin.minable ~= nil, "Fulgoran ruin " .. vals.name .. " has no minable")
	ruin.minable.results = {{
		type = "item",
		name = "scrap",
		amount_min = scrapMin,
		amount_max = scrapMax,
	}}
	if vals.electrophages then
		table.insert(ruin.minable.results, {
			type = "item",
			name = "electrophage",
			amount_min = vals.electrophages[1],
			amount_max = vals.electrophages[2],
			extra_count_fraction = vals.electrophages[3],
		})
	end
end