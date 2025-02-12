--[[ This file adds a recipe for making rocket parts outside rocket silos. Then we put those parts into the rocket silo for assembly.
Also we change the recipe for assembling them to require hydrogen and oxygen. No rocket fuel.
This is better IMO since it lets you use inserters to put blue circuits and LDS into rocket silos for transport. --]]

local assembledRocketPartItem = copy(ITEM["rocket-part"])
assembledRocketPartItem.name = "assembled-rocket-part"
--assembledRocketPartItem.localised_name = {"item-name.assembled-rocket-part"}
assembledRocketPartItem.icon = nil
assembledRocketPartItem.icons = {
	{icon = "__base__/graphics/icons/rocket-part.png", icon_size = 64},
	{icon = "__core__/graphics/icons/mip/recipe-arrow.png", icon_size = 32, shift = {0, 10}},
}
assembledRocketPartItem.order = ITEM["rocket-part"].order .. "-2"
assembledRocketPartItem.hidden = false
ITEM["rocket-part"].hidden = false
data:extend{assembledRocketPartItem}

RECIPE["rocket-part"].hide_from_player_crafting = false
RECIPE["rocket-part"].always_show_made_in = true

local rocketPartAssemblyRecipe = copy(RECIPE["rocket-part"])
rocketPartAssemblyRecipe.name = "assembled-rocket-part"
rocketPartAssemblyRecipe.ingredients = {{type = "item", name = "rocket-part", amount = 1}}
rocketPartAssemblyRecipe.results = {{type = "item", name = "assembled-rocket-part", amount = 1}}
data:extend{rocketPartAssemblyRecipe}
RAW["rocket-silo"]["rocket-silo"].fixed_recipe = "assembled-rocket-part"

RECIPE["rocket-part"].category = "crafting"

Tech.addRecipeToTech("assembled-rocket-part", "rocket-silo", 3)

-- Disable prod modules in the silo itself, since we allow prod modules in assemblers.
RAW["rocket-silo"]["rocket-silo"].allowed_module_categories = {"speed", "efficiency"}