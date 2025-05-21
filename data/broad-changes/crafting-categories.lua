-- Assembler 1 should be able to do fluid recipes.
ASSEMBLER["assembling-machine-1"].crafting_categories = ASSEMBLER["assembling-machine-2"].crafting_categories

-- Create crafting category for smelting or metallurgy, so that sand->glass can be done in both.
extend({
	{
		type = "recipe-category",
		name = "smelting-or-metallurgy",
	},
})
for _, typeAndName in pairs{
	{"furnace", "stone-furnace"},
	{"furnace", "steel-furnace"},
	{"furnace", "ffc-furnace"},
	{"furnace", "electric-furnace"},
	{"assembling-machine", "foundry"},
} do
	table.insert(RAW[typeAndName[1]][typeAndName[2]].crafting_categories, "smelting-or-metallurgy")
end

-- Create crafting category for smelting or handcrafting.
extend({
	{
		type = "recipe-category",
		name = "smelting-or-handcrafting",
	},
})
for _, typeAndName in pairs{
	{"furnace", "stone-furnace"},
	{"furnace", "steel-furnace"},
	{"furnace", "ffc-furnace"},
	{"furnace", "electric-furnace"},
} do
	table.insert(RAW[typeAndName[1] ][typeAndName[2] ].crafting_categories, "smelting-or-handcrafting")
end
table.insert(RAW["character"]["character"].crafting_categories, "smelting-or-handcrafting")

-- Create crafting category for smelting or metallurgy or handcrafting.
--[[ Disabling bc no longer used.
extend({
	{
		type = "recipe-category",
		name = "smelting-or-metallurgy-or-handcrafting",
	},
})
for _, typeAndName in pairs{
	{"furnace", "stone-furnace"},
	{"furnace", "steel-furnace"},
	{"furnace", "ffc-furnace"},
	{"furnace", "electric-furnace"},
	{"assembling-machine", "foundry"},
} do
	table.insert(RAW[typeAndName[1] ][typeAndName[2] ].crafting_categories, "smelting-or-metallurgy-or-handcrafting")
end
table.insert(RAW["character"]["character"].crafting_categories, "smelting-or-metallurgy-or-handcrafting")
]]

-- Create crafting category for chemistry or crafting-with-fluid, so that water filter cleaning can be done in both.
--[[ Disabling bc unused.
extend({
	{
		type = "recipe-category",
		name = "chemistry-or-crafting-with-fluid",
	},
})
local function considerAddingCat(machine)
	if machine.crafting_categories then
		for _, category in pairs(machine.crafting_categories) do
			if category == "chemistry" or category == "crafting-with-fluid" then
				table.insert(machine.crafting_categories, "chemistry-or-crafting-with-fluid")
				return
			end
		end
	end
end
for _, machineType in pairs{
	"assembling-machine",
	"furnace",
} do
	for _, machine in pairs(RAW[machineType]) do
		considerAddingCat(machine)
	end
end
]]

-- Create crafting category for chem plant or handcrafting - for gunpowder, maybe more.
extend({
	{
		type = "recipe-category",
		name = "chemistry-or-handcrafting",
	},
})
table.insert(ASSEMBLER["chemical-plant"].crafting_categories, "chemistry-or-handcrafting")
table.insert(RAW["character"]["character"].crafting_categories, "chemistry-or-handcrafting")

-- Create handcrafting-only category.
extend({
	{
		type = "recipe-category",
		name = "handcrafting-only",
	},
})
table.insert(RAW["character"]["character"].crafting_categories, "handcrafting-only")

-- Create crafting category for chem plant or biochamber or handcrafting - for fulgorite shards to holmium powder.
--[[ Disabling bc unused.
extend({
	{
		type = "recipe-category",
		name = "chemistry-or-organic-or-handcrafting",
	},
})
table.insert(ASSEMBLER["chemical-plant"].crafting_categories, "chemistry-or-organic-or-handcrafting")
table.insert(ASSEMBLER["biochamber"].crafting_categories, "chemistry-or-organic-or-handcrafting")
table.insert(RAW["character"]["character"].crafting_categories, "chemistry-or-organic-or-handcrafting")
]]

-- Create crafting category for chem plant or electromagnetic plant.
extend({
	{
		type = "recipe-category",
		name = "chemistry-or-electronics",
	},
})
table.insert(ASSEMBLER["chemical-plant"].crafting_categories, "chemistry-or-electronics")
table.insert(ASSEMBLER["electromagnetic-plant"].crafting_categories, "chemistry-or-electronics")

-- Create crafting category for organic or assembling-with-fluid.
extend({
	{
		type = "recipe-category",
		name = "organic-or-assembling-with-fluid",
	},
})
for _, machine in pairs(ASSEMBLER) do
	if machine.crafting_categories and Table.hasEntry("organic-or-assembling", machine.crafting_categories) then
		table.insert(machine.crafting_categories, "organic-or-assembling-with-fluid")
	end
end

-- Let god-controller do all crafting categories.
for name, _ in pairs(RAW["recipe-category"]) do
	table.insert(RAW["god-controller"]["default"].crafting_categories, name)
end

-- Create recipe category for heat furnaces.
extend{{
	type = "recipe-category",
	name = "heat-furnace",
}}
-- Can't add this to carbon furnaces, since they would be able to do heating recipes without oxygen/air.