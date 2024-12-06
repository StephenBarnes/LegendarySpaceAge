local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")
local Table = require("code.util.table")

-- Some code and graphics are copied from the Battery Powered mod by harag.

-- I'm using 1 charger and 1 discharger building. Charger runs at 5MW, discharger produces 5MW.
-- I'm making 2 types of batteries: normal battery is 10MJ and holmium battery is 200MJ.
-- Crafting speed of charger/discharger are 1. So charging the batteries needs to take 2 and 40 seconds respectively.

-- Create recipe category for charging, fuel category for batteries.
data:extend({
    { type = "recipe-category", name = "charging", },
    { type = "fuel-category",   name = "battery",  },
})

-- Create items for batteries, with holmium and charged variants.
-- Using a new shorter icon for the battery, so we can put the charge outline around it.
local batteryItem = data.raw.item["battery"]
batteryItem.icon = "__LegendarySpaceAge__/graphics/batteries/battery_short.png"
batteryItem.stack_size = 200 -- Vanilla is 200. This carries through to other cloned batteries.
batteryItem.weight = 1250 -- Vanilla is 2500 (so 400 per rocket). Increasing to 1.25 so 800 per rocket.
local chargedBatteryItem = table.deepcopy(batteryItem)
chargedBatteryItem.name = "charged-battery"
chargedBatteryItem.icon = "__LegendarySpaceAge__/graphics/batteries/battery_short_charged.png"
chargedBatteryItem.order = batteryItem.order .. '-2'
chargedBatteryItem.burnt_result = "battery"
chargedBatteryItem.fuel_category = "battery"
chargedBatteryItem.fuel_emissions_multiplier = 0
chargedBatteryItem.fuel_value = "10MJ"
	-- Quick google says a real-life car battery is 4.3MJ.
	-- So per stack of 200, it's 2GJ, and per rocket of 800, it's 8GJ.
	-- Compared to 8GJ nuclear fuel, per stack of 50 is 400GJ and per rocket of 10 is 80GJ.
	-- Compared to 12MJ solid fuel, per stack of 50 is 600MJ and per rocket of 1000 is 12GJ.
chargedBatteryItem.spoil_ticks = 60 * 60 * 30
chargedBatteryItem.spoil_result = "battery"
local holmiumBatteryItem = table.deepcopy(batteryItem)
holmiumBatteryItem.name = "holmium-battery"
holmiumBatteryItem.icon = "__LegendarySpaceAge__/graphics/batteries/holmium_battery_short.png"
holmiumBatteryItem.order = batteryItem.order .. '-3'
holmiumBatteryItem.weight = 2500 -- So 400 per rocket, twice the weight of a normal battery.
local chargedHolmiumBatteryItem = table.deepcopy(batteryItem)
chargedHolmiumBatteryItem.name = "charged-holmium-battery"
chargedHolmiumBatteryItem.icon = "__LegendarySpaceAge__/graphics/batteries/holmium_battery_short_charged.png"
chargedHolmiumBatteryItem.order = batteryItem.order .. '-4'
chargedHolmiumBatteryItem.weight = 2500
chargedHolmiumBatteryItem.burnt_result = "holmium-battery"
chargedHolmiumBatteryItem.fuel_category = "battery"
chargedHolmiumBatteryItem.fuel_emissions_multiplier = 0
--chargedHolmiumBatteryItem.spoil_ticks = 60 * 60 * 120
--chargedHolmiumBatteryItem.spoil_result = "holmium-battery"
chargedHolmiumBatteryItem.fuel_value = "200MJ"
	-- So 20x as much as a normal battery.
	-- Per stack of 200, it's 40GJ, and per rocket of 200, it's 80GJ. Equivalent to nuclear fuel.
-- TODO check recycling recipe for charged batteries, maybe modify.
data:extend({chargedBatteryItem, holmiumBatteryItem, chargedHolmiumBatteryItem})

