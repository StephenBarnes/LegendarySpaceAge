-- This file will add recipes for low-density structures.

RECIPE["low-density-structure"].auto_recycle = false

-- Reduce weight of low-density structure.
Item.perRocket("low-density-structure", 2000)

-- Create recipe from copper and steel, copying the default recipe.
local recipeFromCopper = copy(RECIPE["low-density-structure"])
recipeFromCopper.name = "low-density-structure-standard"
recipeFromCopper.ingredients = {
	{type="item", name="ingot-copper-hot", amount=5},
	{type="item", name="ingot-steel-hot", amount=2},
	{type="item", name="plastic-bar", amount=3},
	{type="item", name="resin", amount=1},
}
recipeFromCopper.allow_as_intermediate = true
recipeFromCopper.hide_from_player_crafting = false
Icon.set(recipeFromCopper, {"low-density-structure", "ingot-copper-cold"})
extend{recipeFromCopper}
Tech.addRecipeToTech("low-density-structure-standard", "low-density-structure")

-- Hide default recipe.
RECIPE["low-density-structure"].hidden = true
RECIPE["low-density-structure"].hidden_in_factoriopedia = true
Tech.removeRecipeFromTech("low-density-structure", "low-density-structure")

-- Create a new recipe for growing LDS from chitin broth.
local recipeFromChitinAndCarbonFiber = copy(recipeFromCopper)
recipeFromChitinAndCarbonFiber.name = "lds-from-chitin-and-carbon-fiber"
recipeFromChitinAndCarbonFiber.ingredients = {
	{type = "item", name = "carbon-fiber", amount = 1},
	{type = "fluid", name = "chitin-broth", amount = 50},
	{type = "item", name = "slipstack-pearl", amount = 2},
}
recipeFromChitinAndCarbonFiber.energy_required = 20
recipeFromChitinAndCarbonFiber.results = {
	{type = "item", name = "low-density-structure", amount = 1},
}
recipeFromChitinAndCarbonFiber.enabled = false
recipeFromChitinAndCarbonFiber.allow_as_intermediate = false
recipeFromChitinAndCarbonFiber.category = "organic"
Icon.set(recipeFromChitinAndCarbonFiber, {"low-density-structure", "chitin-broth", "carbon-fiber"})
extend{recipeFromChitinAndCarbonFiber}

-- TODO create new recipes for low-density structure.
-- TODO create a recipe like: tubules + carbon fiber + resin + plastic bar -> low-density structure.
-- TODO create a ceramic-based recipe.

Gen.order({
	ITEM["low-density-structure"],
	RECIPE["low-density-structure"],
	recipeFromCopper,
	RECIPE["casting-low-density-structure"],
	recipeFromChitinAndCarbonFiber,
}, "low-density-structure")