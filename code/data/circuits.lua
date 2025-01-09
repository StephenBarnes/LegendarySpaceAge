--[[
Green circuits:
	1 wood + 0.2 resin -> 4 circuit boards
	1 circuit board + 3 copper wire -> 1 green circuit

Red circuits are made after the player has petrochem set up:
	1 carbon + 1 plastic + 1 stone + 1 copper wire -> 1 electronic components
		This represents resistors, capacitors, transistors, etc. that are large enough to pick up by hand.
	1 circuit board + 2 copper wire + 2 electronic components -> 1 red circuit

Blue circuits are made in the late stages of Nauvis part 1, and should have a significantly more complex production process:
	2 stone + 10 sulfuric acid -> 1 silicon wafer
	1 silicon wafer + 1 carbon + 1 plastic bar + 1 copper wire -> 1 doped wafer
		Represents doping with carbon and packaging with wire/plastic.
	1 doped wafer + 1 circuit board + 2 red circuit + 5 sulfuric acid -> 1 blue circuit
		Acid is for final etching/cleaning; red circuits represent simpler control electronics on the advanced board; doped wafer is the new silicon IC.

On Nauvis you first make "improvised" circuit boards, just stone+carbon. Then later you cut trees and put the wood in a wood-to-resin-and-rubber line and use the resin plus wood to make wooden circuit boards. There's early agricultural towers for bulk wood.
When plastic is unlocked with petrochem, you unlock a recipe for circuit boards from plastic:
	2 plastic bar + 1 resin + 1 rubber -> 8 circuit boards
Generally on Nauvis and Gleba both wood and plastic circuit boards are viable. On Fulgora and Aquilo, only plastic circuit boards are viable. On Vulcanus there's another alternative recipe for ceramic circuit boards using calcite.
]]

local Tech = require("code.util.tech")
local Table = require("code.util.table")
local Item = require("code.util.item")

local newData = {}

-- Add circuit board item.
local circuitBoardItem = Table.copyAndEdit(data.raw.item["electronic-circuit"], {
	name = "circuit-board",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/circuit-board-generic.png", icon_size = 64},
	},
	icon = "nil",
	order = "b[circuits]-0",
	subgroup = "resin-and-boards",
	auto_recycle = false,
})
Item.copySoundsTo("copper-cable", circuitBoardItem)
table.insert(newData, circuitBoardItem)

-- Add recipe for circuit board from wood.
-- 	1 wood + 1 resin -> 4 circuit boards
local woodCircuitBoardRecipe = Table.copyAndEdit(data.raw.recipe["barrel"], {
	name = "wood-circuit-board",
	ingredients = {
		{type = "item", name = "wood", amount = 1},
		{type = "item", name = "resin", amount = 1},
	},
	results = {
		{type = "item", name = "circuit-board", amount = 8},
	},
	order = "b[circuits]-001",
	subgroup = "resin-and-boards",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/wood-circuit-board.png", icon_size = 64},
	},
})
table.insert(newData, woodCircuitBoardRecipe)

-- Add recipe for circuit board from plastic.
-- 	2 plastic bar + 1 resin + 0.2 rubber -> 8 circuit boards
local plasticCircuitBoardRecipe = Table.copyAndEdit(data.raw.recipe["barrel"], {
	name = "plastic-circuit-board",
	ingredients = {
		{type = "item", name = "plastic-bar", amount = 2},
		{type = "item", name = "resin", amount = 1},
		--{type = "item", name = "rubber", amount = 0.2}, -- TODO after adding rubber
	},
	results = {
		{type = "item", name = "circuit-board", amount = 8},
	},
	order = "b[circuits]-002",
	subgroup = "resin-and-boards",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/plastic-circuit-board.png", icon_size = 64},
	},
})
table.insert(newData, plasticCircuitBoardRecipe)

-- Add recipe for ceramic circuit board.
-- 	4 calcite + 2 resin -> 8 circuit boards
local calciteCircuitBoardRecipe = Table.copyAndEdit(data.raw.recipe["barrel"], {
	name = "calcite-circuit-board",
	ingredients = {
		{type = "item", name = "calcite", amount = 2},
		{type = "item", name = "resin", amount = 1},
	},
	results = {
		{type = "item", name = "circuit-board", amount = 4},
	},
	order = "b[circuits]-003",
	subgroup = "resin-and-boards",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/ceramic-circuit-board.png", icon_size = 64},
	},
	category = "smelting",
})
table.insert(newData, calciteCircuitBoardRecipe)

--[[ Add "improvised" circuit board recipe, only handcraftable.
	Improvise circuit board: 1 stone + 1 carbon -> 1 circuit board
		Needed because all ways of making circuit boards require resin, which can't be obtained on Aquilo without buildings that require electronic circuits, creating a circular dependency.
]]
local improvisedCircuitBoardRecipe = Table.copyAndEdit(data.raw.recipe["electronic-circuit"], {
	name = "improvised-circuit-board",
	ingredients = {
		{type = "item", name = "stone", amount = 1},
		{type = "item", name = "carbon", amount = 1},
	},
	results = {
		{type = "item", name = "circuit-board", amount = 1},
	},
	order = "b[circuits]-004",
	subgroup = "resin-and-boards",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/circuit-board-generic.png", icon_size = 64, scale = 0.5},
		{icon = "__core__/graphics/icons/mip/slot-item-in-hand-black.png", icon_size = 64, mipmap_count = 2, scale = 0.4, shift = {5, 4}},
		--{icon = "__core__/graphics/icons/mip/slot-item-in-hand.png", icon_size = 64, mipmap_count = 2, scale = 0.33, shift = {7, 6}},
	},
	enabled = false,
	energy_required = 2,
	category = "recycling-or-hand-crafting", -- I don't think I can make a handcrafting-only category. But this built-in category (for scrap recycling) is handcraftable, plus recycling machines can't actually do it bc they only have 1 input slot.
})
table.insert(newData, improvisedCircuitBoardRecipe)

-- TODO create items and recipes for electronic components, wafer, doped wafer.

data:extend(newData)

-- Add circuit board recipes to techs.
Tech.addRecipeToTech("wood-circuit-board", "automation")
Tech.addRecipeToTech("plastic-circuit-board", "plastics") -- TODO rather make a separate tech for this, using plastic circuit board sprite.
Tech.addRecipeToTech("calcite-circuit-board", "calcite-processing") -- TODO rather make a separate tech for this? Unlocked by mining like 10 calcite. Use the ceramic circuit board sprite.
Tech.addRecipeToTech("improvised-circuit-board", "electronics", 2)

-- Move circuits to complex-circuit-intermediates subgroup.
data.raw.item["electronic-circuit"].subgroup = "complex-circuit-intermediates"
data.raw.item["advanced-circuit"].subgroup = "complex-circuit-intermediates"
data.raw.item["processing-unit"].subgroup = "complex-circuit-intermediates"

-- Edit circuit ingredients.
data.raw.recipe["electronic-circuit"].ingredients = {
	{type = "item", name = "circuit-board", amount = 1},
	{type = "item", name = "copper-cable", amount = 3},
	-- TODO later will add circuit components here maybe
}
-- TODO adjust red and blue circuits.