-- This file adjusts tree farming, adds recipes for fertilizer, etc.

local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")
local Item = require("code.util.item")

-- Move tree farming tech to early game.
data.raw.technology["fish-breeding"].prerequisites = {"agricultural-science-pack"}
data.raw.technology["tree-seeding"].prerequisites = {"ammonia-1", "sulfur-processing"}
data.raw.technology["tree-seeding"].unit = {
	count = 10,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
	},
}

-- Remove placement restrictions for agricultural tower.
data.raw["agricultural-tower"]["agricultural-tower"].surface_conditions = nil

-- Gleba needs ag tower.
Tech.addTechDependency("tree-seeding", "planet-discovery-gleba")

-- Cut out the agriculture tech on Gleba.
Tech.hideTech("agriculture")
for _, techName in pairs{"jellynut", "yumako"} do
	data.raw.technology[techName].prerequisites = {"planet-discovery-gleba"}
end

-- Nutrients-from-spoilage recipe should be only in biochambers, and then put it in biochamber tech. (It was in agriculture tech, which we're hiding.)
Tech.addRecipeToTech("nutrients-from-spoilage", "biochamber", 3)
data.raw.recipe["nutrients-from-spoilage"].category = "organic"

-- Edit results from mining the living trees. They should give seeds directly, then we add recipe for seed -> sapling using fertilizer.
-- There's a lot of different types of trees, so I'm just going to look through everything in data.raw.tree and check if it's minable is exactly 4 wood and nothing else.
---@param tree data.TreePrototype
local function isNormalTree(tree)
	return tree.minable and
		((tree.minable.results and #tree.minable.results == 1 and tree.minable.results[1].name == "wood" and tree.minable.results[1].amount == 4)
		or (tree.minable.result and tree.minable.result == "wood" and tree.minable.count == 4))
end
local function isDeadTree(tree)
	return tree.minable and
		((tree.minable.results and #tree.minable.results == 1 and tree.minable.results[1].name == "wood" and tree.minable.results[1].amount == 2)
		or (tree.minable.result and tree.minable.result == "wood" and tree.minable.count == 2))
end
local newTreeMinableResults = {
	{
		type = "item",
		name = "tree-seed",
		amount_min = 1,
		amount_max = 2,
		--extra_count_fraction = 0.05,
		-- Could make it very rarely give an extra seed, so you have to go harvest a ton of trees to set up big plantations.
	},
	{ -- Increase total wood yield, to reduce the number of trees you need to harvest to do the 1000-circuit challenge for red science.
		type = "item",
		name = "wood",
		amount = 8,
	},
	{ -- Add resin, for early fluid fittings.
		type = "item",
		name = "resin",
		amount = 1,
	},
}
local newDeadTreeMinableResults = {
	{
		type = "item",
		name = "wood",
		amount = 4,
	},
}
for _, tree in pairs(data.raw.tree) do
	if isNormalTree(tree) then
		tree.minable.results = newTreeMinableResults
	elseif isDeadTree(tree) then
		tree.minable.results = newDeadTreeMinableResults
	end
end
data.raw.plant["tree-plant"].minable.results = newTreeMinableResults

-- Create item subgroup for "early agriculture".
data:extend{
	{
		type = "item-subgroup",
		name = "early-agriculture",
		group = "intermediate-products",
		order = "gf",
	},
}
data.raw["item-subgroup"]["agriculture-processes"].order = "m2"

-- Organize agriculture row.
data.raw.item["wood"].subgroup = "early-agriculture"
data.raw.item["wood"].order = "001"
data.raw.item["tree-seed"].subgroup = "early-agriculture"
data.raw.item["tree-seed"].order = "002"

-- Create fertilizer item.
local fertilizerIcons = {}
for i = 1, 3 do
	table.insert(fertilizerIcons, {filename = "__LegendarySpaceAge__/graphics/fertilizer/fertilizer-"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local fertilizerItem = table.deepcopy(data.raw.item["wood"])
fertilizerItem.name = "fertilizer"
fertilizerItem.order = "003"
fertilizerItem.icon = nil
fertilizerItem.icons = {{icon = fertilizerIcons[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}}
fertilizerItem.pictures = fertilizerIcons
Item.clearFuel(fertilizerItem)
data:extend{fertilizerItem}

-- Create new "sapling" item.
local saplingPictures = {}
for _, i in pairs{"1", "2", "2-red", "3", "4", "5", "7", "8", "8-brown", "8-red", "9", "9-brown", "9-red"} do
	table.insert(saplingPictures, {filename = "__base__/graphics/icons/tree-0"..i..".png", size = 64, scale=0.5, mipmap_count=4})
end
local saplingItem = table.deepcopy(data.raw.item["tree-seed"])
saplingItem.name = "sapling"
saplingItem.localised_name = {"item-name.sapling"} -- Seems to be necessary, else it takes name from planted/placed thing.
saplingItem.localised_description = nil
saplingItem.subgroup = "early-agriculture"
saplingItem.order = "004"
saplingItem.spoil_ticks = 60 * 60 * 60 -- 1 hour
saplingItem.spoil_result = "wood"
Item.clearFuel(saplingItem)
saplingItem.icon = nil
saplingItem.icons = {{icon = "__base__/graphics/icons/tree-08.png", icon_size = 64, scale=0.5, mipmap_count=4}}
saplingItem.pictures = saplingPictures
data:extend{saplingItem}

-- Can no longer plant seeds directly.
data.raw.item["tree-seed"].plant_result = nil
data.raw.item["tree-seed"].place_result = nil

-- Create recipe for fertilizer.
-- Currently 1 tree -> 4 wood, and 5 wood -> 5 spoilage -> 10 ammonia. So 10 ammonia -> 2 fertilizer allows growing total number of trees.
-- And then once you get biochambers with the prod bonus, you can greatly increase wood production.
local fertilizerRecipe = table.deepcopy(data.raw.recipe["wood-processing"])
fertilizerRecipe.name = "fertilizer"
fertilizerRecipe.ingredients = {
	{type="item", name="niter", amount=1},
	{type="item", name="ash", amount=2},
	{type="fluid", name="sulfuric-acid", amount=5},
	{type="fluid", name="ammonia", amount=10},
}
fertilizerRecipe.results = {
	{type="item", name="fertilizer", amount=2},
}
fertilizerRecipe.category = "organic-or-chemistry"
fertilizerRecipe.subgroup = "early-agriculture"
fertilizerRecipe.order = "005"
fertilizerRecipe.icon = nil
fertilizerRecipe.icons = nil
fertilizerRecipe.surface_conditions = nil
fertilizerRecipe.allow_decomposition = true
data:extend{fertilizerRecipe}

-- Create recipe for saplings.
local saplingRecipe = table.deepcopy(data.raw.recipe["wood-processing"])
saplingRecipe.name = "sapling"
saplingRecipe.ingredients = {
	{type="item", name="tree-seed", amount=1},
	{type="item", name="fertilizer", amount=1},
	{type="fluid", name="water", amount=100},
}
saplingRecipe.results = {
	{type="item", name="sapling", amount=1},
}
saplingRecipe.subgroup = "early-agriculture"
saplingRecipe.category = "organic-or-assembling-with-fluid"
saplingRecipe.order = "006"
saplingRecipe.icon = nil
saplingRecipe.icons = {{icon = "__base__/graphics/icons/tree-08.png", icon_size = 64, scale=0.5, mipmap_count=4}}
saplingRecipe.surface_conditions = {{property = "pressure", min = 1000, max = 1000}}
saplingRecipe.energy_required = 30
saplingRecipe.allow_decomposition = true
data:extend{saplingRecipe}

-- Edit growth time of saplings.
data.raw.plant["tree-plant"].growth_ticks = 60 * 60 * 6 -- Originally 10 minutes.

-- Add recipes to tree-seeding tech.
data.raw.technology["tree-seeding"].effects = {
	{type = "unlock-recipe", recipe = "agricultural-tower"},
	{type = "unlock-recipe", recipe = "fertilizer"},
	{type = "unlock-recipe", recipe = "sapling"},
}

-- Hide the "wood processing" recipe. It converts wood to seeds; we're rather having trees directly yield seeds.
-- This must be after creating recipes above, or they'll inherit the hiddenness.
Recipe.hide("wood-processing")

-- TODO turn off or greatly reduce pollution absorption from trees, since you can now plant a lot from early-game.