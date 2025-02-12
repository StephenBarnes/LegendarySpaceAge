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

-- Tried to allow flipping it; there's some weird restriction where it seems you can only flip stuff if it has at least 1 axis of reflection symmetry, even if not flipping across that axis.
--gasFurnaceEnt.graphics_set_flipped = gasFurnaceEnt.graphics_set

-- Move recipe from fluid handling tech to furnace tech.
Tech.removeRecipeFromTech("gas-furnace", "fluid-handling")
Tech.addRecipeToTech("gas-furnace", "advanced-material-processing")

-- Should only be able to place where there's oxygen.
gasFurnaceEnt.surface_conditions = data.raw["mining-drill"]["burner-mining-drill"].surface_conditions