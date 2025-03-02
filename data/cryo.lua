-- This file creates cryogenic fluids and recipes - nitrogen/oxygen/hydrogen gases and liquids.

local noh = {
	-- Base/flow colors for oxygen/hydrogen taken from Space Age. Nitrogen colors chosen by analogy.
	nitrogen = {
		baseColor = {.1, .53, 0},
		flowColor = {.68, .93, .2},
		boilsAt = -196,
	},
	oxygen = {
		baseColor = {0.0, 0.1, 0.53},
		flowColor = {0.2, 0.68, 0.93},
		boilsAt = -183,
	},
	hydrogen = {
		baseColor = {0.53, 0.1, 0},
		flowColor = {0.93, 0.68, 0.2},
		boilsAt = -253,
	},
}

-- Create gases.
for name, data in pairs(noh) do
	local gas = copy(FLUID.fluorine)
	gas.name = name .. "-gas"
	gas.auto_barrel = true
	Icon.set(gas, "LSA/cryo/" .. name .. "-gas")
	gas.base_color = data.baseColor
	gas.flow_color = data.flowColor
	Item.setFluidSimpleTemp(gas, data.boilsAt, false, 10)
	extend{gas}
end

-- Create compressed nitrogen gas.
local cn = copy(FLUID["nitrogen-gas"])
cn.name = "compressed-nitrogen-gas"
cn.auto_barrel = true
Icon.set(cn, {"nitrogen-gas", "LSA/cryo/compressed"})
cn.icons = {
	{icon = "__LegendarySpaceAge__/graphics/cryo/nitrogen-gas.png", icon_size = 64},
	{icon = "__LegendarySpaceAge__/graphics/cryo/compressed.png", icon_size = 64},
}
extend{cn}

-- Create liquid nitrogen.
local liquidNitrogen = copy(FLUID["fluoroketone-cold"])
liquidNitrogen.name = "liquid-nitrogen"
liquidNitrogen.auto_barrel = true
Icon.set(liquidNitrogen, "LSA/cryo/liquid-nitrogen")
liquidNitrogen.base_color = {.1, .53, 0}
liquidNitrogen.flow_color = {.68, .93, .2}
Item.setFluidSimpleTemp(liquidNitrogen, noh.nitrogen.boilsAt, true, 10)
extend{liquidNitrogen}

-- Set temps for liquid O/H.
Item.setFluidSimpleTemp(FLUID["thruster-oxidizer"], noh.oxygen.boilsAt, true, 10)
Item.setFluidSimpleTemp(FLUID["thruster-fuel"], noh.hydrogen.boilsAt, true, 10)

-- Edit thruster fuel and oxidizer (which we're renaming to liquid hydrogen and oxygen respectively) to use new icons.
Icon.set(FLUID["thruster-fuel"], "LSA/cryo/liquid-hydrogen")
Icon.set(FLUID["thruster-oxidizer"], "LSA/cryo/liquid-oxygen")

-- TODO create recipes.