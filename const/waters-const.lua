-- This file defines stuff for creating the water-like fluids - colors, icons, etc.
-- Barrel colors are imported into barrel-const.lua which is then applied by barrelling code. Colors and icons are applied in water-types.lua.

return {
	["raw-seawater"] = {
		baseColor = {0, .58, .592},
		flowColor = {.794, .606, .33},
		visColor = {0, .58, .592},
		barrelColors = {
			{0, .58, .592},
			{.794, .606, .33},
		},
		icon = "LSA/water-types/raw-seawater",
	},
	["clean-seawater"] = {
		baseColor = {.427, .498, .596},
		flowColor = {.871, .855, .824},
		visColor = {.427, .498, .596},
		barrelColors = {
			{.427, .498, .596},
			{.871, .855, .824},
		},
		icon = "LSA/water-types/clean-seawater",
	},
	["rich-brine"] = {
		baseColor = {.278, .392, .388},
		flowColor = {.769, .757, .722},
		visColor = {.278, .392, .388},
		barrelColors = {
			{.278, .392, .388},
			{.769, .757, .722},
		},
		icon = "LSA/water-types/rich-brine",
	},
	["bitterns"] = {
		baseColor = {.114, .145, .412},
		flowColor = {.71, .694, .651},
		visColor = {.114, .145, .412},
		barrelColors = {
			{.114, .145, .412},
			{.71, .694, .651},
		},
		icon = "LSA/water-types/bitterns",
	},
	["mudwater"] = {
		baseColor = {.533, .353, .18},
		flowColor = {.733, .655, .502},
		visColor = {.533, .353, .18},
		barrelColors = {
			{.62, .49, .251},
			{.4, .188, .09},
		},
		icon = "LSA/water-types/mudwater",
	},
}