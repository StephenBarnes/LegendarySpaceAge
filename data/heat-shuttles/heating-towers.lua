--[[ This file adjusts heating towers.
LSA removes heat pipes, and repurposes heating towers to be only for heating buildings on Aquilo.
So we leave one heat pipe segment in the middle of the tower, and give it a big heating radius.
Also we change it to consume heat shuttles, instead of burning fuel.
]]

local HEATING_RADIUS = 10 -- How far out from the heating tower actually gets heated.

local ent = RAW.reactor["heating-tower"]
ent.energy_source = {
	type = "burner",
	fuel_categories = {"heat-provider"},
	emissions_per_minute = {},
	effectivity = 5,
	fuel_inventory_size = 2,
	burnt_inventory_size = 2,
	burner_usage = "heat-provider",
	light_flicker = {
		color = {0,0,0},
		minimum_intensity = 0.7,
		maximum_intensity = 0.95,
	},
}
ent.picture = {
	layers = {
		util.sprite_load("__space-age__/graphics/entity/heating-tower/heating-tower-main", {
			scale = 0.5,
		}),
		{
			filename = "__LegendarySpaceAge__/graphics/misc/heating-tower-shadow-no-heat-pipes.png",
			width = 312,
			height = 130,
			scale = 0.5,
			draw_as_shadow = true,
			shift = util.by_pixel(29.0, 19.0),
			line_length = 1,
		},
	},
}
--ent.heat_buffer.max_transfer = "10MW" -- Default 10GW.
ent.consumption = "10MW" -- Default 40MW.
ent.heat_buffer.connections = {
	{
		position = {0, 0},
		direction = NORTH,
		hidden = true,
	},
}
ent.connection_patches_connected = nil
ent.connection_patches_disconnected = nil
ent.heat_connection_patches_connected = nil
ent.heat_connection_patches_disconnected = nil
ent.radius_visualisation_specification = {
	sprite = {
		filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
		priority = "extra-high-no-scale",
		width = 10,
		height = 10,
	},
	distance = 1.5 + HEATING_RADIUS,
}
ent.heating_radius = HEATING_RADIUS -- This counts from outer edge of tower, not from center tile, unlike the radius_visualisation_specification above.

-- Create an invisible beacon, so the heating tower is highlighted when placing entities.
---@type data.BeaconPrototype
local heatBeacon = {
	type = "beacon",
	name = "heating-tower-beacon",
	icon = ent.icon,
	icon_size = ent.icon_size,
	icons = ent.icons,
	hidden = false,
	hidden_in_factoriopedia = true,
	distribution_effectivity = 1,
	energy_usage = "1W",
	energy_source = {type="void"},
	module_slots = 0,
	supply_area_distance = 1 + HEATING_RADIUS, -- Must be an integer.
	radius_visualisation_specification = ent.radius_visualisation_specification,
	flags = {"player-creation", "not-blueprintable", "not-repairable", "no-copy-paste", "hide-alt-info", "not-flammable", "not-selectable-in-game"},
	collision_mask = {layers={}},
	beacon_counter = "same_type",
	tile_height = 1,
	tile_width = 1,
}
extend{heatBeacon}