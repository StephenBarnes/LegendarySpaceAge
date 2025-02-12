--[[ This file changes bioflux and yumako/jellynut farming to be more complex.

For bioflux:
	(Original recipe: 15 mash + 12 jelly -> 4 bioflux (actually 6 with prod bonus))
	Initial bioflux: 4 dormant egg + 4 mash + 4 jelly -> 1 bioflux
		This is meant to be impossible to scale - making the dormant eggs requires like 2 bioflux, so this is net-negative. It's just for getting initial bioflux.
	Cultivating bioflux: 1 bioflux + 5 mash + 4 jelly -> 2 bioflux (actually 3 with prod bonus, so +2.)
		Mash and jelly amounts chosen to match original recipe.

For crops:
	Yumako fertilization: 1 dormant yumako seed + 1 bioflux + 10 slime -> 1 fertilized yumako seed
		Fertilized yumako seed spoils into dormant yumako seed.
	Yumako farming: 1 fertilized yumako seed -> 1 yumako tree, harvested to yield 30 yumako fruit.
	Yumako fruit processing: 1 yumako fruit -> 8 mash + 2% 1 dormant yumako seed
	Jellystem recipes are the same as yumako, but swapping jelly/mash and jellynut/yumako fruit.
]]

local Tech = require("code.util.tech")
local Item = require("code.util.item")

-- Change bioflux default recipe.
local cultivationRecipe = data.raw.recipe["bioflux"]
cultivationRecipe.ingredients = {
	{type = "item", name = "bioflux", amount = 1},
	{type = "item", name = "yumako-mash", amount = 5},
	{type = "item", name = "jelly", amount = 4},
}
cultivationRecipe.results = {{type = "item", name = "bioflux", amount = 2}}

-- Create new recipe for initial bioflux.
local initialBiofluxRecipe = table.deepcopy(cultivationRecipe)
initialBiofluxRecipe.name = "bioflux-from-eggs"
initialBiofluxRecipe.ingredients = {
	{type = "item", name = "pentapod-egg", amount = 4},
	{type = "item", name = "yumako-mash", amount = 4},
	{type = "item", name = "jelly", amount = 4},
}
initialBiofluxRecipe.results = {{type = "item", name = "bioflux", amount = 1}}
initialBiofluxRecipe.icon = nil
initialBiofluxRecipe.icons = {
	{icon = "__space-age__/graphics/icons/pentapod-egg.png", size = 64, scale = 0.35, shift = {-5, -5}},
	{icon = "__space-age__/graphics/icons/bioflux.png", size = 64, scale = 0.35, shift = {5, 5}},
}
data:extend{initialBiofluxRecipe}
Tech.addRecipeToTech("bioflux-from-eggs", "bioflux", 1)

-- Create items for fertilized seeds.
local fertilizedDir = "__LegendarySpaceAge__/graphics/gleba/fertilized-seeds/"
local fertilizedYumakoSeedItem = table.deepcopy(data.raw.item["yumako-seed"])
fertilizedYumakoSeedItem.name = "fertilized-yumako-seed"
fertilizedYumakoSeedItem.icon = fertilizedDir .. "yumako-seed.png"
fertilizedYumakoSeedItem.pictures = {}
for i = 1, 4 do
	fertilizedYumakoSeedItem.pictures[i] = {filename = fertilizedDir .. "yumako-seed-" .. i .. ".png", draw_as_glow = true, size = 64, scale = .5}
end
fertilizedYumakoSeedItem.spoil_ticks = 60 * 60 * 10
fertilizedYumakoSeedItem.spoil_result = "yumako-seed"
fertilizedYumakoSeedItem.localised_name = {"item-name.fertilized-yumako-seed"}
fertilizedYumakoSeedItem.localised_description = nil
Item.clearFuel(fertilizedYumakoSeedItem)
data:extend{fertilizedYumakoSeedItem}
local fertilizedJellystemSeedItem = table.deepcopy(data.raw.item["jellynut-seed"])
fertilizedJellystemSeedItem.name = "fertilized-jellynut-seed"
fertilizedJellystemSeedItem.icon = fertilizedDir .. "jellynut-seed.png"
fertilizedJellystemSeedItem.pictures = {}
for i = 1, 4 do
	fertilizedJellystemSeedItem.pictures[i] = {filename = fertilizedDir .. "jellynut-seed-" .. i .. ".png", draw_as_glow = true, size = 64, scale = .5}
