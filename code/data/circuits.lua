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
		{type = "item", name = "circuit-board", amount = 4},
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

-- TODO change circuit recipes to require circuit boards.
-- TODO add circuit components etc.

data:extend(newData)

-- Add circuit board recipes to techs.
Tech.addRecipeToTech("wood-circuit-board", "electronics", 2)
Tech.addRecipeToTech("plastic-circuit-board", "plastics")
Tech.addRecipeToTech("calcite-circuit-board", "calcite-processing")