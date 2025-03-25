-- This file creates tech, item, recipe, and equipment for the personal battery generator equipment.

local TECH_IMG = "__LegendarySpaceAge__/graphics/personal-battery-generator/tech.png"
local ICON_IMG = "__LegendarySpaceAge__/graphics/personal-battery-generator/icon.png"

local equipment = copy(RAW["generator-equipment"]["personal-burner-generator"])
equipment.name = "personal-battery-generator"
equipment.sprite = {
	filename = TECH_IMG,
	width = 256,
	height = 256,
	mipmap_count = 4,
	scale = 0.6, -- Only affects scale when you right-click to open it. Doesn't affect size shown when looking at the equipment grid.
	priority = "medium",
}
equipment.shape = {
	width = 2,
	height = 2,
	type = "full",
}
equipment.burner = {
	type = "burner",
	usage_priority = "secondary-output",
	fuel_categories = {"battery"},
	effectivity = 1,
	fuel_inventory_size = 4,
	burnt_inventory_size = 4,
	smoke = nil,
	emissions_per_minute = {},
}
equipment.energy_source = {
	type = "electric",
	usage_priority = "primary-output",
	buffer_capacity = "1MJ",
	drain = "0W",
}
equipment.power = "150kW"
--[[ For comparison:
Solar panel is 30kW for 1 tile.
Portable fission reactor is 750kW for 4x4, so 46.875kW per tile.
Portable fusion reactor is 2.5MW for 4x4, so 156.25kW per tile.
Personal burner generator is 200kW for 4x2, so 25kW per tile. (But 50% efficient, so consumes 400kW fuel.)
So, could make this like 30-45kW per tile. Let's make it 150kW, so 37.5kW per tile.
]]
equipment.categories = {"armor"}
extend{equipment}

-- Create item.
local item = copy(ITEM["personal-burner-generator"])
item.name = "personal-battery-generator"
item.icon = ICON_IMG
item.icon_size = 64
item.place_as_equipment_result = "personal-battery-generator"
item.subgroup = "equipment"
item.order = "a[energy-source]-1"
stack_size = 50
Item.copySoundsTo("battery-equipment", item)
extend{item}

-- Create tech.
local tech = copy(TECH["battery"])
tech.name = "personal-battery-generator"
tech.effects = {{type = "unlock-recipe", recipe = "personal-battery-generator"}}
tech.prerequisites = {"battery", "basic-equipment"}
tech.icon = TECH_IMG
extend{tech}

-- Create recipe.
Recipe.make{
	recipe = "personal-battery-generator",
	copy = "personal-burner-generator",
	ingredients = {
		{"wiring", 10},
		{"frame", 2},
		{"electronic-components", 20},
	},
	time = 10,
	resultCount = 1,
	category = "electronics",
}