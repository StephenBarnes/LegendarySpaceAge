-- This file makes pipe graphics to attach to machines. Similar to assembler 2 and 3 pipes, except without the blue/green tint, and with some priorities changed.. Code copied from base/prototypes/entity/assemblerpipes.lua.

-- Function to get grey blocks of pipes, like the blue blocks on assembler2's and green blocks on assembler3's.
---@return data.Sprite4Way
local function pipeBlocks()
	return {
		north = {
			filename = "__LegendarySpaceAge__/graphics/pipes/assembling-machine-1-pipe-N.png",
			priority = "extra-high",
			width = 71,
			height = 38,
			shift = util.by_pixel(2.25, 13.5),
			scale = 0.5
		},
		east = {
			filename = "__LegendarySpaceAge__/graphics/pipes/assembling-machine-1-pipe-E.png",
			priority = "extra-high",
			width = 42,
			height = 76,
			shift = util.by_pixel(-24.5, 1),
			scale = 0.5
		},
		south = {
			filename = "__LegendarySpaceAge__/graphics/pipes/assembling-machine-1-pipe-S.png",
			priority = "extra-high",
			width = 88,
			height = 61,
			shift = util.by_pixel(0, -31.25),
			scale = 0.5
		},
		west = {
			filename = "__LegendarySpaceAge__/graphics/pipes/assembling-machine-1-pipe-W.png",
			priority = "extra-high",
			width = 39,
			height = 73,
			shift = util.by_pixel(25.75, 1.25),
			scale = 0.5
		}
	}
end

-- Function to get grey blocks of pipes, but the north one is longer.
---@return data.Sprite4Way
local function pipeBlocksLongNorth()
	local r = pipeBlocks()
	r.north.filename = "__LegendarySpaceAge__/graphics/pipes/assembling-machine-1-pipe-N-long.png"
	return r
end

-- Function to get grey blocks of pipes, but the north one uses special cover for deep drill.
---@return data.Sprite4Way
local function pipeBlocksDeepDrill()
	local r = pipeBlocks()
	r.north.filename = "__LegendarySpaceAge__/graphics/pipes/assembling-machine-1-pipe-N-deep-drill.png"
	r.north.height = 47
	r.north.shift = util.by_pixel(2.25, 13.5+2.25)
	return r
end

-- Function to get grey blocks of pipes, but the north one is shorter.
---@return data.Sprite4Way
local function pipeBlocksShortNorthWest()
	local r = pipeBlocks()
	r.north.filename = "__LegendarySpaceAge__/graphics/pipes/assembling-machine-1-pipe-N-short.png"
	r.west.filename = "__LegendarySpaceAge__/graphics/pipes/assembling-machine-1-pipe-W-short.png"
	return r
end

-- Function to get grey blocks of pipes, but the west one is short
---@return data.Sprite4Way
local function pipeBlocksShortWest()
	local r = pipeBlocks()
	r.west.filename = "__LegendarySpaceAge__/graphics/pipes/assembling-machine-1-pipe-W-short.png"
	return r
end

-- Function to get grey blocks of pipes, but the north and south ones are empty.
---@return data.Sprite4Way
local function pipeBlocksEmptyNS()
	local r = pipeBlocks()
	r.north = util.empty_sprite()
	r.south = util.empty_sprite()
	return r
end

-- Function to get EM-plant-like pipes but longer (manually edited).
---@return data.Sprite4Way
local function pipeBlocksEMPlantLong()
	---@type data.Sprite4Way
	local r = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures
	-- North: added 26 pixels at the bottom.
	-- Not sure why the shift isn't half the added height; values here found by trial and error.
	r.north.layers[1].filename = "__LegendarySpaceAge__/graphics/pipes/EM-plant-modified/N.png"
	r.north.layers[1].height = 100
	r.north.layers[1].shift = util.by_pixel(-1, 22.5 + 10)
	-- East and west: added 6 pixels on left and right side respectively.
	r.east.layers[1].filename = "__LegendarySpaceAge__/graphics/pipes/EM-plant-modified/E.png"
	r.east.layers[1].width = 32 + 6
	r.east.layers[1].shift = util.by_pixel(-20.5 - 2, 0.5)
	r.west.layers[1].filename = "__LegendarySpaceAge__/graphics/pipes/EM-plant-modified/W.png"
	r.west.layers[1].width = 38 + 6
	r.west.layers[1].shift = util.by_pixel(22.5 + 2, 2)
	return r
end

return {
	pipeBlocks = pipeBlocks,
	pipeBlocksLongNorth = pipeBlocksLongNorth,
	pipeBlocksDeepDrill = pipeBlocksDeepDrill,
	pipeBlocksShortNorthWest = pipeBlocksShortNorthWest,
	pipeBlocksShortWest = pipeBlocksShortWest,
	pipeBlocksEmptyNS = pipeBlocksEmptyNS,
	pipeBlocksEMPlantLong = pipeBlocksEMPlantLong,
}