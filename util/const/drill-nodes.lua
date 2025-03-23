-- This file defines constants for "drill nodes", which are placed on world gen and can be harvested with a borehole drill to produce extra resources (eg ice on Apollo, or iron/copper/coal/uranium nodes on Nauvis). Mostly created to provide ice on Apollo. These constants are used both in data stage (to make recipes and entities) and in control stage (to set recipes for borehole drills).

local R = {}

R.specs = {
	{
		name = "ice",
		darkTint = {.125, .184, .239},
		--lightTint = {.655, .757, .796},
		lightTint = {.349, .537, .631},
		mapTint = {.639, .741, .784},
		iconTint = {.639, .741, .784},
		vaporTint = {.565, .663, .698},
		vaporAlpha = 0.24,
		results = {
			{type = "item", name = "ice", amount = 10},
			{type = "fluid", name = "water", amount = 10},
		},
		addToTech = nil, --"planet-discovery-apollo", -- Not adding yet, bc making tech after creating drill nodes.
		order = "2b",
	},
	-- TODO more.
}

R.sideLen = 7

return R