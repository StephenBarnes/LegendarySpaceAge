local Tech = require("code.util.tech")
local Table = require("code.util.table")
local Item = require("code.util.item")

local newData = {}

-- Add circuit board item.
local circuitBoardItem = Table.copyAndEdit(data.raw.item["electronic-circuit"], {
	name = "circuit-board",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/misc/circuit-board.png", icon_size = 64},
	},
	icon = "nil",
	order = "b[circuits-0",
})
Item.copySoundsTo("copper-cable", circuitBoardItem)
table.insert(newData, circuitBoardItem)

-- TODO add circuit board recipes
-- TODO change circuit recipes to require circuit boards.

data:extend(newData)