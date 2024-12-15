-- This file changes the labs.
-- There are 3 lab types: normal electric, pentapod biolabs, and space biolabs.
-- Pentapod biolabs are from the "Gleba Lab" mod by LordMiguel.
-- The base biolabs from Space Age are renamed to space biolabs.

-- For progression, we want to make them successively better but also more complex to run.
-- Base labs: 1x research speed, 100% science pack drain, 120kW electricity, 2 module slots. Produces no pollution.
--    Built only on Nauvis, so have to ship science packs back to Nauvis before you get techs that make planets easier, eg cliff explosives.
-- Pentapod biolabs: 2x research speed, 50% science pack drain, 4 module slots.
--    Requires 1/10s pentapod eggs to run. So if you run out of science, your pentapod eggs hatch. (Modules will probably reduce that to 1/50s.)
--    Built only on Gleba.
--    Produces lots of spores.
-- Space biolabs: 4x research speed, 25% science pack drain, 8 module slots.
--    Requires 1/2s biter eggs to run. (Modules will probably reduce that to 1/10s.)
--    Built only in space. So you'll probably want to have a travelling space platform picking up sciences on all planets.

local Table = require("code.util.table")
local Tech = require("code.util.tech")

-- Regular labs should only be buildable on Nauvis.
data.raw.lab.lab.surface_conditions = table.deepcopy(data.raw.lab.biolab.surface_conditions)
-- Pentapod biolabs should only be buildable on Gleba.
data.raw.lab.glebalab.surface_conditions = {
	{
		property = "pressure",
		min = 2000,
		max = 2000,
	},
}
-- Space biolabs should only be buildable on space platforms.
data.raw.lab.biolab.surface_conditions = {
	{
		property = "gravity",
		max = 0,
		min = 0,
	},
}
-- And remove pollution for space biolabs, since it's irrelevant.
data.raw.lab.biolab.energy_source.emissions_per_minute = nil

-- Set stack sizes and rocket capacities.
data.raw.item.glebalab.stack_size = 10
data.raw.item.biolab.stack_size = 10
data.raw.item.glebalab.weight = 10000
data.raw.item.biolab.weight = 10000

-- Set module slots.
data.raw.lab.biolab.module_slots = 8

-- Set science pack drain, and crafting speed.
data.raw.lab.glebalab.researching_speed = 2
data.raw.lab.biolab.researching_speed = 4
data.raw.lab.glebalab.science_pack_drain_rate_percent = 50
data.raw.lab.biolab.science_pack_drain_rate_percent = 25


-- Make the pentapod biolabs consume pentapod eggs, and space biolabs consume biter eggs.
data:extend({
	{
		type = "fuel-category",
		name = "pentapod-egg",
	},
	{
		type = "fuel-category",
		name = "biter-egg",
	},
})
data.raw.item["pentapod-egg"].fuel_category = "pentapod-egg"
data.raw.item["biter-egg"].fuel_category = "biter-egg"
data.raw.lab.glebalab.energy_source.fuel_categories = {"pentapod-egg"}
data.raw.lab.glebalab.energy_source.burner_usage = "food" -- Determines icons and tooltips - either fuel, nutrients, or food.
data.raw.lab.glebalab.energy_usage = "500kW" -- A pentapod egg is 5MJ, so consumes 1 every 10 seconds. (Modules will probably reduce that to 1/50s.)
data.raw.lab.biolab.energy_source.type = "burner"
data.raw.lab.biolab.energy_source.fuel_inventory_size = 1
data.raw.lab.biolab.energy_source.fuel_categories = {"biter-egg"}
data.raw.lab.biolab.energy_source.burner_usage = "food"
data.raw.lab.biolab.energy_usage = "3MW" -- A biter egg is 6MJ, so consumes 1 every 2 seconds. (Modules will probably reduce that to 1/10s.)

-- Since pentapod eggs and biter eggs are now in a different fuel category, we need to make them burnable in heating towers etc.
for _, ents in pairs(data.raw) do
	for _, ent in pairs(ents) do
		if ent.energy_source ~= nil and ent.energy_source.type == "burner" then
			if ent.energy_source.fuel_categories ~= nil and Table.hasEntry("chemical", ent.energy_source.fuel_categories) then
				table.insert(ent.energy_source.fuel_categories, "pentapod-egg")
				table.insert(ent.energy_source.fuel_categories, "biter-egg")
			end
		end
	end
end

-- Fix ordering of labs on menu
data.raw.item.glebalab.order = data.raw.item.lab.order .. "-2"
data.raw.item.biolab.order = data.raw.item.lab.order .. "-3"

-- Move labs to a new row on the menu, bc right now it's overflowing by 1.
local labSubgroup = table.deepcopy(data.raw["item-subgroup"]["production-machine"])
labSubgroup.name = "labs"
labSubgroup.order = labSubgroup.order .. "-2"
data.raw.item.lab.subgroup = "labs"
data.raw.item.glebalab.subgroup = "labs"
data.raw.item.biolab.subgroup = "labs"
data:extend({labSubgroup})

-- Modify recipes.
-- Plain electric lab: 10 gears, 10 green circuits, 4 transport belts.
data.raw.recipe.glebalab.ingredients = {
	{ type = "item", name = "steel-plate", amount = 10 },
	{ type = "item", name = "processing-unit", amount = 5 },
	{ type = "item", name = "pentapod-egg", amount = 5 },
	{ type = "item", name = "refined-concrete", amount = 10 },
}
data.raw.recipe.biolab.ingredients = {
	{ type = "item", name = "steel-plate", amount = 20 },
	{ type = "item", name = "processing-unit", amount = 10 },
	{ type = "item", name = "uranium-fuel-cell", amount = 4 },
	{ type = "item", name = "biter-egg", amount = 5 },
	{ type = "item", name = "refined-concrete", amount = 20 },
}

-- Modify techs.
-- Move pentapod labs to a separate tech, instead of putting their recipe in bioflux tech.
Tech.removeRecipeFromTech("glebalab", "bioflux")
data:extend({
	{
		type = "technology",
		name = "pentapod-biolab",
		icons = {
			{
				icon = "__LegendarySpaceAge__/graphics/from_gleba_lab/glebalab_tech.png",
				icon_size = 256,
			},
		},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "glebalab"
			},
		},
		prerequisites = {"agricultural-science-pack"},
		unit = table.deepcopy(data.raw.technology["carbon-fiber"].unit),
	},
})
-- Space biolabs go after nuclear fuel cells.
Tech.replacePrereq("biolab", "uranium-processing", "nuclear-power")
Tech.addTechDependency("pentapod-biolab", "biolab")

-- Remove extra description for Gleba biolab.
data.raw.recipe.glebalab.localised_description = nil
data.raw.item.glebalab.localised_description = {"entity-description.glebalab"}
-- TODO check this worked