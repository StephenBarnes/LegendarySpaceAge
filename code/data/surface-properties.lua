-- This file adds/edits the values for surface properties (like gravity and pressure) for planets and recipes.

-- Pressure will be renamed to "oxygen pressure", represents partial pressure of oxygen in hPa.
for planetName, hPa in pairs{
	nauvis = 220, -- Roughly earth-like.
	vulcanus = 20, -- Volcanic activity depletes free oxygen, atmosphere is dominated by CO2 and SO2.
	fulgora = 0, -- No oxygen. That's why the oceans are full of hydrocarbons.	
	aquilo = 10, -- Liquid ammonia does not favor stable free oxygen in large amounts.
	gleba = 260, -- The fungal-looking foliage does massive net photosynthesis. Paradoxical "oxygen-rich swamp" where dead biomass gets locked in permanent spoilage loops, never fully breaking down.
} do
	data.raw.planet[planetName].surface_properties.pressure = hPa
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

-- Search for things requiring specific pressure (because they're meant to be only on one planet) and change condition to use new oxygen-pressure.
local pressureChanges = {
	[1000] = 220, -- Nauvis
	[2000] = 260, -- Gleba
	[4000] = 20, -- Vulcanus
	[300] = 10, -- Aquilo
}
local function getNewPressure(conditions)
	if (conditions ~= nil
		and #conditions == 1
		and conditions[1].property == "pressure"
		and conditions[1].min == conditions[1].max) then
			return pressureChanges[conditions[1].min]
	end
end
for _, typeName in pairs{
	"recipe",
	"assembling-machine",
	"furnace",
	"plant", -- Trees.
} do
	for _, thing in pairs(data.raw[typeName]) do
		local newPressure = getNewPressure(thing.surface_conditions)
		if newPressure ~= nil then
			thing.surface_conditions = {{property = "pressure", min = newPressure, max = newPressure}}
		end
	end
end