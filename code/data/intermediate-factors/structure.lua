-- This file creates the "structure" intermediate, and its multiple recipes. See main.lua in this folder for more info.

local Tech = require("code.util.tech")

-- Create item.
local structureItem = table.deepcopy(data.raw.item["steel-plate"])
structureItem.name = "structure"
structureItem.subgroup = "structure"
structureItem.order = "01"
structureItem.icon = nil
structureItem.icons = {{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/structure.png", icon_size = 64, scale = 0.5}}
data:extend{structureItem}

-- Create recipe: 8 stone brick + 20 cement -> 1 structure
local recipeFromStone = table.deepcopy(data.raw.recipe["iron-stick"])
recipeFromStone.name = "structure-from-stone"
recipeFromStone.ingredients = {
	{type = "item", name = "stone-brick", amount = 8},
	{type = "fluid", name = "cement", amount = 20},
}
recipeFromStone.results = {{type = "item", name = "structure", amount = 1}}
recipeFromStone.enabled = false
recipeFromStone.subgroup = "structure"
recipeFromStone.order = "02"
recipeFromStone.energy_required = 6
recipeFromStone.category = "crafting-with-fluid"
recipeFromStone.icon = nil
recipeFromStone.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/structure.png", icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/stone-brick.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
recipeFromStone.allow_as_intermediate = true
data:extend{recipeFromStone}
Tech.addRecipeToTech("structure-from-stone", "cement")


-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?