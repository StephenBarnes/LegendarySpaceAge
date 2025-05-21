--[[ This file adds ash to the game.
Ash is produced by burning wood, coal, and organic stuff (seeds, fruits, spoilage).
	Not produced by burning carbon, sulfur, pitch, resin, barreled fluids.
Uses of ash:
	* (Can just toss it in a lake.)
	* Fertilizer - it's an ingredient.
	* Refined concrete - it's an ingredient.
	* Glass - it's an ingredient, with sand, for "batch" or "glass batch", which is then smelted into glass. This is realistic.
	* Process it for a smaller amount of carbon, plus maybe some sulfur.
		Use water + sulfuric acid + ash as ingredients.
		Produce carbon, plus small amounts of iron ore, copper ore, sand.
]]


-- Create ash item.
local item = copy(ITEM["sulfur"])
item.name = "ash"
Icon.set(item, "LSA/ash/1")
Icon.variants(item, "LSA/ash/%", 3)
extend{item}

-- Create recipe for reprocessing ash.
-- 5 ash + 5 water + 10 sulfuric acid -> 2 carbon + 1 sand + 20% sulfur + 20% 1 iron ore + 20% 1 copper ore.
Recipe.make{
	copy = "rocket-fuel",
	recipe = "ash-reprocessing",
	ingredients = {
		{"ash", 5},
		{"sulfuric-acid", 5},
		{"water", 10},
	},
	results = {
		{"carbon", 1, show_details_in_recipe_tooltip = false},
		{"sand", 1, show_details_in_recipe_tooltip = false},
		{"sulfur", 1, probability = 0.2, show_details_in_recipe_tooltip = false},
		{"iron-ore", 1, probability = 0.2, show_details_in_recipe_tooltip = false},
		{"copper-ore", 1, probability = 0.2, show_details_in_recipe_tooltip = false},
	},
	allow_decomposition = false,
	allow_as_intermediate = false,
	main_product = "carbon",
	icons = {"ash", "carbon", "sand"},
	iconArrangement = "decomposition",
	category = "chemistry",
	time = 2,
	enabled = false,
}

-- Create tech for ash reprocessing.
local tech = copy(TECH["lamp"])
tech.name = "ash-reprocessing"
tech.effects = {
	{type = "unlock-recipe", recipe = "ash-reprocessing"},
}
tech.prerequisites = {"sulfur-processing"}
tech.unit = {
	count = 30,
	ingredients = {
		{"automation-science-pack", 1},
	},
	time = 15,
}
Icon.set(tech, "LSA/ash/tech")
extend{tech}