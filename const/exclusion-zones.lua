--[[ This file defines exclusion zones, used in both data stage (to create the entities) and control stage (using child-entity system to place them when parent is built).
Exclusion zones are used to prevent buildings from being placed too close to each other.

I've only tested with both dims odd; I think they could be even too.
Making the 2nd number smaller than the 1st number is best, so that it's more rounded rather than cross-shaped.
]]

---@type { [string]: { size: number, dims: {[1]:number, [2]:number} } }
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