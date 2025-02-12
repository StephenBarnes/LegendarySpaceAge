-- This file defines constants used in various places.

local Export = {}

-- The fuel values were chosen so that the relative numbers are realistic, meaning things that are better for burning in the real world should have higher fuel value, so that the player is encouraged to use fuels that are realistic (e.g. "rich gas" / propane over crude oil).
Export.fluidFuelValues = { -- Maps from fluid name to fuel value, pollution multiplier, vehicle acceleration mult, vehicle top-speed mult, and fuel category of barrels/tanks if they're usable as fuel, else nil.
	["crude-oil"] = {"400kJ", 2, .7, .7, "chemical"},
	["heavy-oil"] = {"500kJ", 2.5, .7, .7, "chemical"},
	["light-oil"] = {"700kJ", 1.5, .9, .9, "chemical"},
	["petroleum-gas"] = {"900kJ", .9, .9, .9, "chemical"},
	["dry-gas"] = {"800kJ", .7, .7, .7, "chemical"},
	["natural-gas"] = {"800kJ", 1.2, .8, .8, "chemical"},
	["syngas"] = {"400kJ", 1.5, .5, .5, "chemical"},
	["tar"] = {"200kJ", 3, .5, .5, "chemical"},
	["thruster-fuel"] = {"50kJ", 0, .5, .5, "non-carbon"}, -- Hydrogen
	["thruster-oxidizer"] = {nil, nil, nil, nil, nil}, -- Oxygen. Originally 50kJ, setting it to zero, seems there's no issue doing that, thrusters still work. Don't want oxygen to be usable as fuel in fluid fuelled boilers etc.
	["geoplasm"] = {"100kJ", 1, .5, .5, "chemical"},
	["diesel"] = {"1MJ", 1, 2, 1.15, "chemical"},
		-- Each unit of diesel is 1 light oil + 0.5 rich gas = 700kJ + 450kJ = 1150kJ. I want to allow burning it anywhere carbon fuel is allowed. So, let's make it 1000kJ and set max productivity to 20%.
		-- Re vehicle stats: base game has rocket fuel 1.8 and 1.15, nuclear fuel 2.5 and 1.15. So using 2 and 1.15 here.
}

Export.itemFuelValues = { -- Maps from fluid name to fuel value, pollution multiplier, vehicle acceleration mult, vehicle top-speed mult, fuel category, whether it should produce ash, and type name.
	["sulfur"] = {"3MJ", 8, .5, .5, "non-carbon", false, "item"},

	["pitch"] = {"3MJ", 2.5, .5, .5, "chemical", false, "item"},
	["resin"] = {"1MJ", 2, .5, .5, "chemical", false, "item"},

	["solid-fuel"] = {"12MJ", 2, .8, .8, "chemical", false, "item"},

	["carbon"] = {"2MJ", .6, .7, .7, "pure-carbon", false, "item"},

	["coal"] = {"4MJ", 1, .5, .5, "chemical", true, "item"},
	["wood"] = {"2MJ", 1, .4, .4, "chemical", true, "item"},
	["tree-seed"] = {"100kJ", 1, .4, .4, "chemical", true, "item"},

	["spoilage"] = {"250kJ", 1, .4, .4, "chemical", true, "item"},
	["yumako-seed"] = {"4MJ", 1, .4, .4, "chemical", true, "item"},
	["jellynut-seed"] = {"4MJ", 1, .4, .4, "chemical", true, "item"},

	["yumako"] = {"2MJ", 1, .4, .4, "chemical", true, "capsule"},
	["jellynut"] = {"10MJ", 1, .4, .4, "chemical", true, "capsule"},
	["yumako-mash"] = {"1MJ", 1, .4, .4, "chemical", true, "capsule"},
	["jelly"] = {"1MJ", 1, .4, .4, "chemical", true, "capsule"},

	["neurofibril"] = {"2MJ", 1, .7, .7, "chemical", true, "item"},

	["pentapod-egg"] = {"5MJ", 2, .4, .4, "chemical", true, "item"},
	["activated-pentapod-egg"] = {"5MJ", 2, .4, .4, "activated-pentapod-egg", true, "item"},
	["biter-egg"] = {"6MJ", 1, .4, .4, "biter-egg", true, "item"},
}

-- TODO check again later that all fuel items/fluids are here.

return Export