-- This file changes thrusters.

-- Make the exclusion zone at the back shorter, so you can stack them more easily.
RAW.thruster.thruster.tile_buildability_rules = {
	{area = {{-1.8, -2.3}, {1.8, 2.3}}, required_tiles = {layers={ground_tile=true}}, colliding_tiles = {layers={empty_space=true}}, remove_on_collision = true},
	{area = {{-1.8, 2.7}, {1.8, 30.3}}, required_tiles = {layers={empty_space=true}}, remove_on_collision = true},
		-- Changing 90.3 to 30.3.
}