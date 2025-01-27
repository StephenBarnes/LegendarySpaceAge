-- This file creates "activated eggs" item and makes some changes to recipes etc. to implement them.

local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

-- Create activated egg item.
local activatedEggItem = table.deepcopy(data.raw.item["pentapod-egg"])
activatedEggItem.name = "activated-pentapod-egg"
activatedEggItem.pictures = {
	{filename = "__LegendarySpaceAge__/graphics/gleba/activated-pentapod-egg/main.png", size = 64, scale = 0.5},
	{filename = "__LegendarySpaceAge__/graphics/gleba/activated-pentapod-egg/1.png", size = 64, scale = 0.5},
	{filename = "__LegendarySpaceAge__/graphics/gleba/activated-pentapod-egg/2.png", size = 64, scale = 0.5},
	{filename = "__LegendarySpaceAge__/graphics/gleba/activated-pentapod-egg/3.png", size = 64, scale = 0.5},
}
activatedEggItem.icons = nil
activatedEggItem.icon = activatedEggItem.pictures[4].filename
activatedEggItem.spoil_ticks = 60 * 30 -- 30 seconds
activatedEggItem.order = activatedEggItem.order .. "-2"
activatedEggItem.fuel_category = "activated-pentapod-egg"
data:extend{activatedEggItem}

-- Base Space Age gives eggs 4 variants, of which 4th shows egg in the middle of splitting.
-- So we edit this so regular eggs are always only a single egg, and activated eggs can also be the 4th variant.
local originalPictures = data.raw.item["pentapod-egg"].pictures
assert(originalPictures ~= nil and #originalPictures >= 3)
data.raw.item["pentapod-egg"].pictures = {
	originalPictures[1],
	originalPictures[2],
	originalPictures[3],
}

-- Normal pentapod eggs spoil to activated eggs. Activated eggs spoil to hatch.
data.raw.item["pentapod-egg"].spoil_result = "activated-pentapod-egg"
data.raw.item["pentapod-egg"].spoil_to_trigger_result = nil
data.raw.item["pentapod-egg"].spoil_ticks = 60 * 60 * 10 -- 10 minutes, so it's not unthinkable to just let them spoil, rather than feeding them mash to deliberately activate them.

-- Create new recipe for activating eggs using mash.
local eggActivationRecipe = table.deepcopy(data.raw.recipe["pentapod-egg"])
eggActivationRecipe.name = "activated-pentapod-egg"
eggActivationRecipe.ingredients = {
	{type = "item", name = "pentapod-egg", amount = 1},
	{type = "item", name = "yumako-mash", amount = 1},
}
eggActivationRecipe.results = {
	{type = "item", name = "activated-pentapod-egg", amount = 1},
}
eggActivationRecipe.surface_conditions = nil
-- Remove icons so it defaults to the activated egg icon.
eggActivationRecipe.icon = nil
eggActivationRecipe.icons = nil
eggActivationRecipe.order = eggActivationRecipe.order .. "-2"
data:extend{eggActivationRecipe}
Tech.addRecipeToTech("activated-pentapod-egg", "biochamber")

-- Create new recipe for replicating activated eggs using slime and bioflux.
-- Sometimes produces activated eggs instead of regular eggs.
-- Old recipe was: 30 nutrients + 1 egg + 60 water -> 2 eggs.
local eggReplicationRecipe = table.deepcopy(data.raw.recipe["pentapod-egg"])
--eggReplicationRecipe.name is left as pentapod-egg so it merges with item.
eggReplicationRecipe.ingredients = {
	{type = "item", name = "activated-pentapod-egg", amount = 1},
	{type = "item", name = "bioflux", amount = 1},
	{type = "fluid", name = "slime", amount = 30},
}
eggReplicationRecipe.results = {
	{type = "item", name = "pentapod-egg", amount = 2},
	{type = "item", name = "activated-pentapod-egg", amount = 1, probability = .1},
}
eggReplicationRecipe.main_product = "pentapod-egg"
-- It needs slime, so it's not easy on other planets. But you can barrel slime, so it's possible.
eggReplicationRecipe.surface_conditions = nil
-- Remove icons so it defaults to the egg icon.
eggReplicationRecipe.icon = nil
eggReplicationRecipe.icons = nil
data.raw.recipe["pentapod-egg"] = eggReplicationRecipe