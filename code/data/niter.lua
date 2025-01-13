-- This file adds the niter item. Niter recipe is in ammonia file.

local Table = require("code.util.table")

-- Create niter item
local niterIcons = {}
for i = 1, 3 do
	table.insert(niterIcons, {filename = "__LegendarySpaceAge__/graphics/niter/niter-"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local niterItem = Table.copyAndEdit(data.raw.item["sulfur"], {
	name = "niter",
	icon = "nil",
	icons = {{icon = niterIcons[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}},
	pictures = niterIcons,
	order = "b[chemistry]-a",

	fuel_value = "nil",
	fuel_acceleration_multiplier = "nil",
	fuel_top_speed_multiplier = "nil",
	fuel_emissions_multiplier = "nil",
	fuel_glow_color = "nil",
})
data:extend{niterItem}