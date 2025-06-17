--[[ This file creates recipes for processing stone into other materials, and creates those items.
TODO add gypsum, gravel, many others.
]]

local gypsum = copy(ITEM.stone)
gypsum.name = "gypsum"
Icon.set(gypsum, {"stone", tint = {.7, .8, 1}})
extend{gypsum}
-- TODO this is a placeholder for now. Get better icon.

-- Create recipe for stone crushing. TODO this is a placeholder for now, to test icons.
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