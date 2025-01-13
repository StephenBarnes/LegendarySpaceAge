-- This file creates the water filter item, plus recipes to filter local water on Nauvis and Gleba.

local Table = require("code.util.table")
local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

local newData = {}

-- Create filter item.
local filterItem = Table.copyAndEdit(data.raw.item["battery"], {
	name = "filter",
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64}},
	order = "a[basic-intermediates]-e1",
})
table.insert(newData, filterItem)

-- Create spent filter item.
local spentFilterItem = Table.copyAndEdit(data.raw.item["battery"], {
	name = "spent-filter",
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/filtration/spent-filter.png", icon_size = 64}},
	order = "a[basic-intermediates]-e2",
})
table.insert(newData, spentFilterItem)

-- Create filtration tech.
local filtrationTech = Table.copyAndEdit(data.raw.technology["automation"], {
	name = "filtration-1", -- TODO later filtration-2 on Gleba, then filtration-3 for the petrophages.
	localised_description = {"technology-description.filtration-1"},
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/filtration/tech.png", icon_size = 256}},
	prerequisites = {"automation"},
	effects = {
		{
			type = "unlock-recipe",
			recipe = "filter",
		},
		{
			type = "unlock-recipe",
			recipe = "filter-lake-water",
		},
		{
			type = "unlock-recipe",
			recipe = "clean-filter",
		},
	},
})
table.insert(newData, filtrationTech)

-- Create recipe to make filters.
local filterRecipe = Table.copyAndEdit(data.raw.recipe["iron-gear-wheel"], {
	name = "filter",
	ingredients = {
		{type = "item", name = "iron-plate", amount = 1},
		{type = "item", name = "carbon", amount = 1},
	},
	results = {
		{type = "item", name = "filter", amount = 1},
	},
	enabled = false,
})
table.insert(newData, filterRecipe)

-- Create recipe to clean filters.
local cleanFilterRecipe = Table.copyAndEdit(data.raw.recipe["iron-gear-wheel"], {
	name = "clean-filter",
	ingredients = {
		{type = "item", name = "spent-filter", amount = 1},
		{type = "fluid", name = "water", amount = 20},
	},
	results = {
		{type = "item", name = "filter", amount = 1, probability = .9},
	},
	category = "chemistry-or-crafting-with-fluid",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/spent-filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
		{icon = "__base__/graphics/icons/fluid/water.png", icon_size = 64, scale = 0.34, mipmap_count = 4, shift = {0, -4}},
	},
	enabled = false,
	subgroup = "fluid-recipes",
	order = "04",
	show_amount_in_title = false,
})
table.insert(newData, cleanFilterRecipe)

-- Create recipe to filter lake water.
local filterLakeWaterRecipe = Table.copyAndEdit(data.raw.recipe["iron-gear-wheel"], {
	name = "filter-lake-water",
	ingredients = {
		{type = "item", name = "filter", amount = 1},
		{type = "fluid", name = "lake-water", amount = 400},
	},
	results = {
		{type = "fluid", name = "water", amount = 400},
		{type = "item", name = "spent-filter", amount = 1},
		{type = "item", name = "stone", amount_min = 0, amount_max = 5, show_details_in_recipe_tooltip = false},
		{type = "item", name = "niter", amount_min = 0, amount_max = 2, show_details_in_recipe_tooltip = false},
		{type = "item", name = "raw-fish", amount = 1, probability = .01, show_details_in_recipe_tooltip = false},
	},
	main_product = "water",
	category = "chemistry-or-crafting-with-fluid",
	subgroup = "fluid-recipes",
	order = "03",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
		{icon = "__LegendarySpaceAge__/graphics/filtration/lake-water.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
	},
	enabled = false,
})
table.insert(newData, filterLakeWaterRecipe)

-- Create lake water fluid.
local lakeWaterFluid = Table.copyAndEdit(data.raw.fluid["water"], {
	name = "lake-water",
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/filtration/lake-water.png", icon_size = 64}},
	auto_barrel = false,
	order = "a[fluid]-a[water]-c",
})
table.insert(newData, lakeWaterFluid)

------------------------------------------------------------------------
data:extend(newData)

-- Make Nauvis water tiles yield lake water.
for _, tileName in pairs{
	"water",
	"deepwater",
	"water-green",
	"deepwater-green",
	"water-shallow",
	"water-mud",
} do
	local tile = data.raw.tile[tileName]
	tile.fluid = "lake-water"
end