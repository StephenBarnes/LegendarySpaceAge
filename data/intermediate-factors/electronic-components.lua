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
	ingredients = {
		{"glass", 1},
		{"carbon", 1},
		{"wiring", 2},
	},
	results = {{"electronic-components", 5}},
	category = "electronics",
	time = 2.5,
	allow_decomposition = true,
	allow_as_intermediate = true,
	auto_recycle = false,
	icons = {"electronic-components", "glass"},
}
Tech.addRecipeToTech("components-basic", "electronics", 2)

-- Create recipe: 1 carbon + 1 plastic + 1 wiring -> 5 electronic components
local recipeFromPlastic = Recipe.make{
	copy = basicRecipe,
	recipe = "components-from-plastic",
	ingredients = {
		{"carbon", 1},
		{"plastic-bar", 1},
		{"wiring", 1},
	},
	results = {{"electronic-components", 5}},
	time = 2.5,
	allow_decomposition = false,
	allow_as_intermediate = false,
	icons = {"electronic-components", "plastic-bar"},
}
Tech.addRecipeToTech("components-from-plastic", "plastics", 3)

-- Create recipe: 1 carbon + 1 plastic + 1 glass + 2 wiring -> 10 electronic components
local recipeFromGlassPlastic = Recipe.make{
	copy = recipeFromPlastic,
	recipe = "components-from-glass-plastic",
	ingredients = {
		{"carbon", 1},
		{"plastic-bar", 1},
		{"glass", 1},
		{"wiring", 2},
	},
	results = {{"electronic-components", 10}},
	time = 2.5,
	icons = {"electronic-components", "glass", "plastic-bar"},
}
Tech.addRecipeToTech("components-from-glass-plastic", "plastics", 4)

-- Create recipe: 2 silicon + 1 glass + 1 plastic + 1 carbon + 4 wiring -> 20 electronic components
local recipeFromSilicon = Recipe.make{
	copy = recipeFromPlastic,
	recipe = "components-from-silicon",
	ingredients = {
		{"polysilicon", 2},
		{"glass", 1},
		{"plastic-bar", 1},
		{"carbon", 1},
		{"wiring", 2},
		{"sulfuric-acid", 5},
	},
	results = {{"electronic-components", 20}},
	time = 2.5,
	icons = {"electronic-components", "glass", "plastic-bar", "polysilicon"},
	category = "electronics-with-fluid",
}
Tech.addRecipeToTech("components-from-silicon", "processing-unit")