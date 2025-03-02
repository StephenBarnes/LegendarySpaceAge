-- Add 2 more fluid outputs to the refinery, so we can have recipes with 5 fluid outputs.
-- Could get away with adding only 1 new output, but then it's asymmetric so we can't flip it.
local oilRefinery = ASSEMBLER["oil-refinery"]
local newFluidBox1 = copy(oilRefinery.fluid_boxes[5])
newFluidBox1.pipe_connections = {
	{position = {-2, 1}, direction = defines.direction.west, flow_direction = "output"},
}
newFluidBox1.pipe_picture = GreyPipes.pipeBlocksShortWest()

local newFluidBox2 = copy(oilRefinery.fluid_boxes[5])
newFluidBox2.pipe_connections = {
	{position = {2, 1}, direction = defines.direction.east, flow_direction = "output"},
}
newFluidBox2.pipe_picture = GreyPipes.pipeBlocksShortWest()

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
local chemPlant = ASSEMBLER["chemical-plant"]
local newFluidBox = copy(chemPlant.fluid_boxes[1])
newFluidBox.pipe_connections = {
	{position = {1, 0}, direction = defines.direction.east, flow_direction = "input"},
}
newFluidBox.pipe_picture = GreyPipes.pipeBlocksShortNorthWest()
chemPlant.fluid_boxes = {
	chemPlant.fluid_boxes[1], -- input
	newFluidBox, -- Stick it between the other 2 outputs, so if a recipe has 2 fluid inputs they get distributed more conveniently.
	chemPlant.fluid_boxes[2], -- input
	chemPlant.fluid_boxes[3], -- output
	chemPlant.fluid_boxes[4], -- output
}
chemPlant.fluid_boxes_off_when_no_fluid_recipe = false -- If this is true, they look weird when not used.

-- Also add an extra fluid input to biochambers, needed for synthetic rubber.
local bioChamber = ASSEMBLER["biochamber"]
local newFluidBoxB = copy(bioChamber.fluid_boxes[1])
newFluidBoxB.pipe_connections = {
	{position = {-1, 0}, direction = defines.direction.west, flow_direction = "input"},
}
bioChamber.fluid_boxes = {
	bioChamber.fluid_boxes[1], -- input
	newFluidBoxB, -- Stick it between the other 2 outputs, so if a recipe has 2 fluid inputs they get distributed more conveniently.
	bioChamber.fluid_boxes[2], -- input
	bioChamber.fluid_boxes[3], -- output
	bioChamber.fluid_boxes[4], -- output
}

-- Add fluid input to the assembler 1, needed for some recipes.
ASSEMBLER["assembling-machine-1"].fluid_boxes = ASSEMBLER["assembling-machine-2"].fluid_boxes
ASSEMBLER["assembling-machine-1"].fluid_boxes_off_when_no_fluid_recipe = true
for _, fluidBox in pairs(ASSEMBLER["assembling-machine-1"].fluid_boxes) do
	fluidBox.pipe_picture = GreyPipes.pipeBlocks()
end

-- Add fluid inputs to the rocket silo, needed for assembling rocket parts.
local rocketSilo = RAW["rocket-silo"]["rocket-silo"]
rocketSilo.fluid_boxes_off_when_no_fluid_recipe = false
rocketSilo.fluid_boxes = {
	{
		production_type = "input",
		pipe_picture = GreyPipes.pipeBlocksDeepDrill(),
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = {
			--[[
			{position = {4, 2}, direction = defines.direction.east, flow_direction = "input-output"},
			{position = {-4, 2}, direction = defines.direction.west, flow_direction = "input-output"},
			{position = {-2, -4}, direction = defines.direction.north, flow_direction = "input-output"},
			{position = {-2, 4}, direction = defines.direction.south, flow_direction = "input-output"},
			]]
			{position = {4, -1}, direction = defines.direction.east, flow_direction = "input-output"},
			{position = {-4, -1}, direction = defines.direction.west, flow_direction = "input-output"},
		},
	},
	{
		production_type = "input",
		pipe_picture = GreyPipes.pipeBlocksDeepDrill(),
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = {
			--{position = {4, -2}, direction = defines.direction.east, flow_direction = "input-output"},
			--{position = {-4, -2}, direction = defines.direction.west, flow_direction = "input-output"},
			{position = {2, -4}, direction = defines.direction.north, flow_direction = "input-output"},
			{position = {2, 4}, direction = defines.direction.south, flow_direction = "input-output"},
		},
		secondary_draw_orders = { south = 100, north = -1 },
	},
}