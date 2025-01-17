--[[
local mineralDustItem = table.deepcopy(data.raw.item.stone)
mineralDustItem.name = "mineral-dust"
mineralDustItem.order = (mineralDustItem.order or "") .. "-b"
data:extend({mineralDustItem})
]]

-- Add heating energy to offshore pump and waste pump.
data.raw["offshore-pump"]["offshore-pump"].heating_energy = "50kW"
data.raw.furnace["waste-pump"].heating_energy = "50kW"