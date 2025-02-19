--[[ This file edits quality levels.
Seems the only things mods can edit are beacon power, mining drill drain, and science pack drain.
Editing them to be regular numbers base 10, rather than 1/6, etc.
]]

local qualityData = {
	uncommon = {
		beaconPower = 0.8,
		drillDrain = 0.8,
	},
	rare = {
		beaconPower = 0.6,
		drillDrain = 0.6,
	},
	epic = {
		beaconPower = 0.4,
		drillDrain = 0.4,
	},
	legendary = {
		beaconPower = 0.2,
		drillDrain = 0.2,
	},
}
for qualityName, vals in pairs(qualityData) do
	local quality = RAW.quality[qualityName]
	quality.beacon_power_usage_multiplier = vals.beaconPower
	quality.mining_drill_resource_drain_multiplier = vals.drillDrain
end