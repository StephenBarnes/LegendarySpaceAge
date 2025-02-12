--[[ This file makes item subgroups so we can organize stuff in the player crafting menu and Factoriopedia.
Also reorganizes some recipes.
Does not handle the tab or subgroups for intermediate factors - those are in intermediate-factors/item-groups.lua.
]]

-- Change the space tab's icon, from satellite to rocket silo, since it's now anything after Nauvis.
RAW["item-group"]["space"].icon = "__base__/graphics/technology/rocket-silo.png"
RAW["item-group"]["space"].icon_size = 256

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

	-- Subgroups for production tab.
	{
		type = "item-subgroup",
		name = "electricity-related",
		group = "production",
		order = "b2",
	},
	{
		type = "item-subgroup",
		name = "chemical-processing",
		group = "production",
		order = "e2",
	},
	{
		type = "item-subgroup",
		name = "planetary-special",
		group = "production",
		order = "e3",
	},
	{
		type = "item-subgroup",
		name = "labs",
		group = "production",
		order = "f",
	},

	-- Create subgroups for fluids by planet, etc.
	{ type = "item-subgroup", name = "nauvis-fluids",    group = "fluids", order = "01" },
	{ type = "item-subgroup", name = "petrochem-fluids", group = "fluids", order = "02" },
	{ type = "item-subgroup", name = "vulcanus-fluids",  group = "fluids", order = "03" },
	{ type = "item-subgroup", name = "gleba-fluids",     group = "fluids", order = "04" },
	{ type = "item-subgroup", name = "fulgora-fluids",   group = "fluids", order = "05" },
	{ type = "item-subgroup", name = "aquilo-fluids",    group = "fluids", order = "06" },

	-- Subgroup for post-Nauvis science packs.
	{ type = "item-subgroup", name = "alien-science-packs", group = "intermediate-products", order = "y2" },

	-- Subgroups for Gleba.
	{ type = "item-subgroup", name = "spoilage-and-nutrients", group = "space", order = "0200" },
	{ type = "item-subgroup", name = "yumako-and-jellynut", group = "space", order = "0201" },
	{ type = "item-subgroup", name = "slipstacks-and-boompuffs", group = "space", order = "022b" },

	-- Subgroup for Fulgora biological processes.
	{ type = "item-subgroup", name = "fulgora-agriculture", group = "space", order = "031" },
}

------------------------------------------------------------------------

local function setSubgroupInOrder(subgroup, kind, things, prefix)
	if prefix == nil then prefix = "" end
	for i, thing in pairs(things) do
		if RAW[kind][thing] == nil then
			error("Not found: RAW[" .. kind .. "][" .. thing .. "]")
		end
		RAW[kind][thing].subgroup = subgroup
		RAW[kind][thing].order = prefix .. string.format("%02d", i)
	end
end

------------------------------------------------------------------------

-- Move all fluids to the right row.
for subgroup, fluids in pairs{
	nauvis = {"lake-water", "water", "steam", "ammonia", "latex", "cement", "sulfuric-acid", "lubricant", "thruster-fuel", "thruster-oxidizer"},
	petrochem = {"crude-oil", "natural-gas", "tar", "heavy-oil", "light-oil", "petroleum-gas", "dry-gas", "syngas", "diesel"},
	vulcanus = {"lava", "volcanic-gas", "molten-iron", "molten-copper", "molten-steel", "molten-tungsten"},
	fulgora = {"fulgoran-sludge", "electrolyte", "holmium-solution"},
	gleba = {"slime", "geoplasm", "chitin-broth"},
	aquilo = {"ammoniacal-solution", "fluorine", "fluoroketone-hot", "fluoroketone-cold", "lithium-brine", "fusion-plasma"},
} do
	setSubgroupInOrder(subgroup .. "-fluids", "fluid", fluids)
end

-- Move battery-salvage.
RECIPE["extract-sulfuric-acid-from-battery"].subgroup = ITEM["battery"].subgroup

-- Move batteries to intermediate-product instead of raw-material.
ITEM["battery"].subgroup = "intermediate-product"
ITEM["charged-battery"].subgroup = "intermediate-product"
ITEM["holmium-battery"].subgroup = "intermediate-product"
ITEM["charged-holmium-battery"].subgroup = "intermediate-product"

-- Move rocket fuel to raw-material bc it makes more sense (sprite has canister, but no iron/steel ingredient) and balances subgroup populations better.
ITEM["rocket-fuel"].subgroup = "raw-material"

-- Move lubricant to complex-fluid-recipes.
RECIPE["lubricant"].subgroup = "complex-fluid-recipes"

