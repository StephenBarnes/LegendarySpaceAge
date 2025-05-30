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
assembledRocketPartItem.hidden = false
ITEM["rocket-part"].hidden = false
assembledRocketPartItem.stack_size = 10
Item.perRocket(assembledRocketPartItem, 20)
extend{assembledRocketPartItem}

RECIPE["rocket-part"].hide_from_player_crafting = false
RECIPE["rocket-part"].always_show_made_in = true

Recipe.make{
	copy = "rocket-part",
	recipe = "assembled-rocket-part",
	ingredients = {
		{"rocket-part", 1},
		{"thruster-fuel", 10},
		{"thruster-oxidizer", 10},
	},
	resultCount = 1,
	time = 1,
}
RAW["rocket-silo"]["rocket-silo"].fixed_recipe = "assembled-rocket-part"

RECIPE["rocket-part"].category = "crafting"

Tech.addRecipeToTech("assembled-rocket-part", "rocket-silo", 3)

-- Disable prod modules in the silo itself, since we allow prod modules in assemblers.
RAW["rocket-silo"]["rocket-silo"].allowed_module_categories = {"speed", "efficiency"}