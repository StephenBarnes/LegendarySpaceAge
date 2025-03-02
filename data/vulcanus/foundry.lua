local foundry = ASSEMBLER["foundry"]

-- Adjust stats of foundry.
foundry.crafting_speed = 1 -- Instead of 4, set it to base 1, since it doesn't share recipes with anything else anyway.
foundry.effect_receiver.base_effect = nil -- Remove base productivity bonus.
foundry.energy_source.emissions_per_minute = { pollution = 10 }
foundry.energy_source.drain = "200kW"
foundry.energy_usage = "800kW"

-- Change foundry animation speed, since I've reduced the crafting speed.
local gs = foundry.graphics_set
assert(gs ~= nil)
for _, layer in pairs(gs.animation.layers) do
	if layer.animation_speed == 0.16 then
		layer.animation_speed = 0.64
	end
end
for _, wv in pairs(gs.working_visualisations) do
	if wv.animation ~= nil and wv.animation.animation_speed == 0.16 then
		-- Checking for 0.16 so it doesn't apply to stuff like smoke.
		wv.animation.animation_speed = 0.64
	end
end

--[[ Set foundry fluidboxes. I like passthrough fluidboxes, they make lots of interesting designs possible. Especially with the no-lava-in-pipes restriction.
Seems I can't have fluidboxes with same positions and directions but only enable some. So, have to choose which ones we need, and they can't overlap.
So, what I/O lines do foundries need?
	* water input
	* steam output
	* input line for molten metals, OR two different molten metals.
So, will make 3 input fluidboxes, and then NOT explicitly assign results to them, but arrange so that if we have 1 molten-metal input, water goes to the right input and the other 2 inputs are both used for the single molten metal ingredient. Can't explicitly assign ingredients/results to multiple fluidboxes.
]]
---@return data.FluidBox
local function makePassthroughFluidLine(production_type, positionList, dirList)
	local pipe_connections = {}
	for i, position in pairs(positionList) do
		table.insert(pipe_connections, { flow_direction="input-output", direction = dirList[i], position = position })
	end
	local volume = Gen.ifThenElse(production_type == "input", 1000, 100)
	return {
		production_type = production_type,
		pipe_picture = util.empty_sprite(),
		pipe_picture_frozen = require("__space-age__.prototypes.entity.foundry-pictures").pipe_picture_frozen,
		pipe_covers = pipecoverspictures(),
		always_draw_covers = false,
		enable_working_visualisations = { production_type .. "-pipe" },
		volume = volume,
		pipe_connections = pipe_connections,
	}
end
local fluidIOGroup = {
	input = {
		{ -- North-south west, used for metal input 1.
			positionList = {{-1, -2}, {-1, 2}},
			dirList = {NORTH, SOUTH},
		},
		{ -- North-south east, used for metal input 2.
			positionList = {{1, -2}, {1, 2}},
			dirList = {NORTH, SOUTH},
		},
		{ -- East-west single south, used for water.
			positionList = {{-2, 1}, {2, 1}},
			dirList = {WEST, EAST},
			filter = "water",
		},
	},
	output = {
		{ -- East-west single north, used for steam.
			positionList = {{-2, -1}, {2, -1}},
			dirList = {WEST, EAST},
			filter = "steam",
		},
	},
}
local foundryFluidBoxes = {}
for productionType, fluidSets in pairs(fluidIOGroup) do
	for _, fluidSet in pairs(fluidSets) do
		local fluidBox = makePassthroughFluidLine(productionType, fluidSet.positionList, fluidSet.dirList)
		if fluidSet.filter ~= nil then -- I don't think filter does anything? Could remove it.
			fluidBox.filter = fluidSet.filter
		end
		table.insert(foundryFluidBoxes, fluidBox)
	end
end
foundry.fluid_boxes = foundryFluidBoxes


-- TODO later investigate tints - is foundry tinted for recipe? If not, could I tint the molten metal lights?