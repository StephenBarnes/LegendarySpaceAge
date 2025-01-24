--[[ This file adds a recipe for making rocket parts outside rocket silos. Then we put those parts into the rocket silo for assembly.
Also we change the recipe to use hydrogen and oxygen to make the rocket parts, rather than vehicle fuel.
This is better IMO since it lets you use inserters to put blue circuits, LDS, and rocket fuel into rocket silos for transport. --]]

local Tech = require("code.util.tech")

local assembledRocketPartItem = table.deepcopy(data.raw.item["rocket-part"])
assembledRocketPartItem.name = "assembled-rocket-part"
--assembledRocketPartItem.localised_name = {"item-name.assembled-rocket-part"}
assembledRocketPartItem.icon = nil
assembledRocketPartItem.icons = {
	{icon = "__base__/graphics/icons/rocket-part.png", icon_size = 64},
	{icon = "__core__/graphics/icons/mip/recipe-arrow.png", icon_size = 32, shift = {0, 10}},
}
assembledRocketPartItem.order = data.raw.item["rocket-part"].order .. "-2"
assembledRocketPartItem.hidden = false
data.raw.item["rocket-part"].hidden = false
data:extend{assembledRocketPartItem}

local rocketPartAssemblyRecipe = table.deepcopy(data.raw.recipe["rocket-part"])
rocketPartAssemblyRecipe.name = "assembled-rocket-part"
rocketPartAssemblyRecipe.ingredients = {{type = "item", name = "rocket-part", amount = 1}}
rocketPartAssemblyRecipe.results = {{type = "item", name = "assembled-rocket-part", amount = 1}}
data:extend{rocketPartAssemblyRecipe}

data.raw.recipe["rocket-part"].category = "crafting"
data.raw["rocket-silo"]["rocket-silo"].fixed_recipe = "assembled-rocket-part"

Tech.addRecipeToTech("assembled-rocket-part", "rocket-silo", 3)