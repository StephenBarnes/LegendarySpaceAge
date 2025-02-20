-- This file creates the "shielding" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local shieldingItem = copy(ITEM["steel-plate"])
shieldingItem.name = "shielding"
Icon.set(shieldingItem, "LSA/intermediate-factors/shielding")
extend{shieldingItem}

-- Create recipe: 10 iron plate + 10 stone brick + 10 iron rod -> 1 shielding
local recipeFromIron = copy(RECIPE["iron-stick"])
recipeFromIron.name = "shielding-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-plate", amount = 5},
	{type = "item", name = "stone-brick", amount = 5},
	{type = "item", name = "iron-stick", amount = 5},
}
recipeFromIron.results = {{type = "item", name = "shielding", amount = 1}}
recipeFromIron.enabled = true
recipeFromIron.energy_required = 5
recipeFromIron.category = "crafting"
recipeFromIron.allow_as_intermediate = true
recipeFromIron.auto_recycle = false
Icon.set(recipeFromIron, {"shielding", "iron-plate", "stone-brick"})
extend{recipeFromIron}

-- Create recipe: 4 steel plate + 2 iron rod -> 2 shielding
local recipeFromSteel = copy(recipeFromIron)
recipeFromSteel.name = "shielding-from-steel"
recipeFromSteel.ingredients = {
	{type = "item", name = "steel-plate", amount = 5},
	{type = "item", name = "iron-stick", amount = 5},
}
recipeFromSteel.results = {{type = "item", name = "shielding", amount = 2}}
recipeFromSteel.allow_as_intermediate = false
recipeFromSteel.energy_required = 5
Icon.set(recipeFromSteel, {"shielding", "steel-plate", "iron-stick"})
recipeFromSteel.enabled = false
extend{recipeFromSteel}
Tech.addRecipeToTech("shielding-from-steel", "steel-processing")

-- Create recipe: 2 steel plate + 2 tungsten plate -> 2 shielding
local recipeFromTungsten = copy(recipeFromSteel)
recipeFromTungsten.name = "shielding-from-tungsten"
recipeFromTungsten.ingredients = {
	{type = "item", name = "steel-plate", amount = 5},
	{type = "item", name = "tungsten-plate", amount = 5},
}
recipeFromTungsten.results = {{type = "item", name = "shielding", amount = 5}}
recipeFromTungsten.energy_required = 5
Icon.set(recipeFromTungsten, {"shielding", "steel-plate", "tungsten-plate"})
extend{recipeFromTungsten}
Tech.addRecipeToTech("shielding-from-tungsten", "tungsten-steel")

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?

-- TODO make sprites for shielding different for different recipes.

Gen.order({
	shieldingItem,
	recipeFromIron,
	recipeFromSteel,
	recipeFromTungsten,
}, "shielding")