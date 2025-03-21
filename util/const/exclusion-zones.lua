--[[ This file contains constants for exclusion zones, used in both data and control stages.
I've only tested with both dims odd; I think they could be even too.
Making the 2nd number smaller than the 1st number is best, so that it's more rounded rather than cross-shaped.
]]

return {
	["air-separator"] = {
		size = 3,
		dims = {27, 21},
	},
	["deep-drill"] = {
		size = 11,
		dims = {35, 25},
	},
	["telescope"] = {
		size = 3,
		dims = {11, 7},
	},
}