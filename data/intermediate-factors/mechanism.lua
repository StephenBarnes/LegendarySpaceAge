-- This file creates the "mechanism" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local mechanismItem = copy(ITEM["steel-plate"])
mechanismItem.name = "mechanism"
Icon.set(mechanismItem, "LSA/intermediate-factors/mechanism")
extend{mechanismItem}

-- Create recipe: 8 machine parts + 1 frame -> 1 mechanism
local basicRecipe = copy(RECIPE["iron-gear-wheel"])
basicRecipe.name = "mechanism-from-basic"
basicRecipe.ingredients = {
	{type = "item", name = "iron-gear-wheel", amount = 5},
	{type = "item", name = "frame", amount = 1},
}
basicRecipe.results = {{type = "item", name = "mechanism", amount = 1}}
basicRecipe.enabled = true
basicRecipe.energy_required = 5
basicRecipe.category = "crafting"
Icon.set(basicRecipe, {"mechanism", "iron-gear-wheel"})
basicRecipe.allow_as_intermediate = true
extend{basicRecipe}

-- Create recipe: 4 advanced parts + 1 frame -> 1 mechanism
local advancedRecipe = copy(basicRecipe)
advancedRecipe.name = "mechanism-from-advanced"
advancedRecipe.ingredients = {
	{type = "item", name = "advanced-parts", amount = 2},
	{type = "item", name = "frame", amount = 1},
}
advancedRecipe.results = {{type = "item", name = "mechanism", amount = 2}}
advancedRecipe.energy_required = 2.5
Icon.set(advancedRecipe, {"mechanism", "advanced-parts"})
advancedRecipe.allow_as_intermediate = false
advancedRecipe.enabled = false
extend{advancedRecipe}
Tech.addRecipeToTech("mechanism-from-advanced", "electric-engine")

-- Create recipe: 1 frame + 3 appendage -> 1 mechanism
local appendageRecipe = copy(basicRecipe)
appendageRecipe.name = "mechanism-from-appendage"
appendageRecipe.ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "appendage", amount = 3},
}
appendageRecipe.energy_required = 5
Icon.set(appendageRecipe, {"mechanism", "appendage"})
appendageRecipe.allow_as_intermediate = false
appendageRecipe.enabled = false
appendageRecipe.category = "crafting"
extend{appendageRecipe}

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?

Gen.order({
	mechanismItem,
	basicRecipe,
	advancedRecipe,
	appendageRecipe,
}, "mechanism")