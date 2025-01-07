local Tech = require("code.util.tech")
local Table = require("code.util.table")
local Recipe = require("code.util.recipe")

local ROCKET_MASS = 1000000
local INGOT_COOLING_TIME = 60 * 60 * 10

--[[
Iron:
	8 iron ore -> 1 hot iron ingot + 1 stone (slag)
	Over 20 minutes, hot iron ingots spoil into cold iron ingots which must be reheated in a furnace.
		In furnace: 1 cold iron ingot -> 1 hot iron ingot
	Hot iron ingots are hammered in assemblers, into plates or rods:
		1 hot iron ingot -> 8 iron plate
		1 hot iron ingot -> 16 iron rods
		Each hot iron ingot item converts into multiple plates and rods, so that there's some incentive to rather put ingots on the conveyor belt instead of plates/rods, since ingots are more compact on the belt. This is balanced by the incentive to turn ingots into plates/rods immediately to avoid having to reheat them.

Steel:
	In furnace, slow: 1 hot iron ingot -> 1 hot steel ingot
	In assembler: 1 hot steel ingot -> 2 steel plate

Copper:
	The system is similar to iron, but with an extra intermediate "copper matte" which is then turned into copper ingots.
	In furnace:
		4 copper ore -> 1 copper matte + 1 stone
		2 copper matte -> 1 hot copper ingot + 1 sulfur
	Hot copper ingots cool down over time, and must then be reheated for working.
	Hot copper ingots are converted into plates or cables in an assembler, same as iron ingots.
]]

local newData = {}

local metalTint = {
	copper = {r = .831, g = .467, b = .361, a=1},
	--iron = {r = 0.576, g = 0.576, b = 0.576, a=1},
	--steel = {r = .91, g = .914, b = .902, a=1},
	--iron = {r = 0.7, g = 0.7, b = 0.7, a=1},
	iron = {r = 0.65, g = 0.65, b = 0.65, a=1},
	steel = {r = .955, g = .96, b = 1.0, a=1},
}

