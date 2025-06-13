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
		util.sprite_load("__LegendarySpaceAge__/graphics/misc/heating-tower-shadow-no-heat-pipes", {
			scale = 0.5,
			draw_as_shadow = true,
		}),
	},
}
--ent.heat_buffer.max_transfer = "10MW" -- Default 10GW.
ent.consumption = "10MW" -- Default 40MW.
ent.heat_buffer.connections = {
	{
		position = {0, 0},
		direction = NORTH,
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
ent.heating_radius = 1.5 + HEATING_RADIUS

-- Change heat pipes to have much greater heating radius.
--RAW["heat-pipe"]["heat-pipe"].heating_radius = 1.5 + HEATING_RADIUS
-- Not necessary, since reactor has heating radius.


-- TODO could also create an invisible beacon, so it's highlighted when placing entities.