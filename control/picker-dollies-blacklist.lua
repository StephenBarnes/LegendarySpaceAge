--[[ This file blacklists some entities from picker dollies. ]]

local ExclusionZoneConst = require("const.exclusion-zones")

local function onInitOrLoad()
	local epd_api = remote.interfaces['PickerDollies']
	if (epd_api) then
		-- Blacklist all exclusion-zone-using entities from picker dollies, since they'll be obstructed by their own exclusion zones.
		for entName, _ in pairs(ExclusionZoneConst) do
			remote.call('PickerDollies', 'add_blacklist_name', entName)
		end
		-- Blacklist mini-assemblers, since teleporting is completely banned for loaders and transport belts, so we can't teleport the mini-assembler's child loader ents.
		remote.call('PickerDollies', 'add_blacklist_name', 'mini-assembler')
		-- Blacklist arc furnaces, since the apprentice effect requires wires, so trying to move it gives "wires can't be stretched further" error anyway.
		remote.call('PickerDollies', 'add_blacklist_name', 'arc-furnace')
	end
end

return {
	onInitOrLoad = onInitOrLoad,
}