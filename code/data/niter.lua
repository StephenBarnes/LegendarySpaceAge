-- This file adds the niter item. Niter recipe is in ammonia file.

local Item = require("code.util.item")

-- Create niter item
local niterIcons = {}
for i = 1, 3 do
	table.insert(niterIcons, {filename = "__LegendarySpaceAge__/graphics/niter/niter-"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local niterItem = table.deepcopy(ITEM["sulfur"])
niterItem.name = "niter"
niterItem.icon = nil
niterItem.icons = {{icon = niterIcons[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}}
niterItem.pictures = niterIcons
niterItem.order = "b[chemistry]-a"
Item.clearFuel(niterItem)
data:extend{niterItem}