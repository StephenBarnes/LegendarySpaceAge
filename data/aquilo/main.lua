--[[
local mineralDustItem = copy(ITEM.stone)
mineralDustItem.name = "mineral-dust"
mineralDustItem.order = (mineralDustItem.order or "") .. "-b"
extend({mineralDustItem})
]]

-- Add heating energy to offshore pump and waste pump.
RAW["offshore-pump"]["offshore-pump"].heating_energy = "50kW"

-- Change autoplace control for Aquilo crude oil to one for natural gas wells.
-- Leaving it with the same prototype name, so we don't need to disturb the autoplace expressions. Rather just change the autoplace control's name and rewire it to control natgas instead of oil wells.
local mapGen = RAW.planet.aquilo.map_gen_settings
assert(mapGen ~= nil)
RAW["autoplace-control"]["aquilo_crude_oil"].localised_name = {"", "[entity=natural-gas-well]", {"entity-name.natural-gas-well"}}
mapGen.autoplace_settings.entity.settings["natural-gas-well"] = mapGen.autoplace_settings.entity.settings["crude-oil"]
mapGen.autoplace_settings.entity.settings["crude-oil"] = nil
mapGen.property_expression_names["entity:natural-gas-well:probability"] = mapGen.property_expression_names["entity:crude-oil:probability"]
mapGen.property_expression_names["entity:natural-gas-well:richness"] = mapGen.property_expression_names["entity:crude-oil:richness"]
mapGen.property_expression_names["entity:crude-oil:probability"] = nil
mapGen.property_expression_names["entity:crude-oil:richness"] = nil

-- Create refrigerant fluid.
local refrigerant = copy(FLUID["fluoroketone-cold"])
refrigerant.name = "refrigerant"
refrigerant.auto_barrel = true
Icon.set(refrigerant, "LSA/aquilo/refrigerant")
-- TODO fluid flow colors.
-- TODO temperature to make it a gas.
extend{refrigerant}

-- Change icon for lithium brine, which is now "mineral brine".
Icon.set(FLUID["lithium-brine"], "LSA/aquilo/mineral-brine")

-- Create fluid for liquid nitrogen.
local liquidNitrogen = copy(FLUID["fluoroketone-cold"])
liquidNitrogen.name = "liquid-nitrogen"
liquidNitrogen.auto_barrel = true
Icon.set(liquidNitrogen, "LSA/aquilo/liquid-nitrogen")
-- TODO fluid flow colors.
-- TODO temperature to make it a liquid.
extend{liquidNitrogen}

-- Create fluid for nitrogen gas.
local nitrogenGas = copy(FLUID["fluoroketone-cold"])
nitrogenGas.name = "nitrogen-gas"
nitrogenGas.auto_barrel = true
Icon.set(nitrogenGas, "LSA/aquilo/nitrogen-gas")
-- TODO fluid flow colors.
-- TODO temperature to make it a gas.
extend{nitrogenGas}