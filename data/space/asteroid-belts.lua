--[[ This file creates the asteroid belts.
This file runs before arrange-space-map.lua, which positions all the belts. So here we don't worry about position and orientation, just create the belts and set graphics etc.
]]

local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local C = require("data.space.constants")

for _, vals in pairs(C.planetsAndBelts) do
	if vals.type == "belt" and vals.shouldCreateBeltLocation then
		assert(RAW["space-location"][vals.name] == nil, "Belt " .. vals.name .. " already exists.")
		belt = {
			name = vals.name,
			type = "space-location",

			gravity_pull = 0, -- This is 10 for all planets, except solar system edge and shattered planet, which are -10. Affects speed travelling towards or away. So setting this to 0 means that on planet->belt route, you travel slower and can fall back to the planet.
			draw_orbit = false,
			magnitude = vals.iconMagnitude or 1.2, -- Apparent size on map.

			asteroid_spawn_influence = 1, -- TODO
			asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.aquilo_solar_system_edge, 0.9), -- TODO
			persistent_ambient_sounds = {}, -- TODO?
			surface_render_parameters = {
				shadow_opacity = 0.8, -- Most planets are 0.5. Making this higher due to no atmosphere.
			},

			icon = "__LegendarySpaceAge__/graphics/asteroid-belts/" .. vals.beltGraphicsKey .. "-icon.png",
			icon_size = 64,
			starmap_icon = "__LegendarySpaceAge__/graphics/asteroid-belts/" .. vals.beltGraphicsKey .. "-large.png",
			starmap_icon_size = 512,
		}
		extend{belt}
	end
end

-- Add belt of Aquilo to tech that unlocks Aquilo.
table.insert( TECH["planet-discovery-aquilo"].effects, {
	type = "unlock-space-location",
	space_location = "belt-of-aquilo",
	use_icon_overlay_constant = true,
})