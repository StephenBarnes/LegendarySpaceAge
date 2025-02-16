-- Create item for electronic components.
local electronicComponents = copy(ITEM["advanced-circuit"])
electronicComponents.name = "electronic-components"
electronicComponents.stack_size = 200
Icon.set(electronicComponents, "LSA/circuit-chains/electronic-components/1")
Icon.variants(electronicComponents, "LSA/circuit-chains/electronic-components/%", 3)
extend{electronicComponents}

-- Create recipe: 1 glass + 1 carbon + 1 wiring -> 2 electronic components
local basicRecipe = Recipe.make{
	copy = "electronic-circuit",
	recipe = "components-basic",
	ingredients = {"glass", "carbon", "wiring"},
	results = {{"electronic-components", 2}},
	category = "electronics",
	time = 5,
	allow_decomposition = true,
	allow_as_intermediate = true,
	icons = {"electronic-components", "glass", "carbon"},
}
Tech.addRecipeToTech("components-basic", "electronics", 2)

-- Create recipe: 1 carbon + 1 plastic + 1 wiring -> 5 electronic components
local recipeFromPlastic = Recipe.make{
	copy = basicRecipe,
	recipe = "components-from-plastic",
	ingredients = {"carbon", "plastic-bar", "wiring"},
	results = {{"electronic-components", 5}},
	time = 5,
	allow_decomposition = false,
	allow_as_intermediate = false,
	icons = {"electronic-components", "plastic-bar", "carbon"},
}
Tech.addRecipeToTech("components-from-plastic", "advanced-circuit", 1)

--[[ TODO create more recipes, eg:
* One with glass + plastic + carbon + wiring, producing more.
* One adding silicon as ingredient.
]]

Gen.order({
	electronicComponents,
	basicRecipe,
	recipeFromPlastic,
}, "electronic-components")