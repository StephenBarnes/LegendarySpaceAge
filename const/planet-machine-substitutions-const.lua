--[[ This file exports a table of buildings that need to be swapped to other ents when built, depending on the surface.
For example: to make rocket silos on Apollo only need 10 parts per rocket, we swap them to rocket-silo-10parts.

The table maps ent type => name => surface => correct building for that surface.
We use surface "default" for all other surfaces.

Note this file ignores the quality scaling stuff. That's applied after the surface substitutions. So you don't need to add substitutions for quality-variants here.
]]

local Export = {
	["rocket-silo"] = {
		-- Replace rocket silos on Apollo with rocket silos that only need 10 parts per rocket.
		["rocket-silo"] = {
			apollo = "rocket-silo-10parts",
			default = "rocket-silo",
		},
	},
	["offshore-pump"] = {
		-- Replace offshore pumps on Vulcanus with lava-pumps to prevent lava from going in pipes. See other file data/vulcanus/no-lava-in-pipes.lua for more details.
		["offshore-pump"] = {
			vulcanus = "lava-pump",
			default = "offshore-pump",
		},
	},
	["assembling-machine"] = {

		-- Furnaces: We use a -air variant for furnaces on planets with air in the atmosphere, and -noair for planets without air.
		["stone-furnace"] = {
			nauvis = "stone-furnace-air",
			gleba = "stone-furnace-air",
			default = "stone-furnace-noair",
		},
		["steel-furnace"] = {
			nauvis = "steel-furnace-air",
			gleba = "steel-furnace-air",
			default = "steel-furnace-noair",
		},
		["ff-furnace"] = {
			nauvis = "ff-furnace-air",
			gleba = "ff-furnace-air",
			default = "ff-furnace-noair",
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