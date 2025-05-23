--[[ This file lets the player launch strafer-style pentapod missiles.
Using the built-in proctile shot by small strafers: RAW.projectile["small-strafer-projectile"]
Not creating a new projectile. When it hits it spawns "small-wriggler-pentapod-premature" which automatically fights for you and loses 2 health per second, dying after 50 seconds.
]]

-- Create item
local ammo = copy(RAW.ammo["rocket"])
ammo.name = "wriggler-missile"
---@diagnostic disable-next-line: assign-type-mismatch
ammo.ammo_type = copy(RAW["spider-unit"]["small-strafer-pentapod"].attack_parameters.ammo_type)
Icon.set(ammo, "LSA/gleba/wriggler-missile")
--[[ Could make it spoil into activated pentapod egg, then a big wriggler hostile to you. Tested, this works. But it makes it inconvenient to use, so rather turned off.
ammo.spoil_ticks = 10 * MINUTES
ammo.spoil_result = "activated-pentapod-egg"
]]
extend{ammo}

-- Create recipe
local recipe = copy(RECIPE["rocket"])
recipe.name = "wriggler-missile"
recipe.enabled = false
recipe.ingredients = {
	{type = "item", name = "pentapod-egg", amount = 1},
	{type = "item", name = "boomsac", amount = 1},
	{type = "item", name = "panel", amount = 1},
}
recipe.results = {{type = "item", name = "wriggler-missile", amount = 1}}
Recipe.setCategories(recipe, {"organic", "crafting"})
extend{recipe}

-- Create tech
local tech = copy(TECH["bioflux"])
tech.name = "wriggler-missile"
tech.effects = {
	{type = "unlock-recipe", recipe = "wriggler-missile"},
}
tech.prerequisites = {"egg-duplication"}
tech.research_trigger = {
	type = "craft-item",
	item = "pentapod-egg",
	count = 1,
}
Icon.set(tech, "LSA/gleba/wriggler-missile-tech")
extend{tech}