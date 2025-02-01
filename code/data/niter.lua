-- This file adds the niter item. Niter recipe is in ammonia file.

-- Create niter item
local niterIcons = {}
for i = 1, 3 do
	table.insert(niterIcons, {filename = "__LegendarySpaceAge__/graphics/niter/niter-"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local niterItem = table.deepcopy(data.raw.item["sulfur"])
niterItem.name = "niter"
niterItem.icon = nil
niterItem.icons = {{icon = niterIcons[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}}
niterItem.pictures = niterIcons
niterItem.order = "b[chemistry]-a"

niterItem.fuel_value = nil
niterItem.fuel_acceleration_multiplier = nil
niterItem.fuel_top_speed_multiplier = nil
niterItem.fuel_emissions_multiplier = nil
niterItem.fuel_glow_color = nil

data:extend{niterItem}