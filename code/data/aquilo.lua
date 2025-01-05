--[[
local mineralDustItem = table.deepcopy(data.raw.item.stone)
mineralDustItem.name = "mineral-dust"
mineralDustItem.order = (mineralDustItem.order or "") .. "-b"
data:extend({mineralDustItem})
]]