-- Create recipe for holmium batteries.
local holmiumBatteryRecipe = table.deepcopy(data.raw.recipe["battery"])
holmiumBatteryRecipe.name = "holmium-battery"
holmiumBatteryRecipe.main_product = "holmium-battery"
holmiumBatteryRecipe.results = {
	{ type = "item", name = "holmium-battery", amount = 1 },
}
holmiumBatteryRecipe.icon = "__LegendarySpaceAge__/graphics/batteries/holmium_battery_short.png"
holmiumBatteryRecipe.ingredients = {
	{ type = "item", name = "holmium-plate", amount = 1 },
	{ type = "item", name = "tungsten-plate", amount = 1 },
	{ type = "fluid", name = "electrolyte", amount = 20 },
}
--holmiumBatteryRecipe.surface_conditions = { { property = "magnetic-field", min = 99, max = 99 } }
holmiumBatteryRecipe.category = "electromagnetics"
-- TODO check recycling recipe
data:extend({holmiumBatteryRecipe})

-- Create new tech for holmium battery. It gets unlocked after you've gotten science packs from both Fulgora and Vulcanus.
local holmiumBatteryTech = table.deepcopy(data.raw.technology["battery-mk3-equipment"])
holmiumBatteryTech.name = "holmium-battery"
holmiumBatteryTech.prerequisites = {"electromagnetic-science-pack", "metallurgic-science-pack"}
holmiumBatteryTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "holmium-battery"
	},
}
holmiumBatteryTech.icons = {
	{
		icon = "__space-age__/graphics/technology/holmium-processing.png",
		icon_size = 256,
		mipmap_count = 4,
		scale = 0.6,
		shift = {-15, -30},
	},
	{
		icon = "__base__/graphics/technology/battery.png",
		icon_size = 256,
		mipmap_count = 4,
		scale = 0.5,
		shift = {30, 15},
	},
}
data:extend({holmiumBatteryTech})

-- Change techs and recipes (advanced roboport, personal batteries, maybe more) to require holmium batteries.
Tech.replacePrereq("battery-mk3-equipment", "electromagnetic-science-pack", "holmium-battery")
Recipe.substituteIngredient("battery-mk3-equipment", "supercapacitor", "holmium-battery")
Tech.replacePrereq("mech-armor", "electromagnetic-science-pack", "holmium-battery")
Tech.addTechDependency("metallurgic-science-pack", "mech-armor")
Recipe.substituteIngredient("mech-armor", "supercapacitor", "holmium-battery")
Recipe.substituteIngredient("mech-armor", "holmium-plate", "tungsten-plate")
Tech.replacePrereq("personal-roboport-mk2-equipment", "electromagnetic-science-pack", "holmium-battery")
Recipe.substituteIngredient("personal-roboport-mk2-equipment", "supercapacitor", "holmium-battery")
-- TODO more?


-- Create items and recipes for the charger/discharger buildings.
data:extend({
	{
		type = "item",
		name = "battery-charger",
		icon = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/icons/bp-battery-charger.png",
		stack_size = 20,
		subgroup = "energy",
		order = "z-1",
	},
	{
		type = "item",
		name = "battery-discharger",
		icon = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/icons/bp-battery-discharger.png",
		stack_size = 20,
		subgroup = "energy",
		order = "z-2",
	},
	{
		type = "recipe",
		name = "battery-charger",
		enabled = false,
		ingredients = {
			{ type = "item", name = "iron-plate", amount = 2 },
			{ type = "item", name = "copper-cable", amount = 8 },
			{ type = "item", name = "electronic-circuit", amount = 2 },
		},
		results = {{type = "item", name = "battery-charger", amount = 1}},
		energy_required = 10,
		category = "electronics",
	},
	{
		type = "recipe",
		name = "battery-discharger",
		enabled = false,
		ingredients = {
			{ type = "item", name = "iron-plate", amount = 8 },
			{ type = "item", name = "copper-cable", amount = 4 },
			{ type = "item", name = "electronic-circuit", amount = 2 },
		},
		results = {{type = "item", name = "battery-discharger", amount = 1}},
		energy_required = 10,
		category = "electronics",
	},
})
Tech.addRecipeToTech("battery-charger", "battery")
Tech.addRecipeToTech("battery-discharger", "battery")

