--[[ This file blacklists some entities from picker dollies. ]]

local ExclusionZoneConst = require("const.exclusion-zones")

local function onInitOrLoad()
	local epd_api = remote.interfaces['PickerDollies']
	if (epd_api) then
		-- Blacklist all exclusion-zone-using entities from picker dollies, since they'll be obstructed by their own exclusion zones.
		for entName, _ in pairs(ExclusionZoneConst) do
			remote.call('PickerDollies', 'add_blacklist_name', entName)
		end
	end
end

return {
	onInitOrLoad = onInitOrLoad,
}