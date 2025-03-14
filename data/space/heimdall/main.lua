-- This folder creates Heimdall, moon of Nauvis.

require("data.space.heimdall.autoplace")
require("decorative-craters")
local mapGen = require("map-gen")

-- Create Heimdall, moon of Nauvis.
local heimdall = {
	name = "heimdall",
	type = "planet",
	subgroup = "planets",
	order = "05b", -- after Nauvis, before Vulcanus.
	-- Setting orbit. This is for PlanetsLib, not technically part of Planet prototype.
	orbit = {
		parent = {
			type = "planet",
			name = "nauvis",
		},
		distance = 1.5,
		orientation = 1./3.,
		sprite = {
			type = "sprite",
			filename = "__LegendarySpaceAge__/graphics/heimdall/orbit.png",
			size = 384,
			scale = .25,
		},
	},
	label_orientation = 0.05,
	parked_platforms_orientation = 0.0,
	icon = "__LegendarySpaceAge__/graphics/heimdall/icon.png",
	icon_size = 64,
	starmap_icon = "__LegendarySpaceAge__/graphics/heimdall/large.png",
	starmap_icon_size = 808,
	gravity_pull = 5, -- Seems this is 10 for all planets, except solar system edge and shattered planet, which are -10. Affects speed travelling towards or away. So setting this to 5 means that on Nauvis->Heimdall route, you travel slower and can fall back to Nauvis.
	draw_orbit = true,
	magnitude = 0.4, -- Apparent size on map.
	pollutant_type = nil,
	surface_properties = {
		["day-night-cycle"] = 3 * MINUTES, -- Seems there's no general rule for how long moons' day-night cycles are relative to planet. Since solar is the main source on Heimdall most of the time, setting this fairly short. Also note actual value seems to be 4x this.
		["magnetic-field"] = 0,
		["pressure"] = 5, -- 5 hPa, so basically no atmosphere. (Earth's moon is 3e-15 hPa.)
		["gravity"] = 1, -- Earth's moon is 1.5. Note chests have minimum 0.1, so this allows chests.
		["solar-power"] = 1200, -- Solar power: same as in space around Nauvis. LSA makes solar panels a lot weaker, so this is actually buffing them back to vanilla SA levels.
	},
	solar_power_in_space = 1200,
	platform_procession_set = {
		arrival = { "planet-to-platform-b" },
		departure = { "platform-to-planet-a" },
	},
	planet_procession_set = {
		arrival = { "platform-to-planet-b" },
		departure = { "planet-to-platform-a" },
	},
	procession_graphic_catalogue = nil,
	asteroid_spawn_influence = nil,
	asteroid_spawn_definitions = {},
	persistent_ambient_sounds = {}, -- TODO
	surface_render_parameters = {
		shadow_opacity = 0.75, -- Most planets are 0.5. Making this higher due to no atmosphere.
	},
	entities_require_heating = false,
	map_gen_settings = mapGen,
}
PlanetsLib:extend{heimdall}

-- Make space connections.
---@type data.SpaceConnectionPrototype
local heimdallNauvis = {
	type = "space-connection",
	name = "heimdall-nauvis",
	subgroup = "planet-connections",
	from = "heimdall",
	to = "nauvis",
	order = "05-2",
	length = 1000,
	asteroid_spawn_definitions = {},
}
extend{heimdallNauvis}

-- Make tech.
local tech = copy(TECH["planet-discovery-vulcanus"])
tech.name = "planet-discovery-heimdall"
tech.effects = {
	{
		type = "unlock-space-location",
		space_location = "heimdall",
		use_icon_overlay_constant = true,
	},
}
tech.icon = nil
tech.icons = {
	{
		icon = "__LegendarySpaceAge__/graphics/heimdall/tech.png",
		icon_size = 256,
	},
	{
		icon = "__core__/graphics/icons/technology/constants/constant-planet.png",
		icon_size = 128,
		scale = 0.5,
		shift = {50, 50},
		floating = true
	},
}
extend{tech}