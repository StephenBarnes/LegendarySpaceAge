--[[ This file makes crater decoratives to put on Apollo, and defines autoplaces for them.

Notes on autoplacing craters:
* Craters just come from asteroid impacts and then stay there (since there's no wind on Apollo to erode them). Asteroid impacts are uniformly distributed. There might be large-scale patterns due to orbital mechanics or whatever, but our factory is small relative to the moon, so it's locally uniform. So don't use an aux noise layer to distribute them in clumps, etc, like they are on Vulcanus.
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

local megacrater_crater_penalty = 0.75 -- How much decorative craters are penalized from forming inside megacraters.

extend{
	-- Create first layer of noise expressions for craters.
	{
		type = "noise-expression",
		name = "apollo_crater_1",
		expression = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 1, input_scale = 1/8, output_scale = 1}"
	},
	{
		type = "noise-expression",
		name = "apollo_crater_2",
		expression = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 2, input_scale = 1/6, output_scale = 1}"
	},
	{ -- Used to decide between small and tiny craters, so we don't place them overlapping.
		type = "noise-expression",
		name = "apollo_crater_3",
		expression = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 3, input_scale = 1/4, output_scale = 1}"
	},
	{ -- Penalty to craters from large craters.
		type = "noise-expression",
		name = "apollo_megacrater_crater_penalty",
		expression = "1 - (apollo_clay * " .. megacrater_crater_penalty .. ")",
	},
	-- Create second layer of noise expressions for craters, using 1st layer to place them non-overlapping.
	{
		type = "noise-expression",
		name = "apollo_large_crater",
		expression = "(apollo_crater_1 > 0.76) * every_n_finer(7, 7) * apollo_megacrater_crater_penalty * apollo_megacrater_crater_penalty * .5",
		-- Applying the megacrater penalty twice, seems to produce better results.
	},
	{
		type = "noise-expression",
		name = "apollo_medium_crater",
		expression = "(apollo_crater_1 < 0.4) * (apollo_crater_2 > 0.7) * every_n_finer(5, 5) * apollo_megacrater_crater_penalty",
	},
	{
		type = "noise-expression",
		name = "apollo_small_crater",
		-- Use max with ranges on apollo_crater_1 to make tiny craters only spawn right inside large craters or outside them, not on the rim.
		expression = "max((apollo_crater_1 > 0.85) * every_n_finer(7, 7), (apollo_crater_1 < 0.4))\z
			* (apollo_crater_2 < 0.55)\z
			* every_n_finer(2, 2)\z
			* (apollo_crater_3 > 0.5)\z
			* apollo_megacrater_crater_penalty",
	},
	{
		type = "noise-expression",
		name = "apollo_tiny_crater",
		expression = "max((apollo_crater_1 > 0.85) * every_n_finer(7, 7), (apollo_crater_1 < 0.4))\z
			* (apollo_crater_2 < 0.55)\z
			* (apollo_crater_3 < 0.4)\z
			* 0.08\z
			* apollo_megacrater_crater_penalty",
	},
	-- Create noise expressions for rock decoratives.
	-- Small rocks should go anywhere, but more on rims of megacraters, fewer on non-mega craters except at center.
	{
		type = "noise-expression",
		name = "apollo_rock_small",
		expression = "(apollo_crater_1 < 0.4)\z
			* 0.005\z
			* max(apollo_sandy_rock, apollo_dirt, (1/5)) * 5\z
			* apollo_megacrater_crater_penalty",
	},
}

-- Create crater decoratives.
for i, vals in pairs{
	{
		name = "large",
		scale = 0.5,
		collisionSize = 3,
		placeLayer = "1",
	},
	{
		name = "medium",
		scale = 0.25,
		collisionSize = 1.5,
		placeLayer = "2",
	},
	{
		name = "small",
		scale = 0.1,
		collisionSize = 0.7,
		placeLayer = "3",
	},
	{
		name = "tiny",
		scale = 0.05,
		collisionSize = 0.51,
		placeLayer = "4",
	},
} do
	---@type data.DecorativePrototype
	local crater = {
		name = "apollo-crater-" .. vals.name,
		type = "optimized-decorative",
		order = "z[apollo]-b[decorative]-crater-" .. i,
		collision_box = { { -vals.collisionSize, -vals.collisionSize }, { vals.collisionSize, vals.collisionSize } },
		--collision_mask = {layers={water_tile=true, doodad=true, cliff=true}, colliding_with_tiles_only=false, not_colliding_with_itself=false},
		collision_mask = {layers={water_tile=true, doodad=true, cliff=true}, colliding_with_tiles_only=false, not_colliding_with_itself=false},
			-- This seems to just have absolutely no effect. Except the cliff one.
		render_layer = "decals", -- So it renders underneath brick paving, etc.
		tile_layer = decal_tile_layer,
		walking_sound = base_tile_sounds.walking.sand,
		autoplace = {
			order = "d[ground-surface]-e[crater]-" .. vals.placeLayer, -- TODO testing - same layer, so they won't overlap?
			probability_expression = "apollo_" .. vals.name .. "_crater",
			tile_restriction = {"apollo-doughy", "apollo-clay", "apollo-dirt-2"},
			--tile_restriction = {"apollo-doughy"},
		},
		pictures = {
			sheet = {
				filename = "__LegendarySpaceAge__/graphics/apollo/craters.png",
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

-- Create rock decoratives.
--local rockTint = {.643, .635, .630}
local rockTint = {.624, .635, .642} -- Originally they used {0.2588}*3 multiplied by a Vulcanus base tint of {1}*3.
local smallRock = copy(RAW["optimized-decorative"]["small-volcanic-rock"])
smallRock.name = "apollo-rock-small"
smallRock.autoplace.probability_expression = "apollo_rock_small"
smallRock.autoplace.order = "d[ground-surface]-f[rock]-1"
smallRock.collision_mask = {layers={water_tile=true, cliff=true}, colliding_with_tiles_only=false, not_colliding_with_itself=false}
	-- Add cliff to collision mask, since cliffs have reduced alpha, so rocks under them can shine through them.
for _, pic in pairs(smallRock.pictures) do
	pic.tint = rockTint
end
extend{smallRock}

-- TODO consider using tiny, medium, large, huge rocks as well.

-- TODO consider also using vulcanus-sand-decal.