--[[ This file collects worldgen for lunar terrain - tiles, resources, etc.

What terrain do we want?
On earth's moon IRL, lunar mountains are created by asteroid impacts. The crater rim is like a mountain range, and sometimes lava comes out in the middle forming a little mound.
So, I want most of the terrain to be highlands, but then there's also occasional big circular craters with mountains around the rim, maybe a boulder in the middle.
Telescopes are built on the mountains.

So, how to create that terrain using noise expressions?
	Use spot noise for mega-craters.
		Place highland wherever spot noise is at basement value.
		Use ridge function on the spot noise to curve the rim upwards, like a W shape.
		Then negate that, to make M shape crater.
		Adjust radius of spots to make some mega-craters bigger than others.
		Ideally these craters shouldn't overlap. Not sure how to prevent that, at boundaries of regions.

/c game.print(serpent.line(game.player.surface.calculate_tile_properties({
	"lunar_elevation",
	"lunar_crater_spots",
	"lunar_craters_ridged",
	"lunar_craters_ridged_negated",
	"crater_radius",
	"crater_ridge_height",
}, {game.player.character.position})))
]]

extend{
	------------------------------------------------------------------------
	--- General terrain noise.
	{ -- Crater scale: general scale parameter.
		name = "crater_scale",
		type = "noise-expression",
		--expression = "1",
		expression = "6 * var(\"control:crater-scale:frequency\")",
	},
	{
		name = "crater_max_radius",
		type = "noise-expression",
		--expression = "40 * crater_scale",
		expression = "60 * var(\"control:crater-max-radius:frequency\") * crater_scale",
	},
	{
		name = "crater_rad_variance",
		type = "noise-expression",
		--expression = "0.8",
		expression = "0.8 * var(\"control:crater-rad-variance:frequency\")",
	},
	{ -- Crater radius: random number between max radius and say 20% of max radius.
		name = "crater_radius",
		type = "noise-expression",
		expression = "crater_max_radius * random_penalty{x=x, y=y, amplitude=crater_rad_variance, source=1}",
	},
	{
		name = "crater_spacing",
		type = "noise-expression",
		expression = "crater_max_radius * 2.5", -- This should be at least 2x crater_max_radius, so craters don't touch.
	},
	{
		name = "crater_ridge_height",
		type = "noise-expression",
		expression = "3 * var(\"control:crater-ridge-height:frequency\")",
	},
	{
		name = "crater_depth",
		type = "noise-expression",
		--expression = "5", -- Number of points of depth the crater has, per area.
		expression = "40 * var(\"control:crater-depth:frequency\")",
	},
	{
		name = "crater_candidate_count",
		type = "noise-expression",
		expression = "400 * var(\"control:crater-candidate-count:frequency\")",
	},
	{
		name = "lunar_crater_spots",
		type = "noise-expression",
		expression = "spot_noise{x = x, y = y, seed0 = map_seed, seed1 = 2,\z
						density_expression = 1,\z
						spot_quantity_expression = crater_radius * crater_radius * crater_depth,\z
						spot_radius_expression = crater_radius,\z
						spot_favorability_expression = 1,\z
						region_size = 2048 * crater_scale,\z
						candidate_point_count = crater_candidate_count,\z
						hard_region_target_quantity = 0,\z
						suggested_minimum_candidate_point_spacing = crater_spacing,\z
						basement_value = -1000,\z
						maximum_spot_basement_radius = crater_max_radius}",
		local_expressions = {
			-- Moved out for now, so I can see it.
		},
	},
	{ -- Ridge the spots so that it curves up at the edges, making W shape. Note the outside of spot noise is sometimes negative, so need the max with 0 too.
		name = "lunar_craters_ridged",
		type = "noise-expression",
		expression = "if(lunar_crater_spots < crater_ridge_height, (2 * crater_ridge_height) - lunar_crater_spots, lunar_crater_spots)",
	},
	{ -- Negate the ridged spots, making M shape.
	-- TODO not completely sure about this. Especially the constant.
		name = "lunar_craters_ridged_negated",
		type = "noise-expression",
		expression = "(2 * crater_ridge_height) - lunar_craters_ridged",
	},
	{ -- Noise layer.
		name = "lunar_elevation_noise",
		type = "noise-expression",
		expression = "multioctave_noise{x = x, y = y, seed0 = map_seed, seed1 = 3, input_scale = 1/600, output_scale = .9,\z
										octaves = 6, persistence = 0.5}",
	},
	{
		name = "lunar_elevation",
		type = "noise-expression",
		-- Out of any craters, elevation is 1. Inside craters, we invert the crater and then add something to make mountain ridges.
		expression = "if(lunar_crater_spots < -900, 0, lunar_craters_ridged_negated + lunar_elevation_noise)",
	},
	--expression = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 2, input_scale = 1/60, output_scale = 1}",
	-- TODO add general noise.

	------------------------------------------------------------------------
	--- Tiles.
	{
		name = "lunar_doughy",
		type = "noise-expression",
		-- Doughy highland is outside of craters.
		--expression = "max((lunar_crater_spots == -1000), (lunar_elevation > 0) * 0.5)",
		--expression = "max((lunar_crater_spots == -1000), (lunar_elevation == 0))",
		expression = "(lunar_crater_spots <= 0) * 1000"
			-- Covers both basement values (-1000) and other values outside the radius (which are negative values like -2).
			-- The *1000 makes it override the other tiles, I think.
	},
	{
		name = "lunar_sandy_rock",
		type = "noise-expression",
		-- Sandy rock is wherever elevation is high.
		expression = "lunar_elevation >= 1.8",
	},
	{
		name = "lunar_dirt",
		type = "noise-expression",
		-- Dirt slopes are wherever elevation is fairly low.
		expression = "(lunar_elevation < 1.8) * (lunar_elevation > -5)",
	},
	{
		name = "lunar_clay",
		type = "noise-expression",
		-- Clay lowlands are wherever elevation is very low.
		expression = "(lunar_elevation <= -5) * (lunar_crater_spots > 0)",
	},
}

-- Temporary TODO: Adding some autoplace controls, to experiment.
for i, name in pairs{
	"crater-scale",
	"crater-max-radius",
	"crater-rad-variance",
	"crater-depth",
	"crater-ridge-height",
	"crater-candidate-count",
} do
	extend{
		{
			type = "autoplace-control",
			name = name,
			richness = false,
			order = "z" .. i,
			category = "terrain"
		},
	}
end