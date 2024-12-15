-- This file adds equipment grids to the light and heavy armor, which can only hold basic starting equipment (solar panels, batteries, and personal roboports). This is to allow copy-paste construction from earlier in the game, using equipment given in starting inventory.

data:extend{
	{
		type = "equipment-grid",
		name = "early-armor-grid",
		width = 5,
		height = 4,
		equipment_categories = {"early-armor"}
	},
	{
		type = "equipment-category",
		name = "early-armor",
		hidden = true,
		order = (data.raw["equipment-category"]["armor"].order or "") .. "-a",
	},
}

data.raw.armor["light-armor"].equipment_grid = "early-armor-grid"
data.raw.armor["heavy-armor"].equipment_grid = "early-armor-grid"

-- Add the "early-armor" category to everything we want to allow in the basic armors' grids.
for _, equipmentTypeAndName in pairs{
	{"solar-panel-equipment", "solar-panel-equipment"},
	{"roboport-equipment", "personal-roboport-equipment"},
	{"battery-equipment", "battery-mk2-equipment"},
	{"battery-equipment", "battery-equipment"}} do
	table.insert(data.raw[equipmentTypeAndName[1]][equipmentTypeAndName[2]].categories, "early-armor")
end

-- TODO add descriptions