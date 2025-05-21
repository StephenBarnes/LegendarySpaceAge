-- This file will add recipes for actuators. We hijack the base-game "electric engine unit", renaming it to "actuator". Actuators are like mechanisms, but they require advanced parts and lubricant, so basically they require oil products converted to red circuits, lubricant, plastic, rubber.

-- Move item and recipes into the subgroup.
ITEM["electric-engine-unit"].subgroup = "actuator"

-- Create recipe: 8 advanced parts + 1 frame + 1 red circuit + 20 lubricant -> 1 actuator
local standardRecipe = copy(RECIPE["electric-engine-unit"])
standardRecipe.name = "actuator-standard"
standardRecipe.ingredients = {
	{ type = "item",  name = "advanced-parts",   amount = 10 },
	{ type = "item",  name = "frame",            amount = 1 },
	{ type = "item",  name = "advanced-circuit", amount = 1 },
	{ type = "fluid", name = "lubricant",        amount = 20 }
}
Icon.set(standardRecipe, {"electric-engine-unit", "LSA/parts-advanced/3", "advanced-circuit"})
standardRecipe.auto_recycle = false
extend{standardRecipe}
Tech.addRecipeToTech("actuator-standard", "electric-engine")

-- Hide the default recipe.
RECIPE["electric-engine-unit"].hidden = true
RECIPE["electric-engine-unit"].hidden_in_factoriopedia = true
RECIPE["electric-engine-unit"].auto_recycle = false
Tech.removeRecipeFromTech("electric-engine-unit", "electric-engine")

-- Create recipe: 6 advanced parts + 1 frame + 1 blue circuit + 20 lubricant -> 1 actuator
local advancedRecipe = copy(standardRecipe)
advancedRecipe.name = "actuator-from-blue-circuit"
advancedRecipe.ingredients = {
	{ type = "item",  name = "advanced-parts",   amount = 5 },
	{ type = "item",  name = "frame",            amount = 1 },
	{ type = "item",  name = "processing-unit",  amount = 2 },
	{ type = "fluid", name = "lubricant",        amount = 10 }
}
Icon.set(advancedRecipe, {"electric-engine-unit", "LSA/parts-advanced/3", "processing-unit"})
extend{advancedRecipe}
Tech.addRecipeToTech("actuator-from-blue-circuit", "electric-engine")

-- Create recipe for augmented actuator: 1 mechanism + 5 lubricant + 1 blue circuit + 1 advanced part -> 1 actuator
local augmentedRecipe = copy(standardRecipe)
augmentedRecipe.name = "actuator-augmented"
augmentedRecipe.ingredients = {
	{ type = "item",  name = "mechanism",        amount = 1 },
	{ type = "item",  name = "processing-unit",  amount = 1 },
	{ type = "item",  name = "advanced-parts",   amount = 5 },
	{ type = "fluid", name = "lubricant",        amount = 10 },
}
Icon.set(augmentedRecipe, {"electric-engine-unit", "LSA/intermediate-factors/mechanism", "processing-unit"})
extend{augmentedRecipe}
Tech.addRecipeToTech("actuator-augmented", "electric-engine")

-- Create recipe: 1 frame + 8 appendage + 1 sencytium + 1 red circuit -> 1 actuator
local recipeFromAppendage = copy(standardRecipe)
recipeFromAppendage.name = "actuator-from-appendage"
recipeFromAppendage.ingredients = {
	{ type = "item",  name = "frame",            amount = 1 },
	{ type = "item",  name = "appendage",        amount = 5 },
	{ type = "item",  name = "sencytium",         amount = 1 },
	{ type = "item",  name = "advanced-circuit", amount = 1 },
}
Icon.set(recipeFromAppendage, {"electric-engine-unit", "LSA/gleba/appendage/4", "advanced-circuit"})
recipeFromAppendage.allow_as_intermediate = false
recipeFromAppendage.enabled = false
recipeFromAppendage.category = "crafting"
extend{recipeFromAppendage}

-- TODO create more recipes

Gen.order({
	ITEM["electric-engine-unit"],
	standardRecipe,
	advancedRecipe,
	augmentedRecipe,
	recipeFromAppendage,
}, "actuator")