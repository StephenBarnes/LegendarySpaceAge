--[[ This file defines constants for the regulators (1x1 beacons).
Generally I want them to have the same effect as the corresponding primed circuit.
And we limit them to 1 per machine (or averaging if there's multiple), using beacon profile.
So these are generally better than the basic beacons, but the 1-per-machine limit means you also want to add beacons.
]]

return {
	productivity = {
		baseColor = {.9, .1, .1},
		lightColor = {1, .3, .3},
		effect = {
			productivity = 0.1,
			consumption = 1,
			pollution = 0.1,
		},
	},
	speed = {
		baseColor = {.15, .15, .9},
		lightColor = {.3, .6, 1},
		animationSpeedMult = 2,
		effect = {
			speed = 0.5,
			consumption = 1,
		},
	},
	efficiency = {
		baseColor = {.1, .9, .1},
		lightColor = {.3, 1, .3},
		effect = {
			consumption = -0.5,
		},
	},
	quality = {
		baseColor = {.9, .9, .9},
		lightColor = {1, 1, 1},
		effect = {
			quality = 0.25, -- This is per-10, so 0.1 means 1% bonus.
		},
	},
}