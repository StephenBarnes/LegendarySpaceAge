-- This file defines constants used in various places.

local Export = {}

-- The fuel values were chosen so that the relative numbers are realistic, meaning things that are better for burning in the real world should have higher fuel value, so that the player is encouraged to use fuels that are realistic (e.g. "rich gas" / propane over crude oil).
Export.fluidFuelValues = { -- Maps from fluid name to fuel value, pollution multiplier, vehicle acceleration mult, vehicle top-speed mult, and fuel category of barrels/tanks if they're usable as fuel, else nil.
	["crude-oil"] = {"400kJ", 2, .7, .7, "chemical"},
	["heavy-oil"] = {"500kJ", 2.5, .7, .7, "chemical"},
	["light-oil"] = {"700kJ", 1.5, 1, 1, "chemical"},
	["petroleum-gas"] = {"900kJ", 0.9, 1, 1, "chemical"},
	["dry-gas"] = {"800kJ", 0.7, .7, .7, "chemical"},
	["natural-gas"] = {"800kJ", 1.2, .8, .8, "chemical"},
	["syngas"] = {"400kJ", 1.5, .5, .5, "chemical"},
	["tar"] = {"200kJ", 3, .5, .5, "chemical"},
	["thruster-fuel"] = {"50kJ", 0, .5, .5, "non-carbon"}, -- Hydrogen
	["thruster-oxidizer"] = {nil, nil, nil, nil, nil}, -- Oxygen. Originally 50kJ, setting it to zero, seems there's no issue doing that, thrusters still work. Don't want oxygen to be usable as fuel in fluid fuelled boilers etc.
}
Export.itemFuelValues = { -- Maps from fluid name to fuel value, pollution multiplier, vehicle acceleration mult, vehicle top-speed mult, and fuel category.
	["sulfur"] = {"3MJ", 8, .5, .5, "non-carbon"},
	["solid-fuel"] = {"12MJ", 2, .8, .8, "chemical"},
	["pitch"] = {"3MJ", 2.5, .5, .5, "chemical"},
	["resin"] = {"1MJ", 2, .5, .5, "chemical"},
	["rocket-fuel"] = {"25MJ", .8, 1.8, 1.15, "chemical"}, -- Each one is 25 light oil, 12 rich gas, so that suggests 30MJ. Vanilla is 100MJ.
	["carbon"] = {"2MJ", .6, .7, .7, "chemical"},
	["wood"] = {"2MJ", 1.2, .4, .4, "chemical"},
	["coal"] = {"4MJ", 1.4, .5, .5, "chemical"},
	-- TODO really we should do all the other fuels in the game, eg seeds, so they also have bad vehicle stats.
}

return Export