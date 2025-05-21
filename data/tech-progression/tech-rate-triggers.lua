--[[ This file sets up techs with "rate triggers", eg "make 300 iron ingots per minute for 3 minutes".
This file does data-stage changes for that, while control script actually unlocks techs based on these triggers.
Seems we can't use research_triggers, or else it resets research progress to zero constantly. So instead consider these science packs, like IR3 Inspirations mod did.
]]

local TECH_RATES = require("const.tech-rates")

for techName, vals in pairs(TECH_RATES) do
	local tech = TECH[techName]
	tech.research_trigger = nil
	local techUnit = {}
	if vals.showPerMinute then
		techUnit.count = vals.numMinutes
	else
		techUnit.count = vals.numMinutes * 60
	end
	if vals.showPerMinute then
		techUnit.time = 60
	else
		techUnit.time = 1
	end
	if vals.showPerMinute then
		techUnit.ingredients = {{vals.item .. "-per-minute", vals.perSecond * 60}}
	else
		techUnit.ingredients = {{vals.item .. "-per-second", vals.perSecond}}
	end
	tech.unit = techUnit
	tech.ignore_tech_cost_multiplier = true
end

-- Function to make a dummy science-pack item.
---@param vals table
local function makeRateItem(vals)
	---@type data.ToolPrototype
	---@diagnostic disable-next-line: assign-type-mismatch
	local rateItem = copy(RAW[vals.baseKind][vals.item])
	rateItem.type = "tool"
	rateItem.durability = 1
	rateItem.name = vals.showPerMinute and vals.item .. "-per-minute" or vals.item .. "-per-second"
	rateItem.hidden = true
	rateItem.hidden_in_factoriopedia = true
	rateItem.subgroup = nil
	rateItem.factoriopedia_alternative = vals.item
	rateItem.spoil_ticks = nil
	rateItem.spoil_result = nil
	rateItem.localised_name = {
		vals.showPerMinute and "item-name.rate-item-per-minute" or "item-name.rate-item-per-second",
		{"item-name." .. vals.item},
	}
	assert(rateItem.icon ~= nil, "Rate item " .. vals.item .. " has no icon")
	rateItem.icons = {
		{icon = rateItem.icon, icon_size = rateItem.icon_size},
		{
			icon = "__core__/graphics/clock-icon.png",
			icon_size = 32,
			scale = 0.5,
			shift = {0, 0},
		},
	}
	rateItem.icon = nil
	extend{rateItem}
end

-- Create rate items
for _, vals in pairs(TECH_RATES) do
	makeRateItem(vals)
end

-- Create a dummy lab that accepts all these fake science packs, else there's an error.
local dummyLab = copy(RAW.lab.lab)
dummyLab.name = "rate-trigger-lab"
dummyLab.inputs = {}
for _, vals in pairs(TECH_RATES) do
	table.insert(dummyLab.inputs, vals.showPerMinute and (vals.item .. "-per-minute") or (vals.item .. "-per-second"))
end
dummyLab.hidden = true
extend{dummyLab}