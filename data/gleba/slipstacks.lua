-- This file makes slipstacks a farmable crop, and creates items/techs/recipes for them.
-- Some of the code might be copied from Slipstack Agriculture mod by LordMiguel. Originally that mod was a dependency of this modpack, but I decided to instead implement stuff separately.
-- Note: the new mapgen preset reduces stone spawns on Gleba, partly to encourage slipstack farming.

------------------------------------------------------------------------
--- Change slipstack from type "tree" to type "plant", so it's farmable.

---@type data.PlantPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local slipstackPlant = copy(RAW.tree.slipstack)
slipstackPlant.type = "plant"

slipstackPlant.growth_ticks = 10 * MINUTES -- compare to yumako/jellystem at 5 minutes.
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

-- Create Factoriopedia simulation. Copied from base game's yumako/jellynut simulations.
slipstackPlant.factoriopedia_simulation = {
	planet = "gleba",
	hide_factoriopedia_gradient = true,
	init = [[
		game.simulation.camera_zoom = 1.4
		game.simulation.camera_position = {-0.5, 0}
		for x = -10, 9, 1 do
		for y = -4, 4 do
			game.surfaces[1].set_tiles{{position = {x, y}, name = "wetland-pink-tentacle"}}
		end
		end

		game.surfaces[1].create_entity{name = "slipstack", position = {x=-2.54, y=-0.76}, tick_grown = 1}
		game.surfaces[1].create_entity{name = "slipstack", position = {x=2.87, y=-0.37}, tick_grown = 8000}
		game.surfaces[1].create_entity{name = "slipstack", position = {x=-4.68, y=1.83}, tick_grown = 1000}
		game.surfaces[1].create_entity{name = "slipstack", position = {x=-0.10, y=0.67}, tick_grown = 10000}
		game.surfaces[1].create_entity{name = "slipstack", position = {x=4.80, y=1.69}, tick_grown = 1}
	]]
}

-- Delete old slipstack tree, add new slipstack plant.
RAW.tree.slipstack = nil
extend{slipstackPlant}

------------------------------------------------------------------------
--- Create items

-- Create item for slipstack pearl
local slipstackPearl = copy(ITEM.spoilage)
slipstackPearl.name = "slipstack-pearl"
Icon.set(slipstackPearl, "LSA/gleba/slipstacks/pearl")
slipstackPearl.spoil_ticks = 5 * MINUTES
slipstackPearl.spoil_result = "spoilage"
Item.clearFuel(slipstackPearl)
extend{slipstackPearl}

-- Create item for slipstack nest
local slipstackNest = copy(ITEM["iron-ore"])
slipstackNest.name = "slipstack-nest"
slipstackNest.localised_name = {"item-name.slipstack-nest"}
Icon.set(slipstackNest, "LSA/gleba/slipstacks/nest")
slipstackNest.pictures = nil
slipstackNest.spoil_ticks = 20 * MINUTES
slipstackNest.spoil_result = "stone"
-- Make the nests non-burnable, since thy're supposed to be mostly rock and there's no risk of having too many.
Item.clearFuel(slipstackNest)
slipstackNest.plant_result = "slipstack"
slipstackNest.place_result = "slipstack"
extend{slipstackNest}

------------------------------------------------------------------------
--- Create recipes

-- Recipe for making slipstack nest from pearls and rocks
local slipstackNestRecipe = copy(RECIPE["bioflux"])
slipstackNestRecipe.name = "slipstack-nest"
slipstackNestRecipe.ingredients = {
	{ type = "item", name = "slipstack-pearl", amount = 5 }, -- Requires less than it yields (10), so you don't need a prod bonus to make it sustainable.
	{ type = "item", name = "stone", amount = 5 },
	{ type = "item", name = "marrow", amount = 1 },
}
slipstackNestRecipe.energy_required = 1
slipstackNestRecipe.category = "crafting"
slipstackNestRecipe.results = {{type = "item", name = "slipstack-nest", amount = 1}}
slipstackNestRecipe.surface_conditions = nil -- Allow anywhere. Can't be planted anywhere else, though.
slipstackNestRecipe.auto_recycle = true
Icon.clear(slipstackNestRecipe)
extend{slipstackNestRecipe}

-- Recipe for smelting slipstack pearls to resin
local pearlSmeltRecipe = copy(RECIPE["bioplastic"])
pearlSmeltRecipe.name = "smelt-slipstack-pearl"
pearlSmeltRecipe.ingredients = {{type = "item", name = "slipstack-pearl", amount = 1}}
pearlSmeltRecipe.results = {{type = "item", name = "resin", amount = 1}}
pearlSmeltRecipe.category = "smelting"
Icon.set(pearlSmeltRecipe, {"LSA/resin/resin-1", "slipstack-pearl"})
extend{pearlSmeltRecipe}

------------------------------------------------------------------------
--- Adjust recipes for applications
-- TODO actually all of these recipes should just be redefined wholesale, not like this.

Recipe.addIngredients("bioplastic", {{type = "item", name = "slipstack-pearl", amount = 1}})

-- Change Gleba biolubricant recipe to require slipstack pearls.
-- Base Space Age recipe is 60 jelly => 20 lubricant.
RECIPE["biolubricant"].ingredients = {
	{ type = "fluid", name = "water", amount = 10 },
	{ type = "item", name = "jelly", amount = 20 },
	{ type = "item", name = "slipstack-pearl", amount = 5 },
}
RECIPE["biolubricant"].energy_required = 5

-- Could also put it in carbon fiber, or biosulfur.

------------------------------------------------------------------------
--- Create tech

local slipstackTech = copy(TECH["biochamber"])
slipstackTech.name = "slipstack-propagation"
Icon.set(slipstackTech, "LSA/gleba/slipstacks/tech")
slipstackTech.prerequisites = {"planet-discovery-gleba"}
slipstackTech.research_trigger = {
	type = "mine-entity",
	entity = "slipstack",
}
slipstackTech.effects = {
	{type = "unlock-recipe", recipe = "smelt-slipstack-pearl"},
	{type = "unlock-recipe", recipe = "slipstack-nest"},
}
extend{slipstackTech}