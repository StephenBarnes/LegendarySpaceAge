-- This file creates cryogenic fluids and recipes - nitrogen/oxygen/hydrogen gases and liquids.

local noh = {
	nitrogen = {
		tint = {.243, .835, .322, .35},
	},
	oxygen = {
		tint = {.118, .776, .937, .35},
	},
	hydrogen = {
		tint = {.988, .376, .063, .35},
	},
}

-- Create gases.
for name, data in pairs(noh) do
	local gas = copy(FLUID.fluorine)
	gas.name = name .. "-gas"
	gas.auto_barrel = true
	gas.icon = nil
	gas.icons = {
		{icon = "__LegendarySpaceAge__/graphics/fluids/vapor.png", icon_size = 64, tint = data.tint, scale = .5},
	}
	-- TODO fluid flow colors.
	-- TODO temperature to make it a gas.
	extend{gas}
end

-- Create compressed nitrogen gas.
local cn = copy(FLUID["nitrogen-gas"])
cn.name = "compressed-nitrogen-gas"
cn.auto_barrel = true
cn.icons[2] = cn.icons[1]
cn.icons[2].scale = .35
cn.icons[1] = {
	icon = "__LegendarySpaceAge__/graphics/cryo/compressed.png",
	icon_size = 64,
	scale = .5,
}
extend{cn}

-- Create liquid nitrogen.
local liquidNitrogen = copy(FLUID["fluoroketone-cold"])
liquidNitrogen.name = "liquid-nitrogen"
liquidNitrogen.auto_barrel = true
Icon.set(liquidNitrogen, "LSA/cryo/liquid-nitrogen")
-- TODO fluid flow colors.
-- TODO temperature to make it a liquid.
extend{liquidNitrogen}

-- Edit thruster fuel and oxidizer to use liquid hydrogen/oxygen icons.
Icon.set(FLUID["thruster-fuel"], "LSA/cryo/liquid-hydrogen")
Icon.set(FLUID["thruster-oxidizer"], "LSA/cryo/liquid-oxygen")

-- TODO create recipes.