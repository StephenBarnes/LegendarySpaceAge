--[[ This file will create sand and glass items, and recipes for them, and techs.
Stone can be crushed into sand in an assembling machine: 1 stone -> 1 sand
Sand can then be smelted to glass in a furnace or foundry: 1 sand -> 1 glass
]]

local Table = require("code.util.table")
local Tech = require("code.util.tech")

local newData = {}

-- Create sand item.
local sandIcons = {}
for i = 1, 3 do
	table.insert(sandIcons, {filename = "__LegendarySpaceAge__/graphics/sand/sand-"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local sandItem = Table.copyAndEdit(data.raw.item["stone"], {
	name = "sand",
	icon = "nil",
	icons = {{icon = sandIcons[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}},
	pictures = sandIcons,
	subgroup = "raw-material",
	order = "a2",
})
table.insert(newData, sandItem)

-- Create glass item.
local glassIcons = {}
for i = 1, 6 do
	table.insert(glassIcons, {filename = "__LegendarySpaceAge__/graphics/glass/glass-"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local glassItem = Table.copyAndEdit(data.raw.item["iron-plate"], {
	name = "glass",
	icon = "nil",
	icons = {{icon = glassIcons[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}},
	pictures = glassIcons,
	subgroup = "raw-material",
	order = "a3",
})
table.insert(newData, glassItem)

-- Create recipe for stone -> sand.
local sandRecipe = Table.copyAndEdit(data.raw.recipe["iron-gear-wheel"], {
	name = "sand",
	ingredients = {{type="item", name="stone", amount=1}},
	results = {{type="item", name="sand", amount=1}},
	category = "crafting",
	subgroup = "raw-material",
	enabled = true,
})
table.insert(newData, sandRecipe)

-- Create recipe for sand -> glass.
local glassRecipe = Table.copyAndEdit(data.raw.recipe["iron-plate"], {
	name = "glass",
	ingredients = {{type="item", name="sand", amount=1}},
	results = {{type="item", name="glass", amount=1}},
	category = "smelting-or-metallurgy",
	subgroup = "raw-material",
	enabled = false,
	energy_required = 2,
})
table.insert(newData, glassRecipe)

-- Create tech for glass
local glassTech = Table.copyAndEdit(data.raw.technology["logistics"], {
	name = "glass",
	effects = {
		{
			type = "unlock-recipe",
			recipe = "glass",
		},
	},
	prerequisites = {},
	unit = "nil",
	research_trigger = {
		type = "craft-item",
		item = "sand",
		count = 10,
	},
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/glass/tech.png", icon_size = 256, scale=0.5, mipmap_count = 4}},
})
table.insert(newData, glassTech)

-- TODO Make the sand->glass recipe allowed in foundries.

data:extend(newData)