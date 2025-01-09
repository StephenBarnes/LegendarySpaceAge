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

-- Create subgroup for hot/cold ingots and ingot-heating recipes.
local ingotSubgroup = {
	type = "item-subgroup",
	name = "ingots",
	group = "intermediate-products",
	order = "b1",
}
table.insert(newData, ingotSubgroup)

-- Create subgroup for basic metal intermediates.
local basicMetalSubgroup = {
	type = "item-subgroup",
	name = "basic-metal-intermediates",
	group = "intermediate-products",
	order = "b2",
}
table.insert(newData, basicMetalSubgroup)

-- Create subgroup for circuits and advanced circuit intermediates (electronic components, silicon wafers, doped wafers).
local complexCircuitIntermediatesSubgroup = {
	type = "item-subgroup",
	name = "complex-circuit-intermediates",
	group = "intermediate-products",
	order = "ge",
}
table.insert(newData, complexCircuitIntermediatesSubgroup)

------------------------------------------------------------------------
data:extend(newData)
------------------------------------------------------------------------

-- Put water condensation and melting at the start of simple fluid recipes group.
data.raw.recipe["steam-condensation"].order = "01"
data.raw.recipe["ice-melting"].order = "02"

-- Move battery-salvage.
data.raw.recipe["extract-sulfuric-acid-from-battery"].subgroup = data.raw.item["battery"].subgroup

-- Move batteries to intermediate-product instead of raw-material.
data.raw.item["battery"].subgroup = "intermediate-product"
data.raw.item["charged-battery"].subgroup = "intermediate-product"
data.raw.item["holmium-battery"].subgroup = "intermediate-product"
data.raw.item["charged-holmium-battery"].subgroup = "intermediate-product"

-- Move rocket fuel to raw-material bc it makes more sense (sprite has canister, but no iron/steel ingredient) and balances subgroup populations better.
data.raw.item["rocket-fuel"].subgroup = "raw-material"

-- Move lubricant to complex-fluid-recipes.
data.raw.recipe["lubricant"].subgroup = "complex-fluid-recipes"

-- Reorder raw-materials line.
data.raw.item["solid-fuel"].order = "c"
data.raw.item["explosives"].order = "e"

-- Move chem plant before refinery.
data.raw.item["oil-refinery"].order = "e[refinery]"
data.raw.item["chemical-plant"].order = "d[chemical-plant]"

-- Sulfur near start of raw material line, since it now appears early in the game.
data.raw.item["sulfur"].order = "a0"