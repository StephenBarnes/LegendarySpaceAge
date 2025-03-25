-- This file adds equipment grids to the light and heavy armor, which can only hold basic starting equipment (solar panels, batteries, and personal roboports). This is to allow copy-paste construction from earlier in the game, using equipment given in starting inventory.

extend{
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
		order = (RAW["equipment-category"]["armor"].order or "") .. "-a",
	},
}

RAW.armor["light-armor"].equipment_grid = "early-armor-grid"
RAW.armor["heavy-armor"].equipment_grid = "early-armor-grid"

-- Add the "early-armor" category to everything we want to allow in the basic armors' grids.
for _, equipmentTypeAndName in pairs{
	{"roboport-equipment", "personal-roboport-equipment"},
	{"battery-equipment", "battery-equipment"},
	{"generator-equipment", "personal-burner-generator"},
	{"generator-equipment", "personal-battery-generator"},
} do
	table.insert(RAW[equipmentTypeAndName[1]][equipmentTypeAndName[2]].categories, "early-armor")
end

-- Edit personal burner generator's recipe so it's craftable early-game.
RECIPE["personal-burner-generator"].ingredients = {
	--{type = "item", name = "glass", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "shielding", amount = 1},
	{type = "item", name = "fluid-fitting", amount = 1},
}

-- Edit personal burner generator to be 50% efficient, so it consumes more fuel, but still produces 25kW/tile.
RAW["generator-equipment"]["personal-burner-generator"].burner.effectivity = 0.5

-- Unlock personal burner generator from its own tech, not modular armor.
Tech.removeRecipeFromTech("personal-burner-generator", "modular-armor")

-- Create a tech for light armor and personal burner generator.
local basicEquipmentTech = copy(TECH["electronics"])
basicEquipmentTech.name = "basic-equipment"
basicEquipmentTech.effects = {
	{type = "unlock-recipe", recipe = "light-armor"},
	{type = "unlock-recipe", recipe = "personal-burner-generator"},
	{type = "create-ghost-on-entity-death", modifier = true},
}
basicEquipmentTech.prerequisites = {"basic-electricity"}
Icon.set(basicEquipmentTech, "LSA/equipment/personal-burner-generator-tech")
	-- Tech icons have to be square, so had to re-include this, can't just use the one from the other mod.
basicEquipmentTech.research_trigger = {
	type = "craft-item",
	item = "ingot-iron-hot",
	count = 100,
}
extend{basicEquipmentTech}

-- Remove the create-ghost modifier from construction-robotics tech, since we're adding it early now.
local newEffects = {}
for _, effect in pairs(TECH["construction-robotics"].effects) do
	if effect.type ~= "create-ghost-on-entity-death" then
		table.insert(newEffects, effect)
	end
end
TECH["construction-robotics"].effects = newEffects

-- Since we're adding a lot of starting items, it seems we don't get all of them because there's not enough space in crashed ship.
RAW.container["crash-site-spaceship"].inventory_size = 20
RAW.container["crash-site-spaceship-wreck-medium-1"].inventory_size = 10
RAW.container["crash-site-spaceship-wreck-medium-2"].inventory_size = 5
RAW.container["crash-site-spaceship-wreck-medium-3"].inventory_size = 5
RAW.container["crash-site-spaceship-wreck-big-1"].inventory_size = 5
RAW.container["crash-site-spaceship-wreck-big-2"].inventory_size = 10

-- Move basic armor to electricity tech (so you don't unlock personal burner generator tech before its prereq)
RECIPE["light-armor"].enabled = false
-- Will add to tech in tech-progression.lua.
-- Will edit recipe in infra folders.