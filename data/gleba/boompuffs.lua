-- This file makes boompuffs a farmable crop, and creates recipes and items for them.
-- Some code and graphics copied from Boompuff Agriculture mod by LordMiguel.

local boompuffTint = {
	-- Copied these colors from Boompuff Agriculture mod.
	primary = {r = 0.968, g = 0.381, b = 0.259, a = 1.000}, -- #f66142ff
	secondary = {r = 1.000, g = 0.978, b = 0.513, a = 1.000}, -- #fff982ff
}

------------------------------------------------------------------------
--- Change boompuff from type "tree" to type "plant", so it's farmable.

---@type data.PlantPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local boompuffPlant = copy(RAW.tree.boompuff)
boompuffPlant.type = "plant"

boompuffPlant.growth_ticks = 6 * MINUTES -- compare to yumako/jellystem at 5 minutes.
boompuffPlant.placeable_by = {item = "sprouted-boomnut", count = 1}
-- Wube's autoplace puts them in gleba_boompuff_region, which is some complicated expression. We need to add a tile restriction so it's growable on some tiles.
boompuffPlant.autoplace.tile_restriction = {
	"midland-yellow-crust",
	"midland-yellow-crust-2",
	"midland-yellow-crust-3",
	"midland-yellow-crust-4",
	-- It naturally spawns on these tiles, but I'll rather disable them so it's more visually obvious where it can grow.
	--"midland-cracked-lichen",
	--"midland-cracked-lichen-dull",
	--"midland-cracked-lichen-dark",
}
-- Make them visible on map.
boompuffPlant.map_color = {.72, .525, .25}
-- Edit color shown in ag tower.
boompuffPlant.agricultural_tower_tint = boompuffTint

-- Make boompuffs absorb spores.
-- A jellystem produces 15 spores per harvest, and grows 5m. Yumako is the same. So per second it's 15/(5*60) = 0.05.
-- They also produce -0.001/s pollution (not spores), which is weird bc there's no pollution on Gleba.
-- Hm, making it -0.01/s so 5 boompuffs cancel out 1 jellystem or yumako tree.
boompuffPlant.emissions_per_second = {spores = -.01}

-- Harvesting boompuffs produces boomnuts and boomsacs.
boompuffPlant.minable.results = {
	{type = "item", name = "boomnut", amount = 4},
	{type = "item", name = "boomsac", amount = 4},
}
-- Harvesting boompuffs doesn't produce an explosion (remains_when_mined), although it does make an explosion when destroyed (dying_explosion).
boompuffPlant.remains_when_mined = nil

-- Delete old boompuff tree, add new boompuff plant.
RAW.tree.boompuff = nil
extend({boompuffPlant})

------------------------------------------------------------------------
--- Create items for products of boompuff farming.

-- Create sprouted-boomnut item.
local sproutItem = copy(ITEM["tree-seed"])
sproutItem.name = "sprouted-boomnut"
sproutItem.localised_name = {"item-name.sprouted-boomnut"}
sproutItem.localised_description = {"item-description.sprouted-boomnut"}
Icon.variants(sproutItem, "LSA/gleba/boompuffs/sprout/%", 3)
Icon.set(sproutItem, "LSA/gleba/boompuffs/sprout/1")
sproutItem.subgroup = "slipstacks-and-boompuffs"
sproutItem.order = "12"
sproutItem.plant_result = "boompuff"
sproutItem.place_result = "boompuff"
sproutItem.spoil_ticks = 1 * HOURS
sproutItem.spoil_result = "spoilage"
Item.clearFuel(sproutItem)
extend{sproutItem}

-- Create boomnut item.
local boomnutItem = copy(ITEM["tree-seed"])
boomnutItem.name = "boomnut"
boomnutItem.localised_name = {"item-name.boomnut"}
boomnutItem.place_result = nil
boomnutItem.plant_result = nil
boomnutItem.subgroup = "slipstacks-and-boompuffs"
boomnutItem.order = "11"
Icon.set(boomnutItem, "LSA/gleba/boompuffs/nut/1")
Icon.variants(boomnutItem, "LSA/gleba/boompuffs/nut/%", 3)
Item.clearFuel(boomnutItem)
extend{boomnutItem}

-- Create boomsac item.
local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")
local sounds = require("__base__.prototypes.entity.sounds")
local boomsacItem = copy(RAW.capsule["grenade"])
boomsacItem.name = "boomsac"
boomsacItem.subgroup = "slipstacks-and-boompuffs"
boomsacItem.order = "13"
boomsacItem.spoil_ticks = 2 * MINUTES
boomsacItem.spoil_to_trigger_result = {
	items_per_trigger = 5, -- So for a stack of 100, it triggers 20 times. For 1 item, it still triggers 1 time.
	trigger = {
		type = "direct",
		action_delivery = {
			type = "instant",
			target_effects = {
				{
					type = "create-entity",
					entity_name = "boompuff-explosion"
				},
			}
		}
	}
}
boomsacItem.capsule_action.attack_parameters.cooldown = 15 -- Instead of 30.
boomsacItem.capsule_action.attack_parameters.ammo_type.action = { -- Copied from Boompuff Agriculture mod.
	{
		type = "direct",
		action_delivery = {
			type = "projectile",
			projectile = "boomsac-projectile",
			starting_speed = 0.2
		}
	},
	{
		type = "direct",
		action_delivery = {
			type = "instant",
			target_effects = {
				{
					type = "play-sound",
					sound = sounds.throw_projectile
				},
				{
					type = "play-sound",
					sound = space_age_item_sounds.agriculture_inventory_move
				},
			}
		}
	}
}
Icon.set(boomsacItem, "LSA/gleba/boompuffs/sac/6")
Icon.variants(boomsacItem, "LSA/gleba/boompuffs/sac/%", 8)
Item.copySoundsTo(RAW.capsule["yumako-mash"], boomsacItem)
extend{boomsacItem}

