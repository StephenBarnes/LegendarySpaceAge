--[[ This file creates the recipes and tech for processing water on Nauvis.
Offshore pumps provide raw seawater.
Filtration plant: raw seawater -> clean seawater + mudwater + [rarely: algae, stone, fish]
Boiler: clean seawater + heat -> steam + rich brine
Condensing clean water for chemistry, in exothermic plant: steam -> water + heat
Mudwater can be dumped or filtered again: mudwater -> sand + clay + water
Crystallizer: rich brine -> salt + bitterns
Bitterns are dumped for now; later crystallization can produce magnesium salt.
Algae can be dried out and burned as fuel. Later it can also be cultivated.
]]

-- Create filtration-raw-seawater tech.
local filtrationSeawaterTech = copy(TECH["automation"])
filtrationSeawaterTech.name = "filtration-raw-seawater"
filtrationSeawaterTech.icon = nil
filtrationSeawaterTech.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/tech.png", icon_size = 256, scale = 0.5, shift = {-25, 0}},
	{icon = "__LegendarySpaceAge__/graphics/water-types/seawater-tech.png", icon_size = 256, scale = 0.4, shift = {25, 0}},
}
filtrationSeawaterTech.prerequisites = {"automation-science-pack"}
filtrationSeawaterTech.effects = {
	{type = "unlock-recipe", recipe = "filtration-plant"},
	{type = "unlock-recipe", recipe = "chemical-plant"},
	{type = "unlock-recipe", recipe = "offshore-pump"},
	{type = "unlock-recipe", recipe = "pipe"},
	{type = "unlock-recipe", recipe = "pipe-to-ground"},
	{type = "unlock-recipe", recipe = "filter"},
	{type = "unlock-recipe", recipe = "filter-raw-seawater"},
	{type = "unlock-recipe", recipe = "clean-filter"},
}
filtrationSeawaterTech.unit = {
	count = 10,
	ingredients = {
		{"automation-science-pack", 1},
	},
	time = 30,
}
filtrationSeawaterTech.ignore_tech_cost_multiplier = true
extend{filtrationSeawaterTech}

-- Create recipe to filter seawater.
Recipe.make{
	copy = "iron-gear-wheel",
	recipe = "filter-raw-seawater",
	ingredients = {
		{"raw-seawater", 100, type = "fluid"},
	},
	results = {
		{"water", 100},
		{"sand", 1, probability = .4, show_details_in_recipe_tooltip = false},
		{"stone", 1, probability = .2, show_details_in_recipe_tooltip = false},
		{"niter", 1, probability = .2, show_details_in_recipe_tooltip = false},
		{"raw-fish", 1, probability = .01, show_details_in_recipe_tooltip = false},
	},
	main_product = "water",
	category = "filtration",
	specialIcons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
		{icon = "__LegendarySpaceAge__/graphics/water-types/raw-seawater.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
	},
	enabled = false,
	time = 1,
	crafting_machine_tint = {
		primary = {.015, .631, .682},
		secondary = FLUID.water.flow_color,
		tertiary = FLUID.water.base_color,
	},
}
