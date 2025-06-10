-- Data-stage constants for boilers.

local BoilerConst = require("const.boiler-const")

local Export = {}

-- Fluid boxes for boilers.
---@type table<"x3x2"|"x5x3", table<"input"|"output", table<string, data.FluidBox>>>
Export.fluidBoxes = {
	x3x2 = { -- For 3x2 boilers: electric boiler and heat-shuttle boiler.
		input = {
			water = {
				volume = 200,
				pipe_covers = pipecoverspictures(),
				pipe_connections = {
					{flow_direction = "input-output", direction = WEST, position = {-1, 0.5}},
					{flow_direction = "input-output", direction = EAST, position = {1, 0.5}}
				},
				production_type = "input",
			},
		},
		output = {
			steam = {
				volume = 200,
				pipe_covers = pipecoverspictures(),
				pipe_connections = {
					{flow_direction = "output", direction = NORTH, position = {0, -0.5}}
				},
				production_type = "output",
			},
			brine = {
				volume = 200,
				pipe_covers = pipecoverspictures(),
				pipe_connections = {
					{flow_direction = "output", direction = SOUTH, position = {0, 0.5}},
				},
				production_type = "output",
				pipe_picture = GreyPipes.pipeBlocksEMPlantLongGraySouth(),
				secondary_draw_orders = {north = -1, east = -1, south = 10, west = -1},
			},
		},
	},
	x5x3 = { -- For the 5x3 combustion boiler. Generally want to put main input (water) on one side, main output (steam) on the other side, and then the rest are passthrough.
		input = {
			water = {
				volume = 200,
				pipe_covers = pipecoverspictures(),
				pipe_connections = {
					{flow_direction = "input", direction = NORTH, position = {0, -2}},
				},
				production_type = "input",
			},
			air = {
				volume = 200,
				pipe_covers = pipecoverspictures(),
				pipe_connections = {
					{flow_direction = "input-output", direction = WEST, position = {-1, 0}},
					{flow_direction = "input-output", direction = EAST, position = {1, 0}},
				},
				production_type = "input",
				pipe_picture = GreyPipes.pipeBlocksEMPlantLongGraySouth(),
				secondary_draw_orders = {north = -1, east = -1, south = 10, west = -1},
			},
			airLinked = {
				volume = 200,
				pipe_covers = nil,
				pipe_connections = {
					{flow_direction = "input", connection_type = "linked", linked_connection_id = BoilerConst.airLinkId, position = {0, 0}, direction = NORTH},
				},
				production_type = "input",
				pipe_picture = nil,
				--filter = "air",
				hide_connection_info = true,
			},
		},
		output = {
			steam = {
				volume = 200,
				pipe_covers = pipecoverspictures(),
				pipe_connections = {
					{flow_direction = "output", direction = SOUTH, position = {0, 2}},
				},
				production_type = "output",
			},
			flue = {
				volume = 200,
				pipe_covers = pipecoverspictures(),
				pipe_connections = {
					{flow_direction = "input-output", direction = WEST, position = {-1, 1}},
					{flow_direction = "input-output", direction = EAST, position = {1, 1}}
				},
				production_type = "output",
				pipe_picture = GreyPipes.pipeBlocksEMPlantLongGraySouth(),
				secondary_draw_orders = {north = -1, east = -1, south = 10, west = -1},
			},
			brine = {
				volume = 200,
				pipe_covers = pipecoverspictures(),
				pipe_connections = {
					{flow_direction = "input-output", direction = WEST, position = {-1, -1}},
					{flow_direction = "input-output", direction = EAST, position = {1, -1}}
				},
				production_type = "output",
				pipe_picture = GreyPipes.pipeBlocksEMPlantLongGraySouth(),
				secondary_draw_orders = {north = -1, east = -1, south = 10, west = -1},
			},
		},
	},
}

return Export