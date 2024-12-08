-- This file adds fulgorite farming.

local Tech = require "code.util.tech"

-- Nutrients + fulgorite shards => fulgorite starter
-- Fulgorite starter grows into fulgorite
-- Fulgorite gets harvested to produce fulgorite shards
-- Fulgorite shards can also be crushed to produce holmium.

-- Create item for fulgorite shards.
-- I'm changing the holmium ore item to be called "holmium powder". Then using the holmium ore graphic for fulgorite shards.
local fulgoriteShardItem = table.deepcopy(data.raw.item["holmium-ore"])
fulgoriteShardItem.name = "fulgorite-shard"
fulgoriteShardItem.icon = data.raw.item["holmium-ore"].icon
fulgoriteShardItem.subgroup = "fulgora-processes"
fulgoriteShardItem.order = "a[raw-material]-b[fulgorite-shard]"
fulgoriteShardItem.order = "c[organics]-c[fulgorite-shard]"
data:extend({fulgoriteShardItem})

-- Change holmium ore sprite to look like powder, since I'm renaming it to holmium powder.
data.raw.item["holmium-ore"].pictures = {
	{
		filename = "__LegendarySpaceAge__/graphics/fulgorite-stuff/holmium-powder1.png",
		size = 64,
		mipmap_count = 4,
	},
	{
		filename = "__LegendarySpaceAge__/graphics/fulgorite-stuff/holmium-powder2.png",
		size = 64,
		mipmap_count = 4,
	},
}
data.raw.item["holmium-ore"].icon = "__LegendarySpaceAge__/graphics/fulgorite-stuff/holmium-powder1.png"

-- Fulgorite should yield fulgorite shard on mining, not holmium powder or stone or electrophages.
data.raw["simple-entity"]["fulgurite"].minable.results = { {type = "item", name = "fulgorite-shard", amount_min = 4, amount_max = 8} }
data.raw["simple-entity"]["fulgurite-small"].minable.results = { {type = "item", name = "fulgorite-shard", amount_min = 2, amount_max = 4} }

-- Create item for fulgorite starter.
local fulgoriteStarterItem = table.deepcopy(data.raw.item["holmium-ore"])
fulgoriteStarterItem.name = "fulgorite-starter"
fulgoriteStarterItem.icon = "__LegendarySpaceAge__/graphics/fulgorite-stuff/fulgorite-starter.png"
fulgoriteStarterItem.subgroup = "fulgora-processes"
fulgoriteStarterItem.order = "c[organics]-d[fulgorite-starter]"
fulgoriteStarterItem.place_result = "fulgorite-plant"
fulgoriteStarterItem.localised_name = {"item-name.fulgorite-starter"} -- Otherwise it gets entity name.
fulgoriteStarterItem.spoil_ticks = 60 * 60 * 20
fulgoriteStarterItem.spoil_result = "stone"
fulgoriteStarterItem.plant_result = "fulgorite-plant"
fulgoriteStarterItem.pictures = nil -- Remove the holmium powder picture.
data:extend({fulgoriteStarterItem})

-- Create recipe to crush fulgorite shards for holmium powder.
local crushFulgoriteShardRecipe = table.deepcopy(data.raw.recipe["plastic-bar"])
crushFulgoriteShardRecipe.name = "holmium-ore" -- Naming it the same as holmium ore, so it doesn't get a separate entry in Factoriopedia etc.
---@diagnostic disable-next-line: inject-field
crushFulgoriteShardRecipe.auto_recycle = false
crushFulgoriteShardRecipe.results = {
	{ type = "item", name = "holmium-ore", amount = 1 },
}
crushFulgoriteShardRecipe.main_product = "holmium-ore"
crushFulgoriteShardRecipe.ingredients = {
	{ type = "item", name = "fulgorite-shard", amount = 1 },
}
data:extend({crushFulgoriteShardRecipe})
Tech.addRecipeToTech("holmium-ore", "holmium-processing", 1)

