--[[ This file will create items for sand, glass, and glass batch, and recipes for them, and techs.
Stone can be crushed into sand in an assembling machine: 1 stone -> 1 sand
Sand can then be combined with ash to make glass batch: 1 sand + 1 ash -> 1 glass-batch
Glass batch can be smelted to glass in a furnace or foundry: 1 glass-batch -> 1 glass
]]

-- Create sand item.
local sandItem = copy(ITEM["stone"])
sandItem.name = "sand"
Icon.set(sandItem, "LSA/glass-etc/sand/1")
Icon.variants(sandItem, "LSA/glass-etc/sand/%", 3)
sandItem.subgroup = "raw-material"
sandItem.order = "a2"
sandItem.stack_size = 100 -- Increase 50->100 vs stone and ores. So it makes sense to crush stone before shipping.
extend{sandItem}

-- Create glass batch item.
local glassBatchItem = copy(ITEM["sulfur"])
glassBatchItem.name = "glass-batch"
Icon.set(glassBatchItem, "LSA/glass-etc/batch/1")
Icon.variants(glassBatchItem, "LSA/glass-etc/batch/%", 3)
glassBatchItem.subgroup = "raw-material"
glassBatchItem.order = "a3"
extend{glassBatchItem}

-- Create glass item.
local glassItem = copy(ITEM["iron-plate"])
glassItem.name = "glass"
Icon.set(glassItem, "LSA/glass-etc/glass/1")
Icon.variants(glassItem, "LSA/glass-etc/glass/%", 6)
glassItem.subgroup = "raw-material"
glassItem.order = "a4"
extend{glassItem}

-- Create recipe for stone -> sand.
local sandRecipe = copy(RECIPE["iron-gear-wheel"])
sandRecipe.name = "sand"
sandRecipe.ingredients = {{type="item", name="stone", amount=1}}
sandRecipe.results = {{type="item", name="sand", amount=1}}
sandRecipe.category = "crafting"
sandRecipe.subgroup = "raw-material"
sandRecipe.enabled = true
sandRecipe.allow_decomposition = true
sandRecipe.allow_as_intermediate = true
extend{sandRecipe}

-- Create recipe for sand + ash -> glass batch.
local glassBatchRecipe = copy(RECIPE["iron-plate"])
glassBatchRecipe.name = "glass-batch"
glassBatchRecipe.ingredients = {{type="item", name="sand", amount=1}, {type="item", name="ash", amount=1}}
glassBatchRecipe.results = {{type="item", name="glass-batch", amount=1}}
glassBatchRecipe.category = "crafting"
glassBatchRecipe.subgroup = "raw-material"
glassBatchRecipe.enabled = false
glassBatchRecipe.allow_decomposition = true
glassBatchRecipe.allow_as_intermediate = true
glassBatchRecipe.auto_recycle = true
extend{glassBatchRecipe}

-- Create recipe for glass batch -> glass.
local glassRecipe = copy(RECIPE["iron-plate"])
glassRecipe.name = "glass"
glassRecipe.ingredients = {{type="item", name="glass-batch", amount=1}}
glassRecipe.results = {{type="item", name="glass", amount=1}}
glassRecipe.category = "smelting-or-metallurgy"
glassRecipe.subgroup = "raw-material"
glassRecipe.enabled = false
glassRecipe.energy_required = 2
glassRecipe.allow_decomposition = true
glassRecipe.allow_as_intermediate = true
extend{glassRecipe}

-- Create tech for glass
local glassTech = copy(TECH["logistics"])
glassTech.name = "glass"
glassTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "glass-batch",
	},
	{
		type = "unlock-recipe",
		recipe = "glass",
	},
	{
		type = "unlock-recipe",
		recipe = "panel-from-glass",
	},
}
glassTech.prerequisites = {}
glassTech.unit = nil
glassTech.research_trigger = {
	type = "craft-item",
	item = "sand",
	count = 1,
}
Icon.set(glassTech, "LSA/glass-etc/tech")
glassTech.order = "001"
extend{glassTech}