-- Picture and animation layers for charger and discharger - copied from Battery Powered mod.
local chargerPic = {
	layers = {
		{
			filename = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/entities/hr-charger.png",
			priority = "high",
			width = 128,
			height = 192,
			repeat_count = 24,
			shift = util.by_pixel(0, -16),
			scale = 0.5,
		},
		{
			filename = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/entities/hr-charger-shadow.png",
			priority = "high",
			width = 256,
			height = 128,
			repeat_count = 24,
			shift = util.by_pixel(32, 0),
			draw_as_shadow = true,
			scale = 0.5,
		},
	},
}
local dischargerPic = {
	layers = {
		{
			filename = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/entities/hr-discharger.png",
			priority = "high",
			width = 128,
			height = 192,
			repeat_count = 24,
			shift = util.by_pixel(0, -16),
			scale = 0.5,
		},
		{
			filename = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/entities/hr-discharger-shadow.png",
			priority = "high",
			width = 256,
			height = 128,
			repeat_count = 24,
			shift = util.by_pixel(32, 0),
			draw_as_shadow = true,
			scale = 0.5,
		},
	},
}
local chargerAnimation = {
	layers = {
		chargerPic,
		{
			filename = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/entities/hr-charger-fizzle.png",
			priority = "high",
			width = 143,
			height = 192,
			line_length = 6,
			frame_count = 24,
			draw_as_glow = true,
			shift = util.by_pixel(0, -16),
			scale = 0.5,
		},
		{
			filename = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/entities/hr-charger-worklight.png",
			priority = "high",
			width = 128,
			height = 192,
			line_length = 6,
			frame_count = 24,
			apply_runtime_tint = true,
			-- half speed compared to lightning
			frame_sequence = { 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1 },
			draw_as_glow = true,
			shift = util.by_pixel(0, -16),
			scale = 0.5,
			tint = { r = 0.6, g = 1.0, b = 0.95, a = 1 },
		}
	},
}
local dischargerAnimation = {
	layers = {
		dischargerPic,
		{
			filename = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/entities/hr-discharger-lightning.png",
			priority = "high",
			width = 128,
			height = 192,
			line_length = 6,
			frame_count = 24,
			draw_as_glow = true,
			shift = util.by_pixel(0, -16),
			scale = 0.5,
			-- electric light green-blue
			tint = { r = 0.60, g = 1.00, b = 0.95, a = 1 }
		},
		{
			filename = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/entities/hr-discharger-worklight.png",
			priority = "high",
			width = 128,
			height = 192,
			line_length = 6,
			frame_count = 24,
			apply_runtime_tint = true,
			frame_sequence = { 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1 },
			draw_as_glow = true,
			shift = util.by_pixel(0, -16),
			scale = 0.5,
			tint = { r = 0.60, g = 1.00, b = 0.95, a = 1 },
		},
	},
}

