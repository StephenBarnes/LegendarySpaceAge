--[[ For some entities, we want to substitute them with variants by quality, to give different quality levels different values.
Note that QualityPrototype supports many changes - for those, just adjust that, don't use quality-variant prototypes.

This runs in data-final-fixes stage, so that it takes place after other changes to the entities.
]]

local QualityVariants = require("const.quality-variants")

for entType, entNamesToQualityToName in pairs(QualityVariants.qualityVersions) do
	for entName, qualityToName in pairs(entNamesToQualityToName) do
		---@diagnostic disable-next-line: assign-type-mismatch
		local normalEnt = RAW[entType][entName]
		assert(normalEnt ~= nil, "Entity not found: "..entType.." "..entName)
		for qualityLevel, qualityName in pairs(qualityToName.qualityNames) do
			if qualityName ~= entName then -- Don't need to hide normal ent.
				---@diagnostic disable-next-line: assign-type-mismatch
				local newEnt = copy(normalEnt)
				newEnt.name = qualityName
				newEnt.localised_name = normalEnt.localised_name or {"entity-name."..normalEnt.name}
				newEnt.localised_description = normalEnt.localised_description or {"entity-description."..normalEnt.name}
				assert(normalEnt.placeable_by ~= nil, "placeable_by is nil for "..normalEnt.name)
				newEnt.placeable_by = normalEnt.placeable_by
					--[[ Other mods that do this kind of one-proto-per-quality thing have a quality= field here. But that field does not exist. https://lua-api.factorio.com/latest/types/ItemToPlace.html
					Despite the non-existence of that field, those other mods mostly work anyway because the player has no way to copy an XYZ-legendary with normal quality unless one has already been placed.
					But there's a way around that. Make an upgrade planner that replaces XYZ-legendary (legendary) with XYZ-legendary (normal). Then you can copy-paste that one to place unlimited XYZ-legendary (normal) using only normal quality XYZ-normal items.
					That's a minor exploit, not crucial to fix. And in fact since I'm making higher-quality items WORSE in this way (increased power consumption) I don't think this exploit actually offers any advantage in this mod.
					]]
				newEnt.hidden_in_factoriopedia = true
				newEnt.hidden = true -- This actually makes it unselectable in upgrade planner, so I think it closes the loophole explained above.

				-- Apply the quality-specific changes.
				QualityVariants.qualityVersions[entType][entName].change(newEnt, qualityLevel)

				---@diagnostic disable-next-line: assign-type-mismatch
				data:extend{newEnt}
			end
		end
	end
end