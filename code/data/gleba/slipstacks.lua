-- This file has tweaks to the Slipstack mod by LordMiguel.

-- The mod changes slipstack's minable.results from 6 spoilage, 4 stone, to 50 spoilage, 100 stone.
-- I'm reducing it, same as for yumako/jellystem plants.
-- Also making them produce some slipstack polyps sometimes.
slipstackMinableResults = {
	{type = "item", name = "spoilage", amount = 10 },
	{type = "item", name = "stone", amount_min = 20, amount_max = 40 },
	{type = "item", name = "slipstack-seed", amount = 1, probability = 0.5 }, -- TODO change to polyp which then gets turned into this seed.
}
data.raw.plant["slipstack-plant"].minable.results = slipstackMinableResults
data.raw.tree["slipstack"].minable.results = slipstackMinableResults

-- Grow time is 10 minutes. Jellystem/yumako is 5 minutes. Fulgorites 20 minutes. So I think it's fine.

-- Could move the tech to after Gleba science. But it's not very powerful, just easier than setting up new stone outposts. So, fine.

-- Change research icon to just be a slipstack.
data.raw.technology["slipstack-propagation"].icon = "__LegendarySpaceAge__/graphics/slipstack-tech.png"

-- Allow recipe in chem plant.
data.raw.recipe["slipstack-seed"].category = "organic-or-chemistry"

-- Make the polyps non-burnable, since they're supposed to be mostly rock and there's no risk of having too many.
data.raw.item["slipstack-seed"].fuel_category = nil
data.raw.item["slipstack-seed"].fuel_value = nil

-- Hide the tree.slipstack thing in the factoriopedia, rather redirect to the plant.
data.raw.tree["slipstack"].factoriopedia_alternative = "slipstack-plant"

-- Change the plant's icon in factoriopedia, bc it's currently jellystem.
data.raw.plant["slipstack-plant"].icon = data.raw.tree["slipstack"].icon
data.raw.plant["slipstack-plant"].icons = data.raw.tree["slipstack"].icons

-- TODO later I want to make this more important to the game. Maybe add more items on Gleba, and then have those produced by slipstacks. Or eg require slipstack nodules in the biosulfur recipe.