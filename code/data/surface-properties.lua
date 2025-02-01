-- This file adds/edits the values for surface properties (like gravity and pressure) for planets and recipes.

-- Create a new "oxygen pressure" parameter.
-- We could rename the existing one, but it seems to affect the speed of bots. They glitch out when pressure is too low. And it doesn't seem like I can make robots depend on a different property instead.
local oxygenPressure = table.deepcopy(data.raw["surface-property"]["pressure"])
oxygenPressure.name = "oxygen-pressure"
oxygenPressure.default_value = 0
data:extend{oxygenPressure}

-- Pressure will be renamed to "oxygen pressure", represents partial pressure of oxygen in hPa.
for planetName, hPa in pairs{
	nauvis = 220, -- Roughly earth-like.
	vulcanus = 20, -- Volcanic activity depletes free oxygen, atmosphere is dominated by CO2 and SO2.
	fulgora = 0, -- No oxygen. That's how the oceans can be full of hydrocarbons despite constant lightning strikes.
	aquilo = 10, -- Liquid ammonia does not favor stable free oxygen in large amounts.
	gleba = 260, -- The fungal-looking foliage does massive net photosynthesis. Paradoxical "oxygen-rich swamp" where dead biomass gets locked in permanent spoilage loops, never fully breaking down.
} do
	data.raw.planet[planetName].surface_properties["oxygen-pressure"] = hPa
end

-- Remove crafting conditions for some entities.
-- TODO after setting all infra recipes, check that all of these recipes still need planet-specific ingredients; if they don't, consider whether you're okay with them being craftable on any planet without imports.
for _, recipeName in pairs{
	"electromagnetic-plant",
	"biochamber",
	"cryogenic-plant",
	"recycler",
	"foundry",
	"big-mining-drill",
	"lightning-rod",
	"lightning-collector",
	"fusion-reactor",
	"fusion-generator",
	"turbo-transport-belt",
	"turbo-underground-belt",
	"turbo-splitter",
	"fish-breeding",
} do
	data.raw.recipe[recipeName].surface_conditions = nil
end

-- Aquilo should have less solar power in space, so you need a nuclear reactor.
data.raw.planet.aquilo.solar_power_in_space = .05 -- Changed 60% -> 5%.

-- Search for things requiring pressure over 10hPa, and change them to require oxygen-pressure over 10hPa.
for _, typeName in pairs{
	"recipe",
	"assembling-machine",
	"furnace",
	"mining-drill",
	"boiler",
	"reactor"
} do
	for _, thing in pairs(data.raw[typeName]) do
		if thing.surface_conditions ~= nil then
			for _, condition in pairs(thing.surface_conditions) do
				if condition.property == "pressure" and condition.min == 10 and condition.max == nil then
					condition.property = "oxygen-pressure"
				end
			end
		end
	end
end

-- Create surface property for "surface stability"
local surfaceStability = table.deepcopy(data.raw["surface-property"]["pressure"])
surfaceStability.name = "surface-stability"
surfaceStability.default_value = 100
data:extend{surfaceStability}
for planetName, stabilityPercent in pairs{
	aquilo = 5,
	vulcanus = 90,
	gleba = 95,
} do
	data.raw.planet[planetName].surface_properties["surface-stability"] = stabilityPercent
end
-- Surface stability in space should be 10%.
data.raw.surface["space-platform"].surface_properties["surface-stability"] = 10

-- Make rail only buildable where surface stability at least 80%.
-- Seems it's copying or sharing surface conditions between all rail types, so adding it to each of them will actually add the same condition many times.
-- Also it's being shared with cars and tanks, which I don't want.
for _, stabilityTypeKey in pairs{
	{"straight-rail", "straight-rail"},
	{"elevated-straight-rail", "elevated-straight-rail"},

	{"curved-rail-a", "curved-rail-a"},
	{"curved-rail-b", "curved-rail-b"},
	{"elevated-curved-rail-a", "elevated-curved-rail-a"},
	{"elevated-curved-rail-b", "elevated-curved-rail-b"},

	{"half-diagonal-rail", "half-diagonal-rail"},
	{"elevated-half-diagonal-rail", "elevated-half-diagonal-rail"},

	{"rail-ramp", "rail-ramp"},
	{"rail-support", "rail-support"},

	{"legacy-straight-rail", "legacy-straight-rail"},
	{"legacy-curved-rail", "legacy-curved-rail"},

	{"train-stop", "train-stop"},
	{"rail-signal", "rail-signal"},
	{"rail-chain-signal", "rail-chain-signal"},
	{"locomotive", "locomotive"},
	{"cargo-wagon", "cargo-wagon"},
	{"artillery-wagon", "artillery-wagon"},
} do
	local ent = data.raw[stabilityTypeKey[1]][stabilityTypeKey[2]]
	if ent.surface_conditions == nil then
		ent.surface_conditions = {}
	else
		ent.surface_conditions = table.deepcopy(ent.surface_conditions) -- Get rid of shared conditions, so adding surface stability here doesn't mess up cars etc.
	end
	table.insert(ent.surface_conditions, {
		property = "surface-stability",
		min = 80,
	})
end

-- Update solar power in atmosphere for planets. Generally reducing it to make solar power less OP on planets. Still leaving it powerful for space platforms.
for planetName, solarInAtmosphere in pairs{
	vulcanus = 200, -- 400 to 200
	gleba = 25, -- 50 to 25
	nauvis = 50, -- 100 to 50
	fulgora = 10, -- 20 to 10
	aquilo = 2, -- Increasing 1% to 2% so it's a bit easier to get started.
} do
	data.raw.planet[planetName].surface_properties["solar-power"] = solarInAtmosphere
end