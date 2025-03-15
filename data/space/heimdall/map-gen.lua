-- This file defines map gen settings for Heimdall.

return {
	property_expression_names = {
		elevation = "vulcanus_elevation", -- TODO make new elevation.
		aux = "vulcanus_aux", -- TODO
		cliffiness = "cliffiness_basic",
		cliff_elevation = "cliff_elevation_from_elevation",
		["entity:drill-node-ice:probability"] = "heimdall_ice_node_probability",
	},
	cliff_settings = {
		name = "cliff-nauvis", -- TODO make new cliff set.
		cliff_elevation_interval = 120,
		cliff_elevation_0 = 70
	},
	autoplace_controls = {
		["ice_node"] = {},
	},
	autoplace_settings = {
		["tile"] = {
			settings = {
				-- TODO
				--nauvis tiles
				["volcanic-soil-dark"] = {},
				["volcanic-soil-light"] = {},
				["volcanic-ash-soil"] = {},
			}
		},
		["decorative"] = {
			settings = {
				["heimdall-crater-small"] = {},
				["heimdall-crater-medium"] = {},
				["heimdall-crater-large"] = {},
				-- TODO
				["calcite-stain"] = {},
				["calcite-stain-small"] = {},
				--["crater-small"] = {},
				--["crater-large"] = {},
			}
		},
		["entity"] = {
			settings = {
				["drill-node-ice"] = {},
			}
		}
	}
}