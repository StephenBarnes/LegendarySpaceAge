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
} do
	data.raw.recipe[recipeName].surface_conditions = nil
end

-- Could allow spidertron construction on space platforms. But rather not, that seems like cheese.

-- Aquilo should have less solar power in space, so you need a nuclear reactor.
data.raw.planet.aquilo.solar_power_in_space = .05 -- Changed 60% -> 5%.