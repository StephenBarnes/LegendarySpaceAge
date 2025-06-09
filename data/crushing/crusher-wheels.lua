--[[ This file creates crusher wheels, which are used as "fuel" by crushers.
Also makes related recipes for manufacturing and refurbishing crusher wheels.
]]

-- TODO everything

local item_tints = require("__base__.prototypes.item-tints")
local MetalTints = require("const.metal-tints")

-- Create fuel category. We make crusher wheels a fuel type that's consumed by crushers.
extend{{
	type = "fuel-category",
	name = "crusher-wheel",
}}

-- Create burner usage.
extend{{
	type = "burner-usage",
	name = "crusher-wheel-usage",
	--[[
	empty_slot_sprite = {
		filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/empty-battery-slot.png",
		priority = "extra-high-no-scale",
		size = 64,
		mipmap_count = 2,
		flags = {"gui-icon"},
	},
	]]
	empty_slot_sprite = RAW["burner-usage"]["fuel"].empty_slot_sprite, -- TODO custom icon?
	empty_slot_caption = {"gui.use"},
	empty_slot_description = nil,
	--[[
	icon = {
		filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/battery-icon-red.png",
		priority = "extra-high-no-scale",
		width = 64,
		height = 64,
		flags = {"icon"}
	},
	]]
	icon = RAW["burner-usage"]["fuel"].icon, -- TODO custom icon? Don't really have anything good.
	no_fuel_status = {"entity-status.no-crusher-wheels"},
	accepted_fuel_key = "description.accepted-crusher-wheels",
	burned_in_key = "used-by", -- factoriopedia
}}

-- TODO burner usage strings, warning sprites, etc.

-- Create crusher-wheel items.
local ironItem = copy(ITEM["iron-gear-wheel"])
ironItem.name = "iron-crusher-wheel"
Icon.set(ironItem, {{"LSA/crushers/crusher-wheel", tint = MetalTints.iron}, "LSA/crushers/crusher-wheel-highlights"}, "overlay")
ironItem.pictures = nil
ironItem.spoil_ticks = nil
ironItem.spoil_result = nil
ironItem.random_tint_color = item_tints.iron_rust
ironItem.fuel_category = "crusher-wheel"
ironItem.fuel_value = "1MJ"
ironItem.burnt_result = "ingot-iron-cold"
extend{ironItem}

local steelItem = copy(ironItem)
steelItem.name = "steel-crusher-wheel"
Icon.set(steelItem, {{"LSA/crushers/crusher-wheel", tint = MetalTints.steel}, "LSA/crushers/crusher-wheel-highlights"}, "overlay")
steelItem.fuel_value = "20MJ"
steelItem.burnt_result = "ingot-steel-cold"
extend{steelItem}

local tungstenItem = copy(ironItem)
tungstenItem.name = "tungsten-crusher-wheel"
Icon.set(tungstenItem, {{"LSA/crushers/crusher-wheel", tint = MetalTints.tungsten}, "LSA/crushers/crusher-wheel-highlights"}, "overlay")
tungstenItem.fuel_value = "500MJ"
tungstenItem.burnt_result = "tungsten-plate"
extend{tungstenItem}

-- Create recipes.
local ironRecipe = Recipe.make{
	copy = "barrel",
	recipe = "iron-crusher-wheel",
	ingredients = {"ingot-iron-hot"},
	resultCount = 1,
	enabled = true, -- TODO
	time = 2,
	category = "crafting",
}
Recipe.make{
	copy = ironRecipe,
	recipe = "steel-crusher-wheel",
	ingredients = {"ingot-steel-hot"},
	resultCount = 1,
	enabled = true, -- TODO
	time = 5,
}
Recipe.make{
	copy = ironRecipe,
	recipe = "tungsten-crusher-wheel",
	ingredients = {
		{"molten-tungsten", 100, type = "fluid"},
		{"molten-steel", 100, type = "fluid"},
	},
	resultCount = 1,
	enabled = true, -- TODO
	time = 1,
	category = "metallurgy",
}