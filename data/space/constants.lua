-- This file defines space-related constants shared between multiple files.

local R = {}

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
R.beltOrientation = 0.2
R.beltLabelOrientation = 0.45
R.beltParkedPlatformsOrientation = 0.625
R.planetsOrientation = 0.15
R.planetLabelOrientation = 0.84
R.planetParkedPlatformsOrientation = 0.0
R.planetsAndBelts = {
	{
		name = "vulcanus",
		type = "planet",
		distance = sunDist + 0.5 * layerDist,
	},
	{
		name = "metallic-belt",
		type = "belt",
		distance = sunDist + 1.25 * layerDist,
		drawAsteroidBelt = {
			{1, {.322, .322, .325}}, -- greyish undertone
			{2, {.357, .180, .125}}, -- red top layer
		},
		solarPowerInSpace = 1700,
	},
	{
		name = "gleba",
		type = "planet",
		distance = sunDist + 2 * layerDist,
	},
	{
		name = "carbonic-belt",
		type = "belt",
		distance = sunDist + 3 * layerDist,
		drawAsteroidBelt = {
			{2, {.330, .322, .360}}, -- lighter grey bottom layer
			{1, {.165, .161, .180}}, -- dark top layer
		},
		solarPowerInSpace = 1300,
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
		drawAsteroidBelt = {
			{2, {.404, .549, .541, .7}}, -- light blue
		},
		solarPowerInSpace = 800,
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
		drawAsteroidBelt = {
			{1, {.404, .549, .541, .7}}, -- bottom layer ice
			{2, {.342, .322, .325}}, -- top layer greyish
		},
		solarPowerInSpace = 300,
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
		drawAsteroidBelt = {
			{2, {.733, .227, .160}}, -- brighter red bottom
			{1, {.576, .016, .059}}, -- darker red top
		},
		solarPowerInSpace = 10,
	},
	{
		name = "solar-system-edge",
		type = "belt",
		distance = sunDist + 15 * layerDist,
		solarPowerInSpace = 1,
	},
}

local planetToBeltDeltaV = 10000
local beltToBeltDeltaV = 1000
R.connectionsData = { -- Table of info about new connections between space locations that LSA creates.
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
		b = "carbonic-belt",
		length = planetToBeltDeltaV,
	},
	{
		a = "carbonic-belt",
		b = "nauvis",
		length = planetToBeltDeltaV,
	},
	{
		a = "nauvis",
		b = "ice-belt",
		length = planetToBeltDeltaV,
	},
	{
		a = "carbonic-belt",
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
		b = "carbonic-belt",
		length = beltToBeltDeltaV,
	},
	{
		a = "carbonic-belt",
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
R.connectionEdits = {
	{
		name = "solar-system-edge-shattered-planet",
		length = beltToBeltDeltaV * 25,
	},
}

return R