-- Create plant
local fulgoritePlant = table.deepcopy(data.raw.plant["jellystem"])
fulgoritePlant.name = "fulgorite-plant"
fulgoritePlant.minable = table.deepcopy(data.raw["simple-entity"]["fulgurite"].minable)
fulgoritePlant.harvest_emissions = nil
fulgoritePlant.emissions_per_second = nil -- They're not really a plant, they're a coral, so shouldn't absorb pollution, unlike jellystem/yumako.
fulgoritePlant.agricultural_tower_tint = {
	primary = { r = 0.408, g = 0.231, b = 0.271, a = 1.000 }, -- duller pink from holmium ore sprite
	secondary = { r = 0.941, g = 0.302, b = 0.42, a = 1.000 }, -- bright pink from holmium ore sprite
}
fulgoritePlant.variation_weights = nil
fulgoritePlant.variations = nil
fulgoritePlant.icon = data.raw["simple-entity"].fulgurite.icon
data.raw["simple-entity"].fulgurite.hidden_in_factoriopedia = true -- Because we're rather adding the plant.
--fulgoritePlant.factoriopedia_simulation = data.raw["simple-entity"].fulgurite.factoriopedia_simulation
fulgoritePlant.factoriopedia_simulation = nil -- The simulation above looks stupid because it shows the tiny growing plant, not full-grown plant.
fulgoritePlant.order = "a[tree]-b[fulgora]" -- Between Nauvis tree and Gleba trees.
fulgoritePlant.pictures = {
	sheet = {
		filename = "__space-age__/graphics/decorative/fulgurite/fulgurite.png",
		variation_count = 6,
		width = 284,
		height = 298,
		shift = util.by_pixel( -6.0, -13.5),
		scale = 0.5,
		line_length = 4,
	},
}
-- Stuff below is to make it grow on Fulgoran tiles. Seems it grows on any tile in its autoplace, but it's not documented anywhere.
fulgoritePlant.autoplace = table.deepcopy(data.raw["simple-entity"].fulgurite.autoplace)
local growableFulgoraTiles = {"fulgoran-dust", "fulgoran-dunes", "fulgoran-sand", "fulgoran-rock", "fulgoran-walls", "fulgoran-paving", "fulgoran-conduit", "fulgoran-machinery"}
fulgoritePlant.autoplace.tile_restriction = growableFulgoraTiles
fulgoritePlant.growth_ticks = 60 * 60 * 30 -- Gleba plants are 5 minutes. Making this longer bc they can be planted anywhere.
-- Fix mining sound and particles
fulgoritePlant.mined_sound = nil
fulgoritePlant.mining_sound = nil
fulgoritePlant.minable.mining_particle = "stone-particle"
data:extend({fulgoritePlant})

-- Hide "fulgorite pieces" from Factoriopedia to not confuse people.
data.raw["simple-entity"]["fulgurite-small"].hidden_in_factoriopedia = true

-- Create recipe for making fulgorite starters from electrophages plus fulgorite shards.
local fulgoriteStarterRecipe = table.deepcopy(data.raw.recipe["electrophage-cultivation"])
fulgoriteStarterRecipe.name = "fulgorite-starter"
fulgoriteStarterRecipe.ingredients = {
	{ type = "item", name = "fulgorite-shard", amount = 2 },
	{ type = "item", name = "electrophage", amount = 4 },
	{ type = "fluid", name = "electrolyte", amount = 10 },
}
fulgoriteStarterRecipe.results = {
	{ type = "item", name = "fulgorite-starter", amount = 1 },
}
fulgoriteStarterRecipe.main_product = "fulgorite-starter"
--fulgoriteStarterRecipe.hidden_in_factoriopedia = true
fulgoriteStarterRecipe.icon = nil
data:extend({fulgoriteStarterRecipe})

-- Create tech for fulgorite farming.
local fulgoriteFarmingTech = table.deepcopy(data.raw.technology["electrophages"])
fulgoriteFarmingTech.name = "fulgorite-farming"
fulgoriteFarmingTech.prerequisites = {"electrophages"}
fulgoriteFarmingTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "fulgorite-starter"
	},
}
fulgoriteFarmingTech.icon = "__LegendarySpaceAge__/graphics/fulgorite-stuff/tech.png"
data:extend({fulgoriteFarmingTech})

-- Remove placement restrictions for agricultural tower.
data.raw["agricultural-tower"]["agricultural-tower"].surface_conditions = nil