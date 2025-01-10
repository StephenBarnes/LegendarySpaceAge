-- This file will unlock the heating tower early, and create the fluid heating tower. Also handle existing heating-tower tech on Gleba.
-- TODO

local Table = require("code.util.table")
local Tech = require("code.util.tech")

local newData = {}

-- Create entity for fluid heating tower
local towerEnt = data.raw.reactor["heating-tower"]
---@type data.ReactorPrototype
local fluidHeatingTowerEnt = Table.copyAndEdit(data.raw.reactor["heating-tower"], {
	name = "fluid-heating-tower",
	placeable_by = {item = "fluid-heating-tower", count = 1},
	energy_source = {
		type = "fluid",
		emissions_per_minute = towerEnt.energy_source.emissions_per_minute,
		fluid_box = {
			base_area = 1,
			height = 1,
			volume = 200,
			pipe_picture = furnacepipepictures,
			pipe_covers = pipecoverspictures(),
			pipe_connections = {
				{flow_direction = "input-output", position = {0, -1}, direction = defines.direction.north},
				{flow_direction = "input-output", position = {0, 1}, direction = defines.direction.south},
			},
			secondary_draw_orders = draworders,
			hide_connection_info = false,
		},
		burns_fluid = true,
		scale_fluid_usage = true,
		smoke = towerEnt.energy_source.smoke,
		light_flicker = towerEnt.energy_source.light_flicker,
	},
})
fluidHeatingTowerEnt.minable.result = "fluid-heating-tower"
-- Erase heat pipe connections to the north/south, since we're rather using fluid connections there.
for _, tables in pairs{
	{fluidHeatingTowerEnt.heat_buffer, "connections"},
	--{fluidHeatingTowerEnt, "heat_connection_patches_connected"},
	--{fluidHeatingTowerEnt, "heat_connection_patches_disconnected"},
	--{fluidHeatingTowerEnt, "connection_patches_connected"},
	--{fluidHeatingTowerEnt, "connection_patches_disconnected"},
} do
	log("ERROR "..serpent.block(tables[2]))
	local parent = tables[1]
	local list = parent[tables[2]]
	log("BEFORE "..serpent.block(parent[tables[2]]))
	parent[tables[2]] = {list[2], list[4]}
	log("AFTER "..serpent.block(parent[tables[2]]))
end
table.insert(newData, fluidHeatingTowerEnt)

-- Create item for fluid heating tower
local fluidHeatingTowerItem = Table.copyAndEdit(data.raw.item["heating-tower"], {
	name = "fluid-heating-tower",
	place_result = "fluid-heating-tower",
})
table.insert(newData, fluidHeatingTowerItem)

-- Create recipe for fluid heating tower
local fluidHeatingTowerRecipe = Table.copyAndEdit(data.raw.recipe["heating-tower"], {
	name = "fluid-heating-tower",
	results = {{type = "item", name = "fluid-heating-tower", amount = 1}},
	enabled = true, -- TODO
})
table.insert(newData, fluidHeatingTowerRecipe)

data:extend(newData)

-- Add heating tower unlock to heating tower tech
-- TODO