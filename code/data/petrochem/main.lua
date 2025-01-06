local Table = require("code.util.table")

require("code.data.petrochem.adamo-carbon")
require("code.data.petrochem.gas-furnace")
require("code.data.petrochem.fluids-items")
require("code.data.petrochem.recipes")

-- Add 2 more fluid outputs to the refinery, so we can have recipes with 5 fluid outputs.
local oilRefinery = data.raw["assembling-machine"]["oil-refinery"]
local newFluidBox1 = Table.copyAndEdit(oilRefinery.fluid_boxes[5], {
	pipe_connections = {
		{position = {-2, -1}, direction = defines.direction.west, flow_direction = "output"},
	},
})
table.insert(oilRefinery.fluid_boxes, newFluidBox1)
local newFluidBox2 = Table.copyAndEdit(oilRefinery.fluid_boxes[5], {
	pipe_connections = {
		{position = {2, -1}, direction = defines.direction.east, flow_direction = "output"},
	},
})
table.insert(oilRefinery.fluid_boxes, newFluidBox2)

-- TODO figure out what to put in the 2nd oil tech.
-- TODO figure out what to do with the sulfur tech.
-- TODO move syngas liquefaction tech since it's needed on Vulcanus.