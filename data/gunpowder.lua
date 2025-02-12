-- This file adds gunpowder item and recipes.

-- Create gunpowder item.
local gunpowderPictures = {}
for i = 1, 3 do
	table.insert(gunpowderPictures, {
		filename = "__LegendarySpaceAge__/graphics/gunpowder/gunpowder-" .. i .. ".png",
		size = 64,
		scale = 0.5,
		mipmap_count = 4,
	})
end
local gunpowderItem = copy(ITEM["sulfur"])
gunpowderItem.name = "gunpowder"
gunpowderItem.icons = {{icon = gunpowderPictures[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}}
gunpowderItem.pictures = gunpowderPictures
gunpowderItem.subgroup = "raw-material" -- Could put it with ammo, but it's really an intermediate.
gunpowderItem.order = "b[chemistry]-a2"
gunpowderItem.auto_recycle = true -- The item has auto_recycle (so it gets a recycling recipe), but the recipe doesn't, so quality mod doesn't see any recipe to reverse for recycling gunpowder, and therefore makes it recycle to itself.
data:extend{gunpowderItem}

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
data:extend{gunpowderRecipe}

-- Adjust ammo mag recipes
-- 4 iron plate + 1 gunpowder -> 1 yellow mag
-- 1 steel plate + 4 copper plate + 1 gunpowder -> 1 red mag (represents steel core and copper jacket)
RECIPE["firearm-magazine"].ingredients = {
	{type="item", name="iron-plate", amount=5},
	{type="item", name="gunpowder", amount=1},
}
RECIPE["piercing-rounds-magazine"].ingredients = {
	{type="item", name="steel-plate", amount=1},
	{type="item", name="copper-plate", amount=5},
	{type="item", name="gunpowder", amount=2},
}
RECIPE["piercing-rounds-magazine"].results = {{type = "item", name = "piercing-rounds-magazine", amount = 2}}
RECIPE["shotgun-shell"].ingredients = { -- Originally 2 iron plate + 2 copper plate -> 1 shotgun shell; changing to add 1 gunpowder and produce 2 shells.
	{type="item", name="iron-plate", amount=2},
	{type="item", name="copper-plate", amount=2},
	{type="item", name="gunpowder", amount=1},
}
RECIPE["shotgun-shell"].results = {{type = "item", name = "shotgun-shell", amount = 2}}

-- Create tech.
local tech = copy(TECH["rocket-fuel"])
tech.name = "gunpowder"
tech.effects = {
	{type = "unlock-recipe", recipe = "gunpowder"},
	{type = "unlock-recipe", recipe = "firearm-magazine"},
}
tech.prerequisites = {"char"}
tech.unit = nil
tech.research_trigger = {
	type = "craft-item",
	item = "carbon",
	count = 100,
}
tech.icon = "__LegendarySpaceAge__/graphics/gunpowder/tech.png"
data:extend{tech}
