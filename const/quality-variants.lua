--[[ Defines entities that need to be substituted with variant prototypes by quality.
This was originally used for quality-scaling power consumption, but they added an easier way to do that in 2.0.56 (thanks boskid!) so that's no longer necessary.
Leaving this code here because we could use it for different quality-specific changes in the future. (TODO)

Note this file isn't aware of surface substitutions. So if you have surface variants that need quality-variants, you need to add them here.
]]

local Export = {}

-- Separator between entity name and quality suffix. Chosen to hopefully not appear in the IDs of any modded entities.
local qualitySeparator = "-LSA_"

-- Type and name of entities that need to be substituted with variant prototypes by quality. Format: {entity type, entity name, function to apply quality-specific changes to proto}
---@type {[1]: string, [2]: string, [3]: fun(proto: any, qualityLevel: number)}[]
local qualityVariantsData = {
	-- Example (which works), TODO remove once we have actual variants.
	--[[
	{"furnace", "battery-charger", function(proto, qualityLevel)
		proto.energy_usage = (1 + 0.3 * qualityLevel) .. "kW"
	end},
	]]
}

-- Convert to a set for fast lookups, and then explicitly map quality to modified strings so we don't need to build strings at runtime.
-- Exported table is in form entity type => entity name => (nil (if no quality variants) or {{quality => name of quality version}, function to apply quality-specific changes to proto}).
local function makeQualityName(entName, qualityLevel)
	if qualityLevel == 0 then
		return entName
	else
		return entName .. qualitySeparator .. qualityLevel
	end
end
---@type table<string, table<string, {qualityNames: table<number, string>, change: fun(proto: any, qualityLevel: number)}>>
local qualityVersions = {}
for _, vals in pairs(qualityVariantsData) do
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

	qualityVersions[vals[1]][vals[2]] = {qualityNames = {}, change = vals[3]}
	for _, quality in pairs(qualityProtos) do
		qualityVersions[vals[1]][vals[2]].qualityNames[quality.level] = makeQualityName(vals[2], quality.level)
	end
end
Export.qualityVersions = qualityVersions

-- Make a table mapping back from quality-variant ents' names to the original names.
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