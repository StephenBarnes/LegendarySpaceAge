-- This file has tweaks to the Slipstack mod by LordMiguel.
-- I'm renaming his "slipstack polyp" to "slipstack nest", and adding a recipe to create it from "slipstack pearls" which are the blobs that come out from the tops of slipstacks.
-- Also changing his water-filtration recipe to the recipe for making slipstack nests out of pearls and rocks.

local Recipe = require("code.util.recipe")
local Tech = require("code.util.tech")

-- The mod changes slipstack's minable.results from 6 spoilage, 4 stone, to 50 spoilage, 100 stone.
-- I'm reducing it, same as for yumako/jellystem plants.
-- Also reducing it bc you might be doing this only for the pearls, and have to get rid of stone.
slipstackMinableResults = {
	{type = "item", name = "spoilage", amount = 10 },
	{type = "item", name = "stone", amount_min = 5, amount_max = 15 },
	{type = "item", name = "slipstack-pearl", amount_min = 5, amount_max = 15}
}
data.raw.plant["slipstack-plant"].minable.results = slipstackMinableResults
data.raw.tree["slipstack"].minable.results = slipstackMinableResults

-- Grow time is 10 minutes. Jellystem/yumako is 5 minutes. Fulgorites 20 minutes. So I think it's fine.

-- Could move the tech to after Gleba science. But rather incorporating it into early game.

-- Change research icon to just be a slipstack.
data.raw.technology["slipstack-propagation"].icon = "__LegendarySpaceAge__/graphics/slipstacks/slipstack-tech.png"

-- Allow recipe in chem plant or biochamber.
data.raw.recipe["slipstack-seed"].category = "organic-or-chemistry"

-- Hide the tree.slipstack thing in the factoriopedia, rather redirect to the plant.
data.raw.tree["slipstack"].factoriopedia_alternative = "slipstack-plant"

-- Change the plant's icon in factoriopedia, bc it's currently jellystem.
data.raw.plant["slipstack-plant"].icon = data.raw.tree["slipstack"].icon
data.raw.plant["slipstack-plant"].icons = data.raw.tree["slipstack"].icons

-- Add a new item for slipstack pearls which aren't plantable themselves but get turned into seeds.
local pearlItem = table.deepcopy(data.raw.item.spoilage)
pearlItem.name = "slipstack-pearl"
pearlItem.order = "a[organic-processing]-da[slipstack-pearl]"
pearlItem.subgroup = "agriculture-products"
pearlItem.spoil_ticks = 60 * 60 * 20
pearlItem.spoil_result = "spoilage"
pearlItem.icon = "__LegendarySpaceAge__/graphics/slipstacks/slipstack-pearl.png"
data:extend({pearlItem})

-- Remove the water-filtering recipe. Player can collect some pearls manually from mining slipstacks (or remotely), then replicate them via farming.
-- I'll leave the recipe, but rename it and change ingredients.
data.raw.recipe["slipstack-seed"].ingredients = {
	{ type = "item", name = "slipstack-pearl", amount = 10 },
	{ type = "item", name = "iron-ore", amount = 4 },
	{ type = "item", name = "nutrients", amount = 2 },
}
data.raw.recipe["slipstack-seed"].results = {{type = "item", name = "slipstack-seed", amount = 1}}
data.raw.recipe["slipstack-seed"].surface_conditions = nil -- Allow anywhere. Can't be planted anywhere else, though.
data.raw.item["slipstack-seed"].spoil_ticks = 60 * 60 * 20
data.raw.item["slipstack-seed"].spoil_result = "iron-ore"

-- Make slipstacks absorb spores.
-- A jellystem produces 15 spores per harvest, and grows 5m. Yumako is the same. So per second it's 15/(5*60) = 0.05.
-- They also produce -0.001/s pollution (not spores), which is weird bc there's no pollution on Gleba.
-- Hm, making it -0.01/s so 5 slipstacks cancel out 1 jellystem or yumako tree.
--data.raw.plant["slipstack-plant"].emissions_per_second = {spores = -(data.raw.plant["jellystem"].emissions_per_second.pollution/2)}
data.raw.plant["slipstack-plant"].emissions_per_second = {spores = -0.01}

-- Make the seeds non-burnable, since they're supposed to be mostly rock and there's no risk of having too many.
data.raw.item["slipstack-seed"].fuel_category = nil
data.raw.item["slipstack-seed"].fuel_value = nil
-- Make the pearls burnable.
data.raw.item["slipstack-pearl"].fuel_category = "chemical"
data.raw.item["slipstack-pearl"].fuel_value = "1MJ" -- compared to spoilage 250kJ and wood 2MJ.

-- Trying: allow recycling slipstack nests to recover the pearls.
---@diagnostic disable-next-line: inject-field
data.raw.recipe["slipstack-seed"].auto_recycle = true

-- Give slipstacks some applications: bioplastic.
-- Also putting it in the science packs.
-- Could also put it in carbon fiber, or biosulfur.
--Recipe.addIngredients("biosulfur", {{type = "item", name = "slipstack-pearl", amount = 1}})
Recipe.addIngredients("bioplastic", {{type = "item", name = "slipstack-pearl", amount = 1}})

-- Change Gleba biolubricant recipe to require slipstack pearls.
-- Base Space Age recipe is 60 jelly => 20 lubricant.
data.raw.recipe["biolubricant"].ingredients = {
	{ type = "fluid", name = "water", amount = 10 },
	{ type = "item", name = "jelly", amount = 30 },
	{ type = "item", name = "slipstack-pearl", amount = 5 },
}

-- Add slipstack agriculture as prereq to bioflux processing, since it's now needed for plastic, plus it'll be needed for science pack.
Tech.addTechDependency("slipstack-propagation", "bioflux-processing")

-- Change slipstack nests to use edited version of the icon from Slipstack Agriculture mod, to make the pearls more visible and match the color of my pearl icon.
data.raw.item["slipstack-seed"].icon = "__LegendarySpaceAge__/graphics/slipstacks/slipstack-nest.png"

-- Note: mapgen preset reduces stone spawns on Gleba, partly to encourage slipstack farming. I beat Space Age on the starter patch, without importing stuff to Gleba.
-- Note: we need some way to void stuff on Gleba, eg the stone produced by slipstacks, else you might only want to farm slipstacks for the pearls and then you have to dump the stone into chests somewhere.