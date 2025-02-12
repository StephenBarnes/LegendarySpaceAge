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

local Tech = require("code.util.tech")

-- Create ash item.
local item = table.deepcopy(data.raw.item["sulfur"])
item.name = "ash"
local ashDir = "__LegendarySpaceAge__/graphics/ash/"
item.icon = ashDir.."1.png"
item.pictures = {}
for i = 1, 3 do
	item.pictures[i] = {filename = ashDir..i..".png", size = 64, scale = 0.5}
end
item.order = "0"
data:extend{item}

-- Create recipe for reprocessing ash.
-- 4 ash + 5 water + 5 sulfuric acid -> 2 carbon + 1 sand + 20% sulfur + 20% 1 iron ore + 20% 1 copper ore.
local ashRecipe = table.deepcopy(data.raw.recipe["rocket-fuel"])
ashRecipe.name = "ash-reprocessing"
ashRecipe.ingredients = {
	{type = "item", name = "ash", amount = 4},
	{type = "fluid", name = "water", amount = 5},
	{type = "fluid", name = "sulfuric-acid", amount = 5},
}
ashRecipe.results = {
	{type = "item", name = "carbon", amount = 1},
	{type = "item", name = "sand", amount = 1},
	{type = "item", name = "sulfur", amount = 1, probability = 0.2},
	{type = "item", name = "iron-ore", amount = 1, probability = 0.2},
	{type = "item", name = "copper-ore", amount = 1, probability = 0.2},
}
ashRecipe.allow_decomposition = false
ashRecipe.allow_as_intermediate = false
ashRecipe.main_product = "carbon"
ashRecipe.icon = nil
ashRecipe.icons = {
	{icon = "__space-age__/graphics/icons/carbon.png", icon_size = 64, scale = 0.5, mipmap_count = 4},
	{icon = "__LegendarySpaceAge__/graphics/ash/1.png", icon_size = 64, scale = 0.25, mipmap_count = 4, shift = {-8, -8}},
}
ashRecipe.category = "chemistry"
ashRecipe.energy_required = 2
ashRecipe.enabled = false
data:extend{ashRecipe}

-- Create tech for ash reprocessing.
local tech = table.deepcopy(data.raw.technology["lamp"])
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
tech.icon = "__LegendarySpaceAge__/graphics/ash/tech.png"
data:extend{tech}