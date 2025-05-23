--[[ Defines entities that need to have their power consumption scaled with quality.
Exported table is in form entity type => entity name => true (if it should scale).
]]

local qualityScalers = {
	{"assembling-machine", "stone-furnace"},
	{"assembling-machine", "steel-furnace"},
	{"assembling-machine", "ff-furnace"},
	{"assembling-machine", "gasifier"},
	{"assembling-machine", "fluid-fuelled-gasifier"},
	{"furnace", "battery-charger"},
}

local Export = {}
for _, vals in pairs(qualityScalers) do
	if Export[vals[1]] == nil then
		Export[vals[1]] = {}
	end
	Export[vals[1]][vals[2]] = true
end

return Export