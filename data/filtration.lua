-- This file creates the water filter item, plus recipes to filter local water on Nauvis and Gleba.

-- Create item-subgroup for filtration.
local filtrationSubgroup = copy(RAW["item-subgroup"]["fluid-recipes"])
filtrationSubgroup.name = "filtration"
filtrationSubgroup.order = "c9"
extend{filtrationSubgroup}
-- Also move the other water recipes to that line.
RECIPE["steam-condensation"].subgroup = "filtration"
RECIPE["ice-melting"].subgroup = "filtration"
RECIPE["steam-condensation"].order = "05"
RECIPE["ice-melting"].order = "06"

-- Create filter item.
local filterItem = copy(ITEM["battery"])
filterItem.name = "filter"
Icon.set(filterItem, "LSA/filtration/filter")
filterItem.order = "01"
filterItem.subgroup = "filtration"
filterItem.weight = ROCKET / 1000
extend{filterItem}

-- Create spent filter item.
local spentFilterItem = copy(ITEM["battery"])
spentFilterItem.name = "spent-filter"
Icon.set(spentFilterItem, "LSA/filtration/spent-filter")
spentFilterItem.order = "02"
spentFilterItem.subgroup = "filtration"
spentFilterItem.weight = ROCKET / 1000
extend{spentFilterItem}

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

-- Create filtration-gleban-slime tech.
local filtrationGlebanSlimeTech = copy(TECH["jellynut"])
filtrationGlebanSlimeTech.name = "filtration-gleban-slime"
filtrationGlebanSlimeTech.icon = nil
filtrationGlebanSlimeTech.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/tech.png", icon_size = 256, scale = 0.5, shift = {-25, 0}},
	{icon = "__LegendarySpaceAge__/graphics/filtration/slime-tech.png", icon_size = 256, scale = 0.4, shift = {25, 0}},
}
filtrationGlebanSlimeTech.prerequisites = {"planet-discovery-gleba"}
filtrationGlebanSlimeTech.effects = {
	{type = "unlock-recipe", recipe = "filter-slime"},
}
filtrationGlebanSlimeTech.research_trigger = {
	type = "craft-fluid",
	fluid = "slime",
	amount = 100,
}
extend{filtrationGlebanSlimeTech}

-- Create filtration-fulgoran-sludge tech.
local filtrationFulgoranSludgeTech = copy(TECH["recycling"])
filtrationFulgoranSludgeTech.name = "filtration-fulgoran-sludge"
filtrationFulgoranSludgeTech.icon = nil
filtrationFulgoranSludgeTech.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/tech.png", icon_size = 256, scale = 0.5, shift = {-25, 0}},
	{icon = "__LegendarySpaceAge__/graphics/fulgora/sludge-tech.png", icon_size = 256, scale = 0.4, shift = {25, 0}},
}
filtrationFulgoranSludgeTech.prerequisites = {"planet-discovery-fulgora"}
filtrationFulgoranSludgeTech.effects = {
	{type = "unlock-recipe", recipe = "fulgoran-sludge-filtration"},
}
filtrationFulgoranSludgeTech.research_trigger = {
	type = "craft-fluid",
	fluid = "fulgoran-sludge",
	amount = 100,
}
extend{filtrationFulgoranSludgeTech}
Tech.addTechDependency("filtration-fulgoran-sludge", "holmium-processing")
TECH["holmium-processing"].research_trigger.count = 10

-- Create recipe to make filters.
Recipe.make{
	copy = "iron-gear-wheel",
	recipe = "filter",
	ingredients = {"frame", "carbon"},
	results = {"filter"},
	enabled = false,
	auto_recycle = true,
}

