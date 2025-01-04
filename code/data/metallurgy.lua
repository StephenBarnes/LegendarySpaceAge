local newData = {}


--[[
Iron:
	In fuelled furnace: 8 iron ore -> 1 hot iron bloom + 1 stone (slag)
	Over 20 minutes, hot iron blooms spoil into cold iron blooms which must be reheated in a furnace.
		In any furnace: 1 cold iron bloom -> 1 hot iron bloom
	Hot iron blooms are hammered in assemblers, into plates or rods:
		1 hot iron bloom -> 8 iron plate
		1 hot iron bloom -> 16 iron rods
		Each hot iron bloom item converts into multiple plates and rods, so that there's some incentive to rather put blooms on the conveyor belt instead of plates/rods, since blooms are more compact on the belt. This is balanced by the incentive to turn blooms into plates/rods immediately to avoid having to reheat them.

Steel:
	In fuelled furnace, slow: 1 hot iron bloom -> 1 hot steel bloom
	In assembler: 1 hot steel bloom -> 2 steel plate

Copper:
	The system is similar to iron, but with an extra intermediate "copper matte" which is then turned into copper blooms.
	In fuelled furnace:
		4 copper ore -> 1 copper matte + 1 stone
	In any furnace:
		2 copper matte -> 1 hot copper bloom + 1 sulfur
	Hot copper blooms cool down over time, and must then be reheated for working.
	Hot copper blooms are converted into plates or cables in an assembler, same as iron blooms.
]]

-- Make blooms and bloom-reheating recipes.
for _, metal in pairs{"iron", "copper", "steel"} do
	local hotBloomName = "bloom-" .. metal .. "-hot"
	local coldBloomName = "bloom-" .. metal .. "-cold"

	local hotBloom = table.deepcopy(data.raw.item["iron-ore"])
	hotBloom.name = hotBloomName
	-- TODO make icons.
	hotBloom.icons = {{icon="__LegendarySpaceAge__/graphics/metallurgy/"..hotBloomName..".png", icon_size=64, scale=0.5}}
	hotBloom.icon = nil
	hotBloom.spoil_ticks = 60 * 60 * 20
	hotBloom.spoil_result = coldBloomName
	table.insert(newData, hotBloom)

	local coldBloom = table.deepcopy(hotBloom)
	coldBloom.name = coldBloomName
	coldBloom.spoil_ticks = nil
	coldBloom.spoil_result = nil
	-- TODO make icons.
	coldBloom.icons = {{icon="__LegendarySpaceAge__/graphics/metallurgy/"..coldBloomName..".png", icon_size=64, scale=0.5}}
	table.insert(newData, coldBloom)

	---@type data.RecipePrototype
	local bloomHeatingRecipe = {
		type = "recipe",
		name = "heat-bloom-" .. metal,
		ingredients = {
			{type="item", name=coldBloomName, amount=1},
		},
		results = {
			{type="item", name=hotBloomName, amount=1},
		},
		energy_required = 2,
		hide_from_player_crafting = true,
		category = "smelting-any",
	}
	table.insert(newData, bloomHeatingRecipe)
end

-- Make recipe for iron bloom -> steel bloom.
local steelBloomRecipe = table.deepcopy(data.raw.recipe["steel-plate"])
steelBloomRecipe.name = "bloom-steel-hot"
steelBloomRecipe.ingredients = {{type="item", name="bloom-iron-hot", amount=1}}
steelBloomRecipe.results = {{type="item", name="bloom-steel-hot", amount=1}}
steelBloomRecipe.energy_required = 20
steelBloomRecipe.category = "carbon-smelting"
table.insert(newData, steelBloomRecipe)

-- Make recipe for iron ore -> iron bloom.
local ironBloomRecipe = table.deepcopy(steelBloomRecipe)
ironBloomRecipe.name = "bloom-iron-hot"
ironBloomRecipe.ingredients = {{type="item", name="iron-ore", amount=8}}
ironBloomRecipe.results = {
	{type="item", name="bloom-iron-hot", amount=1},
	{type="item", name="stone", amount=1},
}
table.insert(newData, ironBloomRecipe)

-- Make recipe for copper ore -> copper matte.
local copperMatteRecipe = table.deepcopy(ironBloomRecipe)
copperMatteRecipe.name = "copper-matte"
copperMatteRecipe.ingredients = {{type="item", name="copper-ore", amount=4}}
copperMatteRecipe.results = {
	{type="item", name="copper-matte", amount=1},
	{type="item", name="stone", amount=1},
}
table.insert(newData, copperMatteRecipe)

-- Make recipe for copper matte -> copper bloom.
local copperBloomRecipe = table.deepcopy(steelBloomRecipe)
copperBloomRecipe.name = "bloom-copper-hot"
copperBloomRecipe.ingredients = {{type="item", name="copper-matte", amount=2}}
copperBloomRecipe.results = {
	{type="item", name="bloom-copper-hot", amount=1},
	{type="item", name="sulfur", amount=1},
}
copperBloomRecipe.category = "smelting-any"
table.insert(newData, copperBloomRecipe)

-- Make copper-matte item.
local copperMatte = table.deepcopy(data.raw.item["copper-ore"])
copperMatte.name = "copper-matte"
copperMatte.icons = {
	-- TODO make icons.
	{icon="__LegendarySpaceAge__/graphics/metallurgy/copper-matte.png", icon_size=64, scale=0.5},
}
table.insert(newData, copperMatte)

-- Adjust steel plate recipe.
local steelPlateRecipe = data.raw.recipe["steel-plate"]
steelPlateRecipe.ingredients = {{type="item", name="bloom-steel-hot", amount=1}}
steelPlateRecipe.results = {{type="item", name="steel-plate", amount=2}}
steelPlateRecipe.category = "crafting" -- TODO check -- should be category craftable by hand or assembler.
steelPlateRecipe.energy_required = 2

-- Adjust iron plate recipe.
local ironPlateRecipe = data.raw.recipe["iron-plate"]
ironPlateRecipe.ingredients = {{type="item", name="bloom-iron-hot", amount=1}}
ironPlateRecipe.results = {{type="item", name="iron-plate", amount=8}}
ironPlateRecipe.category = "crafting"
ironPlateRecipe.energy_required = 4 -- TODO playtest

-- Adjust copper plate recipe.
local copperPlateRecipe = data.raw.recipe["copper-plate"]
copperPlateRecipe.ingredients = {{type="item", name="bloom-copper-hot", amount=1}}
copperPlateRecipe.results = {{type="item", name="copper-plate", amount=8}}
copperPlateRecipe.category = "crafting"
copperPlateRecipe.energy_required = 4 -- TODO playtest

-- Add new recipe for iron gears directly from blooms.
-- Or should we rather require making from blooms directly, not allow making from plates? TODO
local newIronGearRecipe = table.deepcopy(data.raw.recipe["iron-gear-wheel"])
newIronGearRecipe.name = "iron-gear-wheel-from-bloom"
-- TODO

-- Adjust recipe for iron rods.
-- TODO

-- Adjust recipe for copper cables.
-- TODO


-- TODO add recipes to tech tree.
-- TODO orders for items and recipes.

data:extend(newData)