-- This file makes item subgroups so we can organize stuff in the player crafting menu and Factoriopedia.
-- Also reorganizes some recipes.

-- Change the space tab's icon, from satellite to rocket silo, since it's now anything after Nauvis.
data.raw["item-group"]["space"].icon = "__base__/graphics/technology/rocket-silo.png"
data.raw["item-group"]["space"].icon_size = 256

data:extend{
	-- Create a new tab for "intermediate factors".
	{
		type = "item-group",
		name = "intermediate-factors",
		order = "c2",
		icon = "__LegendarySpaceAge__/graphics/intermediate-factors/factors-tab.png",
		icon_size = 256,
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

	-- Create subgroups for intermediate factors
	{
		type = "item-subgroup",
		name = "frame",
		group = "intermediate-factors",
		order = "c1",
	},
	{
		type = "item-subgroup",
		name = "panel",
		group = "intermediate-factors",
		order = "c2",
	},
	{
		type = "item-subgroup",
		name = "structure",
		group = "intermediate-factors",
		order = "c3",
	},
	{
		type = "item-subgroup",
		name = "fluid-fitting",
		group = "intermediate-factors",
		order = "c4",
	},
	{
		type = "item-subgroup",
		name = "shielding",
		group = "intermediate-factors",
		order = "c5",
	},
	{
		type = "item-subgroup",
		name = "lightweight-structure",
		group = "intermediate-factors",
		order = "c6",
	},
	{
		type = "item-subgroup",
		name = "mechanism",
		group = "intermediate-factors",
		order = "c7",
	},
	{
		type = "item-subgroup",
		name = "sensor",
		group = "intermediate-factors",
		order = "c8",
	},
	{
		type = "item-subgroup",
		name = "resin",
		group = "intermediate-factors",
		order = "c91",
	},
	{
		type = "item-subgroup",
		name = "circuit-board",
		group = "intermediate-factors",
		order = "c92",
	},

	-- Create subgroup for circuits and advanced circuit intermediates (electronic components, silicon wafers, doped wafers).
	{
		type = "item-subgroup",
		name = "complex-circuit-intermediates",
		group = "intermediate-products",
		order = "c7",
	},

	-- Create item subgroup for all complex fluid recipes, meaning not just fractionation and cracking.
	{
		type = "item-subgroup",
		name = "complex-fluid-recipes",
		group = "intermediate-products",
		order = "e",
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

-- Move biter egg to the right row.
data.raw.item["biter-egg"].subgroup = "nauvis-agriculture"

-- Move intermediate subgroups to the space group.
for subgroupName, order in pairs{
	["vulcanus-processes"] = "01",
	["fulgora-processes"] = "02",
	["agriculture-processes"] = "031",
	["agriculture-products"] = "032",
	["nauvis-agriculture"] = "041", -- Advanced recipes - biter egg, etc.
	["uranium-processing"] = "042",
	["aquilo-processes"] = "05",
} do
	data.raw["item-subgroup"][subgroupName].group = "space"
	data.raw["item-subgroup"][subgroupName].order = order
end

-- In space group, move space platform starter up so it's not wasting a row.
data.raw["space-platform-starter-pack"]["space-platform-starter-pack"].subgroup = "space-interactors"

-- Hide the new cargo pods from Cargo Pod Requires Research
data.raw["temporary-container"]["breaking-cargo-pod-container"].hidden_in_factoriopedia = true
data.raw["temporary-container"]["breaking-cargo-pod-container"].factoriopedia_alternative = "cargo-pod-container"
data.raw["temporary-container"]["durable-cargo-pod-container"].hidden_in_factoriopedia = true
data.raw["temporary-container"]["durable-cargo-pod-container"].factoriopedia_alternative = "cargo-pod-container"