--[[ This file defines the techs unlocked by production rates.
baseKind is the data.raw key for finding the thing to copy to make the rate item.
]]

---@type table<string, {item: string, perSecond: number, numMinutes: number, subtractInputItemName: string|nil, showPerMinute: boolean}>
return {
	["automation-science-pack"] = {
		item = "mechanism",
		perSecond = 0.5,
		numMinutes = 3,
		baseKind = "item",
		showPerMinute = true,
	},
	["logistic-science-pack"] = {
		item = "sensor",
		perSecond = 1,
		numMinutes = 5,
		baseKind = "item",
		showPerMinute = false,
	},
	["chemical-science-pack"] = {
		item = "plastic-bar",
		perSecond = 20,
		numMinutes = 5,
		baseKind = "item",
		showPerMinute = false,
	},
	["military-science-pack"] = {
		item = "piercing-rounds-magazine",
		perSecond = 5,
		numMinutes = 5,
		baseKind = "ammo",
		showPerMinute = false,
	},
}