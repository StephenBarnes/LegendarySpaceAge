-- Create autoplace control for ice nodes.
extend{
	{
		type = "autoplace-control",
		name = "ice_node",
		localised_name = { "", "[entity=drill-node-ice] ", { "entity-name.drill-node-ice" } },
		richness = false, -- TODO?
		order = "z", -- TODO?
		category = "resource"
	},
}

-- Create autoplace for ice nodes.
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
					* spot_noise{x = x, y = y, seed0 = map_seed, seed1 = 4,\z
						density_expression = 0.5 * (control:ice_node:frequency),\z
						spot_quantity_expression = 1,\z
						spot_radius_expression = 1,\z
						spot_favorability_expression = (apollo_clay),\z
						region_size = 512,\z
						candidate_point_count = 30,\z
						hard_region_target_quantity = 0,\z
						basement_value = -1000,\z
						maximum_spot_basement_radius = apollo_crater_max_radius}",
	},
}