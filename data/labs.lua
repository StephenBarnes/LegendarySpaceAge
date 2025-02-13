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

-- Regular labs should only be buildable on Nauvis.
RAW.lab.lab.surface_conditions = copy(RAW.lab.biolab.surface_conditions)
-- Pentapod biolabs should only be buildable on Gleba.
RAW.lab.glebalab.surface_conditions = {
	{
		property = "pressure",
		min = 2000,
		max = 2000,
	},
}
-- Space biolabs should only be buildable on space platforms.
RAW.lab.biolab.surface_conditions = {
	{
		property = "gravity",
		max = 0,
		min = 0,
	},
}
-- And remove pollution for space biolabs, since it's irrelevant.
RAW.lab.biolab.energy_source.emissions_per_minute = nil

-- Set stack sizes and rocket capacities.
ITEM.glebalab.stack_size = 10
ITEM.biolab.stack_size = 10
ITEM.glebalab.weight = ROCKET / 100
ITEM.biolab.weight = ROCKET / 100

-- Set module slots.
RAW.lab.biolab.module_slots = 8

-- Set science pack drain, and crafting speed.
RAW.lab.glebalab.researching_speed = 2
RAW.lab.biolab.researching_speed = 4
RAW.lab.glebalab.science_pack_drain_rate_percent = 50
RAW.lab.biolab.science_pack_drain_rate_percent = 25


-- Make the pentapod biolabs consume pentapod eggs, and space biolabs consume biter eggs.
extend({
	{
		type = "fuel-category",
		name = "activated-pentapod-egg",
	},
	{
		type = "fuel-category",
		name = "biter-egg",
	},
})
-- Egg fuel categories will be added to eggs in constants.lua with fuel.lua.
RAW.lab.glebalab.energy_source.fuel_categories = {"activated-pentapod-egg"}
RAW.lab.glebalab.energy_source.burner_usage = "food" -- Determines icons and tooltips - either fuel, nutrients, or food.
RAW.lab.glebalab.energy_usage = "500kW" -- A pentapod egg is 5MJ, so consumes 1 every 10 seconds. (Modules will probably reduce that to 1/50s.)
RAW.lab.biolab.energy_source.type = "burner"
RAW.lab.biolab.energy_source.fuel_inventory_size = 1
RAW.lab.biolab.energy_source.fuel_categories = {"biter-egg"}
RAW.lab.biolab.energy_source.burner_usage = "food"
RAW.lab.biolab.energy_usage = "3MW" -- A biter egg is 6MJ, so consumes 1 every 2 seconds. (Modules will probably reduce that to 1/10s.)

-- Modify techs.
-- Move pentapod labs to a separate tech, instead of putting their recipe in bioflux tech.
Tech.removeRecipeFromTech("glebalab", "bioflux")
extend({
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
		unit = copy(TECH["carbon-fiber"].unit),
	},
})
-- Space biolabs go after nuclear fuel cells.
Tech.replacePrereq("biolab", "uranium-processing", "nuclear-power")
Tech.addTechDependency("pentapod-biolab", "biolab")

-- Remove extra description for Gleba biolab.
RECIPE.glebalab.localised_description = nil
ITEM.glebalab.localised_description = {"entity-description.glebalab"}
-- TODO check this worked

-- TODO don't allow advanced science packs in ordinary electric labs, rather stage them to pentapod labs and then space biolabs.