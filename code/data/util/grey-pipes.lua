-- This file makes pipe graphics to attach to machines. Similar to assembler 2 and 3 pipes, except without the blue/green tint. Code copied from base/prototypes/entity/assemblerpipes.lua.

local function makeGreyPipes()
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

return makeGreyPipes