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
local resource_autoplace = require("resource-autoplace")
--[[RAW.resource["drill-node-ice"].autoplace = resource_autoplace.resource_autoplace_settings{
	name = "drill-node-ice",
	order = "z",
	autoplace_control_name = "ice_node",
	base_density = 10,
	base_spots_per_km = 10,
	regular_rq_factor_multiplier = 1,
	starting_rq_factor_multiplier = autoplace_parameters.starting_rq_factor_multiplier,
	candidate_spot_count = autoplace_parameters.candidate_spot_count,
	tile_restriction = autoplace_parameters.tile_restriction
}]]
RAW.resource["drill-node-ice"].autoplace = {
	control = "ice_node",
	order = "z",
	probability_expression = "ice_node_probability",
	richness_expression = "1"
}
extend{
	{
		type = "noise-expression",
		name = "ice_node_probability",
		expression = "(control:ice_node:size > 0)\z
                  * (max(aquilo_starting_flourine_vent * 0.02,\z
                        aquilo_starting_flourine_vent_tiny > 0,\z
                        min(aquilo_starting_mask, aquilo_flourine_vent_spots) * 0.008))"
	},
}