--[[ This file makes item subgroups so we can organize stuff in the player crafting menu and Factoriopedia.
Also reorganizes some recipes.
Does not handle the tab or subgroups for intermediate factors - those are in intermediate-factors/item-groups.lua.
]]

-- Change the space tab's icon, from satellite to rocket silo, since it's now anything after Nauvis.
data.raw["item-group"]["space"].icon = "__base__/graphics/technology/rocket-silo.png"
data.raw["item-group"]["space"].icon_size = 256

data:extend{
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

	-- Create subgroups for rusted items and derusting.
	{
		type = "item-subgroup",
		name = "rusty",
		group = "intermediate-products",
		order = "b3",
	},
	{
		type = "item-subgroup",
		name = "derusting",
		group = "intermediate-products",
		order = "b4",
	},

	-- Create subgroup for fluid logistics items.
	{
		type = "item-subgroup",
		name = "fluid-logistics",
		group = "logistics",
		order = "d2",
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

	-- Create subgroups for fluids by planet, etc.
	{ type = "item-subgroup", name = "nauvis-fluids",    group = "fluids", order = "01" },
	{ type = "item-subgroup", name = "petrochem-fluids", group = "fluids", order = "02" },
	{ type = "item-subgroup", name = "vulcanus-fluids",  group = "fluids", order = "03" },
	{ type = "item-subgroup", name = "gleba-fluids",     group = "fluids", order = "04" },
	{ type = "item-subgroup", name = "fulgora-fluids",   group = "fluids", order = "05" },
	{ type = "item-subgroup", name = "aquilo-fluids",    group = "fluids", order = "06" },
}

------------------------------------------------------------------------

-- Move all fluids to the right row.
for subgroup, fluids in pairs{
	nauvis = {"lake-water", "water", "steam", "latex", "cement", "sulfuric-acid", "lubricant", "thruster-fuel", "thruster-oxidizer"},
	petrochem = {"crude-oil", "natural-gas", "tar", "heavy-oil", "light-oil", "petroleum-gas", "dry-gas", "syngas"},
	vulcanus = {"lava", "volcanic-gas", "molten-iron", "molten-copper", "molten-steel", "molten-tungsten"},
	fulgora = {"fulgoran-sludge", "electrolyte", "holmium-solution"},
	gleba = {"slime", "geoplasm", "chitin-broth"},
	aquilo = {"ammoniacal-solution", "ammonia", "fluorine", "fluoroketone-hot", "fluoroketone-cold", "lithium-brine", "fusion-plasma"},
} do
	for i, fluid in pairs(fluids) do
		data.raw.fluid[fluid].subgroup = subgroup .. "-fluids"
		data.raw.fluid[fluid].order = "0" .. i
	end
end

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
	["agriculture-processes"] = "021",
	["agriculture-products"] = "022",
	["fulgora-processes"] = "03",
	["nauvis-agriculture"] = "041", -- Advanced recipes - biter egg, etc.
	["uranium-processing"] = "042",
	["aquilo-processes"] = "05",
} do
	data.raw["item-subgroup"][subgroupName].group = "space"
	data.raw["item-subgroup"][subgroupName].order = order
end

-- In space group, move space platform starter up so it's not wasting a row.
data.raw["space-platform-starter-pack"]["space-platform-starter-pack"].subgroup = "space-interactors"

-- Move fluid logistics stuff to that row.
for _, item in pairs{"pipe", "pipe-to-ground", "pump"} do
	data.raw.item[item].subgroup = "fluid-logistics"
	data.raw.recipe[item].subgroup = "fluid-logistics"
end