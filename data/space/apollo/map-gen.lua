-- This file defines map gen settings for Apollo.

local enableDetailedApolloTerrainSliders = settings.startup["LSA-enable-detailed-apollo-terrain-sliders"].value
local autoplaceControls = Gen.ifThenElse(enableDetailedApolloTerrainSliders,
	{
		["ice_node"] = {},
		["apollo-crater-scale"] = {},
		["apollo-crater-max-radius"] = {},
		["apollo-crater-rad-variance"] = {},
		["apollo-crater-depth"] = {},
		["apollo-crater-ridge-height"] = {},
		["apollo-crater-candidate-count"] = {},
		["apollo-crater-noise-amplitude"] = {},
		["apollo-crater-noise-frequency"] = {},
		["apollo-crater-spacing-mult"] = {},
		["apollo-crater-density"] = {},
		["apollo_cliffs"] = {},
	},
	{
		["ice_node"] = {},
		["apollo_cliffs"] = {},
	}
)

return {
	property_expression_names = {
		elevation = "apollo_elevation",
		aux = "vulcanus_aux", -- TODO
		cliffiness = "cliffiness_basic",
		cliff_elevation = "cliff_elevation_from_elevation",
		["entity:drill-node-ice:probability"] = "apollo_ice_node_probability",
	},
	cliff_settings = {
		name = "cliff-vulcanus", -- TODO make new cliff set?
		cliff_elevation_interval = 1.4,
		cliff_elevation_0 = 1,
		cliff_smoothing = 1,
		control = "apollo_cliffs",
	},
	autoplace_controls = autoplaceControls,
	autoplace_settings = {
		["tile"] = {
			settings = {
				["apollo-dirt"] = {},
				["apollo-doughy"] = {},
				["apollo-clay"] = {},
				["apollo-sandy-rock"] = {},
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