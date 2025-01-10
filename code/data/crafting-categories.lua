-- Assembler 1 should be able to do fluid recipes.
data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories = data.raw["assembling-machine"]["assembling-machine-2"].crafting_categories

-- Create category for smelting or metallurgy, so that sand->glass can be done in both.
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

-- Create crafting for chem plant or handcrafting - for coal coking, gunpowder, maybe more.
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