-- Create entities for charger and discharger buildings.
local accumulator = data.raw.accumulator.accumulator
data:extend({
	{
		type = "furnace",
		name = "battery-charger",
        icon = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/icons/bp-battery-charger.png",
        placeable_by = { item = "battery-charger", count = 1 },
        minable = Table.copyAndEdit(accumulator.minable, {
			result = "battery-charger",
		}),
        flags = accumulator.flags,
		max_health = accumulator.max_health,
        fast_replaceable_group = nil,
        corpse = accumulator.corpse,
        dying_explosion = accumulator.dying_explosion,
        collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
        selection_box = {{-1, -1}, {1, 1}},
        damaged_trigger_effect = table.deepcopy(accumulator.damaged_trigger_effect),
        crafting_speed = 1,
        source_inventory_size = 1,
        result_inventory_size = 1,
        show_recipe_icon = false,
        crafting_categories = { "charging" },
        order = "z-1",
        energy_usage = "5MW", -- PowerMultiplier will increase this, so we decrease it again in batteries-dff.lua.
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            drain = "0kW",
        },
        drawing_box = {{-1, -1.5}, {1, 1}},
        match_animation_speed_to_activity = false,
        graphics_set = {
			idle_animation = chargerPic,
			animation = chargerAnimation,
        },
        water_reflection = table.deepcopy(accumulator.water_reflection),
        vehicle_impact_sound = accumulator.vehicle_impact_sound,
        open_sound = accumulator.open_sound,
        close_sound = accumulator.close_sound,
        working_sound = {
			sound = { filename = "__base__/sound/accumulator-working.ogg", volume = 0.4 },
			max_sounds_per_type = 3,
			audible_distance_modifier = 0.5,
			fade_in_ticks = 4,
			fade_out_ticks = 20,
        },
	},
	{
		type = "burner-generator",
		name = "battery-discharger",
        icon = "__LegendarySpaceAge__/graphics/batteries/from_battery_powered/icons/bp-battery-discharger.png",
        placeable_by = { item = "battery-discharger", count = 1 },
        minable = Table.copyAndEdit(accumulator.minable, {
			result = "battery-discharger",
		}),
        flags = accumulator.flags,
		max_health = accumulator.max_health,
        fast_replaceable_group = nil,
        corpse = accumulator.corpse,
        dying_explosion = accumulator.dying_explosion,
        collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
        selection_box = {{-1, -1}, {1, 1}},
        damaged_trigger_effect = table.deepcopy(accumulator.damaged_trigger_effect),
        effectivity = 1,
		energy_source = {
			type = "electric",
			usage_priority = "tertiary",
			drain = "0kW",
		},
		max_power_output = "5MW",
        order = "z-2",
		burner = {
			emissions_per_minute = {},
			fuel_categories = {"battery"},
			fuel_inventory_size = 1,
			burnt_inventory_size = 1,
			type = "burner",
			light_flicker = {
				minimum_intensity = 0,
				maximum_intensity = 0,
			},
		},
        drawing_box = {{-1, -1.5}, {1, 1}},
		perceived_performance = { minimum = 1 }, -- So if it's running at all, animation plays at full speed.
		idle_animation = dischargerPic,
		animation = dischargerAnimation,
        match_animation_speed_to_activity = false,
        graphics_set = {
			idle_animation = chargerPic,
			animation = chargerAnimation,
        },
        water_reflection = table.deepcopy(accumulator.water_reflection),
        vehicle_impact_sound = accumulator.vehicle_impact_sound,
        open_sound = accumulator.open_sound,
        close_sound = accumulator.close_sound,
		working_sound = {
			sound = { filename = "__base__/sound/accumulator-idle.ogg", volume = 0.55 },
			max_sounds_per_type = 3,
			audible_distance_modifier = 0.5,
			fade_in_ticks = 4,
			fade_out_ticks = 20
		},
	},
})
data.raw.item["battery-charger"].place_result = "battery-charger"
data.raw.item["battery-discharger"].place_result = "battery-discharger"

-- Quality shouldn't give the chargers greater charge speed, or you could make a loop for free energy, since their energy consumption isn't changed by quality.
-- Looks like there's no way to change this.

-- Create recipes for charging batteries.
data:extend({
	{
		type = "recipe",
		name = "charge-battery",
		ingredients = { { type = "item", name = "battery", amount = 1 } },
		results = { { type = "item", name = "charged-battery", amount = 1, probability = 0.95 } },
		energy_required = 2, -- Charger uses 5MW, battery holds 10MJ. TODO check
		enabled = false,
		category = "charging",
		allowed_effects = {},
	},
	{
		type = "recipe",
		name = "charge-holmium-battery",
		ingredients = { { type = "item", name = "holmium-battery", amount = 1 } },
		results = { { type = "item", name = "charged-holmium-battery", amount = 1 } },
		energy_required = 40, -- Charger uses 5MW, battery holds 200MJ. TODO check
		enabled = false,
		category = "charging",
		allowed_effects = {},
	},
})
Tech.addRecipeToTech("charge-battery", "battery")
Tech.addRecipeToTech("charge-holmium-battery", "holmium-battery")

-- Reduce efficiency of lightning rods.
-- TODO

-- TODO ban efficiency modules and prod modules and quality modules, when charging batteries. Allow speed, probably.