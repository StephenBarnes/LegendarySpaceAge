--[[ This file exports a table of buildings that need to be swapped to other ents when built, depending on the surface.
For example: to make rocket silos on Apollo only need 10 parts per rocket, we swap them to rocket-silo-10parts.

The table maps ent type => name => surface => correct building for that surface.
We use surface "default" for all other surfaces.
]]

local Export = {
	["rocket-silo"] = {
		["rocket-silo"] = {
			apollo = "rocket-silo-10parts",
			default = "rocket-silo",
		},
	},
}

-- Annotate this, adding substitutions from substituted versions, for faster lookup. For example, if we have substitutions defined for rocket-silo, and one of those substitution-results is "rocket-silo-10parts", then we also add "rocket-silo-10parts" to the table, with the same surface substitutions.
for entType, entNames in pairs(Export) do
	for entName, surfaceToCorrect in pairs(entNames) do
		for surfaceName, correctName in pairs(surfaceToCorrect) do
			if Export[entType][correctName] == nil then
				Export[entType][correctName] = surfaceToCorrect
			end
		end
	end
end

return Export