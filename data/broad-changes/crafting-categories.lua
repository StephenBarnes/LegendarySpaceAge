--[[ This file creates crafting categories for recipes.
Note that we don't use categories like "smelting-or-handcrafting" any more, since we have RecipePrototype.additional_categories. Only create basic categories like "smelting" and "handcrafting". Though some recipe categories like that still exist, created by the base game.
]]

-- Assembler 1 should be able to do fluid recipes.
ASSEMBLER["assembling-machine-1"].crafting_categories = copy(ASSEMBLER["assembling-machine-2"].crafting_categories)

-- Create crafting category for handcrafting.
extend{{
	type = "recipe-category",
	name = "handcrafting",
}}
for _, character in pairs(RAW["character"]) do
	if character.crafting_categories ~= nil then
		character.crafting_categories = copy(character.crafting_categories)
		table.insert(character.crafting_categories, "handcrafting")
	end
end

-- Create recipe category for heat furnaces.
extend{{
	type = "recipe-category",
	name = "heat-furnace",
}}

-- Create recipe categories for furnace variants (auto-venting output gases, and with free air).
for _, categoryName in pairs{"smelting-free-air", "smelting-venting", "smelting-free-air-venting"} do
	extend{{
		type = "recipe-category",
		name = categoryName,
	}}
end

-- Let god-controller do all crafting categories.
local godController = RAW["god-controller"]["default"]
godController.crafting_categories = {}
for name, _ in pairs(RAW["recipe-category"]) do
	table.insert(godController.crafting_categories, name)
end