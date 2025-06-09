--[[ This file creates assembling-machine versions of boilers.

We change boilers to have type assembling-machine, so that we can do arbitrary recipes in them - boiling raw water, or pure water, and using air or pure oxygen, and outputting flue gas / CO2.
	The actual "boiler" type is sorta pointless? Seems to be a holdover from back when steam wasn't a separate fluid, just water with a different temperature. The BoilerPrototype still has an option for BoilerPrototype.mode = "heat-fluid-inside" which is no longer used in vanilla and I haven't seen it used in any mods.
Note boilers are kinda just like furnaces, or the electric heater - they use combustion or electricity to heat things up. So we could actually remove them entirely and just use furnaces.
	But I think I'll rather keep them in the game, and use them specifically for recipes that heat up fluids. Because we already have the graphics etc, and it looks a bit nicer to have boilers as a separate thing.

This mod has a dependency on Electric Boiler.
]]

local BoilerConst = require("const.boiler-const")

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

-- Fluid boxes.
---@type data.FluidBox
local waterIOFluidBox = {
	volume = 200,
	pipe_covers = pipecoverspictures(),
	pipe_connections = {
		{flow_direction = "input-output", direction = WEST, position = {-1, 0.5}},
		{flow_direction = "input-output", direction = EAST, position = {1, 0.5}}
	},
	production_type = "input",
}
---@type data.FluidBox
local steamOutputFluidBox = {
	volume = 200,
	pipe_covers = pipecoverspictures(),
	pipe_connections = {
		{flow_direction = "output", direction = NORTH, position = {0, -0.5}}
	},
	production_type = "output",
}
---@type data.FluidBox
local airCenterInputFluidBox = {
	volume = 200,
	pipe_covers = pipecoverspictures(),
	pipe_connections = {
		{flow_direction = "input", direction = SOUTH, position = {0, 0.5}}
	},
	production_type = "input",
	pipe_picture = GreyPipes.pipeBlocks(),
	secondary_draw_orders = {north = -1, east = -1, south = 10, west = -1},
}
---@type data.FluidBox
local flueOutputFluidBox = {
	volume = 200,
	pipe_covers = pipecoverspictures(),
	pipe_connections = {
		{flow_direction = "input-output", direction = WEST, position = {-1, -0.5}},
		{flow_direction = "input-output", direction = EAST, position = {1, -0.5}},
	},
	production_type = "output",
	pipe_picture = GreyPipes.pipeBlocksEMPlantLong(),
	secondary_draw_orders = {north = -1, east = -1, south = -1, west = -1}, -- South is -1 too, looks better.
}
---@type data.FluidBox
local linkedAirInputFluidBox = {
	volume = 200,
	pipe_covers = nil,
	pipe_picture = nil,
	pipe_connections = {
		{ flow_direction = "input", position = {0.5, 0}, direction = NORTH, connection_type = "linked", linked_connection_id = BoilerConst.airLinkId },
	},
	production_type = "input",
}

-- Table of boiler names and params for creating the new assembling-machine versions.
-- NOTE fluid_boxes order must match up with the table in boiler-recipes.lua.
---@type table<string, {newName: string, crafting_categories: string[], energy_usage: string}>
local boilers = {
	["boiler"] = {
		newName = "boiler-lsa",
		crafting_categories = {"burner-boiling"},
		energy_usage = "2MW",
		pollution = 20,
		fluid_boxes = {waterIOFluidBox, steamOutputFluidBox, airCenterInputFluidBox, flueOutputFluidBox},
	},
	["electric-boiler"] = {
		newName = "electric-boiler-lsa",
		crafting_categories = {"non-burner-boiling"},
		energy_usage = "2MW",
		pollution = 0,
		fluid_boxes = {waterIOFluidBox, steamOutputFluidBox},
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
	amBoiler.fluid_boxes = vals.fluid_boxes
	amBoiler.energy_source.emissions_per_minute = {pollution = vals.pollution}
	amBoiler.placeable_by = {item = vals.newName, count = 1}
	amBoiler.surface_conditions = nil
	amBoiler.factoriopedia_description = {"factoriopedia-description."..name}
	extend{amBoiler}

	-- Hide original boiler, and make item place new assembling-machine boiler.
	boiler.hidden = true
	boiler.hidden_in_factoriopedia = true
	boiler.factoriopedia_alternative = vals.newName
	ITEM[name].place_result = vals.newName
	-- Rename item and recipe, so they merge with the right entity.
	Item.renameAndHide(name, vals.newName)
	Recipe.renameAndChangeResult(name, vals.newName)
end

-- Remove smoke from the burner-boiler.
local burnerBoiler = ASSEMBLER["boiler-lsa"]
burnerBoiler.created_smoke = nil
burnerBoiler.energy_source.smoke = nil
extend{burnerBoiler}

-- Create alternate version of the burner boiler for planets with air in the atmosphere.
local airBoiler = copy(ASSEMBLER["boiler-lsa"])
airBoiler.name = "boiler-lsa-air"
airBoiler.localised_name = {"entity-name."..airBoiler.name} -- TODO give it a different icon, so we can tell them apart in signal GUI etc.
airBoiler.localised_description = {"entity-description."..airBoiler.name}
airBoiler.hidden_in_factoriopedia = true
airBoiler.hidden = true
airBoiler.factoriopedia_alternative = "boiler-lsa"
airBoiler.minable.result = "boiler-lsa"
airBoiler.fluid_boxes_off_when_no_fluid_recipe = false
airBoiler.fluid_boxes = {waterIOFluidBox, steamOutputFluidBox, airCenterInputFluidBox, flueOutputFluidBox, linkedAirInputFluidBox}
extend{airBoiler}

-- TODO heat exchanger needs to also be changed to assembling-machine.