end
fertilizedJellystemSeedItem.spoil_ticks = 60 * 60 * 10
fertilizedJellystemSeedItem.spoil_result = "jellynut-seed"
fertilizedJellystemSeedItem.localised_name = {"item-name.fertilized-jellynut-seed"}
fertilizedJellystemSeedItem.localised_description = nil
Item.clearFuel(fertilizedJellystemSeedItem)
data:extend{fertilizedJellystemSeedItem}

-- Rewire so crops are planted by fertilized seeds, not ordinary seeds.
data.raw.item["yumako-seed"].plant_result = nil
data.raw.item["yumako-seed"].place_result = nil
data.raw.item["jellynut-seed"].plant_result = nil
data.raw.item["jellynut-seed"].place_result = nil
data.raw.plant["jellystem"].placeable_by = {item = "fertilized-jellynut-seed", count = 1}
data.raw.plant["yumako-tree"].placeable_by = {item = "fertilized-yumako-seed", count = 1}

-- Change yields of jellystem and yumako - default was 50, reducing that to 30.
-- Note 1 fruit is 2 mash or 4 jelly, so roughly 1 fruits -> 1 bioflux with cultivation recipes.
data.raw.plant["yumako-tree"].minable.results = {{type = "item", name = "yumako", amount_min = 20, amount_max = 40}}
data.raw.plant["jellystem"].minable.results = {{type = "item", name = "jellynut", amount_min = 20, amount_max = 40}}

-- Create recipes for fertilized seeds.
local fertilizedYumakoSeedRecipe = table.deepcopy(data.raw.recipe["bioflux"])
fertilizedYumakoSeedRecipe.name = "fertilized-yumako-seed"
fertilizedYumakoSeedRecipe.ingredients = {
	{type = "item", name = "yumako-seed", amount = 1},
	{type = "item", name = "bioflux", amount = 1},
	{type = "fluid", name = "slime", amount = 10},
}
fertilizedYumakoSeedRecipe.results = {{type = "item", name = "fertilized-yumako-seed", amount = 1}}
fertilizedYumakoSeedRecipe.icon = nil -- So it takes the icon of the fertilized seed, instead of bioflux item.
fertilizedYumakoSeedRecipe.result_is_always_fresh = true
fertilizedYumakoSeedRecipe.maximum_productivity = 0
fertilizedYumakoSeedRecipe.energy_required = 2
data:extend{fertilizedYumakoSeedRecipe}
Tech.addRecipeToTech("fertilized-yumako-seed", "yumako")

local fertilizedJellystemSeedRecipe = table.deepcopy(fertilizedYumakoSeedRecipe)
fertilizedJellystemSeedRecipe.name = "fertilized-jellynut-seed"
fertilizedJellystemSeedRecipe.ingredients = {
	{type = "item", name = "jellynut-seed", amount = 1},
	{type = "item", name = "bioflux", amount = 1},
	{type = "fluid", name = "slime", amount = 10},
}
fertilizedJellystemSeedRecipe.results = {{type = "item", name = "fertilized-jellynut-seed", amount = 1}}
fertilizedJellystemSeedRecipe.result_is_always_fresh = true
fertilizedJellystemSeedRecipe.maximum_productivity = 0
data:extend{fertilizedJellystemSeedRecipe}
Tech.addRecipeToTech("fertilized-jellynut-seed", "jellynut")

-- Make the fruit processing recipes yield 90%-spoiled fertilized seeds. (Spoil timer is 10 minutes, so we make the fruits yield 90% spoiled seeds, so 60 seconds left.)
data.raw.recipe["yumako-processing"].results = {
	{type = "item", name = "yumako-mash", amount = 2},
	{type = "item", name = "fertilized-yumako-seed", amount = 1, probability = .02, percent_spoiled = .9},
}
data.raw.recipe["jellynut-processing"].results = {
	{type = "item", name = "jelly", amount = 4},
	{type = "item", name = "fertilized-jellynut-seed", amount = 1, probability = .02, percent_spoiled = .9},
}
