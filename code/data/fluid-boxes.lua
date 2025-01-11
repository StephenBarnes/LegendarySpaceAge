local Table = require("code.util.table")

-- TODO instead of assembler3pipepictures, make a new one that's like that but without the green tint. Use it for assembler 1 and for all of the fluid ports in this file.

-- Add 2 more fluid outputs to the refinery, so we can have recipes with 5 fluid outputs.
-- Could get away with adding only 1 new output, but then it's asymmetric so we can't flip it.
local oilRefinery = data.raw["assembling-machine"]["oil-refinery"]
local newFluidBox1 = Table.copyAndEdit(oilRefinery.fluid_boxes[5], {
	pipe_connections = {
		{position = {-2, 0}, direction = defines.direction.west, flow_direction = "output"},
	},
	pipe_picture = assembler3pipepictures(),
})
local newFluidBox2 = Table.copyAndEdit(oilRefinery.fluid_boxes[5], {
	pipe_connections = {
		{position = {2, 0}, direction = defines.direction.east, flow_direction = "output"},
	},
	pipe_picture = assembler3pipepictures(),
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

-- Add 1 more fluid input to chem plant, so we can do explosives recipe.
local chemPlant = data.raw["assembling-machine"]["chemical-plant"]
local newFluidBox = Table.copyAndEdit(chemPlant.fluid_boxes[1], {
	pipe_connections = {
		{position = {1, 0}, direction = defines.direction.east, flow_direction = "input"},
	},
	pipe_picture = assembler3pipepictures(),
})
chemPlant.fluid_boxes = {
	chemPlant.fluid_boxes[1], -- input
	newFluidBox, -- Stick it between the other 2 outputs, so if a recipe has 2 fluid inputs they get distributed more conveniently.
	chemPlant.fluid_boxes[2], -- input
	chemPlant.fluid_boxes[3], -- output
	chemPlant.fluid_boxes[4], -- output
}
chemPlant.fluid_boxes_off_when_no_fluid_recipe = false -- If this is true, they look weird when not used.

-- Also add an extra fluid input to biochambers, needed for synthetic rubber.
local bioChamber = data.raw["assembling-machine"]["biochamber"]
local newFluidBoxB = Table.copyAndEdit(bioChamber.fluid_boxes[1], {
	pipe_connections = {
		{position = {-1, 0}, direction = defines.direction.west, flow_direction = "input"},
	},
})
bioChamber.fluid_boxes = {
	bioChamber.fluid_boxes[1], -- input
	newFluidBoxB, -- Stick it between the other 2 outputs, so if a recipe has 2 fluid inputs they get distributed more conveniently.
	bioChamber.fluid_boxes[2], -- input
	bioChamber.fluid_boxes[3], -- output
	bioChamber.fluid_boxes[4], -- output
}

-- Add fluid input to the assembler 1, needed for some recipes.
data.raw["assembling-machine"]["assembling-machine-1"].fluid_boxes = data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes
data.raw["assembling-machine"]["assembling-machine-1"].fluid_boxes_off_when_no_fluid_recipe = true

-- Add extra fluid input to the foundry, needed for some recipes.
local foundry = data.raw["assembling-machine"]["foundry"]
local newFluidBoxF1 = Table.copyAndEdit(foundry.fluid_boxes[1], {
	pipe_connections = {
		{position = {-2, 0}, direction = defines.direction.west, flow_direction = "input"},
	},
	pipe_picture = assembler3pipepictures(),
})
foundry.fluid_boxes = {
	foundry.fluid_boxes[1], -- input
	foundry.fluid_boxes[2], -- input
	newFluidBoxF1, -- input
	foundry.fluid_boxes[3], -- output
	foundry.fluid_boxes[4], -- output
}