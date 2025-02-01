--[[ This file will create sand and glass items, and recipes for them, and techs.
Stone can be crushed into sand in an assembling machine: 1 stone -> 1 sand
Sand can then be smelted to glass in a furnace or foundry: 1 sand -> 1 glass
]]

-- Create sand item.
local sandIcons = {}
for i = 1, 3 do
	table.insert(sandIcons, {filename = "__LegendarySpaceAge__/graphics/sand/sand-"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local sandItem = table.deepcopy(data.raw.item["stone"])
sandItem.name = "sand"
sandItem.icon = nil
sandItem.icons = {{icon = sandIcons[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}}
sandItem.pictures = sandIcons
sandItem.subgroup = "raw-material"
sandItem.order = "a2"
sandItem.stack_size = 100 -- Increase 50->100 vs stone and ores. So it makes sense to crush stone before shipping.
data:extend{sandItem}

-- Create glass item.
local glassIcons = {}
for i = 1, 6 do
	table.insert(glassIcons, {filename = "__LegendarySpaceAge__/graphics/glass/glass-"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local glassItem = table.deepcopy(data.raw.item["iron-plate"])
glassItem.name = "glass"
glassItem.icon = nil
glassItem.icons = {{icon = glassIcons[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}}
glassItem.pictures = glassIcons
glassItem.subgroup = "raw-material"
glassItem.order = "a3"
data:extend{glassItem}

-- Create recipe for stone -> sand.
local sandRecipe = table.deepcopy(data.raw.recipe["iron-gear-wheel"])
sandRecipe.name = "sand"
sandRecipe.ingredients = {{type="item", name="stone", amount=1}}
sandRecipe.results = {{type="item", name="sand", amount=1}}
sandRecipe.category = "crafting"
sandRecipe.subgroup = "raw-material"
sandRecipe.enabled = true
sandRecipe.allow_decomposition = true
sandRecipe.allow_as_intermediate = true
sandRecipe.main_product = "sand"
data:extend{sandRecipe}

-- Create recipe for sand -> glass.
local glassRecipe = table.deepcopy(data.raw.recipe["iron-plate"])
glassRecipe.name = "glass"
glassRecipe.ingredients = {{type="item", name="sand", amount=1}}
glassRecipe.results = {{type="item", name="glass", amount=1}}
glassRecipe.category = "smelting-or-metallurgy"
glassRecipe.subgroup = "raw-material"
glassRecipe.enabled = false
glassRecipe.energy_required = 2
glassRecipe.allow_decomposition = true
glassRecipe.allow_as_intermediate = true
glassRecipe.main_product = "glass"
data:extend{glassRecipe}

-- Create tech for glass
local glassTech = table.deepcopy(data.raw.technology["logistics"])
glassTech.name = "glass"
glassTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "glass",
	},
}
glassTech.prerequisites = {}
glassTech.unit = nil
glassTech.research_trigger = {
	type = "craft-item",
	item = "sand",
	count = 1,
}
glassTech.icon = nil
glassTech.icons = {{icon = "__LegendarySpaceAge__/graphics/glass/tech.png", icon_size = 256, scale=0.5, mipmap_count = 4}}
glassTech.order = "001"
data:extend{glassTech}