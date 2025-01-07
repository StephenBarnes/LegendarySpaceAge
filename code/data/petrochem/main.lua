local Table = require("code.util.table")

require("code.data.petrochem.gas-furnace")
require("code.data.petrochem.gas-boiler")
require("code.data.petrochem.fluids-items")
require("code.data.petrochem.recipes")
require("code.data.petrochem.gasifier")

-- Add 2 more fluid outputs to the refinery, so we can have recipes with 5 fluid outputs.
-- Could get away with adding only 1 new output, but then it's asymmetric so we can't flip it.
local oilRefinery = data.raw["assembling-machine"]["oil-refinery"]
local newFluidBox1 = Table.copyAndEdit(oilRefinery.fluid_boxes[5], {
	pipe_connections = {
		{position = {-2, 0}, direction = defines.direction.west, flow_direction = "output"},
	},
})
local newFluidBox2 = Table.copyAndEdit(oilRefinery.fluid_boxes[5], {
	pipe_connections = {
		{position = {2, 0}, direction = defines.direction.east, flow_direction = "output"},
	},
})
-- Add fluid boxes in order chosen so that our recipes have interesting and sensible positions for outputs.
oilRefinery.fluid_boxes = {
	oilRefinery.fluid_boxes[1], -- input
	oilRefinery.fluid_boxes[2], -- input
	newFluidBox2,
	oilRefinery.fluid_boxes[3],
	oilRefinery.fluid_boxes[4],
	oilRefinery.fluid_boxes[5],
	newFluidBox1,
}
-- TODO change the pipe covers so it doesn't look like it's hovering in mid-air. Could steal it from some other machine eg assembler mk2.

-- Add 1 more fluid input to chem plant, so we can do explosives recipe.
local chemPlant = data.raw["assembling-machine"]["chemical-plant"]
local newFluidBox = Table.copyAndEdit(chemPlant.fluid_boxes[1], {
	pipe_connections = {
		{position = {1, 0}, direction = defines.direction.east, flow_direction = "input"},
	},
})
chemPlant.fluid_boxes = {
	chemPlant.fluid_boxes[1], -- input
	newFluidBox, -- Stick it between the other 2 outputs, so if a recipe has 2 fluid inputs they get distributed more conveniently.
	chemPlant.fluid_boxes[2], -- input
	chemPlant.fluid_boxes[3], -- output
	chemPlant.fluid_boxes[4], -- output
}

-- TODO for recipes, define which fluid connections to use - shouldn't use these additional fluid connections if not necessary.

-- TODO figure out what to put in the 2nd oil tech.
-- TODO figure out what to do with the sulfur tech.
-- TODO move syngas liquefaction tech since it's needed on Vulcanus.