--[[ This file sets up techs with "rate triggers", eg "make 300 iron ingots per minute for 3 minutes".
This file does data-stage changes for that, while control script actually unlocks techs based on these triggers.
Seems we can't use research_triggers, or else it resets research progress to zero constantly. So instead consider these science packs, like IR3 Inspirations mod did.
]]

for _, rateTech in pairs{
	{"automation-science-pack", "iron-gear-wheel", 150},
	{"logistic-science-pack", "electronic-circuit", 360},
	{"chemical-science-pack", "plastic-bar", 720},
	{"military-science-pack", "piercing-rounds-magazine", 180},
} do
	local techName = rateTech[1]
	local producedItemName = rateTech[2]
	local requiredCount = rateTech[3]
	local tech = TECH[techName]
	tech.research_trigger = nil
	tech.unit = {
		count = requiredCount,
		ingredients = {
			{producedItemName .. "-per-minute", 1},
		},
		time = 1,
	}
	tech.ignore_tech_cost_multiplier = true
end

-- Function to make a dummy science-pack item.
local function makeRateItem(itemName, base)
	---@type data.ToolPrototype
	local rateItem = copy(base or ITEM[itemName])
	rateItem.type = "tool"
	rateItem.durability = 1
	rateItem.name = itemName .. "-per-minute"
	rateItem.hidden = true
	rateItem.hidden_in_factoriopedia = true
	rateItem.subgroup = nil
	rateItem.factoriopedia_alternative = itemName
	rateItem.spoil_ticks = nil
	rateItem.spoil_result = nil
	rateItem.localised_name = {"item-name.rate-item-per-minute", {"item-name." .. itemName}}
	assert(rateItem.icon ~= nil, "Rate item " .. itemName .. " has no icon")
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
	return rateItem
end

-- Create rate items
local rateItems = {
	makeRateItem("iron-gear-wheel"),
	makeRateItem("electronic-circuit"),
	makeRateItem("plastic-bar"),
	makeRateItem("piercing-rounds-magazine", RAW.ammo["piercing-rounds-magazine"]),
}
extend(rateItems)

-- Create a dummy lab that accepts all these fake science packs, else there's an error.
local dummyLab = copy(RAW.lab.lab)
dummyLab.name = "rate-trigger-lab"
dummyLab.inputs = {}
for _, rateItem in pairs(rateItems) do
	table.insert(dummyLab.inputs, rateItem.name)
end
dummyLab.hidden = true
extend{dummyLab}