--[[ This file makes item subgroups so we can organize stuff in the player crafting menu and Factoriopedia.
Also reorganizes some recipes.
Does not handle the tab or subgroups for intermediate factors - those are in intermediate-factors/item-groups.lua.

TODO rewrite setSubgroupInOrder to use Gen.orderKinds.
TODO also rewrite all the manual for-loops etc to use Gen.orderKinds.
]]

-- Change the space tab's icon, from satellite to rocket silo, since it's now anything after Nauvis.
local originalSpaceIcon = RAW["item-group"].space.icon
local originalSpaceIconSize = RAW["item-group"].space.icon_size
RAW["item-group"]["space"].icon = "__base__/graphics/technology/rocket-silo.png"
RAW["item-group"]["space"].icon_size = 256

-- Create item group for other planets and Nauvis.
extend{{
	type = "item-group",
	name = "post-space",
	order = "d2",
	icon = originalSpaceIcon,
	icon_size = originalSpaceIconSize,
}}

extend{
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

	{ -- Create subgroup for rusted items and derusting.
		type = "item-subgroup",
		name = "rust",
		group = "intermediate-products",
		order = "b3",
	},

	-- Create subgroup for fluid logistics items.
	{
		type = "item-subgroup",
		name = "fluid-logistics",
		group = "logistics",
		order = "d2",
	},

	-- Create subgroup for petroleum materials (plastic, rubber, etc.)
	{
		type = "item-subgroup",
		name = "petroleum-materials",
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
	{ type = "item-subgroup", name = "spoilage-and-nutrients", group = "post-space", order = "0200" },
	{ type = "item-subgroup", name = "yumako-and-jellynut", group = "post-space", order = "0201" },
	{ type = "item-subgroup", name = "slipstacks-and-boompuffs", group = "post-space", order = "022b" },

	-- Subgroup for Fulgora biological processes.
	{ type = "item-subgroup", name = "fulgora-agriculture", group = "post-space", order = "031" },
}

------------------------------------------------------------------------

local function setSubgroupInOrder(subgroup, kinds, things, prefix)
	if prefix == nil then prefix = "" end
	if type(kinds) == "string" then kinds = {kinds} end
	for _, kind in pairs(kinds) do
		for i, thing in pairs(things) do
			if RAW[kind][thing] == nil then
				error("Not found: RAW[" .. kind .. "][" .. thing .. "]")
			end
			RAW[kind][thing].subgroup = subgroup
			RAW[kind][thing].order = prefix .. string.format("%02d", i)
		end
	end
end

------------------------------------------------------------------------

-- Move all fluids to the right row.
for subgroup, fluids in pairs{
	nauvis = {"lake-water", "water", "steam", "ammonia", "latex", "cement", "sulfuric-acid", "lubricant", "thruster-fuel", "thruster-oxidizer"},
	petrochem = {"crude-oil", "natural-gas", "tar", "heavy-oil", "light-oil", "petroleum-gas", "dry-gas", "syngas", "diesel"},
	vulcanus = {"lava", "volcanic-gas", "molten-iron", "molten-copper", "molten-steel", "molten-tungsten"},
	fulgora = {"fulgoran-sludge", "holmium-solution", "electrolyte"},
	gleba = {"slime", "geoplasm", "chitin-broth"},
	aquilo = {"ammoniacal-solution", "fluorine", "fluoroketone-hot", "fluoroketone-cold", "lithium-brine", "fusion-plasma"},
} do
	setSubgroupInOrder(subgroup .. "-fluids", "fluid", fluids)
end

-- Move lubricant to complex-fluid-recipes.
RECIPE["lubricant"].subgroup = "complex-fluid-recipes"

-- Move fluid recipes to after raw materials like sulfur.
RAW["item-subgroup"]["fluid-recipes"].order = "d"

-- Move biter egg to the right row.
ITEM["biter-egg"].subgroup = "nauvis-agriculture"

-- Move intermediate subgroups to the post-space group.
for subgroupName, order in pairs{
	["vulcanus-processes"] = "01",
	["agriculture-processes"] = "021",
	["agriculture-products"] = "022",
	["fulgora-processes"] = "03",
	["nauvis-agriculture"] = "041", -- Advanced recipes - biter egg, etc.
	["uranium-processing"] = "042",
	["aquilo-processes"] = "05",
} do
	RAW["item-subgroup"][subgroupName].group = "post-space"
	RAW["item-subgroup"][subgroupName].order = order
end

-- In space group, move space platform starter up so it's not wasting a row.
RAW["space-platform-starter-pack"]["space-platform-starter-pack"].subgroup = "space-interactors"

-- Move fluid logistics stuff to that row.
local fluidLogistics = {"pipe", "pipe-to-ground", "pump", "offshore-pump"}
setSubgroupInOrder("fluid-logistics", {"item", "recipe"}, fluidLogistics)

-- Move post-Nauvis science packs to the right row.
local sciencePacks = {"metallurgic-science-pack", "agricultural-science-pack", "electromagnetic-science-pack", "nuclear-science-pack", "cryogenic-science-pack", "promethium-science-pack"}
setSubgroupInOrder("alien-science-packs", {"tool", "recipe"}, sciencePacks)

-- Move rocket parts to space section.
local rocketParts = {"rocket-part", "assembled-rocket-part"}
setSubgroupInOrder("space-interactors", {"item", "recipe"}, rocketParts, "e")

-- Populate Gleba subgroups: spoilage-and-nutrients, yumako-and-jellynut, slipstacks-and-boompuffs.
setSubgroupInOrder("spoilage-and-nutrients", "item", {"spoilage", "sugar", "nutrients"})
setSubgroupInOrder("spoilage-and-nutrients", "recipe", {"nutrients-from-spoilage", "nutrients-from-yumako-mash", "nutrients-from-bioflux", "nutrients-from-marrow"})
setSubgroupInOrder("yumako-and-jellynut", "item", {"yumako-seed", "jellynut-seed", "fertilized-yumako-seed", "fertilized-jellynut-seed"}, "1")
setSubgroupInOrder("yumako-and-jellynut", "capsule", {"yumako", "jellynut", "yumako-mash", "jelly"}, "2")
setSubgroupInOrder("yumako-and-jellynut", "recipe", {"fertilized-yumako-seed", "fertilized-jellynut-seed", "yumako-processing", "jellynut-processing"}, "3")

-- Populate Fulgora agricultural processes.
setSubgroupInOrder("fulgora-agriculture", "item", {"fulgorite-shard", "electrophage", "polysalt", "fulgorite-starter"}, "1")
setSubgroupInOrder("fulgora-agriculture", "recipe", {"electrophage-cultivation", "electrophage-cultivation-holmium", "fulgorite-starter"}, "2")

-- Reorganize production tab.
setSubgroupInOrder("electricity-related", {"item", "recipe"},
	{"solar-panel", "battery-charger", "battery-discharger", "accumulator", "lightning-rod", "lightning-collector", "nuclear-reactor", "fusion-reactor", "fusion-generator"})
setSubgroupInOrder("planetary-special", {"item", "recipe"},
	{"foundry", "biochamber", "recycler", "electromagnetic-plant", "captive-biter-spawner", "centrifuge", "cryogenic-plant"})

setSubgroupInOrder("chemical-processing", {"item", "recipe"},
	{"filtration-plant", "chemical-plant", "oil-refinery", "gasifier", "fluid-fuelled-gasifier"})
ITEM["agricultural-tower"].subgroup = "extraction-machine"
ITEM["agricultural-tower"].order = "c"
local labs = {"lab", "glebalab", "biolab"}
setSubgroupInOrder("labs", {"item", "recipe", "lab"}, labs)

-- Move splitters to inserter row, and burner inserter to end of inserter row
local splitters = {"splitter", "fast-splitter", "express-splitter", "turbo-splitter"}
local inserters = {"inserter", "long-handed-inserter", "fast-inserter", "bulk-inserter", "stack-inserter", "burner-inserter"}
setSubgroupInOrder("inserter", {"item", "recipe", "inserter"}, inserters, "b")
setSubgroupInOrder("inserter", {"item", "recipe", "splitter"}, splitters, "a")

-- TODO separate bottom logistics row into two lines, one with paving and one with the rest.

-- Arrange beacons, primers, circuits, primed/superclocked circuits, etc in 3 rows.
for i = 2, 3 do
	local moduleSubgroup = copy(RAW["item-subgroup"]["module"])
	moduleSubgroup.name = "module-" .. i
	moduleSubgroup.order = "g" .. i
	extend{moduleSubgroup}
end
Gen.orderKinds("module", {ITEM, RECIPE}, {
	"electronic-circuit",
	"advanced-circuit",
	"processing-unit",
	"white-circuit",
})
Gen.orderKinds("module-2", {RAW.module, RECIPE}, {
	"electronic-circuit-primed",
	"advanced-circuit-primed",
	"processing-unit-primed",
	"white-circuit-primed",
}, "1-")
Gen.orderKinds("module-2", {FURNACE, RECIPE, ITEM}, {"circuit-primer"}, "2-")
Gen.orderKinds("module-2", {RAW.beacon, RECIPE, ITEM}, {"basic-beacon"}, "3-")
Gen.orderKinds("module-3", {RAW.module, RECIPE}, {
	"electronic-circuit-superclocked",
	"advanced-circuit-superclocked",
	"processing-unit-superclocked",
	"white-circuit-superclocked",
}, "1-")
Gen.orderKinds("module-3", {ASSEMBLER, RECIPE, ITEM}, {"superclocker"}, "2-")
Gen.orderKinds("module-3", {RAW.beacon, RECIPE, ITEM}, {"beacon"}, "3-")

-- Order the raw-material group.
Gen.orderKinds("raw-material", {ITEM}, {
	"ash",
	"sand",
	"glass-batch",
	"glass",
	"silicon",
	"copper-matte",
	"sulfur",
	"niter",
	"gunpowder",
})

-- Move petroleum materials to their row.
Gen.orderKinds("petroleum-materials", {ITEM}, {
	"pitch",
	"carbon",
	"solid-fuel",
	"explosives",
	"plastic-bar",
	"rubber",
}, "1-")
Gen.orderKinds("petroleum-materials", {RECIPE}, {
	"rubber-from-latex",
	"rubber-from-oil",
	"char-carbon",
	"inverse-vulcanization",
}, "2-")

-- Move sulfuric acid to fluid-recipes.
Gen.orderKinds("fluid-recipes", {RECIPE}, {
	"make-sulfuric-acid",
	"extract-sulfuric-acid-from-battery",
}, "c-")

-- Order the intermediate-product group.
Gen.orderKinds("intermediate-product", {ITEM}, {
	"doped-wafer",
	"microchip",
	"engine-unit",
	"flying-robot-frame",
	"barrel",
	"gas-tank",
	"battery",
	"charged-battery",
	"holmium-battery",
	"charged-holmium-battery",
})
RAW["item-subgroup"]["intermediate-product"].order = "c8"