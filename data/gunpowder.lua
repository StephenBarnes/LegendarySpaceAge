-- This file adds gunpowder item and recipes.

-- Create gunpowder item.
local gunpowderItem = copy(ITEM["sulfur"])
gunpowderItem.name = "gunpowder"
Icon.set(gunpowderItem, "LSA/gunpowder/gunpowder-1")
Icon.variants(gunpowderItem, "LSA/gunpowder/gunpowder-%", 3)
gunpowderItem.subgroup = "raw-material" -- Could put it with ammo, but it's really an intermediate.
gunpowderItem.order = "b[chemistry]-a2"
gunpowderItem.auto_recycle = true -- The item has auto_recycle (so it gets a recycling recipe), but the recipe doesn't, so quality mod doesn't see any recipe to reverse for recycling gunpowder, and therefore makes it recycle to itself.
extend{gunpowderItem}

-- Create recipe for gunpowder.
-- 2 carbon + 1 sulfur + 1 sand -> 2 gunpowder
local gunpowderRecipe = copy(RECIPE["firearm-magazine"])
gunpowderRecipe.name = "gunpowder"
gunpowderRecipe.ingredients = {
	{type="item", name="carbon", amount=2},
	{type="item", name="sulfur", amount=1},
	{type="item", name="niter", amount=5},
}
gunpowderRecipe.results = {{type = "item", name = "gunpowder", amount = 10}}
gunpowderRecipe.enabled = false -- Enabled by coal coking tech.
gunpowderRecipe.category = "chemistry-or-handcrafting"
gunpowderRecipe.auto_recycle = false
extend{gunpowderRecipe}

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
