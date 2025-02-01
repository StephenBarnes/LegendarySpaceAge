-- This file will add recipes for actuators. We hijack the base-game "electric engine unit", renaming it to "actuator". Actuators are like mechanisms, but they require advanced parts and lubricant, so basically they require oil products converted to red circuits, lubricant, plastic, rubber.

local Tech = require "code.util.tech"

-- Move item and recipes into the subgroup.
data.raw.item["electric-engine-unit"].subgroup = "actuator"
data.raw.item["electric-engine-unit"].order = "01"

-- Create recipe: 8 advanced parts + 1 frame + 1 red circuit + 20 lubricant -> 1 actuator
local standardRecipe = table.deepcopy(data.raw.recipe["electric-engine-unit"])
standardRecipe.name = "actuator-standard"
standardRecipe.ingredients = {
	{ type = "item",  name = "advanced-parts",   amount = 8 },
	{ type = "item",  name = "frame",            amount = 1 },
	{ type = "item",  name = "advanced-circuit", amount = 1 },
	{ type = "fluid", name = "lubricant",        amount = 20 }
}
standardRecipe.icon = nil
standardRecipe.icons = {
	{icon = "__base__/graphics/icons/electric-engine-unit.png", icon_size = 64, scale=0.5, mipmap_count=4},
	{icon = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-3.png", icon_size = 64, scale=0.25, mipmap_count=4, shift={-8, -8}},
}
data:extend{standardRecipe}
Tech.addRecipeToTech("actuator-standard", "electric-engine")

-- Hide the default recipe.
data.raw.recipe["electric-engine-unit"].hidden = true
data.raw.recipe["electric-engine-unit"].hidden_in_factoriopedia = true
Tech.removeRecipeFromTech("electric-engine-unit", "electric-engine")

-- TODO create more recipes