-- Reorder raw-materials line.
ITEM["solid-fuel"].order = "c"
ITEM["explosives"].order = "e"

-- Move chem plant before refinery.
ITEM["oil-refinery"].order = "e[refinery]"
ITEM["chemical-plant"].order = "d[chemical-plant]"

-- Sulfur near start of raw material line, since it now appears early in the game.
ITEM["sulfur"].order = "a0"

-- Move fluid recipes to after raw materials like sulfur.
RAW["item-subgroup"]["fluid-recipes"].order = "d"

-- Move biter egg to the right row.
ITEM["biter-egg"].subgroup = "nauvis-agriculture"

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
	RAW["item-subgroup"][subgroupName].group = "space"
	RAW["item-subgroup"][subgroupName].order = order
end

-- In space group, move space platform starter up so it's not wasting a row.
RAW["space-platform-starter-pack"]["space-platform-starter-pack"].subgroup = "space-interactors"

-- Move fluid logistics stuff to that row.
local fluidLogistics = {"pipe", "pipe-to-ground", "pump", "offshore-pump"}
setSubgroupInOrder("fluid-logistics", "item", fluidLogistics)
setSubgroupInOrder("fluid-logistics", "recipe", fluidLogistics)

-- Move post-Nauvis science packs to the right row.
local sciencePacks = {"metallurgic-science-pack", "agricultural-science-pack", "electromagnetic-science-pack", "nuclear-science-pack", "cryogenic-science-pack", "promethium-science-pack"}
setSubgroupInOrder("alien-science-packs", "tool", sciencePacks)
setSubgroupInOrder("alien-science-packs", "recipe", sciencePacks)

-- Move rocket parts to space section.
local rocketParts = {"rocket-part", "assembled-rocket-part"}
setSubgroupInOrder("space-interactors", "item", rocketParts, "e")
setSubgroupInOrder("space-interactors", "recipe", rocketParts, "e")

-- Populate Gleba subgroups: spoilage-and-nutrients, yumako-and-jellynut, slipstacks-and-boompuffs.
setSubgroupInOrder("spoilage-and-nutrients", "item", {"spoilage", "sugars", "nutrients"})
setSubgroupInOrder("spoilage-and-nutrients", "recipe", {"nutrients-from-spoilage", "nutrients-from-yumako-mash", "nutrients-from-bioflux", "nutrients-from-marrow"})
setSubgroupInOrder("yumako-and-jellynut", "item", {"yumako-seed", "jellynut-seed", "fertilized-yumako-seed", "fertilized-jellynut-seed"}, "1")
setSubgroupInOrder("yumako-and-jellynut", "capsule", {"yumako", "jellynut", "yumako-mash", "jelly"}, "2")
setSubgroupInOrder("yumako-and-jellynut", "recipe", {"fertilized-yumako-seed", "fertilized-jellynut-seed", "yumako-processing", "jellynut-processing"}, "3")

-- Populate Fulgora agricultural processes.
setSubgroupInOrder("fulgora-agriculture", "item", {"fulgorite-shard", "electrophage", "polysalt", "fulgorite-starter"}, "1")
setSubgroupInOrder("fulgora-agriculture", "recipe", {"electrophage-cultivation", "electrophage-cultivation-holmium", "fulgorite-starter"}, "2")

-- Reorganize production tab.
local electricityRelated = {"solar-panel", "battery-charger", "battery-discharger", "accumulator", "lightning-rod", "lightning-collector"}
setSubgroupInOrder("electricity-related", "item", electricityRelated)
setSubgroupInOrder("electricity-related", "recipe", electricityRelated)
local planetarySpecial = {"foundry", "biochamber", "recycler", "electromagnetic-plant", "captive-biter-spawner", "centrifuge", "nuclear-reactor", "cryogenic-plant", "fusion-reactor", "fusion-generator"}
setSubgroupInOrder("planetary-special", "item", planetarySpecial)
setSubgroupInOrder("planetary-special", "recipe", planetarySpecial)
local chemicalProcessing = {"chemical-plant", "oil-refinery", "gasifier", "fluid-fuelled-gasifier"}
setSubgroupInOrder("chemical-processing", "item", chemicalProcessing)
setSubgroupInOrder("chemical-processing", "recipe", chemicalProcessing)
ITEM["agricultural-tower"].subgroup = "extraction-machine"
ITEM["agricultural-tower"].order = "c"
local labs = {"lab", "glebalab", "biolab"}
setSubgroupInOrder("labs", "item", labs)
setSubgroupInOrder("labs", "recipe", labs)
setSubgroupInOrder("labs", "lab", labs)