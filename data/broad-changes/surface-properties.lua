-- This file adds/edits the values for surface properties (like gravity and pressure) for planets and recipes.

-- Create a new "oxygen pressure" parameter.
-- We could rename the existing one, but it seems to affect the speed of bots. They glitch out when pressure is too low. And it doesn't seem like I can make robots depend on a different property instead.
local oxygenPressure = copy(RAW["surface-property"]["pressure"])
oxygenPressure.name = "oxygen-pressure"
oxygenPressure.default_value = 0
extend{oxygenPressure}

-- Pressure will be renamed to "oxygen pressure", represents partial pressure of oxygen in hPa.
for planetName, hPa in pairs{
	nauvis = 220, -- Roughly earth-like.
	vulcanus = 20, -- Volcanic activity depletes free oxygen, atmosphere is dominated by CO2 and SO2.
	fulgora = 0, -- No oxygen. That's how the oceans can be full of hydrocarbons despite constant lightning strikes.
	aquilo = 10, -- Liquid ammonia does not favor stable free oxygen in large amounts.
	gleba = 260, -- The fungal-looking foliage does massive net photosynthesis. Paradoxical "oxygen-rich swamp" where dead biomass gets locked in permanent spoilage loops, never fully breaking down.
} do
	RAW.planet[planetName].surface_properties["oxygen-pressure"] = hPa
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
	RECIPE[recipeName].surface_conditions = nil
end

-- Search for things requiring pressure over 10hPa, and change them to require oxygen-pressure over 10hPa.
local excluded = {
	["air-separator"] = true,
}
for _, typeName in pairs{
	"recipe",
	"assembling-machine",
	"furnace",
	"mining-drill",
	"boiler",
	"reactor",
	"fluid-turret",
	"inserter",
} do
	for _, thing in pairs(RAW[typeName]) do
		if thing.surface_conditions ~= nil then
			if excluded[thing.name] ~= true then
				for _, condition in pairs(thing.surface_conditions) do
					if condition.property == "pressure" and condition.min == 10 and condition.max == nil then
						condition.property = "oxygen-pressure"
					end
				end
			end
		end
	end
end

-- Create surface property for "surface stability"
local surfaceStability = copy(RAW["surface-property"]["pressure"])
surfaceStability.name = "surface-stability"
surfaceStability.default_value = 100
extend{surfaceStability}
for planetName, stabilityPercent in pairs{
	aquilo = 5,
	vulcanus = 90,
	gleba = 95,
} do
	RAW.planet[planetName].surface_properties["surface-stability"] = stabilityPercent
end
-- Surface stability in space should be 10%.
RAW.surface["space-platform"].surface_properties["surface-stability"] = 10

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
	local ent = RAW[stabilityTypeKey[1]][stabilityTypeKey[2]]
	if ent.surface_conditions == nil then
		ent.surface_conditions = {}
	else
		ent.surface_conditions = copy(ent.surface_conditions) -- Get rid of shared conditions, so adding surface stability here doesn't mess up cars etc.
	end
	table.insert(ent.surface_conditions, {
		property = "surface-stability",
		min = 80,
	})

	-- Could also edit their recipes so they can't be crafted. Not sure if I should do that.
end


------------------------------------------------------------------------
--- Solar power.
--- I want to generally make solar infeasible on planets, so that it's only worth it on space platforms. But I don't want to make it like 50% on Nauvis surface, rather keep it at 100% on Nauvis surface and then reduce solar panel's power field. And then make it higher in space.

-- Reduce energy from solar panels, from 60kW default to 10kW.
RAW["solar-panel"]["solar-panel"].production = "10kW"

-- Update solar power in atmosphere for planets, and in space. Generally keeping it the same on the ground, since solar panels are made 6x weaker above already, and I want to keep Nauvis ground as the 100% standard. For space platforms, I'm buffing it by about 4x so it's still fairly powerful in space.
for planetName, groundAndSpace in pairs{
	vulcanus = {400, 2000}, -- Default 400, 600.
	gleba = {50, 1000}, -- Default 50, 200.
	nauvis = {100, 1200}, -- Default 100, 300.
	fulgora = {20, 5000}, -- Default 20, 120.
	aquilo = {10, 10}, -- Default 1, 60. Increasing ground 1% to 10% so it's easier to get started. Reducing space 60->10 so you need a nuclear reactor.
} do
	RAW.planet[planetName].surface_properties["solar-power"] = groundAndSpace[1]
	RAW.planet[planetName].solar_power_in_space = groundAndSpace[2]
end

------------------------------------------------------------------------
-- Hide some surface properties.

-- Magnetic field is not used.
RAW["surface-property"]["magnetic-field"].hidden = true
RAW["surface-property"]["magnetic-field"].hidden_in_factoriopedia = true