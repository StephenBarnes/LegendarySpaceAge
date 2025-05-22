--[[ This file exports a table of buildings that need to be swapped to other ents when built, depending on the surface.
For example: to make rocket silos on Apollo only need 10 parts per rocket, we swap them to rocket-silo-10parts.

The table maps ent type => name => surface => correct building for that surface.
We use surface "default" for all other surfaces.
]]

local rocketSubst = {
	apollo = "rocket-silo-10parts",
	default = "rocket-silo",
}

return {
	["rocket-silo"] = {
		["rocket-silo-10parts"] = rocketSubst,
		["rocket-silo"] = rocketSubst,
	},
}