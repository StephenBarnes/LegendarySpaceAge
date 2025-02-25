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

-- Create recipe: 5 steel plate + 2 tungsten plate -> 10 shielding. Goal is to make this much cheaper, but it requires tungsten plate, which needs a big Vulcanus setup.
local recipeFromTungsten = Recipe.make{
	copy = recipeFromSteel,
	recipe = "shielding-from-tungsten",
	ingredients = {
		{"steel-plate", 5},
		{"tungsten-plate", 5},
	},
	results = {{"shielding", 10}},
	time = 5,
	icons = {"shielding", "steel-plate", "tungsten-plate"},
}
Tech.addRecipeToTech("shielding-from-tungsten", "tungsten-steel")

local recipeFromCastingTungsten = Recipe.make{
	copy = recipeFromTungsten,
	recipe = "shielding-from-casting-tungsten",
	ingredients = {
		{"molten-tungsten", 50, minimum_temperature = 1800, maximum_temperature = 1900},
		{"water", 5},
	},
	results = {
		{"shielding", 5},
		{"steam", 50, temperature = 500, ignored_by_productivity=50},
	},
	category = "metallurgy",
	icons = {"shielding", "molten-tungsten"},
	iconArrangement = "casting",
}
Tech.addRecipeToTech("shielding-from-casting-tungsten", "tungsten-steel")

-- TODO make more recipes, and add them to techs.
-- TODO create a castings recipe from steel or iron.

-- TODO make sprites for shielding different for different recipes.

Gen.order({
	shieldingItem,
	recipeFromIron,
	recipeFromSteel,
	recipeFromTungsten,
	recipeFromCastingTungsten,
}, "shielding")