-- This file creates rusty versions of items, and adds derusting recipes.

local Tech = require("code.util.tech")

local RUST_TIME = 60 * 60 * 20

-- Create rusty versions of items, and recipes for derusting them using sand or sulfuric acid.
for i, itemName in pairs{
	"ingot-iron-cold",
	"iron-plate",
	"iron-gear-wheel",
	"iron-stick",
} do
	local baseItem = data.raw.item[itemName]
	local rustyItem = table.deepcopy(baseItem)
	rustyItem.name = "rusty-"..itemName
	rustyItem.icon = nil
	rustyItem.icons = {
		{icon = "__LegendarySpaceAge__/graphics/metallurgy/rusty/"..itemName..".png", icon_size = 64, scale = 0.5},
	}
	rustyItem.has_random_tint = true
	rustyItem.random_tint_color = {.592, .463, .322}
	rustyItem.localised_name = {"item-name.rusty-X", {"item-name.compound-"..itemName}}
	rustyItem.subgroup = "rusty"
	rustyItem.order = "a-"..i
	data:extend{rustyItem}
	baseItem.spoil_ticks = RUST_TIME
	baseItem.spoil_result = "rusty-"..itemName

	local recipe1 = table.deepcopy(data.raw.recipe["iron-stick"])
	recipe1.name = "sand-derust-"..itemName
	recipe1.ingredients = {
		{type="item", name="rusty-"..itemName, amount=1},
		{type="item", name="sand", amount=1},
	}
	recipe1.results = {
		{type="item", name=itemName, amount=1},
		{type="item", name="sand", amount=1, probability=0.8, show_details_in_recipe_tooltip=false},
	}
	recipe1.main_product = itemName
	recipe1.icon = nil
	recipe1.icons = {
		rustyItem.icons[1],
		{icon = "__LegendarySpaceAge__/graphics/sand/sand-1.png", icon_size = 64, shift = {-8, -8}, scale = 0.25},
	}
	recipe1.enabled = true
	recipe1.subgroup = "derusting"
	recipe1.order = "b-"..i
	recipe1.auto_recycle = false
	recipe1.localised_name = {"recipe-name.sand-derust-X", {"item-name.compound-"..itemName}}
	recipe1.category = "crafting"
	data:extend{recipe1}

	local recipe2 = table.deepcopy(recipe1)
	recipe2.name = "acid-derust-"..itemName
	recipe2.ingredients = {
		{type="item", name="rusty-"..itemName, amount=1},
		{type="fluid", name="sulfuric-acid", amount=1},
	}
	recipe2.results = {
		{type="item", name=itemName, amount=1},
	}
	recipe2.icons[2].icon = "__base__/graphics/icons/fluid/sulfuric-acid.png"
	recipe2.order = "c-"..i
	recipe2.enabled = false
	recipe2.localised_name = {"recipe-name.acid-derust-X", {"item-name.compound-"..itemName}}
	recipe2.category = "chemistry"
	data:extend{recipe2}
	Tech.addRecipeToTech(recipe2.name, "sulfur-processing")
end

-- Gears actually use different rusty sprites.
data.raw.item["rusty-iron-gear-wheel"].icons = {
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-2.png", icon_size = 64, scale=0.4, mipmap_count=4, shift={-3, 3}},
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/rusty/spring-2.png", icon_size = 64, scale=0.4, mipmap_count=4, shift={3, -4}},
}
data.raw.item["rusty-iron-gear-wheel"].pictures = {
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-1.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-2.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-3.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/rusty/spring-1.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/rusty/spring-2.png", size = 64, scale = 0.5, mipmap_count = 4},
}
data.raw.recipe["sand-derust-iron-gear-wheel"].icons[1].icon = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-2.png"
data.raw.recipe["acid-derust-iron-gear-wheel"].icons[1].icon = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-2.png"

-- TODO check that rusty items recycle properly.