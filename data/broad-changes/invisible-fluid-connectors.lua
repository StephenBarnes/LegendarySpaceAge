--[[ Create entities to provide fluids, or to automatically vent fluids.
This is used to supply air to furnaces on Nauvis/Gleba, and to automatically vent gases from stone furnaces.
]]

local HIDE_PIPES = true
local ALLOW_INSPECTING_PIPES = false
local HIDE_INVISIBLE_FLUID_PORTS = true
local ALLOW_SELECTING_INVISIBLE_FLUID_PORTS = false

-- Create invisible entity to supply air.
-- TODO this should be moved out of stone-furnace.lua
local boundingBox = {{-.1, -.1}, {.1, .1}}
local pos = {0, 0}
---@type data.InfinityPipePrototype
local airSupplier = {
	name = "invisible-infinity-pipe",
	type = "infinity-pipe",
	gui_mode = Gen.ifThenElse(ALLOW_INSPECTING_PIPES, "all", "none"),
	fluid_box = {
		production_type = "output",
		volume = 1000,
		hide_connection_visualization = HIDE_PIPES,
		pipe_connections = {
			{ direction = NORTH, position = pos, hide_connection_visualization = HIDE_PIPES, connection_type = "linked", linked_connection_id = 1 },
			{ direction = EAST, position = pos, hide_connection_visualization = HIDE_PIPES, connection_type = "linked", linked_connection_id = 2 },
			{ direction = SOUTH, position = pos, hide_connection_visualization = HIDE_PIPES, connection_type = "linked", linked_connection_id = 3 },
			{ direction = WEST, position = pos, hide_connection_visualization = HIDE_PIPES, connection_type = "linked", linked_connection_id = 4 },
			-- Here, connection_type = "linked" means it can only be connected by script, so won't connect to other pipes on the side of the entity.
		},
	},
	hidden = HIDE_INVISIBLE_FLUID_PORTS,
	hidden_in_factoriopedia = true,
	horizontal_window_bounding_box = boundingBox,
	vertical_window_bounding_box = boundingBox,
	collision_box = boundingBox,
	selection_box = boundingBox,
	selectable_in_game = ALLOW_SELECTING_INVISIBLE_FLUID_PORTS,
	collision_mask = {layers={}},
	flags = {"hide-alt-info", "not-rotatable", "not-blueprintable", "not-deconstructable", "not-flammable", "not-repairable", "not-on-map"},
}
airSupplier.icon = RAW.pipe.pipe.icon
extend{airSupplier}
-- TODO hide icon.
-- TODO make immune to attacks, mining, explosions.