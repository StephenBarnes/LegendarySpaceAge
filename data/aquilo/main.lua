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

-- Change icon for lithium brine, which is now "mineral brine".
Icon.set(FLUID["lithium-brine"], "LSA/aquilo/mineral-brine")

-- Clear temperature spam for fluids.
Fluid.setSimpleTemp(FLUID["ammoniacal-solution"], -33, true, -50)