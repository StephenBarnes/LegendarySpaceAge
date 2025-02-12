-- This file creates the water filter item, plus recipes to filter local water on Nauvis and Gleba.

-- Create item-subgroup for filtration.
local filtrationSubgroup = copy(RAW["item-subgroup"]["fluid-recipes"])
filtrationSubgroup.name = "filtration"
filtrationSubgroup.order = "c9"
data:extend{filtrationSubgroup}
-- Also move the other water recipes to that line.
RECIPE["steam-condensation"].subgroup = "filtration"
RECIPE["ice-melting"].subgroup = "filtration"
RECIPE["steam-condensation"].order = "05"
RECIPE["ice-melting"].order = "06"

-- Create filter item.
local filterItem = copy(ITEM["battery"])
filterItem.name = "filter"
filterItem.icon = nil
filterItem.icons = {{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64}}
filterItem.order = "01"
filterItem.subgroup = "filtration"
filterItem.weight = 1000
data:extend{filterItem}

-- Create spent filter item.
local spentFilterItem = copy(ITEM["battery"])
spentFilterItem.name = "spent-filter"
spentFilterItem.icon = nil
spentFilterItem.icons = {{icon = "__LegendarySpaceAge__/graphics/filtration/spent-filter.png", icon_size = 64}}
spentFilterItem.order = "02"
spentFilterItem.subgroup = "filtration"
spentFilterItem.weight = 1000
data:extend{spentFilterItem}

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
data:extend{filtrationLakeWaterTech}

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
data:extend{filtrationGlebanSlimeTech}
-- Make filtration-gleban-sludge mandatory before biochambers.
Tech.addTechDependency("filtration-gleban-slime", "biochamber")

-- TODO create tech for advanced filtration of Gleban slime, producing petrophages.

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
data:extend{filtrationFulgoranSludgeTech}
Tech.addTechDependency("filtration-fulgoran-sludge", "holmium-processing")
TECH["holmium-processing"].research_trigger.count = 10

-- Create recipe to make filters.
local filterRecipe = copy(RECIPE["iron-gear-wheel"])
filterRecipe.name = "filter"
filterRecipe.ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "carbon", amount = 1},
}
filterRecipe.results = {
	{type = "item", name = "filter", amount = 1},
}
filterRecipe.enabled = false
filterRecipe.auto_recycle = true
data:extend{filterRecipe}

-- Create recipe to clean filters.
local cleanFilterRecipe = copy(RECIPE["iron-gear-wheel"])
cleanFilterRecipe.name = "clean-filter"
cleanFilterRecipe.ingredients = {
	{type = "item", name = "spent-filter", amount = 1},
	{type = "fluid", name = "water", amount = 20},
}
cleanFilterRecipe.results = {
	{type = "item", name = "filter", amount = 1, probability = .9},
}
cleanFilterRecipe.category = "chemistry-or-crafting-with-fluid"
cleanFilterRecipe.icon = nil
cleanFilterRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/spent-filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
	{icon = "__base__/graphics/icons/fluid/water.png", icon_size = 64, scale = 0.34, mipmap_count = 4, shift = {0, -4}},
}
cleanFilterRecipe.enabled = false
cleanFilterRecipe.subgroup = "filtration"
cleanFilterRecipe.order = "03"
cleanFilterRecipe.show_amount_in_title = false
cleanFilterRecipe.energy_required = 1
cleanFilterRecipe.crafting_machine_tint = {
	primary = FLUID.water.base_color,
	secondary = FLUID.water.flow_color,
	tertiary = FLUID.water.visualization_color,
}
cleanFilterRecipe.auto_recycle = false
data:extend{cleanFilterRecipe}

