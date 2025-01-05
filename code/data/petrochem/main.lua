local Table = require("code.util.table")

require("code.data.petrochem.adamo-carbon")
require("code.data.petrochem.gas-furnace")
require("code.data.petrochem.fluids-items")
require("code.data.petrochem.recipes")

-- Add fluid output to refinery, so we can have recipes with 4 fluid outputs.
local oilRefinery = data.raw["assembling-machine"]["oil-refinery"]
local newFluidBox = Table.copyAndEdit(oilRefinery.fluid_boxes[5], {
	pipe_connections = {
		{position = {-2, -1}, direction = defines.direction.west, flow_direction = "output"},
	},
})
table.insert(oilRefinery.fluid_boxes, newFluidBox)