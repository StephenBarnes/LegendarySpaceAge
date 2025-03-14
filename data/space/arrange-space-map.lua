-- This file creates arranges positions and orientations for planets and belt nodes, and creates space routes between them.

local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local C = require("data.space.constants")

local function editBelt(vals)
	local belt = RAW["space-location"][vals.name]
	assert(belt ~= nil, "Belt " .. vals.name .. " not found.")
	belt.distance = vals.distance
	belt.orientation = C.beltOrientation
	belt.label_orientation = C.beltLabelOrientation
	assert(vals.solarPowerInSpace ~= nil, "Belt " .. vals.name .. " has no solar power in space.")
	belt.solar_power_in_space = vals.solarPowerInSpace
	belt.draw_orbit = false
	belt.parked_platforms_orientation = C.beltParkedPlatformsOrientation
	belt.order = vals.order
	if vals.iconMagnitude ~= nil then
		belt.magnitude = vals.iconMagnitude
	end
	belt.asteroid_spawn_definitions = vals.asteroid_spawn_definitions
	belt.asteroid_spawn_influence = vals.asteroid_spawn_influence
end

local function editPlanet(vals)
	local loc = PLANET[vals.name]
	assert(loc ~= nil, "Planet " .. vals.name .. " not found.")
	loc.distance = vals.distance
	loc.orientation = C.planetsOrientation
	loc.label_orientation = C.planetLabelOrientation
	loc.parked_platforms_orientation = C.planetParkedPlatformsOrientation
	if vals.drawOrbit ~= nil then
		loc.draw_orbit = vals.drawOrbit
	end
	loc.order = vals.order
	if vals.iconMagnitude ~= nil then
		loc.magnitude = vals.iconMagnitude
	end
	loc.asteroid_spawn_definitions = vals.asteroid_spawn_definitions -- This is always nil, currently.
	loc.asteroid_spawn_influence = vals.asteroid_spawn_influence -- This is always nil, currently. Default is 0.1.
end

for i, vals in pairs(C.planetsAndBelts) do
	vals.order = string.format("%02d", i)
	if vals.type == "belt" then
		editBelt(vals)
	elseif vals.type == "planet" then
		editPlanet(vals)
	else
		assert(false, "Unknown type " .. vals.type)
	end
end

------------------------------------------------------------------------
--- SPACE CONNECTIONS.

local connectionsToHide = {
	"vulcanus-gleba",
	"gleba-fulgora",
	"gleba-aquilo",
	"fulgora-aquilo",
	"nauvis-fulgora",
	"nauvis-gleba",
	"nauvis-vulcanus",
	"aquilo-solar-system-edge",
}
for _, name in pairs(connectionsToHide) do
	local conn = RAW["space-connection"][name]
	assert(conn ~= nil, "Connection " .. name .. " not found.")
	-- conn.hidden = true -- Just hiding doesn't work, they still show up in the starmap.
	RAW["space-connection"][name] = nil
end

for i, vals in pairs(C.connectionsData) do
	local conn = {
		type = "space-connection",
		name = vals.a .. "-" .. vals.b,
		subgroup = "planet-connections",
		from = vals.a,
		to = vals.b,
		length = vals.length,
		order = string.format("%02d", i),
		--asteroid_spawn_definitions = nil,
	}
	extend{conn}
end
for _, vals in pairs(C.connectionEdits) do
	local conn = RAW["space-connection"][vals.name]
	assert(conn ~= nil, "Connection " .. vals.name .. " not found.")
	conn.length = vals.length
	conn.from = vals.a
	conn.to = vals.b
	conn.asteroid_spawn_definitions = vals.asteroid_spawn_definitions
end