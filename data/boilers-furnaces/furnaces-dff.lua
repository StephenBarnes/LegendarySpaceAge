--[[ Convert stone-furnace and steel-furnace to internally be assembling-machine, so that we can set eg char recipe.
Doing this in data-final-fixes stage, so that other mods are less likely to crash if they want to change these entities.
]]

local FurnaceConst = require("const.furnace-const")

for _, furnaceName in pairs{"stone-furnace", "steel-furnace", "ff-furnace", "electric-furnace"} do
	local furnace = FURNACE[furnaceName]
	furnace.type = "assembling-machine"
	extend{furnace}
	FURNACE[furnaceName] = nil
end

-- Edit pollution for stone furnace. This gets multiplied by the emissions multiplier for the specific vented gas.
ASSEMBLER["stone-furnace"].energy_source.emissions_per_minute = {pollution = 1}
-- Edit pollution to be zero for steel/ff furnaces, since they capture the waste gases.
for _, furnaceName in pairs{"steel-furnace", "ff-furnace"} do
	local furnace = ASSEMBLER[furnaceName]
	furnace.energy_source.emissions_per_minute = {}
end

-- Create alternate versions of the furnaces for planets with air in the atmosphere.
for _, furnaceName in pairs{"stone-furnace", "steel-furnace", "ff-furnace"} do
	local furnace = ASSEMBLER[furnaceName]
	for _, suffix in pairs{"-noair", "-air"} do
		local newFurnace = copy(furnace)
		newFurnace.name = newFurnace.name..suffix
		newFurnace.localised_name = {"entity-name."..furnace.name} -- TODO give them different names and icons, so we can tell them apart in signal GUI etc.
		newFurnace.localised_description = {"entity-description."..furnace.name}
		newFurnace.hidden_in_factoriopedia = true
		newFurnace.hidden = true
		newFurnace.factoriopedia_alternative = furnace.name
		newFurnace.placeable_by = {item = furnace.name, count = 1}
		newFurnace.minable.result = furnace.name
		extend{newFurnace}
	end
end

-- Give fluid input and output to all furnaces.
local oxygenInput = { --- @type data.FluidBox
	production_type = "input",
	filter = "oxygen-gas",
	pipe_picture = furnacepipepictures,
	pipe_covers = pipecoverspictures(),
	always_draw_covers = false,
	pipe_connections = {
		{ flow_direction = "input-output", position = {-0.5, 0.5}, direction = WEST },
		{ flow_direction = "input-output", position = {0.5, 0.5}, direction = EAST },
	},
	volume = 100,
}
local airInputExplicit = { --- @type data.FluidBox
	production_type = "input",
	filter = "air",
	pipe_picture = furnacepipepictures,
	pipe_covers = pipecoverspictures(),
	always_draw_covers = false,
	pipe_connections = {
		{ flow_direction = "input-output", position = {-0.5, -0.5}, direction = WEST },
		{ flow_direction = "input-output", position = {0.5, -0.5}, direction = EAST },
	},
	volume = 100,
}
local airInputLinked = { --- @type data.FluidBox
	production_type = "input",
	pipe_picture = nil,
	pipe_covers = nil,
	pipe_connections = {
		{ flow_direction = "input", position = {0.5, 0.5}, direction = NORTH, connection_type = "linked", linked_connection_id = FurnaceConst.airLinkId },
	},
	volume = 1000,
}
local gasOutputExplicit = { --- @type data.FluidBox
	production_type = "output",
	pipe_picture = furnacepipepictures,
	pipe_covers = pipecoverspictures(),
	always_draw_covers = false,
	pipe_connections = {
		{ flow_direction = "input-output", position = {0.5, -0.5}, direction = NORTH},
		{ flow_direction = "input-output", position = {0.5, 0.5}, direction = SOUTH},
	},
	volume = 100,
}
local gasOutputLinked = { --- @type data.FluidBox
	production_type = "output",
	pipe_picture = nil,
	pipe_covers = nil,
	pipe_connections = {
		{ flow_direction = "output", position = {-0.5, -0.5}, direction = NORTH, connection_type = "linked", linked_connection_id = FurnaceConst.outputLinkId },
	},
	volume = 1000,
}
ASSEMBLER["stone-furnace"].fluid_boxes = {airInputExplicit, gasOutputLinked}
ASSEMBLER["stone-furnace-air"].fluid_boxes = {airInputLinked, gasOutputLinked}
ASSEMBLER["stone-furnace-noair"].fluid_boxes = {airInputExplicit, gasOutputLinked}
ASSEMBLER["steel-furnace"].fluid_boxes = {airInputExplicit, oxygenInput, gasOutputExplicit}
ASSEMBLER["steel-furnace-air"].fluid_boxes = {airInputLinked, oxygenInput, gasOutputExplicit}
ASSEMBLER["steel-furnace-noair"].fluid_boxes = {airInputExplicit, oxygenInput, gasOutputExplicit}
ASSEMBLER["ff-furnace"].fluid_boxes = {airInputExplicit, oxygenInput, gasOutputExplicit}
ASSEMBLER["ff-furnace-air"].fluid_boxes = {airInputLinked, oxygenInput, gasOutputExplicit}
ASSEMBLER["ff-furnace-noair"].fluid_boxes = {airInputExplicit, oxygenInput, gasOutputExplicit}