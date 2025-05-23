-- This file will unlock the heating tower early, and create the fluid heating tower. Also handle existing heating-tower tech on Gleba.

local towerEnt = RAW.reactor["heating-tower"]

-- Create entity for fluid heating tower
---@type data.ReactorPrototype
local fluidHeatingTowerEnt = copy(towerEnt)
fluidHeatingTowerEnt.name = "fluid-heating-tower"
fluidHeatingTowerEnt.placeable_by = {item = "fluid-heating-tower", count = 1}
fluidHeatingTowerEnt.minable.result = "fluid-heating-tower"
fluidHeatingTowerEnt.energy_source = {
	type = "fluid",
	emissions_per_minute = towerEnt.energy_source.emissions_per_minute,
	fluid_box = {
		base_area = 1,
		height = 1,
		volume = 200,
		pipe_picture = GreyPipes.pipeBlocks(),
		pipe_covers = pipecoverspictures(),
		pipe_connections = {
			{flow_direction = "input-output", position = {1, 0}, direction = EAST},
			{flow_direction = "input-output", position = {-1, 0}, direction = WEST},
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
	{icon = FLUID["petroleum-gas"].icons[1].icon, icon_size = 64, scale = 0.3, shift = {-5, 6}, tint = FLUID["petroleum-gas"].icons[1].tint},
}
fluidHeatingTowerEnt.hidden_in_factoriopedia = false
-- Adjust heat pipes, since I want the fluid pipes to be where the side heat pipes used to be.
fluidHeatingTowerEnt.heat_buffer.connections = {
	{position = {0, -1}, direction = NORTH},
	{position = {1, -1}, direction = EAST},
	{position = {0, 1}, direction = SOUTH},
	{position = {-1, -1}, direction = WEST},
}
extend{fluidHeatingTowerEnt}

local fluidHeatingTowerItem = copy(ITEM["heating-tower"])
fluidHeatingTowerItem.name = "fluid-heating-tower"
fluidHeatingTowerItem.place_result = "fluid-heating-tower"
fluidHeatingTowerItem.icons = fluidHeatingTowerEnt.icons
extend{fluidHeatingTowerItem}

-- Create recipe for fluid heating tower
local fluidHeatingTowerRecipe = copy(RECIPE["heating-tower"])
fluidHeatingTowerRecipe.name = "fluid-heating-tower"
fluidHeatingTowerRecipe.results = {{type = "item", name = "fluid-heating-tower", amount = 1}}
extend{fluidHeatingTowerRecipe}
Tech.addRecipeToTech("fluid-heating-tower", "heating-tower", 2)