--[[ This file defines stuff related to barrelling.
Namely:
* Which fluids use gas tanks, vs barrels.
* Fluids that use multi-color barrels.
]]

-- TODO look through fluids, maybe make more of them auto_barrel.
--TODO: Maybe add more different tankType options: barrels, gas tanks, glass tanks (for fluoric acid), tungsten canisters (for lava), maybe a special tank for heat shuttles like molten salt and steam/water?

return {
	["steam"] = {
		autoBarrel = true, -- In the real world, seems it's hard to do without constant heating and some amount of condensation.
			-- TODO actually rather allow placing in gas tanks, but unbarrelling gives back some water and some steam.
		tankType = "gas-tank",
	},
	["holmium-solution"] = {
		autoBarrel = false,
	},
	["electrolyte"] = {
		autoBarrel = true,
	},
	["thruster-oxidizer"] = {
		autoBarrel = true,
		tankType = "gas-tank",
	},
	["thruster-fuel"] = {
		autoBarrel = true,
		tankType = "gas-tank",
	},
	["ammonia"] = {
		autoBarrel = true,
		tankType = "gas-tank",
	},
	["fluorine"] = {
		autoBarrel = true,
			-- It's not that hard to barrel and transport IRL, so I'll allow it.
		tankType = "gas-tank",
	},
	["fluoric-acid"] = {
		autoBarrel = true,
		tankType = "gas-tank",
	},
	["hydrofluoric-acid"] = { -- TODO remove
		autoBarrel = true,
		tankType = "gas-tank",
	},
	["lithium-brine"] = {
		autoBarrel = true,
	},
	["fulgoran-sludge"] = {
		autoBarrel = true,
		-- Could be interesting to ship it around and filter it elsewhere.
	},
	["slime"] = {
		autoBarrel = true,
	},
	["petroleum-gas"] = {
		tankType = "gas-tank",
	},
	["spore-gas"] = {
		tankType = "gas-tank",
	},
	["dry-gas"] = {
		tankType = "gas-tank",
	},
	["natural-gas"] = {
		tankType = "gas-tank",
	},
	["syngas"] = {
		tankType = "gas-tank",
	},
	["liquid-nitrogen"] = {
		tankType = "gas-tank",
	},
	["nitrogen-gas"] = {
		tankType = "gas-tank",
	},
	["compressed-nitrogen-gas"] = {
		tankType = "gas-tank",
	},
	["oxygen-gas"] = {
		tankType = "gas-tank",
	},
	["hydrogen-gas"] = {
		tankType = "gas-tank",
	},
	["chlorine-gas"] = {
		tankType = "gas-tank",
	},
	["sulfur-dioxide"] = {
		tankType = "gas-tank",
	},
	["nox-gas"] = {
		tankType = "gas-tank",
	},
	["fluorine-gas"] = {
		tankType = "gas-tank",
	},
	["phosphine-gas"] = {
		tankType = "gas-tank",
	},
	["raw-seawater"] = {
		autoBarrel = true,
	},
	["clean-seawater"] = {
		autoBarrel = true,
	},
	["rich-brine"] = {
		autoBarrel = true,
	},
	["bitterns"] = {
		autoBarrel = true,
	},
	["mudwater"] = {
		autoBarrel = true,
	},
}

