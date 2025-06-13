-- This file adds fulgorite farming.

-- Electrophages + 2 fulgorite shards => fulgorite starter
-- Fulgorite starter grows into fulgorite
-- Fulgorite gets harvested to produce 4-8 fulgorite shards
-- Fulgorite shard can also be crushed to produce 4 holmium powder.

-- Create item for fulgorite shards.
-- I'm changing the holmium ore item to be called "holmium powder". Then using the holmium ore graphic for fulgorite shards.
local fulgoriteShardItem = copy(ITEM["holmium-ore"])
fulgoriteShardItem.name = "fulgorite-shard"
fulgoriteShardItem.icon = ITEM["holmium-ore"].icon
extend({fulgoriteShardItem})

-- Change holmium ore sprite to look like powder, since I'm renaming it to holmium powder.
local holmiumPowderIcons = {}
for _, a in pairs{"a", "b"} do for _, b in pairs{"0", "90", "180", "270"} do
	table.insert(holmiumPowderIcons, {filename = "__LegendarySpaceAge__/graphics/fulgora/fulgorite-stuff/holmium-powder-"..a.."-"..b..".png", size = 64, mipmap_count = 4, scale = 0.65})
end end
ITEM["holmium-ore"].pictures = holmiumPowderIcons
ITEM["holmium-ore"].icon = holmiumPowderIcons[1].filename

-- Change holmium powder sounds so it sounds like a powder instead of rock.
ITEM["holmium-ore"].drop_sound = ITEM["sulfur"].drop_sound
ITEM["holmium-ore"].pick_sound = ITEM["sulfur"].pick_sound
ITEM["holmium-ore"].inventory_move_sound = ITEM["sulfur"].inventory_move_sound

-- Fulgorite should yield fulgorite shard on mining, not holmium powder or stone or electrophages.
RAW["simple-entity"]["fulgurite"].minable.results = { {type = "item", name = "fulgorite-shard", amount_min = 4, amount_max = 8} }
RAW["simple-entity"]["fulgurite-small"].minable.results = { {type = "item", name = "fulgorite-shard", amount_min = 2, amount_max = 4} }

-- Create item for fulgorite starter.
local fulgoriteStarterItem = copy(ITEM["holmium-ore"])
fulgoriteStarterItem.name = "fulgorite-starter"
Icon.set(fulgoriteStarterItem, "LSA/fulgora/fulgorite-stuff/fulgorite-starter")
fulgoriteStarterItem.place_result = "fulgorite-plant"
fulgoriteStarterItem.localised_name = {"item-name.fulgorite-starter"} -- Otherwise it gets entity name.
fulgoriteStarterItem.spoil_ticks = 30 * MINUTES
fulgoriteStarterItem.spoil_result = "stone"
fulgoriteStarterItem.plant_result = "fulgorite-plant"
fulgoriteStarterItem.pictures = nil -- Remove the holmium powder picture.
extend({fulgoriteStarterItem})

-- Create recipe to crush fulgorite shards for holmium powder.
local crushFulgoriteShardRecipe = copy(RECIPE["plastic-bar"])
crushFulgoriteShardRecipe.name = "holmium-ore" -- Naming it the same as holmium ore, so it doesn't get a separate entry in Factoriopedia etc.
Recipe.setCategories(crushFulgoriteShardRecipe, {"chemistry", "handcrafting"})
crushFulgoriteShardRecipe.auto_recycle = false
crushFulgoriteShardRecipe.results = {
	{ type = "item", name = "holmium-ore", amount = 2 },
}
crushFulgoriteShardRecipe.ingredients = {
	{ type = "item", name = "fulgorite-shard", amount = 1 },
}
extend({crushFulgoriteShardRecipe})
Tech.addRecipeToTech("holmium-ore", "holmium-processing", 1)

-- Create plant
local fulgoritePlant = copy(RAW.plant["jellystem"])
fulgoritePlant.name = "fulgorite-plant"
fulgoritePlant.minable = copy(RAW["simple-entity"]["fulgurite"].minable)
fulgoritePlant.harvest_emissions = nil
fulgoritePlant.emissions_per_second = nil -- They're not really a plant, they're a coral, so shouldn't absorb pollution, unlike jellystem/yumako.
fulgoritePlant.agricultural_tower_tint = {
	primary = { r = 0.408, g = 0.231, b = 0.271, a = 1.000 }, -- duller pink from holmium ore sprite
	secondary = { r = 0.941, g = 0.302, b = 0.42, a = 1.000 }, -- bright pink from holmium ore sprite
}
fulgoritePlant.variation_weights = nil
fulgoritePlant.variations = nil
fulgoritePlant.icon = RAW["simple-entity"].fulgurite.icon
RAW["simple-entity"].fulgurite.hidden_in_factoriopedia = true -- Because we're rather adding the plant.
RAW["simple-entity"].fulgurite.factoriopedia_alternative = "fulgorite-plant" -- Redirect to the plant.
--fulgoritePlant.factoriopedia_simulation = RAW["simple-entity"].fulgurite.factoriopedia_simulation
fulgoritePlant.factoriopedia_simulation = nil -- The simulation above looks stupid because it shows the tiny growing plant, not full-grown plant.
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
fulgoritePlant.autoplace = copy(RAW["simple-entity"].fulgurite.autoplace)
local growableFulgoraTiles = {"fulgoran-dust", "fulgoran-dunes", "fulgoran-sand", "fulgoran-rock", "fulgoran-walls", "fulgoran-paving", "fulgoran-conduit", "fulgoran-machinery"}
fulgoritePlant.autoplace.tile_restriction = growableFulgoraTiles
fulgoritePlant.growth_ticks = 20 * MINUTES -- Gleba plants are 5 minutes. Making this longer bc they can be planted anywhere, but not too much since yield is low.
-- Fix mining sound and particles
fulgoritePlant.mined_sound = nil
fulgoritePlant.mining_sound = nil
fulgoritePlant.minable.mining_particle = "stone-particle"
extend({fulgoritePlant})

-- Hide "fulgorite pieces" simple entity from Factoriopedia to not confuse people.
Entity.hide("simple-entity", "fulgurite-small", "fulgorite-plant")

-- Create recipe for making fulgorite starters from electrophages plus fulgorite shards.
local fulgoriteStarterRecipe = copy(RECIPE["electrophage-cultivation"])
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
Icon.clear(fulgoriteStarterRecipe)
extend({fulgoriteStarterRecipe})

-- Create tech for fulgorite farming.
local fulgoriteFarmingTech = copy(TECH["electrophages"])
fulgoriteFarmingTech.name = "fulgorite-farming"
fulgoriteFarmingTech.prerequisites = {"electrophages"}
fulgoriteFarmingTech.effects = {{type = "unlock-recipe", recipe = "fulgorite-starter"}}
Icon.set(fulgoriteFarmingTech, "LSA/fulgora/fulgorite-stuff/tech")
extend({fulgoriteFarmingTech})