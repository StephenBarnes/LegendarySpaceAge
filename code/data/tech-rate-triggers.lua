--[[ This file sets up techs with "rate triggers", eg "make 300 iron ingots per minute for 3 minutes".
This file does data-stage changes for that, while control script actually unlocks techs based on these triggers.
Seems we can't use research_triggers, or else it resets research progress to zero constantly. So instead consider these science packs, like IR3 Inspirations mod did.
]]

data.raw.technology["automation-science-pack"].research_trigger = nil
data.raw.technology["automation-science-pack"].unit = {
	count = 120,
	ingredients = {
		{"ingot-iron-hot-per-minute", 1},
	},
	time = 1,
}
data.raw.technology["automation-science-pack"].ignore_tech_cost_multiplier = true

local ingotIronRateItem = table.deepcopy(data.raw.item["ingot-iron-hot"])
ingotIronRateItem.type = "tool"
---@diagnostic disable-next-line: inject-field
ingotIronRateItem.durability = 100
ingotIronRateItem.name = "ingot-iron-hot-per-minute"
ingotIronRateItem.hidden = true
ingotIronRateItem.hidden_in_factoriopedia = true
ingotIronRateItem.subgroup = nil
ingotIronRateItem.factoriopedia_alternative = "ingot-iron-hot"
---@diagnostic disable-next-line: inject-field
ingotIronRateItem.auto_recycle = false
ingotIronRateItem.spoil_ticks = nil
ingotIronRateItem.spoil_result = nil
table.insert(ingotIronRateItem.icons, {
	icon = "__core__/graphics/clock-icon.png",
	icon_size = 32,
	scale = 0.5,
	shift = {0, 0},
})
data:extend{ingotIronRateItem}

-- Create a dummy lab that accepts all these fake science packs, else there's an error.
local dummyLab = table.deepcopy(data.raw.lab.lab)
dummyLab.name = "rate-trigger-lab"
dummyLab.inputs = {"ingot-iron-hot-per-minute"}
dummyLab.hidden = true
data:extend{dummyLab}