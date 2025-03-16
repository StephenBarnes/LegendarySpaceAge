--[[ This file makes crater decoratives to put on Heimdall, and defines autoplaces for them.

Notes on autoplacing craters:
* Craters just come from asteroid impacts and then stay there (since there's no wind on Heimdall to erode them). Asteroid impacts are uniformly distributed. There might be large-scale patterns due to orbital mechanics or whatever, but our factory is small relative to the moon, so it's locally uniform. So don't use an aux noise layer to distribute them in clumps, etc, like they are on Vulcanus.
* Craters IRL do sometimes overlap. But my decals partially overlapping won't work, makes a vesica piscis shape that looks unnatural. So I want to avoid overlaps. But it's fine for smaller craters to be completely inside larger ones.
* The collision mask doesn't seem to work for decoratives, except for the cliff layer and tile layers. Can't use them to make craters not overlap. Seems it forces colliding_with_tiles_only=true, maybe.
* So instead, I'll have to use noise expressions to make them not overlap.
	* Vanilla code has a place_every_n noise-function which places at the corners of a sort of tilted triangular grid. Used for crater decals on Vulcanus. However this sometimes includes like 2 adjacent tiles, so it can create overlapping cters.
* We could also use control-stage scripts - on chunk generated, look for large or medium craters, remove other large/medium craters that are overlapping.
* Let's use a basis noise layer, then segment by ranges:
	* Large craters spawn where it's say 0.95 - 1.0.
	* Then all other craters only spawn where it's say under 0.7 or above 0.98 (ie inside large craters).
	* Then use a second noise layer as a nested condition to place medium vs small/tiny, etc.
]]

local base_tile_sounds = require("__base__.prototypes.tile.tile-sounds")

local base_decorative_sprite_priority = "extra-high"
local decal_tile_layer = 255

-- Define a new version of the built-in place_every_n function that's a bit narrower, won't include multiple adjacent tiles.
extend{{
	type = "noise-function",
	name = "every_n_finer",
	parameters = {"x_spacing", "y_spacing"},
	expression = "min(((x + y * 0.93819) / 1.41983 % x_spacing) <= 0.6,\z
                       ((x / 4.1875839 - y) * 0.913853883 % y_spacing) <= 0.6)",
}}

-- Noise expressions for craters.
extend{
	{
		type = "noise-expression",
		name = "heimdall_crater_1",
		expression = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 1, input_scale = 1/8, output_scale = 1}"
	},
	{
		type = "noise-expression",
		name = "heimdall_crater_2",
		expression = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 2, input_scale = 1/6, output_scale = 1}"
	},
	{ -- Used to decide between small and tiny craters, so we don't place them overlapping.
		type = "noise-expression",
		name = "heimdall_crater_3",
		expression = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 3, input_scale = 1/4, output_scale = 1}"
	},
}

for i, vals in pairs{
	{
		name = "large",
		scale = 0.5,
		collisionSize = 3,
		placeLayer = "1",
		probabilityExpression = "(heimdall_crater_1 > 0.76) * every_n_finer(7, 7)",
	},
	{
		name = "medium",
		scale = 0.25,
		collisionSize = 1.5,
		placeLayer = "2",
		probabilityExpression = "(heimdall_crater_1 < 0.5) * (heimdall_crater_2 > 0.7) * every_n_finer(5, 5)",
	},
	{
		name = "small",
		scale = 0.1,
		collisionSize = 0.7,
		placeLayer = "3",
		-- Use max with ranges on heimdall_crater_1 to make tiny craters only spawn right inside large craters or outside them, not on the rim.
		probabilityExpression = "max((heimdall_crater_1 > 0.85) * every_n_finer(7, 7), (heimdall_crater_1 < 0.5))\z
			* (heimdall_crater_2 < 0.55)\z
			* every_n_finer(2, 2)\z
			* (heimdall_crater_3 > 0.5)",
	},
	{
		name = "tiny",
		scale = 0.05,
		collisionSize = 0.51,
		placeLayer = "4",
		probabilityExpression = "max((heimdall_crater_1 > 0.85) * every_n_finer(7, 7), (heimdall_crater_1 < 0.5))\z
			* (heimdall_crater_2 < 0.55)\z
			* (heimdall_crater_3 < 0.4)\z
			* 0.12",
	},
} do
	---@type data.DecorativePrototype
	local crater = {
		name = "heimdall-crater-" .. vals.name,
		type = "optimized-decorative",
		order = "z[heimdall]-b[decorative]-crater-" .. i,
		collision_box = { { -vals.collisionSize, -vals.collisionSize }, { vals.collisionSize, vals.collisionSize } },
		--collision_mask = {layers={water_tile=true, doodad=true, cliff=true}, colliding_with_tiles_only=false, not_colliding_with_itself=false},
		collision_mask = {layers={water_tile=true, doodad=true, cliff=true}, colliding_with_tiles_only=false, not_colliding_with_itself=false},
			-- This seems to just have absolutely no effect. Except the cliff one.
		render_layer = "decals", -- So it renders underneath brick paving, etc.
		tile_layer = decal_tile_layer,
		walking_sound = base_tile_sounds.walking.sand,
		autoplace = {
			order = "d[ground-surface]-e[crater]-" .. vals.placeLayer, -- TODO testing - same layer, so they won't overlap?
			probability_expression = vals.probabilityExpression,
		},
		pictures = {
			sheet = {
				filename = "__LegendarySpaceAge__/graphics/heimdall/craters.png",
				width = 1024,
				height = 1024,
				scale = 0.5 * vals.scale,
				variation_count = 24,
				priority = base_decorative_sprite_priority,
				line_length = 6,
			},
		},
	}
	extend{crater}
end