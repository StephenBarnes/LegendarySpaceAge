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

-- Create filtration-lake-water tech.
local filtrationLakeWaterTech = Table.copyAndEdit(data.raw.technology["automation"], {
	name = "filtration-lake-water",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/tech.png", icon_size = 256, scale = 0.5, shift = {-25, 0}},
		{icon = "__LegendarySpaceAge__/graphics/filtration/lake-water-tech.png", icon_size = 256, scale = 0.4, shift = {25, 0}},
	},
	prerequisites = {"coal-coking", "automation-science-pack"}, -- Needs coking for carbon, to make filters.
	effects = {
		{type = "unlock-recipe", recipe = "offshore-pump"},
		{type = "unlock-recipe", recipe = "pipe"},
		{type = "unlock-recipe", recipe = "pipe-to-ground"},
		{type = "unlock-recipe", recipe = "filter"},
		{type = "unlock-recipe", recipe = "filter-lake-water"},
		{type = "unlock-recipe", recipe = "clean-filter"},
	},
	unit = "nil",
})
filtrationLakeWaterTech.research_trigger = nil
filtrationLakeWaterTech.unit = {
	count = 10,
	ingredients = {
		{"automation-science-pack", 1},
	},
	time = 30,
}
filtrationLakeWaterTech.ignore_tech_cost_multiplier = true
table.insert(newData, filtrationLakeWaterTech)

-- Create filtration-gleban-slime tech.
local filtrationGlebanSlimeTech = Table.copyAndEdit(data.raw.technology["jellynut"], {
	name = "filtration-gleban-slime",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/tech.png", icon_size = 256, scale = 0.5, shift = {-25, 0}},
		{icon = "__LegendarySpaceAge__/graphics/filtration/slime-tech.png", icon_size = 256, scale = 0.4, shift = {25, 0}},
	},
	prerequisites = {"planet-discovery-gleba"},
	effects = {
		{type = "unlock-recipe", recipe = "filter-slime"},
	},
	research_trigger = {
		type = "craft-fluid",
		fluid = "slime",
		amount = 100,
	},
})
table.insert(newData, filtrationGlebanSlimeTech)
-- Make filtration-gleban-sludge mandatory before biochambers.
Tech.addTechDependency("filtration-gleban-slime", "biochamber")

-- TODO create tech for advanced filtration of Gleban slime, producing petrophages.

-- Create filtration-fulgoran-sludge tech.
local filtrationFulgoranSludgeTech = Table.copyAndEdit(data.raw.technology["recycling"], {
	name = "filtration-fulgoran-sludge",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/tech.png", icon_size = 256, scale = 0.5, shift = {-25, 0}},
		{icon = "__LegendarySpaceAge__/graphics/fulgora/sludge-tech.png", icon_size = 256, scale = 0.4, shift = {25, 0}},
	},
	prerequisites = {"planet-discovery-fulgora"},
	effects = {
		{type = "unlock-recipe", recipe = "fulgoran-sludge-filtration"},
	},
	research_trigger = {
		type = "craft-fluid",
		fluid = "fulgoran-sludge",
		amount = 100,
	},
})
table.insert(newData, filtrationFulgoranSludgeTech)
Tech.addTechDependency("filtration-fulgoran-sludge", "holmium-processing")
data.raw.technology["holmium-processing"].research_trigger.count = 10

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
	auto_recycle = true,
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
	order = "05",
	show_amount_in_title = false,
	energy_required = 1,
	crafting_machine_tint = {
		primary = data.raw.fluid.water.base_color,
		secondary = data.raw.fluid.water.flow_color,
		tertiary = data.raw.fluid.water.visualization_color,
	},
	auto_recycle = false,
})
table.insert(newData, cleanFilterRecipe)

-- Create recipe to filter lake water.
local filterLakeWaterRecipe = Table.copyAndEdit(data.raw.recipe["iron-gear-wheel"], {
	name = "filter-lake-water",
	ingredients = {
		{type = "item", name = "filter", amount = 1},
		{type = "fluid", name = "lake-water", amount = 1200},
	},
	results = {
		{type = "fluid", name = "water", amount = 1000},
		{type = "item", name = "spent-filter", amount = 1},
		{type = "item", name = "sand", amount_min = 0, amount_max = 4, show_details_in_recipe_tooltip = false},
		{type = "item", name = "stone", amount_min = 0, amount_max = 2, show_details_in_recipe_tooltip = false},
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
	energy_required = 5,
	crafting_machine_tint = {
		primary = {.015, .631, .682},
		secondary = data.raw.fluid.water.base_color,
		tertiary = data.raw.fluid.water.flow_color,
	},
})
table.insert(newData, filterLakeWaterRecipe)

-- Create lake water fluid.
local lakeWaterFluid = Table.copyAndEdit(data.raw.fluid["water"], {
	name = "lake-water",
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/filtration/lake-water.png", icon_size = 64}},
	auto_barrel = false,
	order = "a[fluid]-a[water]-c",
	base_color = {0, .44, .6},
	flow_color = {.7, .7, .7},
	visualization_color = {.015, .681, .682}, -- To differentiate from ordinary water.
})
table.insert(newData, lakeWaterFluid)

-- Create slime fluid.
local slimeFluid = Table.copyAndEdit(data.raw.fluid["water"], {
	name = "slime",
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/filtration/slime.png", icon_size = 64}},
	auto_barrel = true,
	order = "b[new-fluid]-c2[gleba]-a",
	base_color = {.176, .255, .200},
	flow_color = {.393, .453, .333},
	visualization_color = {.482, .745, .215},
})
table.insert(newData, slimeFluid)

-- Create recipe to filter slime.
local filterSlimeRecipe = Table.copyAndEdit(data.raw.recipe["iron-gear-wheel"], {
	name = "filter-slime",
	ingredients = {
		{type = "item", name = "filter", amount = 1},
		{type = "fluid", name = "slime", amount = 400},
	},
	results = {
		{type = "fluid", name = "water", amount = 300},
		{type = "item", name = "spent-filter", amount = 1},
		{type = "item", name = "spoilage", amount_min = 0, amount_max = 20, show_details_in_recipe_tooltip = false},
		--{type = "item", name = "iron-bacteria", amount = 1, probability = .01, show_details_in_recipe_tooltip = false},
		--{type = "item", name = "copper-bacteria", amount = 1, probability = .01, show_details_in_recipe_tooltip = false},
		-- Could give eggs or fruits with some small probability. But rather not, since that makes it too easy to restart cycles.
	},
	main_product = "water",
	category = "chemistry-or-crafting-with-fluid",
	subgroup = "fluid-recipes",
	order = "04",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
		{icon = "__LegendarySpaceAge__/graphics/filtration/slime.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
	},
	enabled = false,
	energy_required = 6,
	crafting_machine_tint = {
		primary = {.176, .255, .200},
		secondary = {.393, .453, .333},
		tertiary = {.482, .745, .215},
	},
})
table.insert(newData, filterSlimeRecipe)

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
	data.raw.tile[tileName].fluid = "lake-water"
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
	data.raw.tile[tileName].fluid = "slime"
end