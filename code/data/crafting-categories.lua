-- Assembler 1 should be able to do fluid recipes.
data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories = data.raw["assembling-machine"]["assembling-machine-2"].crafting_categories

-- Create crafting category for smelting or metallurgy, so that sand->glass can be done in both.
data:extend({
	{
		type = "recipe-category",
		name = "smelting-or-metallurgy",
	},
})
for _, typeAndName in pairs{
	{"furnace", "stone-furnace"},
	{"furnace", "steel-furnace"},
	{"furnace", "gas-furnace"},
	{"furnace", "electric-furnace"},
	{"assembling-machine", "foundry"},
} do
	table.insert(data.raw[typeAndName[1]][typeAndName[2]].crafting_categories, "smelting-or-metallurgy")
end

-- Create crafting category for chemistry or crafting-with-fluid, so that water filter cleaning can be done in both.
data:extend({
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
	for _, machine in pairs(data.raw[machineType]) do
		considerAddingCat(machine)
	end
end

-- Create crafting category for chem plant or handcrafting - for coal coking, gunpowder, maybe more.
data:extend({
	{
		type = "recipe-category",
		name = "chemistry-or-handcrafting",
	},
})
table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "chemistry-or-handcrafting")
table.insert(data.raw["god-controller"]["default"].crafting_categories, "chemistry-or-handcrafting")
table.insert(data.raw["character"]["character"].crafting_categories, "chemistry-or-handcrafting")

-- Create handcrafting-only category.
data:extend({
	{
		type = "recipe-category",
		name = "handcrafting-only",
	},
})
table.insert(data.raw["god-controller"]["default"].crafting_categories, "handcrafting-only")
table.insert(data.raw["character"]["character"].crafting_categories, "handcrafting-only")

-- Create crafting category for chem plant or biochamber or handcrafting - for fulgorite shards to holmium powder.
data:extend({
	{
		type = "recipe-category",
		name = "chemistry-or-organic-or-handcrafting",
	},
})
table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "chemistry-or-organic-or-handcrafting")
table.insert(data.raw["assembling-machine"]["biochamber"].crafting_categories, "chemistry-or-organic-or-handcrafting")
table.insert(data.raw["god-controller"]["default"].crafting_categories, "chemistry-or-organic-or-handcrafting")
table.insert(data.raw["character"]["character"].crafting_categories, "chemistry-or-organic-or-handcrafting")

-- Create crafting category for chem plant or electromagnetic plant.
data:extend({
	{
		type = "recipe-category",
		name = "chemistry-or-electronics",
	},
})
table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "chemistry-or-electronics")
table.insert(data.raw["assembling-machine"]["electromagnetic-plant"].crafting_categories, "chemistry-or-electronics")