------------------------------------------------------------------------
-- Create projectile for thrown boomsac.
local boomsacProjectile = copy(RAW.projectile["grenade"])
boomsacProjectile.name = "boomsac-projectile"
boomsacProjectile.localised_name = {"item-name.boomsac"}
boomsacProjectile.hidden = true
boomsacProjectile.animation = { -- Graphics and idea copied from Boompuff Agriculture mod.
	filename = "__LegendarySpaceAge__/graphics/gleba/boompuffs/grenade.png",
	draw_as_glow = true,
	frame_count = 15,
	line_length = 8,
	animation_speed = 0.250,
	width = 48,
	height = 54,
	shift = util.by_pixel(0.5, 0.5),
	priority = "high",
	scale = 0.5,
}
boomsacProjectile.icon = "__LegendarySpaceAge__/graphics/gleba/boompuffs/sac/6.png"
extend{boomsacProjectile}

------------------------------------------------------------------------
--- Create recipes.

-- Create recipe for sprouted-boomnut: 1 boomnut -> 40% chance for 1 sprouted-boomnut.
local sproutedBoomnutRecipe = copy(RECIPE["bioflux"])
sproutedBoomnutRecipe.name = "sprouted-boomnut"
sproutedBoomnutRecipe.ingredients = {
	{type = "item", name = "boomnut", amount = 1},
}
sproutedBoomnutRecipe.results = {
	{type = "item", name = "sprouted-boomnut", amount = 1, probability = 0.4},
}
sproutedBoomnutRecipe.category = "smelting"
sproutedBoomnutRecipe.crafting_machine_tint = boompuffTint
Icon.clear(sproutedBoomnutRecipe)
sproutedBoomnutRecipe.show_amount_in_title = false
extend{sproutedBoomnutRecipe}

-- Create recipe for crush-boomnut: 1 boomnut -> 1 niter + 1 spoilage
local crushBoomnutRecipe = copy(RECIPE["bioflux"])
crushBoomnutRecipe.name = "crush-boomnut"
crushBoomnutRecipe.ingredients = {
	{type = "item", name = "boomnut", amount = 1},
}
crushBoomnutRecipe.results = {
	{type = "item", name = "niter", amount = 1},
	{type = "item", name = "sugar", amount = 1},
}
crushBoomnutRecipe.category = "crafting"
crushBoomnutRecipe.crafting_machine_tint = boompuffTint
Icon.set(crushBoomnutRecipe, {"boomnut", "niter", "LSA/gleba/sugar/1"}, "decomposition")
crushBoomnutRecipe.subgroup = "slipstacks-and-boompuffs"
crushBoomnutRecipe.order = "14"
crushBoomnutRecipe.allow_decomposition = false -- Otherwise it thinks spoilage comes from boomnut crushing by default.
extend{crushBoomnutRecipe}

-- Create recipe for boomsac-deflation: 1 boomsac + 10 water + 10 sulfuric acid -> 40 natural gas + 20 sulfuric acid + 1 sulfur
local boomsacDeflationRecipe = copy(RECIPE["bioflux"])
boomsacDeflationRecipe.name = "boomsac-deflation"
boomsacDeflationRecipe.ingredients = {
	{type = "item", name = "boomsac", amount = 1},
	{type = "fluid", name = "water", amount = 10},
	{type = "fluid", name = "sulfuric-acid", amount = 10},
}
boomsacDeflationRecipe.results = {
	{type = "fluid", name = "natural-gas", amount = 40},
	{type = "fluid", name = "sulfuric-acid", amount = 20},
	{type = "item", name = "sulfur", amount = 1},
}
boomsacDeflationRecipe.category = "chemistry"
boomsacDeflationRecipe.crafting_machine_tint = boompuffTint
Icon.set(boomsacDeflationRecipe, {"natural-gas", "boomsac"})
boomsacDeflationRecipe.subgroup = "slipstacks-and-boompuffs"
boomsacDeflationRecipe.order = "15"
extend{boomsacDeflationRecipe}

------------------------------------------------------------------------
-- Create tech.
local tech = copy(TECH["jellynut"])
tech.name = "boompuff-cultivation"
tech.effects = {
	{type = "unlock-recipe", recipe = "sprouted-boomnut"},
	{type = "unlock-recipe", recipe = "crush-boomnut"},
	{type = "unlock-recipe", recipe = "boomsac-deflation"},
	{type = "unlock-recipe", recipe = "ammonia-from-spoilage"},
}
tech.research_trigger = {
	type = "mine-entity",
	entity = "boompuff",
}
Icon.set(tech, "LSA/gleba/boompuffs/tech")
extend{tech}

------------------------------------------------------------------------

RAW.explosion["boompuff-explosion"].icon = "__base__/graphics/icons/explosion.png"
RAW.explosion["boompuff-explosion"].localised_name = {"entity-name.boompuff-explosion"}