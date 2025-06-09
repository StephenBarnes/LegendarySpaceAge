-- This file adds sections to the tips-and-tricks panel.

extend {
	{ -- Make category, to put it at the top.
		type = "tips-and-tricks-item-category",
		name = "Legendary-Space-Age",
		order = "---a",
	},
}

for i, section in pairs{
	{name = "main", indent = 0},
	{name = "early-bots"},
	{
		name = "factors",
		trigger = {type = "research", technology = "basic-electricity"},
	},
	{
		name = "enemy-spawns",
		trigger = {type = "research", technology = "char"},
	},
	{
		name = "enemy-resistances",
		trigger = {type = "research", technology = "char"},
	},
	{
		name = "power-overload",
		trigger = {type = "research", technology = "basic-electricity"},
	},
	{
		name = "dumping",
		trigger = {type = "research", technology = "automation"},
	},
	{
		name = "fuels",
		trigger = {type = "research", technology = "fluid-handling"},
	},
	{
		name = "acid-base-chemistry",
		-- TODO add trigger and tech.
	},
	{
		name = "balance-changes",
		trigger = {type = "research", technology = "automation-science-pack"},
	},
	{
		name = "space-platforms",
		trigger = {type = "research", technology = "space-platform"},
	},
	{
		name = "planet-drops",
		trigger = {type = "research", technology = "space-platform-thruster"},
	},
	{
		name = "vulcanus",
		trigger = {type = "research", technology = "planet-discovery-vulcanus"},
	},
	{
		name = "vulcanus-lava",
		indent = 2,
		trigger = {type = "research", technology = "planet-discovery-vulcanus"},
	},
	{
		name = "gleba",
		trigger = {type = "research", technology = "planet-discovery-gleba"},
	},
	{
		name = "aquilo-trip",
		trigger = {type = "research", technology = "planet-discovery-aquilo"},
	},
} do
	---@type data.TipsAndTricksItem
	section = section
	section.name = "LSA-" .. section.name
	section.type = "tips-and-tricks-item"
	section.category = "Legendary-Space-Age"
	section.order = string.format("%02d", i)
	section.indent = section.indent or 1
	---@diagnostic disable-next-line: assign-type-mismatch
	extend{section}
end
