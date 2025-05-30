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

-- Change bioflux default recipe.
local cultivationRecipe = RECIPE["bioflux"]
cultivationRecipe.ingredients = {
	{type = "item", name = "bioflux", amount = 1},
	{type = "item", name = "yumako-mash", amount = 5},
	{type = "item", name = "jelly", amount = 4},
}
cultivationRecipe.results = {{type = "item", name = "bioflux", amount = 2}}
cultivationRecipe.energy_required = 5

-- Create new recipe for initial bioflux.
local initialBiofluxRecipe = copy(cultivationRecipe)
initialBiofluxRecipe.name = "bioflux-from-eggs"
initialBiofluxRecipe.ingredients = {
	{type = "item", name = "pentapod-egg", amount = 4},
	{type = "item", name = "yumako-mash", amount = 4},
	{type = "item", name = "jelly", amount = 4},
}
initialBiofluxRecipe.results = {{type = "item", name = "bioflux", amount = 1}}
Icon.set(initialBiofluxRecipe, {"bioflux", "pentapod-egg"})
extend{initialBiofluxRecipe}
Tech.addRecipeToTech("bioflux-from-eggs", "bioflux", 1)

-- Create items for fertilized seeds.
local fertilizedYumakoSeedItem = copy(ITEM["yumako-seed"])
fertilizedYumakoSeedItem.name = "fertilized-yumako-seed"
Icon.set(fertilizedYumakoSeedItem, "LSA/gleba/fertilized-seeds/yumako-seed")
Icon.variants(fertilizedYumakoSeedItem, "LSA/gleba/fertilized-seeds/yumako-seed-%", 4, {draw_as_glow=true})
fertilizedYumakoSeedItem.spoil_ticks = 10 * MINUTES
fertilizedYumakoSeedItem.spoil_result = "yumako-seed"
fertilizedYumakoSeedItem.localised_name = {"item-name.fertilized-yumako-seed"}
fertilizedYumakoSeedItem.localised_description = nil
Item.clearFuel(fertilizedYumakoSeedItem)
extend{fertilizedYumakoSeedItem}
local fertilizedJellystemSeedItem = copy(ITEM["jellynut-seed"])
fertilizedJellystemSeedItem.name = "fertilized-jellynut-seed"
Icon.set(fertilizedJellystemSeedItem, "LSA/gleba/fertilized-seeds/jellynut-seed")
Icon.variants(fertilizedJellystemSeedItem, "LSA/gleba/fertilized-seeds/jellynut-seed-%", 4, {draw_as_glow=true})
fertilizedJellystemSeedItem.spoil_ticks = 10 * MINUTES
fertilizedJellystemSeedItem.spoil_result = "jellynut-seed"
fertilizedJellystemSeedItem.localised_name = {"item-name.fertilized-jellynut-seed"}
fertilizedJellystemSeedItem.localised_description = nil
Item.clearFuel(fertilizedJellystemSeedItem)
extend{fertilizedJellystemSeedItem}

-- Rewire so crops are planted by fertilized seeds, not ordinary seeds.
ITEM["yumako-seed"].plant_result = nil
ITEM["yumako-seed"].place_result = nil
ITEM["jellynut-seed"].plant_result = nil
ITEM["jellynut-seed"].place_result = nil
RAW.plant["jellystem"].placeable_by = {item = "fertilized-jellynut-seed", count = 1}
RAW.plant["yumako-tree"].placeable_by = {item = "fertilized-yumako-seed", count = 1}

-- Change yields of jellystem and yumako - default was 50, reducing that to 30.
-- Note 1 fruit is 2 mash or 4 jelly, so roughly 1 fruits -> 1 bioflux with cultivation recipes.
RAW.plant["yumako-tree"].minable.results = {{type = "item", name = "yumako", amount_min = 20, amount_max = 40}}
RAW.plant["jellystem"].minable.results = {{type = "item", name = "jellynut", amount_min = 20, amount_max = 40}}

-- Create recipes for fertilized seeds.
local fertilizedYumakoSeedRecipe = Recipe.make{
	copy = "bioflux",
	recipe = "fertilized-yumako-seed",
	ingredients = {
		{"yumako-seed", 1},
		{"bioflux", 1},
		{"slime", 10, type = "fluid"},
	},
	resultCount = 1,
	clearIcons = true, -- So it takes the icon of the fertilized seed, instead of bioflux item.
	result_is_always_fresh = true,
	allow_productivity = false,
	allow_quality = false,
	time = 1,
}
Tech.addRecipeToTech("fertilized-yumako-seed", "yumako")

local fertilizedJellynutSeedRecipe = Recipe.make{
	copy = fertilizedYumakoSeedRecipe,
	recipe = "fertilized-jellynut-seed",
	ingredients = {
		{"jellynut-seed", 1},
		{"bioflux", 1},
		{"slime", 10, type = "fluid"},
	},
	resultCount = 1,
}
Tech.addRecipeToTech("fertilized-jellynut-seed", "jellynut")

-- Make the fruit processing recipes yield 90%-spoiled fertilized seeds. (Spoil timer is 10 minutes, so we make the fruits yield 90% spoiled seeds, so 60 seconds left.)
-- Also, increase seed output, since biochambers no longer have a prod bonus.
Recipe.edit{
	recipe = "yumako-processing",
	results = {
		{"yumako-mash", 2},
		{"fertilized-yumako-seed", 1, probability = .025, percent_spoiled = .9},
	},
}
Recipe.edit{
	recipe = "jellynut-processing",
	results = {
		{"jelly", 4},
		{"fertilized-jellynut-seed", 1, probability = .025, percent_spoiled = .9},
	},
}