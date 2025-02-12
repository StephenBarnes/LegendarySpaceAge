-- This file makes slipstacks a farmable crop, and creates items/techs/recipes for them.
-- Some of the code might be copied from Slipstack Agriculture mod by LordMiguel. Originally that mod was a dependency of this modpack, but I decided to instead implement stuff separately.
-- Note: the new mapgen preset reduces stone spawns on Gleba, partly to encourage slipstack farming.

local Item = require("code.util.item")

------------------------------------------------------------------------
--- Change slipstack from type "tree" to type "plant", so it's farmable.

---@type data.PlantPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local slipstackPlant = table.deepcopy(data.raw.tree.slipstack)
slipstackPlant.type = "plant"

slipstackPlant.growth_ticks = 60 * 60 * 10 -- 10 minutes; compare to yumako/jellystem at 5 minutes.
slipstackPlant.placeable_by = {item = "slipstack-nest", count = 1}
slipstackPlant.autoplace.tile_restriction = {
	--"wetland-blue-slime",
	"wetland-light-dead-skin",
	"wetland-dead-skin",
	"wetland-pink-tentacle",
	"wetland-red-tentacle",
}
-- Make them visible on map. Color matches purple swamp.
slipstackPlant.map_color = {.92, .525, .6}
-- Edit color shown in ag tower.
slipstackPlant.agricultural_tower_tint = {
	primary = {r = 0.15, g = 0.22, b = 0.38, a = 1},
	secondary = {r = 0.361, g = 0.113, b = 0.308, a = 1},
}

-- Harvesting slipstacks produces stone and pearls.
slipstackPlant.minable.results = {
	{type = "item", name = "stone", amount_min = 5, amount_max = 15 },
	{type = "item", name = "slipstack-pearl", amount_min = 5, amount_max = 15}
}

-- Delete old slipstack tree, add new slipstack plant.
data.raw.tree.slipstack = nil
data:extend{slipstackPlant}

------------------------------------------------------------------------
--- Create items

-- Create item for slipstack pearl
local slipstackPearl = table.deepcopy(data.raw.item.spoilage)
slipstackPearl.name = "slipstack-pearl"
slipstackPearl.icon = "__LegendarySpaceAge__/graphics/slipstacks/slipstack-pearl.png"
slipstackPearl.subgroup = "slipstacks-and-boompuffs"
slipstackPearl.order = "01"
slipstackPearl.spoil_ticks = 60 * 60 * 5 -- 5 minutes.
slipstackPearl.spoil_result = "spoilage"
Item.clearFuel(slipstackPearl)
data:extend{slipstackPearl}

-- Create item for slipstack nest
local slipstackNest = table.deepcopy(data.raw.item["iron-ore"])
slipstackNest.name = "slipstack-nest"
slipstackNest.localised_name = {"item-name.slipstack-nest"}
slipstackNest.icon = "__LegendarySpaceAge__/graphics/slipstacks/slipstack-nest.png"
slipstackNest.pictures = nil
slipstackNest.subgroup = "slipstacks-and-boompuffs"
slipstackNest.order = "02"
slipstackNest.spoil_ticks = 60 * 60 * 20
slipstackNest.spoil_result = "stone"
-- Make the nests non-burnable, since thy're supposed to be mostly rock and there's no risk of having too many.
Item.clearFuel(slipstackNest)
slipstackNest.plant_result = "slipstack"
slipstackNest.place_result = "slipstack"
data:extend{slipstackNest}

------------------------------------------------------------------------
--- Create recipes

-- Recipe for making slipstack nest from pearls and rocks
local slipstackNestRecipe = table.deepcopy(data.raw.recipe["bioflux"])
slipstackNestRecipe.name = "slipstack-nest"
slipstackNestRecipe.ingredients = {
	{ type = "item", name = "slipstack-pearl", amount = 4 }, -- Requires less than it yields (10), so you don't need a prod bonus to make it sustainable.
	{ type = "item", name = "stone", amount = 4 },
	{ type = "item", name = "marrow", amount = 2 },
}
slipstackNestRecipe.category = "crafting"
slipstackNestRecipe.results = {{type = "item", name = "slipstack-nest", amount = 1}}
slipstackNestRecipe.surface_conditions = nil -- Allow anywhere. Can't be planted anywhere else, though.
slipstackNestRecipe.auto_recycle = true
slipstackNestRecipe.icon = nil
data:extend{slipstackNestRecipe}

-- Recipe for smelting slipstack pearls to resin
local pearlSmeltRecipe = table.deepcopy(data.raw.recipe["bioplastic"])
pearlSmeltRecipe.name = "smelt-slipstack-pearl"
pearlSmeltRecipe.ingredients = {{type = "item", name = "slipstack-pearl", amount = 1}}
pearlSmeltRecipe.results = {{type = "item", name = "resin", amount = 1}}
pearlSmeltRecipe.category = "smelting"
pearlSmeltRecipe.subgroup = "resin"
pearlSmeltRecipe.order = "04"
pearlSmeltRecipe.icon = nil
pearlSmeltRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/slipstacks/slipstack-pearl.png", icon_size = 64, scale = 0.3, shift = {-8, -8}},
}
data:extend{pearlSmeltRecipe}

------------------------------------------------------------------------
--- Adjust recipes for applications
-- TODO actually all of these recipes should just be redefined wholesale, not like this.

local Recipe = require("code.util.recipe")

Recipe.addIngredients("bioplastic", {{type = "item", name = "slipstack-pearl", amount = 1}})

-- Change Gleba biolubricant recipe to require slipstack pearls.
-- Base Space Age recipe is 60 jelly => 20 lubricant.
data.raw.recipe["biolubricant"].ingredients = {
	{ type = "fluid", name = "water", amount = 10 },
	{ type = "item", name = "jelly", amount = 20 },
	{ type = "item", name = "slipstack-pearl", amount = 5 },
}
data.raw.recipe["biolubricant"].energy_required = 5

-- Could also put it in carbon fiber, or biosulfur.

------------------------------------------------------------------------
--- Create tech

local slipstackTech = table.deepcopy(data.raw.technology["biochamber"])
slipstackTech.name = "slipstack-propagation"
slipstackTech.icon = "__LegendarySpaceAge__/graphics/slipstacks/slipstack-tech.png"
slipstackTech.prerequisites = {"planet-discovery-gleba"}
slipstackTech.research_trigger = {
	type = "mine-entity",
	entity = "slipstack",
}
slipstackTech.effects = {
	{type = "unlock-recipe", recipe = "smelt-slipstack-pearl"},
	{type = "unlock-recipe", recipe = "slipstack-nest"},
}
data:extend{slipstackTech}