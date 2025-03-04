-- This file creates the recipes and tech for filtering local water on Nauvis.

-- Create filtration-lake-water tech.
local filtrationLakeWaterTech = copy(TECH["automation"])
filtrationLakeWaterTech.name = "filtration-lake-water"
filtrationLakeWaterTech.icon = nil
filtrationLakeWaterTech.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/tech.png", icon_size = 256, scale = 0.5, shift = {-25, 0}},
	{icon = "__LegendarySpaceAge__/graphics/filtration/lake-water-tech.png", icon_size = 256, scale = 0.4, shift = {25, 0}},
}
filtrationLakeWaterTech.prerequisites = {"automation-science-pack"}
filtrationLakeWaterTech.effects = {
	{type = "unlock-recipe", recipe = "filtration-plant"},
	{type = "unlock-recipe", recipe = "chemical-plant"},
	{type = "unlock-recipe", recipe = "offshore-pump"},
	{type = "unlock-recipe", recipe = "pipe"},
	{type = "unlock-recipe", recipe = "pipe-to-ground"},
	{type = "unlock-recipe", recipe = "filter"},
	{type = "unlock-recipe", recipe = "filter-lake-water"},
	{type = "unlock-recipe", recipe = "clean-filter"},
}
filtrationLakeWaterTech.unit = {
	count = 10,
	ingredients = {
		{"automation-science-pack", 1},
	},
	time = 30,
}
filtrationLakeWaterTech.ignore_tech_cost_multiplier = true
extend{filtrationLakeWaterTech}

-- Create recipe to filter lake water.
Recipe.make{
	copy = "iron-gear-wheel",
	recipe = "filter-lake-water",
	ingredients = {
		{"lake-water", 100, type = "fluid"},
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
	subgroup = "filtration",
	order = "04",
	specialIcons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
		{icon = "__LegendarySpaceAge__/graphics/filtration/lake-water.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
	},
	enabled = false,
	time = 1,
	crafting_machine_tint = {
		primary = {.015, .631, .682},
		secondary = FLUID.water.flow_color,
		tertiary = FLUID.water.base_color,
	},
}

-- Create lake water fluid.
local lakeWaterFluid = copy(FLUID.water)
lakeWaterFluid.name = "lake-water"
Icon.set(lakeWaterFluid, "LSA/filtration/lake-water")
lakeWaterFluid.auto_barrel = false
lakeWaterFluid.order = "a[fluid]-a[water]-c"
lakeWaterFluid.base_color = {0, .44, .6}
lakeWaterFluid.flow_color = {.7, .7, .7}
lakeWaterFluid.visualization_color = {.015, .681, .682} -- To differentiate from ordinary water.
lakeWaterFluid.max_temperature = nil
lakeWaterFluid.heat_capacity = nil
extend{lakeWaterFluid}

-- Make Nauvis water tiles yield lake water.
for _, tileName in pairs{
	"water",
	"deepwater",
	"water-green",
	"deepwater-green",
	"water-shallow",
	"water-mud",
} do
	RAW.tile[tileName].fluid = "lake-water"
end