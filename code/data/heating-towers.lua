-- This file will unlock the heating tower early, and create the fluid heating tower. Also handle existing heating-tower tech on Gleba.

local Tech = require("code.util.tech")
local greyPipes = require("code.data.util.grey-pipes")

-- Create entity for fluid heating tower
local towerEnt = data.raw.reactor["heating-tower"]
---@type data.ReactorPrototype
local fluidHeatingTowerEnt = table.deepcopy(data.raw.reactor["heating-tower"])
fluidHeatingTowerEnt.name = "fluid-heating-tower"
fluidHeatingTowerEnt.subgroup = "environmental-protection"
fluidHeatingTowerEnt.placeable_by = {item = "fluid-heating-tower", count = 1}
fluidHeatingTowerEnt.minable.result = "fluid-heating-tower"
fluidHeatingTowerEnt.energy_source = {
	type = "fluid",
	emissions_per_minute = towerEnt.energy_source.emissions_per_minute,
	fluid_box = {
		base_area = 1,
		height = 1,
		volume = 200,
		pipe_picture = greyPipes.pipeBlocks(),
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
}
fluidHeatingTowerEnt.icon = nil
fluidHeatingTowerEnt.icons = {
	{icon = "__space-age__/graphics/icons/heating-tower.png", icon_size = 64, scale = 0.5, shift = {2, 0}},
	{icon = data.raw.fluid["petroleum-gas"].icons[1].icon, icon_size = 64, scale = 0.3, shift = {-5, 6}, tint = data.raw.fluid["petroleum-gas"].icons[1].tint},
}
fluidHeatingTowerEnt.hidden_in_factoriopedia = false
-- Adjust heat pipes, since I want the fluid pipes to be where the side heat pipes used to be.
fluidHeatingTowerEnt.heat_buffer.connections = {
	{position = {0, -1}, direction = defines.direction.north},
	{position = {1, -1}, direction = defines.direction.east},
	{position = {0, 1}, direction = defines.direction.south},
	{position = {-1, -1}, direction = defines.direction.west},
}
data:extend{fluidHeatingTowerEnt}

local fluidHeatingTowerItem = table.deepcopy(data.raw.item["heating-tower"])
fluidHeatingTowerItem.name = "fluid-heating-tower"
fluidHeatingTowerItem.place_result = "fluid-heating-tower"
fluidHeatingTowerItem.icons = fluidHeatingTowerEnt.icons
fluidHeatingTowerItem.order = data.raw.item["heating-tower"].order .. "-2"
data:extend{fluidHeatingTowerItem}

-- Create recipe for fluid heating tower
local fluidHeatingTowerRecipe = table.deepcopy(data.raw.recipe["heating-tower"])
fluidHeatingTowerRecipe.name = "fluid-heating-tower"
fluidHeatingTowerRecipe.results = {{type = "item", name = "fluid-heating-tower", amount = 1}}
data:extend{fluidHeatingTowerRecipe}

Tech.addRecipeToTech("fluid-heating-tower", "heating-tower")