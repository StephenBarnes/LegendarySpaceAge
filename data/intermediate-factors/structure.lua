-- This file creates the "structure" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local structureItem = copy(ITEM["steel-plate"])
structureItem.name = "structure"
structureItem.subgroup = "structure"
structureItem.order = "01"
structureItem.icon = nil
structureItem.icons = {{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/structure/structure.png", icon_size = 64, scale = 0.5}}
extend{structureItem}

-- Create recipe: 8 stone brick + 20 cement -> 1 structure
local recipeFromCement = copy(RECIPE["iron-stick"])
recipeFromCement.name = "structure-from-cement"
recipeFromCement.ingredients = {
	{type = "item", name = "stone-brick", amount = 10},
	{type = "fluid", name = "cement", amount = 20},
}
recipeFromCement.results = {{type = "item", name = "structure", amount = 1}}
recipeFromCement.enabled = false
recipeFromCement.subgroup = "structure"
recipeFromCement.order = "03"
recipeFromCement.energy_required = 2
recipeFromCement.category = "crafting-with-fluid"
recipeFromCement.icon = nil
recipeFromCement.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/structure/structure.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/stone-brick.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
	{icon = "__LegendarySpaceAge__/graphics/fluids/cement-fluid.png", icon_size = 64, scale = 0.25, shift = {8, -8}},
}
recipeFromCement.allow_as_intermediate = false
recipeFromCement.auto_recycle = false
extend{recipeFromCement}
Tech.addRecipeToTech("structure-from-cement", "cement")

-- Create recipe for structure from resin: 8 stone brick + 4 resin -> 1 structure
local recipeFromResin = copy(recipeFromCement)
recipeFromResin.name = "structure-from-resin"
recipeFromResin.ingredients = {
	{ type = "item", name = "stone-brick", amount = 10 },
	{ type = "item", name = "resin",    amount = 5 },
}
recipeFromResin.enabled = true
recipeFromResin.order = "02"
recipeFromResin.energy_required = 5
recipeFromResin.category = "crafting"
recipeFromResin.icons[3].icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png"
recipeFromResin.icons[3].scale = 0.2
recipeFromResin.allow_as_intermediate = true
extend{recipeFromResin}

-- Create recipe for structure from chitin block: 4 chitin block + 20 slime -> 1 structure
local recipeFromChitin = copy(recipeFromCement)
recipeFromChitin.name = "structure-from-chitin"
recipeFromChitin.ingredients = {
	{type = "item", name = "chitin-block", amount = 10},
	{type = "fluid", name = "slime", amount = 20},
}
recipeFromChitin.results = {{type = "item", name = "structure", amount = 1}}
recipeFromChitin.enabled = false
recipeFromChitin.order = "04"
recipeFromChitin.category = "crafting-with-fluid"
recipeFromChitin.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/structure/structure.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/gleba/chitin-block/1.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
	{icon = "__LegendarySpaceAge__/graphics/filtration/slime.png", icon_size = 64, scale = 0.25, shift = {8, -8}},
}
recipeFromChitin.allow_as_intermediate = false
extend{recipeFromChitin}

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?

-- TODO make a recipe with concrete and resin, for Fulgora.