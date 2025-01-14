-- This file adds gunpowder item and recipes.

local Table = require("code.util.table")

local newData = {}

-- Create gunpowder item.
local gunpowderPictures = {}
for i = 1, 3 do
	table.insert(gunpowderPictures, {
		filename = "__LegendarySpaceAge__/graphics/gunpowder/gunpowder-" .. i .. ".png",
		size = 64,
		scale = 0.5,
		mipmap_count = 4,
	})
end
local gunpowderItem = Table.copyAndEdit(data.raw.item["sulfur"], {
	name = "gunpowder",
	icons = {{icon = gunpowderPictures[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}},
	pictures = gunpowderPictures,
	subgroup = "ammo",
	order = "0",
	auto_recycle = false, -- Can't get sulfur/sand/carbon back.
})
table.insert(newData, gunpowderItem)

-- Create recipe for gunpowder.
-- 2 carbon + 1 sulfur + 1 sand -> 2 gunpowder
local gunpowderRecipe = Table.copyAndEdit(data.raw.recipe["firearm-magazine"], {
	name = "gunpowder",
	ingredients = {
		{type="item", name="carbon", amount=2},
		{type="item", name="sulfur", amount=1},
		{type="item", name="niter", amount=4},
	},
	results = {{type = "item", name = "gunpowder", amount = 8}},
	enabled = true,
	category = "chemistry-or-handcrafting",
})
table.insert(newData, gunpowderRecipe)

-- Adjust ammo mag recipes
-- 4 iron plate + 1 gunpowder -> 1 yellow mag
-- 1 steel plate + 4 copper plate + 1 gunpowder -> 1 red mag (represents steel core and copper jacket)
data.raw.recipe["firearm-magazine"].ingredients = {
	{type="item", name="iron-plate", amount=4},
	{type="item", name="gunpowder", amount=1},
}
data.raw.recipe["piercing-rounds-magazine"].ingredients = {
	{type="item", name="steel-plate", amount=1},
	{type="item", name="copper-plate", amount=4},
	{type="item", name="gunpowder", amount=1},
}
data.raw.recipe["shotgun-shell"].ingredients = {
	{type="item", name="steel-plate", amount=2},
	{type="item", name="copper-plate", amount=2},
	{type="item", name="gunpowder", amount=1},
}
data.raw.recipe["shotgun-shell"].results = {{type = "item", name = "shotgun-shell", amount = 2}}

data:extend(newData)