-- Make ingots and ingot-reheating recipes.
local ingotItems = {}
for i, metal in pairs{"iron", "copper", "steel"} do
	local hotIngotName = "ingot-" .. metal .. "-hot"
	local coldIngotName = "ingot-" .. metal .. "-cold"
	local tint = metalTint[metal]

	local hotIngot = Table.copyAndEdit(data.raw.item["iron-plate"], {
		name = hotIngotName,
		icons = {
			{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot-heat.png", icon_size=64, scale=0.5},
			{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.5, tint=tint},
		},
		icon = "nil",
		icon_size = "nil",
		spoil_ticks = INGOT_COOLING_TIME,
		spoil_result = coldIngotName,
		order = "a[smelting]-0-" .. i,
		stack_size = 100,
		weight = ROCKET_MASS / 500,
		subgroup = "ingots",
	})
	table.insert(newData, hotIngot)
	ingotItems[hotIngotName] = hotIngot

	local coldIngot = Table.copyAndEdit(hotIngot, {
		name = coldIngotName,
		spoil_ticks = "nil",
		spoil_result = "nil",
		icons = {
			{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.5, tint=tint},
		},
		order = "a[smelting]-1-" .. i,
	})
	table.insert(newData, coldIngot)
	ingotItems[coldIngotName] = coldIngot

	---@type data.RecipePrototype
	local ingotHeatingRecipe = Table.copyAndEdit(data.raw.recipe["stone-brick"], {
		name = "heat-ingot-" .. metal,
		ingredients = {
			{type="item", name=coldIngotName, amount=1},
		},
		results = {
			{type="item", name=hotIngotName, amount=1},
		},
		energy_required = 2,
		hide_from_player_crafting = true,
		category = "smelting",
		enabled = true,
		icons = {
			{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot-heat.png", icon_size=64, scale=0.5},
			{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.4, tint=tint},
		},
		result_is_always_fresh = true, -- So almost-rusted cold ingots don't turn into almost-cold hot ingots.
	})
	table.insert(newData, ingotHeatingRecipe)
end

-- Make recipe for iron ingot -> steel ingot.
local steelIngotRecipe = Table.copyAndEdit(data.raw.recipe["steel-plate"], {
	name = "ingot-steel-hot",
	ingredients = {{type="item", name="ingot-iron-hot", amount=1}},
	results = {{type="item", name="ingot-steel-hot", amount=1}},
	energy_required = 20,
})
table.insert(newData, steelIngotRecipe)

-- Make recipe for iron ore -> iron ingot.
local ironIngotRecipe = Table.copyAndEdit(steelIngotRecipe, {
	name = "ingot-iron-hot",
	ingredients = {{type="item", name="iron-ore", amount=8}},
	results = {
		{type="item", name="ingot-iron-hot", amount=1},
		{type="item", name="stone", amount=1, show_details_in_recipe_tooltip=false},
	},
	main_product = "ingot-iron-hot",
	energy_required = 6,
	enabled = true,
})
table.insert(newData, ironIngotRecipe)

-- Make recipe for copper ore -> copper matte.
local copperMatteRecipe = Table.copyAndEdit(ironIngotRecipe, {
	name = "copper-matte",
	ingredients = {{type="item", name="copper-ore", amount=4}},
	results = {
		{type="item", name="copper-matte", amount=1},
		{type="item", name="stone", amount=1, show_details_in_recipe_tooltip=false},
	},
	main_product = "copper-matte",
	energy_required = 4,
	enabled = true,
	--factoriopedia_description = {"factoriopedia-description.copper-matte"}, -- Doesn't work, not sure why.
})
table.insert(newData, copperMatteRecipe)

-- Make copper-matte item.
local copperMattePictures = {}
for i = 1, 12 do
	table.insert(copperMattePictures, {
		filename = "__LegendarySpaceAge__/graphics/metallurgy/matte/matte" .. i .. ".png",
		size = 64,
		scale = 0.5,
		mipmap_count = 4,
	})
end
local copperMatte = Table.copyAndEdit(data.raw.item["copper-ore"], {
	name = "copper-matte",
	icons = {
		{icon="__LegendarySpaceAge__/graphics/metallurgy/matte/matte1.png", icon_size=64, scale=0.5},
	},
	pictures = copperMattePictures,
	--factoriopedia_description = {"factoriopedia-description.copper-matte"}, -- Doesn't work, not sure why.
	subgroup = "raw-material",
})
table.insert(newData, copperMatte)

-- Make recipe for copper matte -> copper ingot.
local copperIngotRecipe = Table.copyAndEdit(steelIngotRecipe, {
	name = "ingot-copper-hot",
	ingredients = {{type="item", name="copper-matte", amount=2}},
	results = {
		{type="item", name="ingot-copper-hot", amount=1},
		{type="item", name="sulfur", amount=1, show_details_in_recipe_tooltip=false},
	},
	category = "smelting",
	main_product = "ingot-copper-hot",
	energy_required = 4,
	enabled = true,
})
table.insert(newData, copperIngotRecipe)

-- Adjust steel plate recipe.
Table.setFields(data.raw.recipe["steel-plate"], {
	ingredients = {{type="item", name="ingot-steel-hot", amount=1}},
	results = {{type="item", name="steel-plate", amount=2}},
	category = "crafting", -- Means it's craftable by hand or by assembler. (Unlike basegame's recipe for steel plate, which has category "smelting".)
	energy_required = 2,
	auto_recycle = true,
	allow_as_intermediate = true,
	allow_decomposition = true,
})

-- Adjust iron plate recipe.
Table.setFields(data.raw.recipe["iron-plate"], {
	ingredients = {{type="item", name="ingot-iron-hot", amount=1}},
	results = {{type="item", name="iron-plate", amount=8}},
	category = "crafting",
	energy_required = 4,
	auto_recycle = true,
	allow_as_intermediate = true,
	allow_decomposition = true,
})

-- Adjust copper plate recipe.
Table.setFields(data.raw.recipe["copper-plate"], {
	ingredients = {{type="item", name="ingot-copper-hot", amount=1}},
	results = {{type="item", name="copper-plate", amount=8}},
	category = "crafting",
	energy_required = 4,
	auto_recycle = true,
	allow_as_intermediate = true,
	allow_decomposition = true,
})

-- Adjust iron gear recipe.
Table.setFields(data.raw.recipe["iron-gear-wheel"], {
	ingredients = {{type="item", name="ingot-iron-hot", amount=1}},
	results = {{type="item", name="iron-gear-wheel", amount=4}},
	energy_required = 2,
	auto_recycle = true,
})

-- Adjust recipe for iron rods.
Table.setFields(data.raw.recipe["iron-stick"], {
	ingredients = {{type="item", name="ingot-iron-hot", amount=1}},
	results = {{type="item", name="iron-stick", amount=16}},
	energy_required = 4,
	auto_recycle = true,
})

-- Adjust recipe for copper cables.
Table.setFields(data.raw.recipe["copper-cable"], {
	ingredients = {{type="item", name="ingot-copper-hot", amount=1}},
	results = {{type="item", name="copper-cable", amount=16}},
	energy_required = 4,
	auto_recycle = true,
})

-- Adjust recipe for low-density structures.
-- Originally 20 copper plate, 2 steel plate, 5 plastic bar. Changing to 4 copper ingot, 1 steel ingot, 5 plastic bar.
Table.setFields(data.raw.recipe["low-density-structure"], {
	ingredients = {
		{type="item", name="ingot-copper-hot", amount=4},
		{type="item", name="ingot-steel-hot", amount=1},
		{type="item", name="plastic-bar", amount=5},
	},
	auto_recycle = true,
})

-- Adjust chest recipes.
-- Actually rather don't do this, bc then how do you make them from molten metals? Would need to add ingot casting or chest casting.
--data.raw.recipe["iron-chest"].ingredients = {{type="item", name="ingot-iron-hot", amount=2}}
--data.raw.recipe["steel-chest"].ingredients = {{type="item", name="ingot-steel-hot", amount=2}}

-- Put basic metal intermediates in their own subgroup.
for i, itemName in pairs{"iron-plate", "iron-gear-wheel", "iron-stick", "copper-plate", "copper-cable", "steel-plate"} do
	data.raw.item[itemName].subgroup = "basic-metal-intermediates"
	data.raw.item[itemName].order = ""..i
end

-- Change rusting recipes to sometimes return stone (to reduce cost and increase complexity), and increase time.
for _, recipeName in pairs{"rocs-rusting-iron-iron-plate-derusting", "rocs-rusting-iron-iron-gear-wheel-derusting", "rocs-rusting-iron-iron-stick-derusting"} do
	local recipe = data.raw.recipe[recipeName]
	table.insert(recipe.results, {type="item", name="stone", amount=1, probability=0.8, show_details_in_recipe_tooltip=false})
	recipe.main_product = recipe.results[1].name
	recipe.energy_required = 1 -- Increased 0.25 -> 1
end

-- Create item for rusted cold iron ingot.
local rustedIronIngot = Table.copyAndEdit(ingotItems["ingot-iron-cold"], {
	name = "ingot-iron-rusted",
	icons = {
		{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot-rusted.png", icon_size=64, scale=0.5},
	},
})
table.insert(newData, rustedIronIngot)
ingotItems["ingot-iron-cold"].spoil_ticks = 60 * 60 * 20
ingotItems["ingot-iron-cold"].spoil_result = "ingot-iron-rusted"

-- Add recipe to de-rust cold iron ingot.
local derustIronIngotRecipe = Table.copyAndEdit(data.raw.recipe["rocs-rusting-iron-iron-stick-derusting"], {
	name = "ingot-iron-derusting",
	ingredients = {
		{type="item", name="ingot-iron-rusted", amount=1},
		{type="item", name="stone", amount=1},
	},
	results = {
		{type="item", name="ingot-iron-cold", amount=1},
		{type="item", name="stone", amount=1, probability=0.8, show_details_in_recipe_tooltip=false},
	},
	main_product = "ingot-iron-cold",
	icons = {{icon="__LegendarySpaceAge__/graphics/metallurgy/derusting-iron-ingot.png", icon_size=64, scale=0.5}},
	enabled = true,
	order = "e[derusting]-0[derust-iron-ingot]",
})
table.insert(newData, derustIronIngotRecipe)

------------------------------------------------------------------------
-- Add new prototypes.
data:extend(newData)
------------------------------------------------------------------------

-- Add recipes to techs.
Tech.addRecipeToTech("ingot-steel-hot", "steel-processing", 1)
Tech.addRecipeToTech("heat-ingot-steel", "steel-processing", 2)
data.raw.recipe["heat-ingot-steel"].enabled = false

-- Adjust tech unlock triggers.
data.raw.technology["steam-power"].research_trigger.item = "ingot-iron-hot"
data.raw.technology["electronics"].research_trigger.item = "ingot-copper-hot"
data.raw.technology["steel-axe"].research_trigger.item = "ingot-steel-hot"

-- Adjust stack sizes and rocket capacities of basic metal products.
data.raw.item["copper-matte"].weight = ROCKET_MASS / 500 -- Compare to 500 ingots = 500 mattes.
data.raw.item["iron-plate"].weight = ROCKET_MASS / 4000 -- Compare to 500 ingots = 4000 plates.
data.raw.item["copper-plate"].weight = ROCKET_MASS / 4000
data.raw.item["steel-plate"].weight = ROCKET_MASS / 1000 -- Compare to 500 ingots = 1000 plates.
data.raw.item["iron-gear-wheel"].weight = ROCKET_MASS / 2000 -- Compare to 500 ingots = 2000 gears.
data.raw.item["iron-stick"].weight = ROCKET_MASS / 8000 -- Compare to 500 ingots = 8000 rods.
data.raw.item["copper-cable"].weight = ROCKET_MASS / 8000 -- Compare to 500 ingots = 8000 cables.

-- Move all rusty items to the subgroup for derusting (actually now the "rust" group).
data.raw.item["ingot-iron-rusted"].subgroup = "derusting"
data.raw.item["rocs-rusting-iron-iron-plate-rusty"].subgroup = "derusting"
data.raw.item["rocs-rusting-iron-iron-gear-wheel-rusty"].subgroup = "derusting"
data.raw.item["rocs-rusting-iron-iron-stick-rusty"].subgroup = "derusting"
data.raw.item["rocs-rusting-iron-iron-gear-wheel-rusty"].order = data.raw.item["rocs-rusting-iron-iron-plate-rusty"].order .. "-1"
data.raw.item["rocs-rusting-iron-iron-stick-rusty"].order = data.raw.item["rocs-rusting-iron-iron-plate-rusty"].order .. "-2"

-- Add output slots to furnaces - otherwise some recipe products just disappear, apparently.
for _, furnace in pairs{"stone-furnace", "steel-furnace", "gas-furnace", "electric-furnace"} do
	data.raw.furnace[furnace].result_inventory_size = 2
end