-- This file makes crater decoratives to put on Heimdall.
-- Mostly copied from vanilla code.

local base_tile_sounds = require("__base__.prototypes.tile.tile-sounds")
local space_age_tile_sounds = require ("__space-age__.prototypes.tile.tile-sounds")

local base_decorative_sprite_priority = "extra-high"
local decal_tile_layer = 255
function get_decal_pictures(file_path, size_class, image_size, amount, tint, tint_as_overlay, scale)
	local pictures  = {}
	tint_as_overlay = tint_as_overlay or false
	tint            = tint or { 1, 1, 1 }
	for i = 1, amount do
		table.insert(pictures,
			{
				filename = file_path .. size_class .. string.format("%02i", i) .. ".png",
				priority = base_decorative_sprite_priority,
				width = image_size,
				height = image_size,
				scale = 0.5 * (scale or 1),
				tint_as_overlay = tint_as_overlay,
				tint = tint
			})
	end
	return pictures
end

for i, vals in pairs{
	{ -- Place large craters first, then smaller ones.
		name = "large",
		scale = 0.5,
		collisionSize = 3,
		noise_expression = "min(0.03, (0.2 - vulcanus_rock_noise - aux) * place_every_n(5,5,0,0))",
	},
	{
		name = "medium",
		scale = 0.25,
		collisionSize = 1.5,
		noise_expression = "min(0.05, (0.2 - vulcanus_rock_noise - aux) * place_every_n(3,3,0,0))",
	},
	{
		name = "small",
		scale = 0.1,
		collisionSize = 0.7,
		noise_expression = "min(0.02, (0.2 - vulcanus_rock_noise - aux))",
	},
} do
	extend{
		{
			name = "heimdall-crater-" .. vals.name,
			type = "optimized-decorative",
			order = "z[heimdall]-b[decorative]-crater", -- Same order, so they won't overlap? TODO
			collision_box = { { -vals.collisionSize, -vals.collisionSize }, { vals.collisionSize, vals.collisionSize } },
			collision_mask = {layers={water_tile=true, doodad=true, cliff=true}, colliding_with_tiles_only=false, not_colliding_with_itself=false},
			render_layer = "decals", -- So it renders underneath brick paving, etc.
			--minimal_separation = 3.0, -- TODO testing.
			--target_count = 4, -- TODO testing.
			tile_layer = decal_tile_layer,
			walking_sound = base_tile_sounds.walking.sand,
			autoplace = {
				order = "d[ground-surface]-e[crater]-" .. i,
				probability_expression = "heimdall_crater_" .. vals.name,
			},
			--pictures = get_decal_pictures("__LegendarySpaceAge__/graphics/heimdall/craters/", "", 1024, 24, nil, true, vals.scale)
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
		},
		{ -- Create noise expressions for placing these.
			type = "noise-expression",
			name = "heimdall_crater_" .. vals.name,
			expression = vals.noise_expression
		},
	}
end