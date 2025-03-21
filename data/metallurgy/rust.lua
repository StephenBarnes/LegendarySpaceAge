-- This file creates rusty versions of items, and adds derusting recipes.

local RUST_TIME = 20 * MINUTES

-- Create rusty versions of items, and recipes for derusting them using sand or sulfuric acid.
for i, itemName in pairs{
	"ingot-iron-cold",
	"iron-plate",
	"iron-gear-wheel",
	"iron-stick",
} do
	local baseItem = ITEM[itemName]
	local rustyItem = copy(baseItem)
	rustyItem.name = "rusty-"..itemName
	Icon.set(rustyItem, "LSA/metallurgy/rusty/" .. itemName)
	rustyItem.has_random_tint = true
	rustyItem.random_tint_color = {.592, .463, .322}
	rustyItem.localised_name = {"item-name.rusty-X", {"item-name.compound-"..itemName}}
	rustyItem.subgroup = "rust"
	rustyItem.order = "a-"..i
	extend{rustyItem}
	baseItem.spoil_ticks = RUST_TIME
	baseItem.spoil_result = "rusty-"..itemName

	local recipe1 = copy(RECIPE["iron-stick"])
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
	Icon.set(recipe1, {"rusty-"..itemName, "sand"})
	recipe1.enabled = true
	recipe1.subgroup = "rust"
	recipe1.order = "b-"..i
	recipe1.auto_recycle = false
	recipe1.localised_name = {"recipe-name.sand-derust-X", {"item-name.compound-"..itemName}}
	recipe1.category = "crafting"
	recipe1.allow_as_intermediate = true
	recipe1.allow_decomposition = false
	extend{recipe1}

	local recipe2 = copy(recipe1)
	recipe2.name = "acid-derust-"..itemName
	recipe2.ingredients = {
		{type="item", name="rusty-"..itemName, amount=1},
		{type="fluid", name="sulfuric-acid", amount=1},
	}
	recipe2.results = {
		{type="item", name=itemName, amount=1},
	}
	Icon.set(recipe2, {"rusty-"..itemName, "sulfuric-acid"})
	recipe2.order = "c-"..i
	recipe2.enabled = false
	recipe2.localised_name = {"recipe-name.acid-derust-X", {"item-name.compound-"..itemName}}
	recipe2.category = "chemistry"
	extend{recipe2}
	Tech.addRecipeToTech(recipe2.name, "sulfur-processing")
end

-- Gears actually use different rusty sprites.
Icon.set("rusty-iron-gear-wheel", "LSA/parts-basic/rusty/pair-item")
Icon.variants("rusty-iron-gear-wheel", "LSA/parts-basic/rusty/%", 5)
Icon.set("sand-derust-iron-gear-wheel", {"LSA/parts-basic/rusty/pair-item", "sand"})
Icon.set("acid-derust-iron-gear-wheel", {"LSA/parts-basic/rusty/pair-item", "sulfuric-acid"})