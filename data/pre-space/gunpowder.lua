-- This file adds gunpowder item and recipes.

-- Create gunpowder item.
local gunpowderItem = copy(ITEM["sulfur"])
gunpowderItem.name = "gunpowder"
Icon.set(gunpowderItem, "LSA/gunpowder/gunpowder-1")
Icon.variants(gunpowderItem, "LSA/gunpowder/gunpowder-%", 3)
gunpowderItem.auto_recycle = true -- The item has auto_recycle (so it gets a recycling recipe), but the recipe doesn't, so quality mod doesn't see any recipe to reverse for recycling gunpowder, and therefore makes it recycle to itself.
extend{gunpowderItem}

-- Create recipe for gunpowder.
-- 2 carbon + 1 sulfur + 1 sand -> 2 gunpowder
Recipe.make{
	copy = "firearm-magazine",
	recipe = "gunpowder",
	ingredients = {
		{"carbon", 2},
		{"sulfur", 1},
		{"niter", 5},
	},
	resultCount = 10,
	enabled = false, -- Enabled by coal coking tech.
	categories = {"chemistry", "handcrafting"},
	auto_recycle = false,
	crafting_machine_tint = {
		primary = {0.5, 0.5, 0.5},
		secondary = {0.2, 0.2, 0.2},
	},
}

-- Create tech.
local tech = copy(TECH["rocket-fuel"])
tech.name = "gunpowder"
tech.effects = {
	{type = "unlock-recipe", recipe = "gunpowder"},
	{type = "unlock-recipe", recipe = "shotgun-shell"},
	{type = "unlock-recipe", recipe = "shotgun"},
}
tech.prerequisites = {"char"}
tech.unit = nil
tech.research_trigger = {
	type = "craft-item",
	item = "carbon",
	count = 20,
}
Icon.set(tech, "LSA/gunpowder/tech")
extend{tech}
