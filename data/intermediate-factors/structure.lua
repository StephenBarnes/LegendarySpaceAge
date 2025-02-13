-- This file creates the "structure" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local structureItem = copy(ITEM["steel-plate"])
structureItem.name = "structure"
Icon.set(structureItem, "LSA/intermediate-factors/structure/structure")
extend{structureItem}

-- Create recipe: 10 stone brick + 20 cement -> 1 structure
local recipeFromCement = copy(RECIPE["iron-stick"])
recipeFromCement.name = "structure-from-cement"
recipeFromCement.ingredients = {
	{type = "item", name = "stone-brick", amount = 10},
	{type = "fluid", name = "cement", amount = 20},
}
recipeFromCement.results = {{type = "item", name = "structure", amount = 1}}
recipeFromCement.enabled = false
recipeFromCement.energy_required = 2
recipeFromCement.category = "crafting-with-fluid"
Icon.set(recipeFromCement, {"structure", "stone-brick", "cement"})
recipeFromCement.allow_as_intermediate = false
recipeFromCement.auto_recycle = false
extend{recipeFromCement}
Tech.addRecipeToTech("structure-from-cement", "cement")

-- Create recipe for structure from resin: 8 stone brick + 4 resin -> 1 structure
local recipeFromResin = copy(recipeFromCement)
recipeFromResin.name = "structure-from-resin"
recipeFromResin.ingredients = {
	{ type = "item", name = "stone-brick", amount = 10 },
	{ type = "item", name = "resin",    amount = 2 },
}
recipeFromResin.enabled = true
recipeFromResin.energy_required = 5
recipeFromResin.category = "crafting"
Icon.set(recipeFromResin, {"structure", "stone-brick", "resin"})
recipeFromResin.allow_as_intermediate = true
extend{recipeFromResin}

-- Create recipe for structure from vitrified brick: 10 stone brick -> 1 structure
local recipeFromVitrified = copy(recipeFromCement)
recipeFromVitrified.name = "structure-from-vitrified-brick"
recipeFromVitrified.ingredients = {
	{type = "item", name = "stone-brick", amount = 10},
}
recipeFromVitrified.energy_required = 20
recipeFromVitrified.enabled = true
recipeFromVitrified.category = "smelting"
Icon.set(recipeFromVitrified, {"structure", "stone-brick", "base/signal/signal-hourglass"})
extend{recipeFromVitrified}

-- Create recipe for structure from chitin block: 4 chitin block + 20 slime -> 1 structure
local recipeFromChitin = copy(recipeFromCement)
recipeFromChitin.name = "structure-from-chitin"
recipeFromChitin.ingredients = {
	{type = "item", name = "chitin-block", amount = 10},
	{type = "fluid", name = "slime", amount = 20},
}
recipeFromChitin.results = {{type = "item", name = "structure", amount = 1}}
recipeFromChitin.enabled = false
recipeFromChitin.category = "crafting-with-fluid"
Icon.set(recipeFromChitin, {"structure", "chitin-block", "slime"})
recipeFromChitin.allow_as_intermediate = false
extend{recipeFromChitin}

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?

-- TODO make a recipe with concrete and resin, for Fulgora.

Gen.order({
	structureItem,
	recipeFromResin,
	recipeFromVitrified,
	recipeFromCement,
	recipeFromChitin,
}, "structure")