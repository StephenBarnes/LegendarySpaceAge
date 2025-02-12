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
local aquilo = RAW.planet.aquilo
RAW["autoplace-control"]["aquilo_crude_oil"].localised_name = {"", "[entity=natural-gas-well]", {"entity-name.natural-gas-well"}}
aquilo.map_gen_settings.autoplace_settings.entity.settings["natural-gas-well"] = aquilo.map_gen_settings.autoplace_settings.entity.settings["crude-oil"]
aquilo.map_gen_settings.autoplace_settings.entity.settings["crude-oil"] = nil
aquilo.map_gen_settings.property_expression_names["entity:natural-gas-well:probability"] = aquilo.map_gen_settings.property_expression_names["entity:crude-oil:probability"]
aquilo.map_gen_settings.property_expression_names["entity:natural-gas-well:richness"] = aquilo.map_gen_settings.property_expression_names["entity:crude-oil:richness"]
aquilo.map_gen_settings.property_expression_names["entity:crude-oil:probability"] = nil
aquilo.map_gen_settings.property_expression_names["entity:crude-oil:richness"] = nil