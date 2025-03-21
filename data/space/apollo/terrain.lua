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
-- NOTE it seems this command doesn't work with local expressions, so I'm registering most of the stuff below as noise expressions for debugging.
]]

local enableDetailedApolloTerrainSliders = settings.startup["LSA-enable-detailed-apollo-terrain-sliders"].value

extend{
	------------------------------------------------------------------------
	--- General terrain noise.
	{ -- Crater scale: general scale parameter.
		name = "apollo_crater_scale",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"12 * var(\"control:apollo-crater-scale:frequency\")",
			"12"),
	},
	{
		name = "apollo_crater_max_radius",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"22 * var(\"control:apollo-crater-max-radius:frequency\") * apollo_crater_scale",
			"22 * apollo_crater_scale"),
	},
	{
		name = "apollo_crater_rad_variance",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"0.8 * var(\"control:apollo-crater-rad-variance:frequency\")",
			"0.8"),
	},
	{ -- Crater radius: random number between max radius and say 20% of max radius.
		name = "apollo_crater_radius",
		type = "noise-expression",
		expression = "apollo_crater_max_radius * random_penalty{x=x, y=y, amplitude=apollo_crater_rad_variance, source=1}",
	},
	{
		name = "apollo_crater_spacing_mult",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"2 * var(\"control:apollo-crater-spacing-mult:frequency\")",
			"2"),
	},
	{
		name = "apollo_crater_spacing",
		type = "noise-expression",
		expression = "apollo_crater_max_radius * apollo_crater_spacing_mult", -- This should be at least 2x crater_max_radius, so craters don't touch.
	},
	{
		name = "apollo_crater_ridge_height",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"4 * var(\"control:apollo-crater-ridge-height:frequency\")",
			"4"),
	},
	{
		name = "apollo_crater_depth",
		type = "noise-expression",
		--expression = "5", -- Number of points of depth the crater has, per area.
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"45 * var(\"control:apollo-crater-depth:frequency\")",
			"45"),
	},
	{
		name = "apollo_crater_candidate_count",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"60 * var(\"control:apollo-crater-candidate-count:frequency\")",
			"60"),
	},
	{
		name = "apollo_crater_density",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"2.0 * var(\"control:apollo-crater-density:frequency\")",
			"2.0"),
	},
	{ -- Place craters, using spot noise.
		-- x dimension is stretched a bit, so craters are wider than they are tall, to match the decoratives.
		name = "apollo_crater_spots",
		type = "noise-expression",
		expression = "spot_noise{x = x * 0.85, y = y, seed0 = map_seed, seed1 = 2,\z
						density_expression = apollo_crater_density,\z
						spot_quantity_expression = apollo_crater_radius * apollo_crater_radius * apollo_crater_depth,\z
						spot_radius_expression = apollo_crater_radius,\z
						spot_favorability_expression = 1,\z
						region_size = 1024,\z
						candidate_point_count = apollo_crater_candidate_count,\z
						hard_region_target_quantity = 0,\z
						suggested_minimum_candidate_point_spacing = apollo_crater_spacing,\z
						basement_value = -1000,\z
						maximum_spot_basement_radius = apollo_crater_max_radius}",
		local_expressions = {
			-- Moved out for now, so I can see it.
		},
	},
	{ -- Noise amplitude.
		name = "apollo_crater_noise_amplitude",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"2.25 * var(\"control:apollo-crater-noise-amplitude:frequency\")",
			"2.25"),
	},
	{ -- Noise frequency.
		name = "apollo_crater_noise_frequency",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"(1/50) * var(\"control:apollo-crater-noise-frequency:frequency\")",
			"(1/50)"),
	},
	{ -- Noise layer.
		name = "apollo_crater_spot_noise",
		type = "noise-expression",
		expression = "apollo_crater_noise_amplitude * multioctave_noise{x = x * 0.85, y = y, seed0 = map_seed, seed1 = 3, input_scale = apollo_crater_noise_frequency, output_scale = 1.1,\z
										octaves = 6, persistence = 0.6}",
	},
	{ -- Noise layer.
		name = "apollo_crater_spots_with_noise",
		type = "noise-expression",
		expression = "apollo_crater_spots + apollo_crater_spot_noise",
	},
	{ -- Ridge the spots so that it curves up at the edges, making W shape. Note the outside of spot noise is sometimes negative, so need the max with 0 too.
		name = "apollo_craters_ridged",
		type = "noise-expression",
		expression = "if(apollo_crater_spots_with_noise < apollo_crater_ridge_height, (2 * apollo_crater_ridge_height) - apollo_crater_spots_with_noise, apollo_crater_spots_with_noise)",
	},
	{ -- Negate the ridged spots, making M shape.
		name = "apollo_craters_ridged_negated",
		type = "noise-expression",
		expression = "(2 * apollo_crater_ridge_height) - apollo_craters_ridged",
	},
	{
		name = "apollo_inside_crater",
		type = "noise-expression",
		expression = "apollo_crater_spots_with_noise > 0",
	},
	{
		name = "apollo_elevation_noise_outside_craters_frequency",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"(1/20) * var(\"control:apollo-elevation-noise-outside-craters-frequency:frequency\")",
			"(1/20)"),
	},
	{
		name = "apollo_elevation_noise_outside_craters_amplitude",
		type = "noise-expression",
		expression = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
			"1.5 * var(\"control:apollo-elevation-noise-outside-craters-amplitude:frequency\")",
			"1.5"),
	},
	{
		name = "apollo_elevation_noise_outside_craters",
		type = "noise-expression",
		expression = "multioctave_noise{x = x, y = y, seed0 = map_seed, seed1 = 5, input_scale = apollo_elevation_noise_outside_craters_frequency, output_scale = apollo_elevation_noise_outside_craters_amplitude, octaves = 5, persistence = 0.5}",
	},
	{
		name = "apollo_elevation",
		type = "noise-expression",
		-- Out of any craters, elevation is 0. Inside craters, we use the negated-ridged crater shapes.
		expression = "if(apollo_inside_crater, apollo_craters_ridged_negated, apollo_elevation_noise_outside_craters)",
	},
	{
		name = "apollo_aux",
		type = "noise-expression",
		-- Aux dimension, mostly just for some terrain variation so it doesn't look so uniform.
		expression = "multioctave_noise{x = x, y = y, seed0 = map_seed, seed1 = 6, input_scale = (1/5), output_scale = 1, octaves = 6, persistence = 0.5}",
	},

	------------------------------------------------------------------------
	--- Tiles.
	{
		name = "apollo_doughy",
		type = "noise-expression",
		-- Doughy highland spawns outside craters.
		expression = "(apollo_inside_crater == 0) * (apollo_aux <= 0.5)",
	},
	{
		name = "apollo_dirt_2",
		type = "noise-expression",
		-- Highland 2 spawns outside craters, but at different aux.
		expression = "(apollo_inside_crater == 0) * (apollo_aux > 0.5)",
	},
	{
		name = "apollo_dirt",
		type = "noise-expression",
		-- Dirt tiles are on crater rims, ie inside crater regions at high elevations.
		expression = "(apollo_elevation >= 1.8) * apollo_inside_crater",
	},
	{
		name = "apollo_sandy_rock",
		type = "noise-expression",
		-- Sandy rock tiles are on crater slopes.
		expression = "apollo_inside_crater * (apollo_elevation > -5) * (apollo_elevation < 1.8)",
	},
	{
		name = "apollo_clay",
		type = "noise-expression",
		-- Clay lowlands are inside craters, at low elevations.
		expression = "(apollo_elevation <= -5) * apollo_inside_crater",
	},
}

