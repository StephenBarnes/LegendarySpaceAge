--[[ This file defines all ventable gases and liquids, with pollution mults and whether they're only ventable in space.
Maps fluid name => {emissions, is liquid}
Emissions is pollution per 100*60 fluid units for gas venting, or reduced for waste pumping. Also see misc-const.lua.
	This is because we specify pollution per minute as 1, and each vent recipe takes 1 second.
If it's liquid, then it's ventable by waste pump, or by gas-vent in space.
These numbers are also used for stone furnaces that automatically vent their waste gases.
]]

---@type table<string, {[1]: number, [2]: boolean}>
return {
	-- Gases - ventable anywhere.
	["steam"] = {0, false},
	["natural-gas"] = {2, false},
	["petroleum-gas"] = {3, false},
	["dry-gas"] = {4, false},
	["syngas"] = {5, false},
	["ammonia"] = {10, false},
	["volcanic-gas"] = {10, false},
	["spore-gas"] = {20, false},
	["fluorine"] = {30, false},
	["compressed-nitrogen-gas"] = {0, false},
	["nitrogen-gas"] = {0, false},
	["oxygen-gas"] = {0, false},
	["hydrogen-gas"] = {0, false},
	["air"] = {0, false},
	["flue-gas"] = {3, false},
	["sulfurous-gas"] = {4, false},
	["silicon-gas"] = {10, false},
	["silicon-waste-gas"] = {10, false},

	-- Liquids - only gas-ventable in space (no pollution), and only pump-ventable on planets.
	["thruster-fuel"] = {0, true}, -- hydrogen
	["thruster-oxidizer"] = {0, true}, -- oxygen
	["liquid-nitrogen"] = {0, true},
	["water"] = {0, true},
	["lake-water"] = {0, true},
	["lava"] = {0, true},
	["sulfuric-acid"] = {20, true},
	["crude-oil"] = {20, true},
	["tar"] = {30, true},
	["heavy-oil"] = {25, true},
	["light-oil"] = {15, true},
	["diesel"] = {20, true},
	["cement"] = {2, true},
	["latex"] = {2, true},
	["lubricant"] = {20, true},
	["fulgoran-sludge"] = {0, true},
	["slime"] = {0, true},
	["geoplasm"] = {5, true},
	["chitin-broth"] = {1, true},
	["molten-iron"] = {20, true},
	["molten-copper"] = {20, true},
	["molten-steel"] = {20, true},
	["molten-tungsten"] = {20, true},
	["holmium-solution"] = {10, true},
	["electrolyte"] = {0, true},
	["lithium-brine"] = {0, true},
	["fluoroketone-hot"] = {0, true}, -- TODO remove this later, will replace fluoroketone with refrigerant and liquid nitrogen
	["fluoroketone-cold"] = {0, true}, -- TODO remove this later, will replace fluoroketone with refrigerant and liquid nitrogen
	["ammoniacal-solution"] = {2, true},

	-- TODO check that all fluids are included here.
}