-- This file creates 4 asteroid belts, and creates space routes, and rearranges the planets so it all makes sense.

local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

--[[ Define table of info on asteroid belts and planets.
Fields:
	name: name of the space-location or planet.
	type: "belt" or "planet". This determines orientation.
	distance: distance from sun, chosen to be in specific order. By default Vulcanus is 10, Aquilo is 35.
NOTE I'm not adjusting Charon here, rather set it in the separate file for Charon, loaded after this one.
TODO asteroid definitions, later.
]]
local sunDist = 5.0 -- Base distance from sun.
local layerDist = 4.0 -- Distance between planets and adjacent asteroid belts, etc, except around the end where distances get bigger.
local beltOrientation = 0.2
local beltLabelOrientation = 0.45
local planetsOrientation = 0.15
local planetLabelOrientation = 0.84
local allData = {
	{
		name = "vulcanus",
		type = "planet",
		distance = sunDist + 0.5 * layerDist,
	},
	{
		name = "metallic-belt",
		type = "belt",
		distance = sunDist + 1.25 * layerDist,
	},
	{
		name = "gleba",
		type = "planet",
		distance = sunDist + 2 * layerDist,
	},
	{
		name = "carbon-belt",
		type = "belt",
		distance = sunDist + 3 * layerDist,
	},
	{
		name = "nauvis",
		type = "planet",
		distance = sunDist + 4 * layerDist,
	},
	{
		name = "ice-belt",
		type = "belt",
		distance = sunDist + 5 * layerDist,
	},
	{
		name = "fulgora",
		type = "planet",
		distance = sunDist + 6 * layerDist,
	},
	{
		name = "belt-of-aquilo",
		type = "belt",
		distance = sunDist + 8 * layerDist,
	},
	{
		name = "aquilo",
		type = "planet",
		distance = sunDist + 10 * layerDist,
	},
	{
		name = "shattered-planet",
		type = "belt",
		distance = sunDist + 12 * layerDist,
	},
	{
		name = "solar-system-edge",
		type = "belt",
		distance = sunDist + 15 * layerDist,
	},
}

local function editBelt(vals)
	local belt = RAW["space-location"][vals.name]
	assert(belt ~= nil, "Belt " .. vals.name .. " not found.")
	belt.distance = vals.distance
	belt.orientation = beltOrientation
	belt.label_orientation = beltLabelOrientation
	belt.solar_power_in_space = 1200 -- TODO separate for each belt.
	belt.draw_orbit = false
end

local function editPlanet(vals)
	local loc = PLANET[vals.name]
	assert(loc ~= nil, "Planet " .. vals.name .. " not found.")
	loc.distance = vals.distance
	loc.orientation = planetsOrientation
	loc.label_orientation = planetLabelOrientation
	if vals.drawOrbit ~= nil then
		loc.draw_orbit = vals.drawOrbit
	end
end

for i, vals in pairs(allData) do
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

local planetToBeltDeltaV = 10000
local beltToBeltDeltaV = 1000
local connectionsData = {
	-- Planet-to-belt-to-planet links.
	{
		a = "vulcanus",
		b = "metallic-belt",
		length = planetToBeltDeltaV,
	},
	{
		a = "metallic-belt",
		b = "gleba",
		length = planetToBeltDeltaV,
	},
	{
		a = "gleba",
		b = "carbon-belt",
		length = planetToBeltDeltaV,
	},
	{
		a = "carbon-belt",
		b = "nauvis",
		length = planetToBeltDeltaV,
	},
	{
		a = "nauvis",
		b = "ice-belt",
		length = planetToBeltDeltaV,
	},
	{
		a = "carbon-belt",
		b = "charon",
		length = planetToBeltDeltaV,
	},
	{
		a = "charon",
		b = "ice-belt",
		length = planetToBeltDeltaV,
	},
	{
		a = "ice-belt",
		b = "fulgora",
		length = planetToBeltDeltaV,
	},
	{
		a = "fulgora",
		b = "belt-of-aquilo",
		length = planetToBeltDeltaV,
	},
	{
		a = "belt-of-aquilo",
		b = "aquilo",
		length = planetToBeltDeltaV * 2,
	},
	{
		a = "aquilo",
		b = "shattered-planet",
		length = planetToBeltDeltaV * 2,
	},
	-- Belt-to-belt links.
	{
		a = "metallic-belt",
		b = "carbon-belt",
		length = beltToBeltDeltaV,
	},
	{
		a = "carbon-belt",
		b = "ice-belt",
		length = beltToBeltDeltaV,
	},
	{
		a = "ice-belt",
		b = "belt-of-aquilo",
		length = beltToBeltDeltaV * 2,
	},
	{
		a = "belt-of-aquilo",
		b = "shattered-planet",
		length = beltToBeltDeltaV * 20,
	},
}
local connectionEdits = {
	{
		name = "solar-system-edge-shattered-planet",
		length = beltToBeltDeltaV * 25,
	},
}
for i, vals in pairs(connectionsData) do
	local conn = {
		type = "space-connection",
		name = vals.a .. "-" .. vals.b,
		subgroup = "planet-connections",
		from = vals.a,
		to = vals.b,
		length = vals.length,
		order = string.format("%02d", i),
		asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_fulgora), -- TODO
	}
	extend{conn}
end
for _, vals in pairs(connectionEdits) do
	local conn = RAW["space-connection"][vals.name]
	assert(conn ~= nil, "Connection " .. vals.name .. " not found.")
	conn.length = vals.length
end