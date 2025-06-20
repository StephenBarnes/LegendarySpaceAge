--[[ Defines entities that need to have their power consumption scaled with quality.
	For example, battery chargers charge up say 1MJ worth of batteries per second, and have energy consumption 1MW. But high-quality battery chargers have higher crafting speed, so they charge more than 1MJ per second, so their power consumption must scale up with quality too. Otherwise you could make infinite energy by charging and discharging batteries using quality chargers.
Same applies to other entities that could generate energy: boilers, gasifiers, furnaces (for char recipe), etc.

Note this file isn't aware of surface substitutions. So if you have surface variants that need quality-scaling, you need to add all of them here separately.
]]

-- Return a table of {entity type, entity name}.
---@type {[1]: string, [2]: string}[]
return {
	{"assembling-machine", "stone-furnace"},
	{"assembling-machine", "stone-furnace-air"},
	{"assembling-machine", "steel-furnace"},
	{"assembling-machine", "steel-furnace-air"},

	{"assembling-machine", "gasifier"},
	{"assembling-machine", "fluid-fuelled-gasifier"},
	{"furnace", "battery-charger"},

	{"assembling-machine", "shuttle-boiler"},
	{"assembling-machine", "electric-boiler"},
	{"assembling-machine", "burner-boiler"},
	{"assembling-machine", "burner-boiler-air"},
}