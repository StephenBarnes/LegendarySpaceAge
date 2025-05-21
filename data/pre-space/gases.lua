-- This file creates fluids for some gases.

-- Create "air" fluid, for Earth-like breathable air - nitrogen, oxygen, trace carbon dioxide.
local airFluid = copy(FLUID["steam"])
airFluid.name = "air"
Fluid.setSimpleTemp(airFluid, -150, false)
Icon.set(airFluid, "LSA/fluids/air")
extend{airFluid}

-- Create "air or oxygen" fluid, for recipes that can use either air or oxygen.
local airOrOxygenFluid = copy(FLUID["steam"])
airOrOxygenFluid.name = "air-or-oxygen"
Fluid.setSimpleTemp(airOrOxygenFluid, -150, false)
Icon.set(airOrOxygenFluid, "LSA/fluids/air-or-oxygen")
extend{airOrOxygenFluid}

-- Create "sulfurous gas" fluid, for mixture of sulfur dioxide and flue gas, produced by smelting sulfate ores or from volcanic fumaroles.
-- TODO move the colours out to a const file.
local sulfurousGasColor = {0.788, 0.627, 0.167}
local brighterSulfurousGasColor = {0.996, 0.859, 0.31}
local sulfurousGasFluid = copy(FLUID["steam"])
sulfurousGasFluid.name = "sulfurous-gas"
Fluid.setSimpleTemp(sulfurousGasFluid, 200, false)
Icon.set(sulfurousGasFluid, "LSA/fluids/sulfurous-gas")
sulfurousGasFluid.base_color = sulfurousGasColor
sulfurousGasFluid.flow_color = brighterSulfurousGasColor
sulfurousGasFluid.visualization_color = sulfurousGasColor
sulfurousGasFluid.icon = nil
sulfurousGasFluid.icons = {
	{icon = "__LegendarySpaceAge__/graphics/fluids/gas-2.png", icon_size = 64, tint = brighterSulfurousGasColor},
}
extend{sulfurousGasFluid}

-- TODO create flue gas
-- TODO create oxygen/nitrogen/hydrogen gases
-- TODO create coke oven gas
-- TODO create fuel gas