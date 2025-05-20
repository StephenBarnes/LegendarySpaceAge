local Const = require "util.const.heat-shuttle-const"

-- Create heat/cold shuttle relations.
for _, vals in pairs(Const.heatShuttles) do
	local coldItem = ITEM[vals[1]]
	local hotItem = ITEM[vals[2]]
	local heatValue = vals[3]
	local spoilTime = vals[4]

	coldItem.fuel_value = heatValue
	hotItem.fuel_value = heatValue
	coldItem.burnt_result = hotItem.name
	hotItem.burnt_result = coldItem.name
	coldItem.fuel_category = "heat-absorber"
	hotItem.fuel_category = "heat-provider"
	hotItem.spoil_ticks = spoilTime
	hotItem.spoil_result = coldItem.name
end

-- Create burner usage for heat provider and absorber items.
local emptyHeatSlot = {
	filename = "__LegendarySpaceAge__/graphics/heat-shuttles/empty-heat-slot-mip.png",
	priority = "extra-high-no-scale",
	size = 64,
	mipmap_count = 2,
	flags = {"gui-icon"}
}
local heatWarning = {
	filename = "__LegendarySpaceAge__/graphics/heat-shuttles/heat-icon-red.png",
	priority = "extra-high-no-scale",
	width = 64,
	height = 64,
	flags = {"icon"}
}
for _, details in pairs{
	{
		name = "heat-absorber",
		-- TODO could give them separate empty slot sprites and warning icons.
	},
	{
		name = "heat-provider",
	},
	{
		name = "cooling-provider",
	},
} do
	-- Create fuel category.
	extend{{
		type = "fuel-category",
		name = details.name,
	}}

	-- Create burner usage.
	local burnerUsage = copy(RAW["burner-usage"]["fuel"])
	burnerUsage.name = details.name
	burnerUsage.empty_slot_sprite = emptyHeatSlot
	burnerUsage.empty_slot_caption = {"gui." .. details.name}
	burnerUsage.empty_slot_description = nil
	burnerUsage.icon = heatWarning
	burnerUsage.no_fuel_status = {"entity-status.no-" .. details.name}
	burnerUsage.accepted_fuel_key = "description.accepted-" .. details.name
	burnerUsage.burned_in_key = details.name .. "-to" -- [factoriopedia] category in locale file.
	extend{burnerUsage}
end