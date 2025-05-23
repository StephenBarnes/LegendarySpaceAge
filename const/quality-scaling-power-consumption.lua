--[[ Defines entities that need to have their power consumption scaled with quality.
Exported table is in form entity type => entity name => true (if it should scale).

Note this file isn't aware of surface substitutions. So if you have surface variants that need to quality-scale, you need to add them here.
]]

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

-- Convert to a set for fast lookups, and export.
local Export = {}
for _, vals in pairs(qualityScalers) do
	if Export[vals[1]] == nil then
		Export[vals[1]] = {}
	end
	Export[vals[1]][vals[2]] = true
end

return Export