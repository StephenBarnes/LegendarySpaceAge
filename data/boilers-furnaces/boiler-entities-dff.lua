--[[ This file creates assembling-machine versions of boilers.

We change boilers to have type assembling-machine, so that we can do arbitrary recipes in them - boiling raw water, or pure water, and using air or pure oxygen, and outputting flue gas / CO2.
	The actual "boiler" type is sorta pointless? Seems to be a holdover from back when steam wasn't a separate fluid, just water with a different temperature. The BoilerPrototype still has an option for BoilerPrototype.mode = "heat-fluid-inside" which is no longer used in vanilla and I haven't seen it used in any mods.
Note boilers are kinda just like furnaces, or the electric heater - they use combustion or electricity to heat things up. So we could actually remove them entirely and just use furnaces.
	But I think I'll rather keep them in the game, and use them specifically for recipes that heat up fluids. Because we already have the graphics etc, and it looks a bit nicer to have boilers as a separate thing.

This mod has dependencies on Electric Boiler and Gas Boiler mods.
]]

-- Function to convert graphics of boilers into assembling-machine graphics.
---@param boilerPictures data.BoilerPictureSet
---@return data.CraftingMachineGraphicsSet
local function convertBoilerGraphics(boilerPictures)
	---@type data.Animation4Way
	local animation = {
		north = {
			frame_count = 1,
			layers = boilerPictures.north.structure.layers,
		},
		south = {
			frame_count = 1,
			layers = boilerPictures.south.structure.layers,
		},
		east = {
			frame_count = 1,
			layers = boilerPictures.east.structure.layers,
		},
		west = {
			frame_count = 1,
			layers = boilerPictures.west.structure.layers,
		},
	}
	---@type data.WorkingVisualisations
	local workingVisualisations = {
		{
			north_animation = boilerPictures.north.fire,
			south_animation = boilerPictures.south.fire,
			east_animation = boilerPictures.east.fire,
			west_animation = boilerPictures.west.fire,
		},
		{
			north_animation = boilerPictures.north.fire_glow,
			south_animation = boilerPictures.south.fire_glow,
			east_animation = boilerPictures.east.fire_glow,
			west_animation = boilerPictures.west.fire_glow,
		},
	}
	return {animation = animation, working_visualisations = workingVisualisations}
end

-- Table of boiler names and params for creating the new assembling-machine versions.
---@type table<string, {newName: string, crafting_categories: string[], energy_usage: string}>
local boilers = {
	["boiler"] = {
		newName = "boiler-lsa",
		crafting_categories = {"combustion-boiling"},
		energy_usage = "2MW",
		pollution = 20,
	},
	["gas-boiler"] = {
		newName = "gas-boiler-lsa",
		crafting_categories = {"combustion-boiling"},
		energy_usage = "2MW",
		pollution = 20,
	},
	["electric-boiler"] = {
		newName = "electric-boiler-lsa",
		crafting_categories = {"electric-boiling"},
		energy_usage = "2MW",
		pollution = 0,
	},
}

-- Convert all 3 boiler types to assembling-machine.
for name, vals in pairs(boilers) do
	local boiler = RAW.boiler[name]

	---@type data.AssemblingMachinePrototype
	---@diagnostic disable-next-line: assign-type-mismatch
	local amBoiler = copy(boiler)
	amBoiler.name = vals.newName
	amBoiler.type = "assembling-machine"
	amBoiler.crafting_categories = vals.crafting_categories
	amBoiler.crafting_speed = 1
	amBoiler.energy_source = boiler.energy_source
	amBoiler.energy_usage = vals.energy_usage
	amBoiler.localised_name = boiler.localised_name or {"entity-name." .. name}
	---@diagnostic disable-next-line: assign-type-mismatch
	amBoiler.graphics_set = convertBoilerGraphics(boiler.pictures)
	amBoiler.fluid_boxes = {
		boiler.fluid_box,
		boiler.output_fluid_box,
	}
	amBoiler.energy_source.emissions_per_minute = {pollution = vals.pollution}
	extend{amBoiler}

	-- Hide original boiler, and make item place new assembling-machine boiler.
	boiler.hidden = true
	ITEM[name].place_result = vals.newName
end

-- Move gas boiler to steam-power tech.
Tech.removeRecipeFromTech("gas-boiler", "fluid-handling")
-- Adding it to steam-power in tech-progression.lua.

-- Gas boiler smoke shoots out much faster than burner boiler, so change it back.
ASSEMBLER["gas-boiler-lsa"].energy_source.smoke = RAW.boiler.boiler.energy_source.smoke

-- Change gas-boiler icon to be consistent with other fluid-fuelled stuff.
ITEM["gas-boiler"].icons = {
	{icon = "__gas-boiler__/graphics/icons/gas-boiler.png", icon_size = 32, scale = 1, shift = {2, 0}},
	{icon = FLUID["petroleum-gas"].icons[1].icon, icon_size = 64, scale = 0.3, shift = {-5, 6}, tint = FLUID["petroleum-gas"].icons[1].tint},
}

-- TODO add invisible air provider to boilers.
-- TODO do substitutions by planet? so air input isn't needed on Nauvis/Gleba.
-- TODO do quality substitutions. (Boilers scale correctly, but assembling-machines don't.)