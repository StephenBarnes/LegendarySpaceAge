-- Modifying the gas furnace, from Adamo's Gas Furnace mod.
local gasFurnaceEnt = data.raw.furnace["gas-furnace"]

-- Remove fluid inputs and outputs.
gasFurnaceEnt.fluid_boxes = nil

-- Change from 4 fuel inputs to only 2.
gasFurnaceEnt.energy_source.fluid_box.pipe_connections = {
	{ flow_direction = "input-output", position = { 0.5, -0.5 }, direction = 4 },
	{ flow_direction = "input-output", position = { -0.5, -0.5 }, direction = 12 },
}

-- Show arrows for fuel pipes.
gasFurnaceEnt.energy_source.fluid_box.hide_connection_info = false

-- Prevent it from doing chem plant recipes.
gasFurnaceEnt.crafting_categories = data.raw.furnace["electric-furnace"].crafting_categories

-- Change energy usage. TODO balance.
gasFurnaceEnt.energy_usage = "200kW" -- default 100kW.

-- Edit graphics so it has 2 pipe covers at the bottom, since I removed the fluid inputs/outputs.
gasFurnaceEnt.graphics_set.working_visualisations[3].animation.filename = "__LegendarySpaceAge__/graphics/from_gas_furnace/entity-working.png"
gasFurnaceEnt.graphics_set.animation.layers[1].filename = "__LegendarySpaceAge__/graphics/from_gas_furnace/entity.png"

-- Tried to allow flipping it, but doesn't seem to work. So instead I'm just putting the 2 fluid connections in positions so that rotating the furnace is probably enough. Turns out that also makes it so flipping is allowed, for some reason.
--gasFurnaceEnt.graphics_set_flipped = gasFurnaceEnt.graphics_set

