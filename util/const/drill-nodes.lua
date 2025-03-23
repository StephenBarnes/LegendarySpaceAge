-- This file defines constants for "drill nodes", which are placed on world gen and can be harvested with a borehole drill to produce extra resources (eg ice on Apollo, or iron/copper/coal/uranium nodes on Nauvis). Mostly created to provide ice on Apollo. These constants are used both in data stage (to make recipes and entities) and in control stage (to set recipes for borehole drills).

local R = {}

R.specs = {
	{
		name = "ice",
		iconTint = {.639, .741, .784},
		mapTint = {.639, .741, .784},
		rockTint = {.467, .443, .443, .7}, -- Apollo crater-floor tint, since that's where it spawns.
		rockTintAsOverlay = true,
		-- TODO rename dark/lightTint to edge/deepTint.
		darkTint = {.125, .184, .239},
		darkTintAsOverlay = true,
		darkTintGlows = false,
		--lightTint = {.655, .757, .796},
		lightTint = {.349, .537, .631},
		lightTintAsOverlay = true,
		lightTintGlows = false,
		vaporTint = {.565, .663, .698},
		vaporAlpha = 0.24,
		results = {
			{type = "item", name = "ice", amount = 10},
			{type = "fluid", name = "water", amount = 10},
		},
		addToTech = nil, --"planet-discovery-apollo", -- Not adding yet, bc making tech after creating drill nodes.
		order = "2b",
	},
	{ -- TODO this is currently mostly placeholder to test graphics. Need to fully implement by deciding recipe results, adding autoplace, editing default borehole mining products (when not on node), etc.
		name = "carbon",
		iconTint = {.2, .2, .2},
		mapTint = RAW.resource["crude-oil"].map_color,
		rockTint = {.155, .130, .115, .3}, -- Vulcanus terrain tint.
		rockTintAsOverlay = true,
		darkTint = {.2, .2, .2},
		darkTintAsOverlay = false,
		darkTintGlows = false,
		lightTint = {0, 0, 0}, -- Using darker colors for "light tint" so it's dark in the middle.
		lightTintAsOverlay = false, -- Otherwise it's white in the middle which looks wrong.
		lightTintGlows = false,
		vaporTint = {.2, .2, .2},
		vaporAlpha = 0.55,
		results = {
			{type = "item", name = "carbon", amount = 10},
			{type = "fluid", name = "tar", amount = 10},
		},
		addToTech = "planet-discovery-vulcanus",
		order = "3",
	},
	{ -- TODO this is currently mostly placeholder to test graphics. Need to fully implement by deciding recipe results, adding autoplace, editing default borehole mining products (when not on node), etc.
		name = "geoplasm",
		iconTint = {.7, .25, .22},
		mapTint = {.792, .384, .361},
		rockTint = util.multiply_color({.404, .365, .239}, .45), -- Gleba terrain tint. TODO redo this once you've decided what terrain type it spawns on, to match that terrain.
		rockTintAsOverlay = true,
		--darkTint = {.306, .451, .098},
		darkTint = {.792, .384, .361},
		darkTintGlows = false,
		darkTintAsOverlay = false,
		lightTint = {.7, .25, .22},
		lightTintGlows = false,
		lightTintAsOverlay = false,
		--vaporTint = {.306, .451, .098}, -- Green vapor?
		vaporTint = {.4, .1, .1}, -- Red vapor
		vaporAlpha = 0.3,
		results = {
			{type = "item", name = "marrow", amount = 10},
			{type = "fluid", name = "geoplasm", amount = 10},
		},
		addToTech = "planet-discovery-gleba",
		order = "4",
		-- TODO add sounds? Maybe a squelching sound.
		-- TODO add tint for the rock layer, since it should fit with surface's scenery.
	},
}

R.sideLen = 7

return R