-- This file creates the "fluid fitting" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local fluidFitting = copy(ITEM["plastic-bar"])
fluidFitting.name = "fluid-fitting"
Icon.set(fluidFitting, "LSA/intermediate-factors/fluid-fitting/1")
Icon.variants(fluidFitting, "LSA/intermediate-factors/fluid-fitting/%", 7)
extend{fluidFitting}

-- Create recipe: 2 copper plates + 2 resin -> 1 fluid fitting
local recipeFromCopper = copy(RECIPE["iron-stick"])
recipeFromCopper.name = "fluid-fitting-from-copper"
recipeFromCopper.ingredients = {
	{type = "item", name = "copper-plate", amount = 2},
	{type = "item", name = "resin", amount = 2}
}
recipeFromCopper.results = {{type = "item", name = "fluid-fitting", amount = 1}}
recipeFromCopper.main_product = "fluid-fitting"
recipeFromCopper.enabled = true
recipeFromCopper.energy_required = 5
Icon.set(recipeFromCopper, {"fluid-fitting", "resin", "copper-plate"})
recipeFromCopper.auto_recycle = false
-- TODO make a copper-colored sprite.
extend{recipeFromCopper}

-- Create recipe: 2 plastic-bar + 1 rubber -> 2 fluid fitting
local recipeFromPlastic = copy(recipeFromCopper)
recipeFromPlastic.name = "fluid-fitting-from-plastic"
recipeFromPlastic.ingredients = {
	{type = "item", name = "plastic-bar", amount = 2},
	{type = "item", name = "rubber", amount = 1}
}
recipeFromPlastic.results = {{type = "item", name = "fluid-fitting", amount = 2}}
recipeFromPlastic.enabled = false
recipeFromPlastic.allow_as_intermediate = false
recipeFromPlastic.allow_decomposition = false
recipeFromPlastic.energy_required = 5
Icon.set(recipeFromPlastic, {"fluid-fitting", "rubber", "plastic-bar"})
-- TODO make custom sprite with plastic.
extend{recipeFromPlastic}
Tech.addRecipeToTech("fluid-fitting-from-plastic", "plastics")

-- TODO make more recipes, and add them to techs.

Gen.order({
	fluidFitting,
	recipeFromCopper,
	recipeFromPlastic,
}, "fluid-fitting")