-- This file adjusts tree farming, adds recipes for fertilizer, etc.

-- Move tree farming tech to early game.
TECH["fish-breeding"].prerequisites = {"agricultural-science-pack"}
TECH["tree-seeding"].prerequisites = {"ammonia-1", "sulfur-processing"}
TECH["tree-seeding"].unit = {
	count = 10,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
	},
}

-- Remove placement restrictions for agricultural tower.
RAW["agricultural-tower"]["agricultural-tower"].surface_conditions = nil

-- Gleba needs ag tower.
Tech.addTechDependency("tree-seeding", "planet-discovery-gleba")

-- Cut out the agriculture tech on Gleba.
Tech.hideTech("agriculture")
for _, techName in pairs{"jellynut", "yumako"} do
	TECH[techName].prerequisites = {"planet-discovery-gleba"}
end

-- Nutrients-from-spoilage recipe should be only in biochambers, and then put it in biochamber tech. (It was in agriculture tech, which we're hiding.)
Tech.addRecipeToTech("nutrients-from-spoilage", "biochamber", 3)
RECIPE["nutrients-from-spoilage"].category = "organic"

-- Edit results from mining the living trees. They should give seeds directly, then we add recipe for seed -> sapling using fertilizer.
-- There's a lot of different types of trees, so I'm just going to look through everything in RAW.tree and check if it's minable is exactly 4 wood and nothing else.
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
	{type = "item", name = "wood", amount = 10},
	{type = "item", name = "resin", amount = 2},
	{
		type = "item",
		name = "tree-seed",
		amount_min = 1,
		amount_max = 2,
		--extra_count_fraction = 0.05,
		-- Could make it very rarely give an extra seed, so you have to go harvest a ton of trees to set up big plantations.
	},
}
local newDeadTreeMinableResults = {
	{type = "item", name = "wood", amount = 5},
	{type = "item", name = "resin", amount = 2},
}
for _, tree in pairs(RAW.tree) do
	if isNormalTree(tree) then
		tree.minable.results = newTreeMinableResults
	elseif isDeadTree(tree) then
		tree.minable.results = newDeadTreeMinableResults
	end
end
RAW.plant["tree-plant"].minable.results = newTreeMinableResults

-- Create fertilizer item.
local fertilizerItem = copy(ITEM["wood"])
fertilizerItem.name = "fertilizer"
Icon.set(fertilizerItem, "LSA/fertilizer/fertilizer-1")
Icon.variants(fertilizerItem, "LSA/fertilizer/fertilizer-%", 3)
Item.clearFuel(fertilizerItem)
extend{fertilizerItem}

-- Create new "sapling" item.
local saplingPictures = {}
for _, i in pairs{"1", "2", "2-red", "3", "4", "5", "7", "8", "8-brown", "8-red", "9", "9-brown", "9-red"} do
	table.insert(saplingPictures, {filename = "__base__/graphics/icons/tree-0"..i..".png", size = 64, scale=0.5, mipmap_count=4})
end
local saplingItem = copy(ITEM["tree-seed"])
saplingItem.name = "sapling"
saplingItem.localised_name = {"item-name.sapling"} -- Seems to be necessary, else it takes name from planted/placed thing.
saplingItem.localised_description = nil
saplingItem.spoil_ticks = 1 * HOURS
saplingItem.spoil_result = "wood"
Item.clearFuel(saplingItem)
Icon.set(saplingItem, "base/tree-08")
saplingItem.pictures = saplingPictures
extend{saplingItem}

-- Can no longer plant seeds directly.
ITEM["tree-seed"].plant_result = nil
ITEM["tree-seed"].place_result = nil

-- Create recipe for fertilizer.
-- Currently 1 tree -> 4 wood, and 5 wood -> 5 spoilage -> 10 ammonia. So 10 ammonia -> 2 fertilizer allows growing total number of trees.
-- And then once you get biochambers with the prod bonus, you can greatly increase wood production.
local fertilizerRecipe = copy(RECIPE["wood-processing"])
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
fertilizerRecipe.category = "chemistry"
Icon.clear(fertilizerRecipe)
fertilizerRecipe.surface_conditions = nil
fertilizerRecipe.allow_decomposition = true
extend{fertilizerRecipe}

-- Create recipe for saplings.
local saplingRecipe = copy(RECIPE["wood-processing"])
saplingRecipe.name = "sapling"
saplingRecipe.ingredients = {
	{type="item", name="tree-seed", amount=1},
	{type="item", name="fertilizer", amount=1},
	{type="fluid", name="water", amount=100},
}
saplingRecipe.results = {
	{type="item", name="sapling", amount=1},
}
Recipe.setCategories(saplingRecipe, {"organic", "crafting-with-fluid"})
Icon.clear(saplingRecipe)
saplingRecipe.surface_conditions = {{property = "pressure", min = 1000, max = 1000}}
saplingRecipe.energy_required = 30
saplingRecipe.allow_decomposition = true
extend{saplingRecipe}

-- Edit growth time of saplings.
RAW.plant["tree-plant"].growth_ticks = 6 * MINUTES -- Originally 10 minutes.

-- Add recipes to tree-seeding tech.
TECH["tree-seeding"].effects = {
	{type = "unlock-recipe", recipe = "agricultural-tower"},
	{type = "unlock-recipe", recipe = "fertilizer"},
	{type = "unlock-recipe", recipe = "sapling"},
}

-- Hide the "wood processing" recipe. It converts wood to seeds; we're rather having trees directly yield seeds.
-- This must be after creating recipes above, or they'll inherit the hiddenness.
Recipe.hide("wood-processing")

-- TODO turn off or greatly reduce pollution absorption from trees, since you can now plant a lot from early-game.

-- Clear description of ag tower.
RAW["agricultural-tower"]["agricultural-tower"].localised_description = {"entity-description.no-description"}