-- Detailed sliders for controlling terrain gen.
if enableDetailedApolloTerrainSliders then
	for i, name in pairs{
		"apollo-crater-scale",
		"apollo-crater-max-radius",
		"apollo-crater-rad-variance",
		"apollo-crater-depth",
		"apollo-crater-ridge-height",
		"apollo-crater-candidate-count",
		"apollo-crater-noise-amplitude",
		"apollo-crater-noise-frequency",
		"apollo-crater-spacing-mult",
		"apollo-crater-density",
		"apollo-elevation-noise-outside-craters-frequency",
		"apollo-elevation-noise-outside-craters-amplitude",
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
end

extend{
	{
		type = "autoplace-control",
		name = "apollo_cliffs",
		order = "z",
		category = "cliff"
	}
}

--[[ Create autoplace for ice nodes.
Basically I want all craters to have some nodes, even small craters, but I also don't want big craters to have too many. So I want a higher density of ice nodes per area for small craters.
	So, accomplishing that using spot noise, with hard region target quantity. It tries to place nodes, but stops once it's placed enough, which causes lower density for big craters.
]]
RAW.resource["drill-node-ice"].autoplace = {
	control = "ice_node",
	order = "z",
	probability_expression = "ice_node_probability",
	richness_expression = "1",
	tile_restriction = {"apollo-clay"}, -- Only inside craters.
}
extend{
	{
		type = "noise-expression",
		name = "ice_node_probability",
		expression = "(control:ice_node:size > 0)\z
					* spot_noise{x = x, y = y, seed0 = map_seed, seed1 = 6,\z
						density_expression = (1 * (control:ice_node:frequency)) / region_area,\z
						spot_quantity_expression = 1,\z
						spot_radius_expression = 1,\z
						spot_favorability_expression = (apollo_clay),\z
						region_size = region_side,\z
						candidate_point_count = 10 * (control:ice_node:size),\z
						hard_region_target_quantity = 1,\z
						basement_value = 0,\z
						maximum_spot_basement_radius = 5}",
		local_expressions = {
			region_side = "128 * (control:ice_node:size)",
			region_area = "region_side * region_side",
		},
	},
}