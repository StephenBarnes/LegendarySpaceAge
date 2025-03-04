--[[ This file edits the recycler machine.
Note edits to basic stats and recipe are in infra/2-production/assemblers.lua.
]]

local recycler = FURNACE["recycler"]

-- Add a fluid output.
assert(recycler.fluid_boxes == nil, "Recycler already has fluid boxes")
local PIPE_PICTURES = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures
recycler.fluid_boxes = {
	{
		production_type = "output",
		pipe_covers = pipecoverspictures(),
		pipe_picture = PIPE_PICTURES,
		secondary_draw_orders = {north=-1, west=-1, south=1, east=-1},
		filter = "sulfuric-acid",
		pipe_connections = {
			{
				flow_direction = "input-output",
				direction = WEST,
				position = {-.5, .5},
			},
			{
				flow_direction = "input-output",
				direction = EAST,
				position = {.5, .5},
			},
		},
		volume = 200,
	},
}

-- Add more output slots. Default was 12.
recycler.result_inventory_size = 20