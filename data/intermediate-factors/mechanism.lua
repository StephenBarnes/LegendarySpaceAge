-- This file creates the "mechanism" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local mechanismItem = copy(ITEM["steel-plate"])
mechanismItem.name = "mechanism"
Icon.set(mechanismItem, "LSA/intermediate-factors/mechanism")
extend{mechanismItem}

-- Create recipe: 5 machine parts + 1 frame -> 1 mechanism
local basicRecipe = Recipe.make{
	copy = "iron-gear-wheel",
	recipe = "mechanism-from-basic",
	ingredients = {
		{"iron-gear-wheel", 5},
		{"frame", 1},
	},
	results = {{"mechanism", 1}},
	main_product = "mechanism",
	enabled = true,
	time = 5,
	category = "crafting",
	allow_as_intermediate = true,
	allow_decomposition = true,
	icons = {"mechanism", "iron-gear-wheel"},
	auto_recycle = false,
}

-- Create recipe: 2 advanced parts + 1 frame -> 2 mechanism
local advancedRecipe = Recipe.make{
	copy = basicRecipe,
	recipe = "mechanism-from-advanced",
	ingredients = {
		{"advanced-parts", 5},
		{"frame", 1},
	},
	results = {{"mechanism", 2}},
	allow_as_intermediate = false,
	enabled = false,
	time = 2.5,
	icons = {"mechanism", "advanced-parts"},
}
Tech.addRecipeToTech("mechanism-from-advanced", "electric-engine")

-- Create recipe: 1 frame + 3 appendage -> 1 mechanism
local appendageRecipe = Recipe.make{
	copy = basicRecipe,
	recipe = "mechanism-from-appendage",
	ingredients = {
		{"frame", 1},
		{"appendage", 3},
	},
	results = {{"mechanism", 1}},
	allow_as_intermediate = false,
	enabled = false,
	time = 5,
	icons = {"mechanism", "appendage"},
}

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?

Gen.order({
	mechanismItem,
	basicRecipe,
	advancedRecipe,
	appendageRecipe,
}, "mechanism")