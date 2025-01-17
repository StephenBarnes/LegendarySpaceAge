-- This file adds equipment grids to the light and heavy armor, which can only hold basic starting equipment (solar panels, batteries, and personal roboports). This is to allow copy-paste construction from earlier in the game, using equipment given in starting inventory.

local Tech = require("code.util.tech")

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
	{"roboport-equipment", "personal-roboport-equipment"},
	{"battery-equipment", "battery-equipment"},
	{"generator-equipment", "personal-burner-generator"},
} do
	table.insert(data.raw[equipmentTypeAndName[1]][equipmentTypeAndName[2]].categories, "early-armor")
end

-- TODO add descriptions

-- Unlock personal burner generator from electronics, not modular armor.
Tech.removeRecipeFromTech("personal-burner-generator", "modular-armor")
Tech.addRecipeToTech("personal-burner-generator", "electronics")

-- Edit personal burner generator's recipe so it's craftable early-game.
data.raw.recipe["personal-burner-generator"].ingredients = {
	{type = "item", name = "iron-plate", amount = 10},
	{type = "item", name = "copper-cable", amount = 8},
	{type = "item", name = "electronic-circuit", amount = 1},
}