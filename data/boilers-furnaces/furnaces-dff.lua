--[[ Convert stone-furnace and steel-furnace to internally be assembling-machine, so that we can set eg char recipe.
Doing this in data-final-fixes stage, so that other mods are less likely to crash if they want to change these entities.
]]

local FurnaceConst = require("const.furnace-const")

local pipePictures = GreyPipes.pipeBlocksEMPlantLong()
local drawOrders = {north = -1, east = -1, south = 10, west = -1}

for _, furnaceName in pairs{"stone-furnace", "steel-furnace", "electric-furnace"} do
	local furnace = FURNACE[furnaceName]
	furnace.type = "assembling-machine"
	extend{furnace}
	FURNACE[furnaceName] = nil
end

-- Edit pollution for stone furnace. This gets multiplied by the emissions multiplier for the specific vented gas.
ASSEMBLER["stone-furnace"].energy_source.emissions_per_minute = {pollution = 1}
-- Edit pollution to be zero for steel furnaces, since they capture the waste gases.
ASSEMBLER["steel-furnace"].energy_source.emissions_per_minute = {}

-- Create alternate versions of the furnaces for planets with air in the atmosphere.
for _, furnaceName in pairs{"stone-furnace", "steel-furnace"} do
	local furnace = ASSEMBLER[furnaceName]
	furnace.fluid_boxes_off_when_no_fluid_recipe = true
	furnace.placeable_by = {item = furnace.name, count = 1}
	furnace.surface_conditions = nil

	local newFurnace = copy(furnace)
	newFurnace.name = newFurnace.name.."-air"
	newFurnace.localised_name = {"entity-name."..newFurnace.name}
	newFurnace.localised_description = {"entity-description."..newFurnace.name}
	newFurnace.hidden_in_factoriopedia = true
	newFurnace.hidden = true
	newFurnace.factoriopedia_alternative = furnace.name
	--newFurnace.minable.result = furnace.name
	newFurnace.fluid_boxes_off_when_no_fluid_recipe = true
	newFurnace.deconstruction_alternative = furnace.name
	extend{newFurnace}
end

-- Give fluid input and output to all furnaces.
local oxygenInput = { --- @type data.FluidBox
	production_type = "input",
	filter = "oxygen-gas",
	pipe_covers = pipecoverspictures(),
	always_draw_covers = false,
	pipe_connections = {
		{ flow_direction = "input-output", position = {-0.5, 0.5}, direction = WEST },
		{ flow_direction = "input-output", position = {0.5, 0.5}, direction = EAST },
	},
	volume = 100,
	pipe_picture = pipePictures,
	secondary_draw_orders = drawOrders,
}
local airInputExplicit = { --- @type data.FluidBox
	production_type = "input",
	filter = "air",
	pipe_covers = pipecoverspictures(),
	always_draw_covers = false,
	pipe_connections = {
		{ flow_direction = "input-output", position = {-0.5, -0.5}, direction = WEST },
		{ flow_direction = "input-output", position = {0.5, -0.5}, direction = EAST },
	},
	volume = 100,
	pipe_picture = pipePictures,
	secondary_draw_orders = drawOrders,
}
local airInputLinked = { --- @type data.FluidBox
	production_type = "input",
	pipe_picture = nil,
	pipe_covers = nil,
	pipe_connections = {
		{ flow_direction = "input", position = {0.5, 0.5}, direction = NORTH, connection_type = "linked", linked_connection_id = FurnaceConst.airLinkId },
	},
	volume = 1000,
}
local gasOutputExplicit = { --- @type data.FluidBox
	production_type = "output",
	pipe_covers = pipecoverspictures(),
	always_draw_covers = false,
	pipe_connections = {
		{ flow_direction = "input-output", position = {0.5, -0.5}, direction = NORTH},
		{ flow_direction = "input-output", position = {0.5, 0.5}, direction = SOUTH},
	},
	volume = 100,
	pipe_picture = pipePictures,
	secondary_draw_orders = drawOrders,
}
local gasOutputLinked = { --- @type data.FluidBox
	production_type = "output",
	pipe_picture = nil,
	pipe_covers = nil,
	pipe_connections = {
		{ flow_direction = "output", position = {-0.5, -0.5}, direction = NORTH, connection_type = "linked", linked_connection_id = FurnaceConst.outputLinkId },
	},
	volume = 1000,
}
ASSEMBLER["stone-furnace"].fluid_boxes = {airInputExplicit, oxygenInput, gasOutputLinked}
ASSEMBLER["stone-furnace-air"].fluid_boxes = {airInputLinked, oxygenInput, gasOutputLinked}
ASSEMBLER["steel-furnace"].fluid_boxes = {airInputExplicit, oxygenInput, gasOutputExplicit}
ASSEMBLER["steel-furnace-air"].fluid_boxes = {airInputLinked, oxygenInput, gasOutputExplicit}