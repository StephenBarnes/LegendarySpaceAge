--[[ This file creates recipes for processing stone into other materials, and creates those items.
TODO add gypsum, gravel, many others.
]]

local gypsum = copy(ITEM.stone)
gypsum.name = "gypsum"
Icon.set(gypsum, "LSA/stone-processing/gypsum/1")
Icon.variants(gypsum, "LSA/stone-processing/gypsum/%", 4)
extend{gypsum}

-- Create recipe for stone crushing.
Recipe.make{
	copy = RECIPE.barrel,
	recipe = "stone-crushing",
	ingredients = {"stone"},
	results = {"sand"}, -- TODO will later return more.
	time = 1,
	category = "crushing",
	icons = {"stone"},
	iconArrangement = "crushing",
	enabled = true, -- TODO
}