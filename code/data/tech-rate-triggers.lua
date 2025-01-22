--[[ This file sets up techs with "rate triggers", eg "make 300 iron ingots per minute for 3 minutes".
This file does data-stage changes for that, while control script actually unlocks techs based on these triggers.
Seems we can't use research_triggers, or else it resets research progress to zero constantly. So instead consider these science packs, like IR3 Inspirations mod did.
]]

data.raw.technology["automation-science-pack"].research_trigger = nil
data.raw.technology["automation-science-pack"].unit = {
	count = 200,
	ingredients = {
		{"iron-gear-wheel-per-minute", 1},
	},
	time = 1,
}
data.raw.technology["automation-science-pack"].ignore_tech_cost_multiplier = true

data.raw.technology["logistic-science-pack"].research_trigger = nil
data.raw.technology["logistic-science-pack"].unit = {
	count = 400,
	ingredients = {
		{"electronic-circuit-per-minute", 1},
	},
	time = 1,
}
data.raw.technology["logistic-science-pack"].ignore_tech_cost_multiplier = true

-- Function to make a dummy science-pack item.
local function makeRateItem(itemName, backgroundIcons)
	local rateItem = table.deepcopy(data.raw.item[itemName])
	rateItem.type = "tool"
	---@diagnostic disable-next-line: inject-field
	rateItem.durability = 1
	rateItem.name = itemName .. "-per-minute"
	rateItem.hidden = true
	rateItem.hidden_in_factoriopedia = true
	rateItem.subgroup = nil
	rateItem.factoriopedia_alternative = itemName
	---@diagnostic disable-next-line: inject-field
	rateItem.auto_recycle = false -- TODO this doesn't do anything, also this goes in recipes not items; TODO check.
	rateItem.spoil_ticks = nil
	rateItem.spoil_result = nil
	rateItem.localised_name = {"item-name.rate-item-per-minute", {"item-name." .. itemName}}
	rateItem.icons = backgroundIcons
	table.insert(rateItem.icons, {
		icon = "__core__/graphics/clock-icon.png",
		icon_size = 32,
		scale = 0.5,
		shift = {0, 0},
	})
	return rateItem
end

-- Create rate items
local rateItems = {
	makeRateItem("iron-gear-wheel", table.deepcopy(data.raw.item["iron-gear-wheel"].icons)),
	makeRateItem("electronic-circuit", {{icon = data.raw.item["electronic-circuit"].icon, icon_size = data.raw.item["electronic-circuit"].icon_size}}),
}
data:extend(rateItems)

-- Create a dummy lab that accepts all these fake science packs, else there's an error.
local dummyLab = table.deepcopy(data.raw.lab.lab)
dummyLab.name = "rate-trigger-lab"
dummyLab.inputs = {}
for _, rateItem in pairs(rateItems) do
	table.insert(dummyLab.inputs, rateItem.name)
end
dummyLab.hidden = true
data:extend{dummyLab}