-- Create recipe to clean filters.
Recipe.make{
	copy = "iron-gear-wheel",
	recipe = "clean-filter",
	ingredients = {
		{"spent-filter", 1},
		{"water", 20},
	},
	results = {{"filter", 1, probability = .9}},
	enabled = false,
	category = "chemistry-or-crafting-with-fluid",
	subgroup = "filtration",
	order = "03",
	show_amount_in_title = false,
	time = 1,
	auto_recycle = false,
	specialIcons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/spent-filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
		{icon = "__base__/graphics/icons/fluid/water.png", icon_size = 64, scale = 0.34, mipmap_count = 4, shift = {0, -4}},
	},
	crafting_machine_tint = {
		primary = FLUID.water.base_color,
		secondary = FLUID.water.flow_color,
		tertiary = FLUID.water.visualization_color,
	},
}

-- Create recipe to filter lake water.
Recipe.make{
	copy = "iron-gear-wheel",
	recipe = "filter-lake-water",
	ingredients = {
		{"filter", 1},
		{"lake-water", 1200, type = "fluid"},
	},
	results = {
		{"water", 1000},
		{"spent-filter", 1},
		{"sand", amount_min = 0, amount_max = 4, show_details_in_recipe_tooltip = false},
		{"stone", amount_min = 0, amount_max = 2, show_details_in_recipe_tooltip = false},
		{"niter", amount_min = 0, amount_max = 2, show_details_in_recipe_tooltip = false},
		{"raw-fish", 1, probability = .01, show_details_in_recipe_tooltip = false},
	},
	main_product = "water",
	category = "chemistry-or-crafting-with-fluid",
	subgroup = "filtration",
	order = "04",
	specialIcons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
		{icon = "__LegendarySpaceAge__/graphics/filtration/lake-water.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
	},
	enabled = false,
	time = 5,
	crafting_machine_tint = {
		primary = {.015, .631, .682},
		secondary = FLUID.water.base_color,
		tertiary = FLUID.water.flow_color,
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

-- Create slime fluid.
local slimeFluid = copy(FLUID["water"])
slimeFluid.name = "slime"
Icon.set(slimeFluid, "LSA/filtration/slime")
slimeFluid.auto_barrel = true
slimeFluid.order = "b[new-fluid]-c2[gleba]-a"
slimeFluid.base_color = {.176, .255, .200}
slimeFluid.flow_color = {.393, .453, .333}
slimeFluid.visualization_color = {.482, .745, .215}
slimeFluid.max_temperature = nil
slimeFluid.heat_capacity = nil
extend{slimeFluid}

-- Create recipe to filter slime.
Recipe.make{
	copy = "iron-gear-wheel",
	recipe = "filter-slime",
	ingredients = {
		{"filter", 1},
		{"slime", 400, type = "fluid"},
	},
	results = {
		{"water", 300},
		{"spent-filter", 1},
		{"spoilage", 10, show_details_in_recipe_tooltip = false},
		{"petrophage", 1, probability = .05, show_details_in_recipe_tooltip = false},
		-- Could give eggs or fruits with some small probability. But rather not, since that makes it too easy to restart cycles.
	},
	main_product = "water",
	category = "chemistry-or-crafting-with-fluid",
	subgroup = "gleba-non-agriculture",
	order = "00",
	enabled = false,
	time = 5,
	specialIcons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
		{icon = "__LegendarySpaceAge__/graphics/filtration/slime.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
	},
	crafting_machine_tint = {
		primary = {.176, .255, .200},
		secondary = {.393, .453, .333},
		tertiary = {.482, .745, .215},
	}
}

------------------------------------------------------------------------

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

-- Make Gleba water tiles yield slime.
for _, tileName in pairs{
	"gleba-deep-lake",
	"wetland-blue-slime",
	"wetland-light-green-slime",
	"wetland-green-slime",
	"wetland-light-dead-skin",
	"wetland-dead-skin",
	"wetland-pink-tentacle",
	"wetland-red-tentacle",
	"wetland-yumako",
	"wetland-jellynut",
} do
	RAW.tile[tileName].fluid = "slime"
end