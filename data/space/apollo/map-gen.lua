-- This file defines map gen settings for Apollo.

return {
	property_expression_names = {
		elevation = "lunar_elevation", -- TODO make new elevation.
		aux = "vulcanus_aux", -- TODO
		cliffiness = "cliffiness_basic",
		cliff_elevation = "cliff_elevation_from_elevation",
		["entity:drill-node-ice:probability"] = "apollo_ice_node_probability",
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
				["lunar-dirt"] = {},
				["lunar-doughy"] = {},
				["lunar-clay"] = {},
				["lunar-sandy-rock"] = {},
				-- TODO add fulgoran rock.
			}
		},
		["decorative"] = {
			settings = {
				["apollo-crater-large"] = {},
				["apollo-crater-medium"] = {},
				["apollo-crater-small"] = {},
				["apollo-crater-tiny"] = {},
				-- TODO add rocks.
			}
		},
		["entity"] = {
			settings = {
				["drill-node-ice"] = {},
			}
		}
	}
}

-- TODO make cliffs, and then make them so they don't actually obstruct the player's movement, you can jump over them.