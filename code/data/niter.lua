--[[ This file adds niter - item, tech, recipes.
TODO
]]

local Table = require("code.util.table")
local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

local newData = {}

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
})
table.insert(newData, niterItem)

------------------------------------------------------------------------
data:extend(newData)