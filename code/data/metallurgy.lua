local Tech = require("code.util.tech")

--[[
Iron:
	8 iron ore -> 1 hot iron ingot + 1 stone (slag)
	Over 20 minutes, hot iron ingots spoil into cold iron ingots which must be reheated in a furnace.
		In any furnace: 1 cold iron ingot -> 1 hot iron ingot
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
	iron = {r = 0.7, g = 0.7, b = 0.7, a=1},
	steel = {r = .955, g = .96, b = .97, a=1},
}

-- Make ingots and ingot-reheating recipes.
for i, metal in pairs{"iron", "copper", "steel"} do
	local hotIngotName = "ingot-" .. metal .. "-hot"
	local coldIngotName = "ingot-" .. metal .. "-cold"
	local tint = metalTint[metal]

	local hotIngot = table.deepcopy(data.raw.item["iron-plate"])
	hotIngot.name = hotIngotName
	hotIngot.icons = {
		{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot-heat.png", icon_size=64, scale=0.5},
		{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.5, tint=tint},
	}
	hotIngot.icon = nil
	hotIngot.icon_size = nil
	hotIngot.spoil_ticks = 60 * 60 * 20
	hotIngot.spoil_result = coldIngotName
	hotIngot.order = "a[smelting]-0-" .. i
	log(serpent.block(hotIngot))
	table.insert(newData, hotIngot)

	local coldIngot = table.deepcopy(hotIngot)
	coldIngot.name = coldIngotName
	coldIngot.spoil_ticks = nil
	coldIngot.spoil_result = nil
	coldIngot.icons = {
		{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.5, tint=tint},
	}
	coldIngot.order = "a[smelting]-1-" .. i
	table.insert(newData, coldIngot)

	---@type data.RecipePrototype
	local ingotHeatingRecipe = {
		type = "recipe",
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
			{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot-heat.png", icon_size=64, scale=0.35, shift={5,-5}},
			{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.35, tint=tint, shift={5,-5}},
			{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.35, tint=tint, shift={-5,5}},
		},
	}
	table.insert(newData, ingotHeatingRecipe)
end

-- Make recipe for iron ingot -> steel ingot.
local steelIngotRecipe = table.deepcopy(data.raw.recipe["steel-plate"])
steelIngotRecipe.name = "ingot-steel-hot"
steelIngotRecipe.ingredients = {{type="item", name="ingot-iron-hot", amount=1}}
steelIngotRecipe.results = {{type="item", name="ingot-steel-hot", amount=1}}
steelIngotRecipe.energy_required = 20
table.insert(newData, steelIngotRecipe)

-- Make recipe for iron ore -> iron ingot.
local ironIngotRecipe = table.deepcopy(steelIngotRecipe)
ironIngotRecipe.name = "ingot-iron-hot"
ironIngotRecipe.ingredients = {{type="item", name="iron-ore", amount=8}}
ironIngotRecipe.results = {
	{type="item", name="ingot-iron-hot", amount=1},
	{type="item", name="stone", amount=1},
}
ironIngotRecipe.main_product = "ingot-iron-hot"
ironIngotRecipe.energy_required = 6
ironIngotRecipe.enabled = true
table.insert(newData, ironIngotRecipe)

-- Make recipe for copper ore -> copper matte.
local copperMatteRecipe = table.deepcopy(ironIngotRecipe)
copperMatteRecipe.name = "copper-matte"
copperMatteRecipe.ingredients = {{type="item", name="copper-ore", amount=4}}
copperMatteRecipe.results = {
	{type="item", name="copper-matte", amount=1},
	{type="item", name="stone", amount=1},
}
copperMatteRecipe.main_product = "copper-matte"
copperMatteRecipe.energy_required = 4
copperMatteRecipe.enabled = true
table.insert(newData, copperMatteRecipe)

-- Make recipe for copper matte -> copper ingot.
local copperIngotRecipe = table.deepcopy(steelIngotRecipe)
copperIngotRecipe.name = "ingot-copper-hot"
copperIngotRecipe.ingredients = {{type="item", name="copper-matte", amount=2}}
copperIngotRecipe.results = {
	{type="item", name="ingot-copper-hot", amount=1},
	{type="item", name="sulfur", amount=1},
}
copperIngotRecipe.category = "smelting"
copperIngotRecipe.main_product = "ingot-copper-hot"
copperIngotRecipe.energy_required = 4
copperIngotRecipe.enabled = true
table.insert(newData, copperIngotRecipe)

-- Make copper-matte item.
local copperMatte = table.deepcopy(data.raw.item["copper-ore"])
copperMatte.name = "copper-matte"
copperMatte.icons = {
	-- TODO make icons.
	--{icon="__LegendarySpaceAge__/graphics/metallurgy/copper-matte.png", icon_size=64, scale=0.5},
	{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.5},
}
table.insert(newData, copperMatte)

-- Adjust steel plate recipe.
local steelPlateRecipe = data.raw.recipe["steel-plate"]
steelPlateRecipe.ingredients = {{type="item", name="ingot-steel-hot", amount=1}}
steelPlateRecipe.results = {{type="item", name="steel-plate", amount=2}}
steelPlateRecipe.category = "crafting" -- TODO check -- should be category craftable by hand or assembler.
steelPlateRecipe.energy_required = 2

-- Adjust iron plate recipe.
local ironPlateRecipe = data.raw.recipe["iron-plate"]
ironPlateRecipe.ingredients = {{type="item", name="ingot-iron-hot", amount=1}}
ironPlateRecipe.results = {{type="item", name="iron-plate", amount=8}}
ironPlateRecipe.category = "crafting"
ironPlateRecipe.energy_required = 4 -- TODO playtest

-- Adjust copper plate recipe.
local copperPlateRecipe = data.raw.recipe["copper-plate"]
copperPlateRecipe.ingredients = {{type="item", name="ingot-copper-hot", amount=1}}
copperPlateRecipe.results = {{type="item", name="copper-plate", amount=8}}
copperPlateRecipe.category = "crafting"
copperPlateRecipe.energy_required = 4 -- TODO playtest

-- Add new recipe for iron gears directly from ingots.
-- Or should we rather require making from ingots directly, not allow making from plates? TODO
local newIronGearRecipe = table.deepcopy(data.raw.recipe["iron-gear-wheel"])
newIronGearRecipe.name = "iron-gear-wheel-from-ingot"
-- TODO

-- Adjust recipe for iron rods.
-- TODO

-- Adjust recipe for copper cables.
-- TODO


-- TODO add recipes to tech tree.
-- TODO orders for items and recipes.

-- TODO add rusting for cold iron ingots, and for iron items.

-- Add new prototypes.
data:extend(newData)

-- Add recipes to techs.
Tech.addRecipeToTech("ingot-steel-hot", "steel-processing")
Tech.addRecipeToTech("heat-ingot-steel", "steel-processing")
data.raw.recipe["heat-ingot-steel"].enabled = false

-- Adjust tech unlock triggers.
data.raw.technology["steam-power"].research_trigger.item = "ingot-iron-hot"
data.raw.technology["electronics"].research_trigger.item = "ingot-copper-hot"