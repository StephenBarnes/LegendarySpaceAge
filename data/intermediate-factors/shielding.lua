-- This file creates the "shielding" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local shieldingItem = copy(ITEM["steel-plate"])
shieldingItem.name = "shielding"
Icon.set(shieldingItem, "LSA/intermediate-factors/shielding")
extend{shieldingItem}

-- Create recipe: 10 iron plate + 10 stone brick + 10 iron rod -> 1 shielding
-- This is slow and expensive, but available before steel is researched.
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
-- Faster than the iron+brick recipe, doesn't require stone, but requires some more iron.
local recipeFromSteel = copy(recipeFromIron)
recipeFromSteel.name = "shielding-from-steel"
recipeFromSteel.ingredients = {
	{type = "item", name = "steel-plate", amount = 2},
	{type = "item", name = "iron-stick", amount = 2},
}
recipeFromSteel.results = {{type = "item", name = "shielding", amount = 1}}
recipeFromSteel.allow_as_intermediate = false
recipeFromSteel.energy_required = 2
Icon.set(recipeFromSteel, {"shielding", "steel-plate", "iron-stick"})
recipeFromSteel.enabled = false
extend{recipeFromSteel}
Tech.addRecipeToTech("shielding-from-steel", "steel-processing")

-- Create recipe: 1 steel plate + 1 tungsten carbide -> 1 shielding.
-- This is partly for the player's first foundry and arc furnace on Vulcanus. Fairly low costs assuming you're carbon-rich, which they should be after landing on Vulcanus, since boulders have lots of carbon.
local recipeFromTungstenCarbide = Recipe.make{
	copy = recipeFromSteel,
	recipe = "shielding-from-tungsten-carbide",
	ingredients = {
		{"steel-plate", 1},
		{"tungsten-carbide", 1},
	},
	results = {{"shielding", 1}},
	time = 2,
	icons = {"shielding", "steel-plate", "tungsten-carbide"},
}
Tech.addRecipeToTech("shielding-from-tungsten-carbide", "tungsten-carbide")

-- Create recipe: 1 steel plate + 1 tungsten plate -> 2 shielding.
-- This is meant to be the cheapest way to get shielding from solid items. Needs a big Vulcanus setup to produce tungsten plate.
local recipeFromTungstenSteel = Recipe.make{
	copy = recipeFromSteel,
	recipe = "shielding-from-tungsten",
	ingredients = {
		{"steel-plate", 1},
		{"tungsten-plate", 1},
	},
	results = {{"shielding", 2}},
	time = 1,
	icons = {"shielding", "steel-plate", "tungsten-plate"},
}
Tech.addRecipeToTech("shielding-from-tungsten", "tungsten-steel")

-- Create casting recipe: 100 molten steel -> 1 shielding, plus 1 water -> 10 steam.
-- This is expensive, eg for 1/s shielding it needs 2 fully-heated arc furnaces making iron from lava. But it's simple.
local recipeFromCastingSteel = Recipe.make{
	copy = recipeFromTungstenSteel,
	recipe = "shielding-from-casting-steel",
	ingredients = {
		{"molten-steel", 50},
		{"water", 1},
	},
	results = {
		{"shielding", 1},
		{"steam", 10, temperature = 500, ignored_by_productivity=10},
	},
	category = "metallurgy",
	icons = {"shielding", "molten-steel"},
	iconArrangement = "casting",
	addToTech = "foundry-2",
}

-- Create casting recipe: 10 molten tungsten + 10 molten steel -> 1 shielding, plus 1 water -> 10 steam.
-- This is similar to the recipe from steel and tungsten plate items, but with fluids, so a bit simpler.
local recipeFromCastingTungsten = Recipe.make{
	copy = recipeFromTungstenSteel,
	recipe = "shielding-from-casting-tungsten",
	ingredients = {
		{"molten-tungsten", 10, minimum_temperature = 1800, maximum_temperature = 1900},
		{"molten-steel", 10},
		{"water", 2},
	},
	results = {
		{"shielding", 1},
		{"steam", 20, temperature = 500, ignored_by_productivity=20},
	},
	category = "metallurgy",
	icons = {"shielding", "molten-tungsten"},
	iconArrangement = "casting",
	addToTech = "tungsten-steel",
}

-- TODO make sprites for shielding different for different recipes.

Gen.order({
	shieldingItem,
	recipeFromIron,
	recipeFromSteel,
	recipeFromCastingSteel,
	recipeFromTungstenCarbide,
	recipeFromTungstenSteel,
	recipeFromCastingTungsten,
}, "shielding")