-- This file creates the water filter item, and recipes to create and clean it. The actual filtration recipes are in pre-space/freshwater.lua, gleba/slime.lua, and fulgora/sludge.lua.

-- Create fuel category for filters.
local filterFuelCategory = copy(RAW["fuel-category"]["chemical"])
filterFuelCategory.name = "filter"
filterFuelCategory.fuel_value_type = {"description.filtration-energy-value"}
extend{filterFuelCategory}

-- Create filter item.
local filterItem = copy(ITEM["battery"])
filterItem.name = "filter"
Icon.set(filterItem, "LSA/filtration/filter")
Item.perRocket(filterItem, 1000)
filterItem.fuel_category = "filter"
filterItem.fuel_value = "10J"
filterItem.burnt_result = "spent-filter"
filterItem.fuel_glow_color = nil
extend{filterItem}

-- Create spent filter item.
local spentFilterItem = copy(ITEM["battery"])
spentFilterItem.name = "spent-filter"
Icon.set(spentFilterItem, "LSA/filtration/spent-filter")
Item.perRocket(spentFilterItem, 1000)
extend{spentFilterItem}

-- Create recipe to make filters.
Recipe.make{
	copy = "iron-gear-wheel",
	recipe = "filter",
	ingredients = {"frame", "carbon"},
	results = {"filter"},
	main_product = "filter",
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
	results = {
		{"filter", 1, probability = .5},
		{"frame", 1, probability = .5},
	},
	main_product = "filter",
	enabled = false,
	category = "crafting-with-fluid",
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
	allow_quality = false,
	allow_productivity = false,
}