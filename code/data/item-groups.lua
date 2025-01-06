-- This file makes item subgroups so we can organize stuff in the player crafting menu and Factoriopedia.
-- Also reorganizes some recipes.

local newData = {}

-- Create item subgroup for resin and circuit boards and circuits, since each of them has 3 alternative recipes.
local resinAndBoardsSubgroup = {
	type = "item-subgroup",
	name = "resin-and-boards",
	group = "intermediate-products",
	order = "gd",
}
table.insert(newData, resinAndBoardsSubgroup)

-- Create item subgroup for all complex fluid recipes, meaning not just fractionation and cracking.
local complexFluidRecipesSubgroup = {
	type = "item-subgroup",
	name = "complex-fluid-recipes",
	group = "intermediate-products",
	order = "a2",
}
table.insert(newData, complexFluidRecipesSubgroup)

------------------------------------------------------------------------
data:extend(newData)
------------------------------------------------------------------------

-- Put water condensation and melting at the start of simple fluid recipes group.
data.raw.recipe["steam-condensation"].order = "01"
data.raw.recipe["ice-melting"].order = "02"

-- Move battery-salvage to complex recipes.
data.raw.recipe["extract-sulfuric-acid-from-battery"].subgroup = "complex-fluid-recipes"