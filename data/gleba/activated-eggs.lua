-- This file creates "activated eggs" item and makes some changes to recipes etc. to implement them.

-- Create activated egg item.
local activatedEggItem = copy(ITEM["pentapod-egg"])
activatedEggItem.name = "activated-pentapod-egg"
Icon.variants(activatedEggItem, "LSA/gleba/activated-pentapod-egg/%", 4, {draw_as_glow=true})
Icon.set(activatedEggItem, "LSA/gleba/activated-pentapod-egg/1")
activatedEggItem.spoil_ticks = 30 * SECONDS
activatedEggItem.order = activatedEggItem.order .. "-2"
-- activatedEggItem.fuel_category = "activated-pentapod-egg" -- Fuel category set in constants.lua.
extend{activatedEggItem}

-- Base Space Age gives eggs 4 variants, of which 4th shows egg in the middle of splitting.
-- So we edit this so regular eggs are always only a single egg, and activated eggs can also be the 4th variant.
local originalPictures = ITEM["pentapod-egg"].pictures
assert(originalPictures ~= nil and #originalPictures >= 3)
ITEM["pentapod-egg"].pictures = {
	originalPictures[1],
	originalPictures[2],
	originalPictures[3],
}

-- Normal pentapod eggs spoil to activated eggs. Activated eggs spoil to hatch.
ITEM["pentapod-egg"].spoil_result = "activated-pentapod-egg"
ITEM["pentapod-egg"].spoil_to_trigger_result = nil
ITEM["pentapod-egg"].spoil_ticks = 10 * MINUTES -- 10 minutes, so it's not unthinkable to just let them spoil, rather than feeding them mash to deliberately activate them.

-- Create new recipe for activating eggs using mash.
local eggActivationRecipe = copy(RECIPE["pentapod-egg"])
eggActivationRecipe.name = "activated-pentapod-egg"
eggActivationRecipe.ingredients = {
	{type = "item", name = "pentapod-egg", amount = 1},
	{type = "item", name = "yumako-mash", amount = 1},
}
eggActivationRecipe.results = {
	{type = "item", name = "activated-pentapod-egg", amount = 1},
}
eggActivationRecipe.surface_conditions = nil
Icon.clear(eggActivationRecipe) -- Remove icons so it defaults to the activated egg icon.
eggActivationRecipe.order = eggActivationRecipe.order .. "-2"
extend{eggActivationRecipe}

-- Create new recipe for replicating activated eggs using slime and bioflux.
-- Sometimes produces activated eggs instead of regular eggs.
-- Old recipe was: 30 nutrients + 1 egg + 60 water -> 2 eggs.
local eggReplicationRecipe = copy(RECIPE["pentapod-egg"])
--eggReplicationRecipe.name is left as pentapod-egg so it merges with item.
eggReplicationRecipe.ingredients = {
	{type = "item", name = "activated-pentapod-egg", amount = 1},
	{type = "item", name = "bioflux", amount = 1},
	--{type = "fluid", name = "slime", amount = 5}, -- Removing this, it's just annoying.
}
eggReplicationRecipe.results = {
	{type = "item", name = "pentapod-egg", amount = 2},
	{type = "item", name = "activated-pentapod-egg", amount = 1, probability = .1},
}
eggReplicationRecipe.main_product = "pentapod-egg"
eggReplicationRecipe.surface_conditions = nil
	-- Allow it anywhere, though it's only really useful on Gleba (since science pack can only be crafted on Gleba, and pentapod labs can only be placed on Gleba).
Icon.clear(eggReplicationRecipe) -- Remove icons so it defaults to the egg icon.
RECIPE["pentapod-egg"] = eggReplicationRecipe

-- Create tech for egg duplication etc. instead of having it in the bioflux tech.
local tech = copy(TECH["bioflux"])
tech.name = "egg-duplication"
tech.effects = {
	{type = "unlock-recipe", recipe = "activated-pentapod-egg"},
	{type = "unlock-recipe", recipe = "pentapod-egg"},
}
tech.research_trigger = {
	type = "craft-item",
	item = "bioflux",
	count = 1,
}
tech.prerequisites = {"bioflux"}
Icon.set(tech, "LSA/gleba/egg-tech")
extend{tech}
Tech.removeRecipeFromTech("pentapod-egg", "bioflux")
Tech.removeRecipeFromTech("pentapod-egg", "biochamber")