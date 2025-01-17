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