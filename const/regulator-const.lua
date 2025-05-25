--[[ This file defines constants for the regulators (1x1 beacons).
Generally I want them to have about half as much effect as the corresponding primed circuit.
]]

return {
	productivity = {
		color = {.9, .1, .1},
		effect = {
			productivity = 0.05,
			consumption = 0.5,
			pollution = 0.05,
		},
	},
	speed = {
		color = {.15, .15, .9},
		effect = {
			speed = 0.25,
			consumption = 0.5,
		},
	},
	efficiency = {
		color = {.1, .9, .1},
		effect = {
			consumption = -0.25,
		},
	},
	quality = {
		color = {.9, .9, .9},
		effect = {
			quality = 0.125, -- This is per-10, so 0.1 means 1% bonus.
		},
	},
}