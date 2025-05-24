-- This file creates fluids for some gases.

-- Create "air" fluid, for Earth-like breathable air - nitrogen, oxygen, trace carbon dioxide.
local airColor = {.8, .85, .85}
local brighterAirColor = {.95, 1, 1}
local airFluid = copy(FLUID["steam"])
airFluid.name = "air"
Fluid.setSimpleTemp(airFluid, -150, false)
airFluid.factoriopedia_description = {"factoriopedia-description.air"}
airFluid.base_color = airColor
airFluid.flow_color = brighterAirColor
airFluid.visualization_color = airColor
airFluid.icon = nil
airFluid.icons = {
	{icon = "__LegendarySpaceAge__/graphics/fluids/vent-gas.png", icon_size = 64, tint = brighterAirColor},
}
extend{airFluid}

-- Create "sulfurous gas" fluid, for mixture of sulfur dioxide and flue gas, produced by smelting sulfide ores.
-- TODO move the colours out to a const file.
local sulfurousGasColor = {0.788, 0.627, 0.167}
local brighterSulfurousGasColor = {0.996, 0.859, 0.31}
local sulfurousGasFluid = copy(FLUID["steam"])
sulfurousGasFluid.name = "sulfurous-gas"
Fluid.setSimpleTemp(sulfurousGasFluid, 200, false)
sulfurousGasFluid.base_color = sulfurousGasColor
sulfurousGasFluid.flow_color = brighterSulfurousGasColor
sulfurousGasFluid.visualization_color = sulfurousGasColor
sulfurousGasFluid.icon = nil
sulfurousGasFluid.icons = {
	{icon = "__LegendarySpaceAge__/graphics/fluids/vent-gas.png", icon_size = 64, tint = sulfurousGasColor},
}
sulfurousGasFluid.factoriopedia_description = {"factoriopedia-description.sulfurous-gas"}
extend{sulfurousGasFluid}

-- Create "flue gas" fluid, for result of combustion in air.
local flueGasColor = {.375, .375, .375}
local brighterFlueGasColor = {.5, .5, .5}
local flueGasFluid = copy(FLUID["steam"])
flueGasFluid.name = "flue-gas"
Fluid.setSimpleTemp(flueGasFluid, 200, false)
flueGasFluid.base_color = flueGasColor
flueGasFluid.flow_color = brighterFlueGasColor
flueGasFluid.visualization_color = flueGasColor
flueGasFluid.icon = nil
flueGasFluid.icons = {
	{icon = "__LegendarySpaceAge__/graphics/fluids/vent-gas.png", icon_size = 64, tint = flueGasColor},
}
flueGasFluid.factoriopedia_description = {"factoriopedia-description.flue-gas"}
extend{flueGasFluid}

-- TODO move oxygen/nitrogen/hydrogen gases to this file.
-- TODO create coke gas
-- TODO create fuel gas