-- Create recipe to filter lake water.
local filterLakeWaterRecipe = copy(RECIPE["iron-gear-wheel"])
filterLakeWaterRecipe.name = "filter-lake-water"
filterLakeWaterRecipe.ingredients = {
	{type = "item", name = "filter", amount = 1},
	{type = "fluid", name = "lake-water", amount = 1200},
}
filterLakeWaterRecipe.results = {
	{type = "fluid", name = "water", amount = 1000},
	{type = "item", name = "spent-filter", amount = 1},
	{type = "item", name = "sand", amount_min = 0, amount_max = 4, show_details_in_recipe_tooltip = false},
	{type = "item", name = "stone", amount_min = 0, amount_max = 2, show_details_in_recipe_tooltip = false},
	{type = "item", name = "niter", amount_min = 0, amount_max = 2, show_details_in_recipe_tooltip = false},
	{type = "item", name = "raw-fish", amount = 1, probability = .01, show_details_in_recipe_tooltip = false},
}
filterLakeWaterRecipe.main_product = "water"
filterLakeWaterRecipe.category = "chemistry-or-crafting-with-fluid"
filterLakeWaterRecipe.subgroup = "filtration"
filterLakeWaterRecipe.order = "04"
filterLakeWaterRecipe.icon = nil
filterLakeWaterRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
	{icon = "__LegendarySpaceAge__/graphics/filtration/lake-water.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
}
filterLakeWaterRecipe.enabled = false
filterLakeWaterRecipe.energy_required = 5
filterLakeWaterRecipe.crafting_machine_tint = {
	primary = {.015, .631, .682},
	secondary = FLUID.water.base_color,
	tertiary = FLUID.water.flow_color,
}
data:extend{filterLakeWaterRecipe}

-- Create lake water fluid.
local lakeWaterFluid = copy(FLUID.water)
lakeWaterFluid.name = "lake-water"
lakeWaterFluid.icon = nil
lakeWaterFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/filtration/lake-water.png", icon_size = 64}}
lakeWaterFluid.auto_barrel = false
lakeWaterFluid.order = "a[fluid]-a[water]-c"
lakeWaterFluid.base_color = {0, .44, .6}
lakeWaterFluid.flow_color = {.7, .7, .7}
lakeWaterFluid.visualization_color = {.015, .681, .682} -- To differentiate from ordinary water.
lakeWaterFluid.max_temperature = nil
lakeWaterFluid.heat_capacity = nil
data:extend{lakeWaterFluid}

-- Create slime fluid.
local slimeFluid = copy(FLUID["water"])
slimeFluid.name = "slime"
slimeFluid.icon = nil
slimeFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/filtration/slime.png", icon_size = 64}}
slimeFluid.auto_barrel = true
slimeFluid.order = "b[new-fluid]-c2[gleba]-a"
slimeFluid.base_color = {.176, .255, .200}
slimeFluid.flow_color = {.393, .453, .333}
slimeFluid.visualization_color = {.482, .745, .215}
slimeFluid.max_temperature = nil
slimeFluid.heat_capacity = nil
data:extend{slimeFluid}

-- Create recipe to filter slime.
local filterSlimeRecipe = copy(RECIPE["iron-gear-wheel"])
filterSlimeRecipe.name = "filter-slime"
filterSlimeRecipe.ingredients = {
	{type = "item", name = "filter", amount = 1},
	{type = "fluid", name = "slime", amount = 400},
}
filterSlimeRecipe.results = {
	{type = "fluid", name = "water", amount = 300},
	{type = "item", name = "spent-filter", amount = 1},
	{type = "item", name = "spoilage", amount = 10, show_details_in_recipe_tooltip = false},
	{type = "item", name = "petrophage", amount = 1, probability = .05, show_details_in_recipe_tooltip = false},
	-- Could give eggs or fruits with some small probability. But rather not, since that makes it too easy to restart cycles.
}
filterSlimeRecipe.main_product = "water"
filterSlimeRecipe.category = "chemistry-or-crafting-with-fluid"
filterSlimeRecipe.subgroup = "gleba-non-agriculture"
filterSlimeRecipe.order = "00"
filterSlimeRecipe.icon = nil
filterSlimeRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
	{icon = "__LegendarySpaceAge__/graphics/filtration/slime.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
}
filterSlimeRecipe.enabled = false
filterSlimeRecipe.energy_required = 6
filterSlimeRecipe.crafting_machine_tint = {
	primary = {.176, .255, .200},
	secondary = {.393, .453, .333},
	tertiary = {.482, .745, .215},
}
data:extend{filterSlimeRecipe}

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