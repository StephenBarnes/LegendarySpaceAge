--[[ This file adds items and recipes related to wood.
Eg wood chips item, and recipe for crushing wood.
]]

-- Create item for wood chips.
local woodChipsItem = copy(ITEM.wood)
woodChipsItem.name = "wood-chips"
Icon.set(woodChipsItem, "LSA/crushed/wood-chips/1")
Icon.variants(woodChipsItem, "LSA/crushed/wood-chips/%", 3)
extend{woodChipsItem}

-- Create recipe for wood chips.
Recipe.make{
	recipe = "wood-chips",
	copy = "stone-brick",
	category = "crushing",
	ingredients = {"wood"},
	main_product = "wood-chips",
	resultCount = 2,
	enabled = true, -- TODO add to crushing tech probably.
	-- TODO recipe tint
}

-- Recipe for classifying wood chips to filler.
Recipe.make{
	recipe = "filler-from-wood-chips",
	copy = "stone-brick",
	categories = {"crafting", "mini-assembling"},
	ingredients = {"wood-chips"},
	results = {"filler"},
	time = 0.1,
	icons = {"filler", "wood-chips"},
}

-- TODO recipe for making spoilage from wood, etc.
