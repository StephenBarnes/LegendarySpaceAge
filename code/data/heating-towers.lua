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
			pipe_picture = assembler3pipepictures(),
			pipe_covers = pipecoverspictures(),
			pipe_connections = {
				{flow_direction = "input-output", position = {1, 0}, direction = defines.direction.east},
				{flow_direction = "input-output", position = {-1, 0}, direction = defines.direction.west},
			},
			secondary_draw_orders = draworders,
			hide_connection_info = false,
		},
		burns_fluid = true,
		scale_fluid_usage = true,
		smoke = towerEnt.energy_source.smoke,
		light_flicker = towerEnt.energy_source.light_flicker,
	},
	icon = "nil",
	icons = {
		{icon = "__space-age__/graphics/icons/heating-tower.png", icon_size = 64, scale = 0.5, shift = {2, 0}},
		{icon = data.raw.fluid["petroleum-gas"].icons[1].icon, icon_size = 64, scale = 0.3, shift = {-5, 6}, tint = data.raw.fluid["petroleum-gas"].icons[1].tint},
	},
})
fluidHeatingTowerEnt.minable.result = "fluid-heating-tower"
-- Adjust heat pipes, since I want the fluid pipes to be where the side heat pipes used to be.
fluidHeatingTowerEnt.heat_buffer.connections = {
	---@diagnostic disable-next-line: assign-type-mismatch
	{position = {0, -1}, direction = defines.direction.north},
	---@diagnostic disable-next-line: assign-type-mismatch
	{position = {1, -1}, direction = defines.direction.east},
	---@diagnostic disable-next-line: assign-type-mismatch
	{position = {0, 1}, direction = defines.direction.south},
	---@diagnostic disable-next-line: assign-type-mismatch
	{position = {-1, -1}, direction = defines.direction.west},
}
table.insert(newData, fluidHeatingTowerEnt)

-- Create item for fluid heating tower
local fluidHeatingTowerItem = Table.copyAndEdit(data.raw.item["heating-tower"], {
	name = "fluid-heating-tower",
	place_result = "fluid-heating-tower",
	icons = fluidHeatingTowerEnt.icons,
	order = data.raw.item["heating-tower"].order .. "-2",
})
table.insert(newData, fluidHeatingTowerItem)

-- Create recipe for fluid heating tower
local fluidHeatingTowerRecipe = Table.copyAndEdit(data.raw.recipe["heating-tower"], {
	name = "fluid-heating-tower",
	results = {{type = "item", name = "fluid-heating-tower", amount = 1}},
})
table.insert(newData, fluidHeatingTowerRecipe)

data:extend(newData)

-- Add heating tower unlock to heating tower tech
Tech.addRecipeToTech("fluid-heating-tower", "heating-tower", 2)