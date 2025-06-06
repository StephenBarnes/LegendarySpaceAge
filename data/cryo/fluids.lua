-- This file creates cryogenic fluids - nitrogen/oxygen/hydrogen gases and liquids.

local noh = {
	-- Base/flow colors for oxygen/hydrogen taken from Space Age. Nitrogen colors chosen by analogy.
	["nitrogen-gas"] = {
		baseColor = {.1, .53, 0},
		flowColor = {.68, .93, .2},
		boilsAt = -196,
	},
	["oxygen-gas"] = {
		baseColor = {0.0, 0.1, 0.53},
		flowColor = {0.2, 0.68, 0.93},
		boilsAt = -183,
	},
	["hydrogen-gas"] = {
		baseColor = {0.53, 0.1, 0},
		flowColor = {0.93, 0.68, 0.2},
		boilsAt = -253,
	},
	["carbon-dioxide"] = {
		baseColor = {.31, .31, .31},
		flowColor = {.153, .153, .153},
		boilsAt = -78,
	},
}

-- Create gases.
for name, data in pairs(noh) do
	local gas = copy(FLUID.fluorine)
	gas.name = name
	gas.auto_barrel = true
	Icon.set(gas, "LSA/cryo/" .. name)
	gas.base_color = data.baseColor
	gas.flow_color = data.flowColor
	Fluid.setSimpleTemp(gas, data.boilsAt, false, 10)
	extend{gas}
end

-- Create compressed nitrogen gas.
local cn = copy(FLUID["nitrogen-gas"])
cn.name = "compressed-nitrogen-gas"
cn.auto_barrel = true
Icon.set(cn, "LSA/cryo/compressed-nitrogen-gas")
extend{cn}

-- Create liquid nitrogen.
local liquidNitrogen = copy(FLUID["fluoroketone-cold"])
liquidNitrogen.name = "liquid-nitrogen"
liquidNitrogen.auto_barrel = true
Icon.set(liquidNitrogen, "LSA/cryo/liquid-nitrogen")
liquidNitrogen.base_color = {.1, .53, 0}
liquidNitrogen.flow_color = {.68, .93, .2}
Fluid.setSimpleTemp(liquidNitrogen, noh["nitrogen-gas"].boilsAt, true, 10)
extend{liquidNitrogen}

-- Set temps for liquid O/H.
Fluid.setSimpleTemp(FLUID["thruster-oxidizer"], noh["oxygen-gas"].boilsAt, true, 10)
Fluid.setSimpleTemp(FLUID["thruster-fuel"], noh["hydrogen-gas"].boilsAt, true, 10)

-- Edit thruster fuel and oxidizer (which we're renaming to liquid hydrogen and oxygen respectively) to use new icons.
Icon.set(FLUID["thruster-fuel"], "LSA/cryo/liquid-hydrogen")
Icon.set(FLUID["thruster-oxidizer"], "LSA/cryo/liquid-oxygen")