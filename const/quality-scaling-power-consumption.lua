--[[ Defines entities that need to have their power consumption scaled with quality.

Note this file isn't aware of surface substitutions. So if you have surface variants that need to quality-scale, you need to add them here.
]]

local Export = {}

-- Separator between entity name and quality suffix. Chosen to hopefully not appear in the IDs of any modded entities.
local qualitySeparator = "-LSA_"


local qualityScalers = {
	{"assembling-machine", "stone-furnace-noair"},
	{"assembling-machine", "stone-furnace-air"},
	{"assembling-machine", "steel-furnace-noair"},
	{"assembling-machine", "steel-furnace-air"},
	{"assembling-machine", "ff-furnace-noair"},
	{"assembling-machine", "ff-furnace-air"},

	{"assembling-machine", "gasifier"},
	{"assembling-machine", "fluid-fuelled-gasifier"},
	{"furnace", "battery-charger"},
}

-- Convert to a set for fast lookups, and then explicitly map quality to modified strings so we don't need to build strings at runtime.
-- Exported table is in form entity type => entity name => (nil (if no quality scaling) or {quality => name of quality version}).
local function makeQualityName(entName, qualityLevel)
	if qualityLevel == 0 then
		return entName
	else
		return entName .. qualitySeparator .. qualityLevel
	end
end
local qualityVersions = {}
for _, vals in pairs(qualityScalers) do
	if qualityVersions[vals[1]] == nil then
		qualityVersions[vals[1]] = {}
	end
	qualityVersions[vals[1]][vals[2]] = {}

	local qualityProtos
	if data ~= nil then -- If we're in data stage.
		qualityProtos = data.raw.quality
	else -- If we're in control stage.
		qualityProtos = prototypes.quality
	end

	for _, quality in pairs(qualityProtos) do
		qualityVersions[vals[1]][vals[2]][quality.level] = makeQualityName(vals[2], quality.level)
	end
end
Export.qualityVersions = qualityVersions

-- Make a table mapping back from quality-scaled ents' names to the original names.
-- Exported table is entity name => original name.
local qualityToOriginal = {}
for _, entNamesToQualityToName in pairs(qualityVersions) do
	for originalName, qualityToName in pairs(entNamesToQualityToName) do
		for _, name in pairs(qualityToName) do
			if name ~= originalName then
				qualityToOriginal[name] = originalName
			end
		end
	end
end
Export.qualityToOriginal = qualityToOriginal

return Export