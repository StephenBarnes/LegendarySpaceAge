-- This file creates the "frame" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local frame = copy(ITEM["steel-plate"])
frame.name = "frame"
Icon.set(frame, "LSA/intermediate-factors/frame/frame")
frame.stack_size = 50
Item.perRocket(frame, 500)
extend{frame}

-- Create recipe: 2 wood + 1 resin -> 1 frame
local recipeFromWood = copy(RECIPE["iron-stick"])
recipeFromWood.name = "frame-from-wood"
recipeFromWood.ingredients = {
	{type = "item", name = "wood", amount = 2},
	{type = "item", name = "resin", amount = 1}
}
recipeFromWood.results = {{type = "item", name = "frame", amount = 1}}
recipeFromWood.main_product = "frame"
recipeFromWood.enabled = true
recipeFromWood.energy_required = 10
recipeFromWood.category = "crafting"
recipeFromWood.allow_as_intermediate = false
recipeFromWood.auto_recycle = false
Icon.set(recipeFromWood, {"LSA/intermediate-factors/frame/wooden-frame", "wood"})
extend{recipeFromWood}

-- Create recipe: 12 iron rods -> 1 frame
local recipeFromIron = copy(RECIPE["iron-stick"])
recipeFromIron.name = "frame-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-stick", amount = 10}
}
recipeFromIron.results = {{type = "item", name = "frame", amount = 1}}
recipeFromIron.main_product = "frame"
recipeFromIron.enabled = true
recipeFromIron.energy_required = 5
recipeFromIron.category = "crafting"
recipeFromIron.allow_as_intermediate = true
recipeFromIron.auto_recycle = false
Icon.set(recipeFromIron, {"frame", "iron-stick"})
extend{recipeFromIron}

-- Create recipe: 5 iron rod + 1 steel plate -> 1 frame.
-- With early recipes, this needs 2 iron ingots, so it's basically the same raw materials, plus coal to make steel. But it needs fewer machines total. And then later you get more efficient recipes for making steel.
local recipeFromIronAndSteel = Recipe.make{
	copy = recipeFromIron,
	recipe = "frame-from-iron-and-steel",
	ingredients = {
		{"iron-stick", 5},
		{"steel-plate", 1},
	},
	time = 2,
	icons = {"frame", "steel-plate", "iron-stick"},
	allow_as_intermediate = false,
}
Tech.addRecipeToTech("frame-from-iron-and-steel", "steel-processing")

-- Create recipe from steel: 5 steel plate -> 2 frame
local recipeFromSteel = Recipe.make{
	copy = recipeFromIronAndSteel,
	recipe = "frame-from-steel",
	ingredients = {
		{"steel-plate", 5},
	},
	results = {{"frame", 2}},
	time = 5,
	icons = {"frame", "steel-plate"},
	allow_as_intermediate = false,
}
Tech.addRecipeToTech("frame-from-steel", "steel-processing")

-- Create recipe from tubules: 8 tubules + 20 slime -> 1 frame
local recipeFromTubules = copy(recipeFromIron)
recipeFromTubules.name = "frame-from-tubules"
recipeFromTubules.ingredients = {
	{type = "item", name = "tubule", amount = 5},
	{type = "fluid", name = "slime", amount = 20}
}
recipeFromTubules.enabled = false
recipeFromTubules.energy_required = 5
recipeFromTubules.category = "crafting-with-fluid"
recipeFromTubules.allow_as_intermediate = false
Icon.set(recipeFromTubules, {"frame", "tubule"}) -- TODO make separate tubule frame icon.
extend{recipeFromTubules}

-- TODO create recipes for rigid structure
-- TODO add recipes to techs

Gen.order({
	frame,
	recipeFromWood,
	recipeFromIron,
	recipeFromIronAndSteel,
	recipeFromSteel,
	recipeFromTubules,
}, "frame")