-- This file makes item subgroups so we can organize stuff in the player crafting menu and Factoriopedia.
-- Also reorganizes some recipes.

data:extend{
	-- Create item subgroup for resin and circuit boards and circuits, since each of them has 3 alternative recipes.
	{
		type = "item-subgroup",
		name = "resin-and-boards",
		group = "intermediate-products",
		order = "gd",
	},

	-- Create item subgroup for all complex fluid recipes, meaning not just fractionation and cracking.
	{
		type = "item-subgroup",
		name = "complex-fluid-recipes",
		group = "intermediate-products",
		order = "a2",
	},

	-- Create subgroup for hot/cold ingots and ingot-heating recipes.
	{
		type = "item-subgroup",
		name = "ingots",
		group = "intermediate-products",
		order = "b1",
	},

	-- Create subgroup for basic metal intermediates.
	{
		type = "item-subgroup",
		name = "basic-metal-intermediates",
		group = "intermediate-products",
		order = "b2",
	},

	-- Create subgroup for circuits and advanced circuit intermediates (electronic components, silicon wafers, doped wafers).
	{
		type = "item-subgroup",
		name = "complex-circuit-intermediates",
		group = "intermediate-products",
		order = "ge",
	},

	-- Create subgroups for intermediate factors (rigid structure, etc.)
	{
		type = "item-subgroup",
		name = "rigid-structure",
		group = "intermediate-products",
		order = "c1",
	},
	{
		type = "item-subgroup",
		name = "lightweight-structure",
		group = "intermediate-products",
		order = "c2",
	},
	{
		type = "item-subgroup",
		name = "fluid-fitting",
		group = "intermediate-products",
		order = "c3",
	},
	{
		type = "item-subgroup",
		name = "thermal-casing",
		group = "intermediate-products",
		order = "c4",
	},
	{
		type = "item-subgroup",
		name = "sensor",
		group = "intermediate-products",
		order = "c5",
	},
}

------------------------------------------------------------------------

-- Move derusting row (now also the rust-items row) to after ingots etc.
data.raw["item-subgroup"]["derusting"].order = "b3"

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

-- Move fluid recipes to after raw materials like sulfur.
data.raw["item-subgroup"]["fluid-recipes"].order = "d"
data.raw["item-subgroup"]["complex-fluid-recipes"].order = "e"

-- Move nuclear stuff close to the end, before Aquilo, since we're moving nuclear to "Nauvis part 2".
data.raw["item-subgroup"]["uranium-processing"].order = "o2"

-- Move biter egg to the right row.
data.raw.item["biter-egg"].subgroup = "nauvis-agriculture"