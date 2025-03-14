-- This file defines constants for "drill nodes", which are placed on world gen and can be harvested with a borehole drill to produce extra resources (eg ice on Heimdall, or iron/copper/coal/uranium nodes on Nauvis). Mostly created to provide ice on Heimdall. These constants are used both in data stage (to make recipes and entities) and in control stage (to set recipes for borehole drills).

local R = {}

R.specs = {
	{
		name = "ice",
		entTint = {.565, .663, .698},
		mapTint = {.639, .741, .784},
		--iconTint = {.727, .832, .867},
		iconTint = {.639, .741, .784},
		results = {
			{type = "item", name = "ice", amount = 10},
			{type = "fluid", name = "water", amount = 10},
		},
		addToTech = "planet-discovery-heimdall",
	},
	-- TODO more.
}

R.sideLen = 5

return R