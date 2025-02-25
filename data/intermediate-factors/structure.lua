-- This file creates the "structure" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local structureItem = copy(ITEM["steel-plate"])
structureItem.name = "structure"
Icon.set(structureItem, "LSA/intermediate-factors/structure/structure")
extend{structureItem}

-- Create recipe: 10 stone brick + 20 cement -> 1 structure
local recipeFromCement = Recipe.make{
	copy = "iron-stick",
	recipe = "structure-from-cement",
	ingredients = {
		{"stone-brick", 10},
		{"cement", 20, type = "fluid"},
	},
	results = {{"structure", 1}},
	enabled = false,
	time = 2,
	category = "crafting-with-fluid",
	icons = {"structure", "stone-brick", "cement"},
	allow_as_intermediate = false,
	auto_recycle = false,
}
Tech.addRecipeToTech("structure-from-cement", "cement")

-- Create recipe for structure from resin: 10 stone brick + 2 resin -> 1 structure
local recipeFromResin = Recipe.make{
	copy = recipeFromCement,
	recipe = "structure-from-resin",
	ingredients = {
		{"stone-brick", 10},
		{"resin", 2},
	},
	results = {{"structure", 1}},
	enabled = true,
	time = 5,
	category = "crafting",
	icons = {"structure", "stone-brick", "resin"},
	allow_as_intermediate = true,
}

-- Create recipe for structure from vitrified brick: 10 stone brick -> 1 structure
local recipeFromVitrified = Recipe.make{
	copy = recipeFromCement,
	recipe = "structure-from-vitrified-brick",
	ingredients = {
		{"stone-brick", 10},
	},
	results = {{"structure", 1}},
	enabled = true,
	time = 30,
	category = "smelting",
	--icons = {"structure", "stone-brick", "base/signal/signal-hourglass"},
	icons = {"structure", "stone-brick", "LSA/temp-delete/signal-hourglass"},
	allow_as_intermediate = true,
}

-- Create recipe for structure from chitin block: 5 chitin block + 20 slime -> 1 structure
local recipeFromChitin = Recipe.make{
	copy = recipeFromCement,
	recipe = "structure-from-chitin",
	ingredients = {
		{"chitin-block", 5},
		{"slime", 20, type = "fluid"},
	},
	results = {{"structure", 1}},
	enabled = false,
	time = 2,
	category = "crafting-with-fluid",
	icons = {"structure", "chitin-block", "slime"},
	allow_as_intermediate = false,
}

-- Create recipe for structure from concrete: 10 concrete + 20 cement -> 2 structure
local recipeFromConcrete = Recipe.make{
	copy = recipeFromCement,
	recipe = "structure-from-concrete",
	ingredients = {
		{"concrete", 10},
		{"cement", 20, type = "fluid"},
	},
	results = {{"structure", 2}},
	enabled = false,
	time = 2,
	category = "crafting-with-fluid",
	icons = {"structure", "concrete", "cement"},
	allow_as_intermediate = false,
}
Tech.addRecipeToTech("structure-from-concrete", "concrete")

-- Create recipe for structure from refined concrete: 10 refined concrete + 10 cement -> 5 structure
local recipeFromRefinedConcrete = Recipe.make{
	copy = recipeFromConcrete,
	recipe = "structure-from-refined-concrete",
	ingredients = {
		{"refined-concrete", 10},
		{"cement", 10, type = "fluid"},
	},
	results = {{"structure", 5}},
	enabled = false,
	time = 5,
	category = "crafting-with-fluid",
	icons = {"structure", "refined-concrete", "cement"},
	allow_as_intermediate = false,
}
Tech.addRecipeToTech("structure-from-refined-concrete", "concrete")


-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?

-- TODO make a recipe with concrete and resin, for Fulgora.

Gen.order({
	structureItem,
	recipeFromResin,
	recipeFromVitrified,
	recipeFromCement,
	recipeFromConcrete,
	recipeFromRefinedConcrete,
	recipeFromChitin,
}, "structure")