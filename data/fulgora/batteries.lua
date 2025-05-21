-- Some code and graphics are copied from the Battery Powered mod by harag.

-- I'm using 1 charger and 1 discharger building. Chargers run at 1MW, generators at 2MW.
-- I'm making 2 types of batteries: normal battery is 10MJ and holmium battery is 100MJ.
-- Crafting speed of charger/discharger are 1. So charging the batteries needs to take 10 and 100 seconds respectively.
-- Compare to vanilla accumulators, which hold 5MJ and have max input/output of 300kW.
-- So compared to accumulators, you need fewer chargers/dischargers, but a much more complex setup to load batteries into chargers/dischargers and return used ones, etc.

-- Create recipe category for charging, fuel category for batteries.
extend({
    { type = "recipe-category", name = "charging", },
    { type = "fuel-category",   name = "battery",  },
})

-- Create items for batteries, with holmium and charged variants.
-- Using a new shorter icon for the battery, so we can put the charge outline around it.
local batteryItem = ITEM["battery"]
Icon.set(batteryItem, "LSA/fulgora/batteries/battery_short")
batteryItem.stack_size = 200 -- Vanilla is 200. This carries through to other cloned batteries.
Item.perRocket(batteryItem, 1000) -- Vanilla is 400 per rocket.
local chargedBatteryItem = copy(batteryItem)
chargedBatteryItem.name = "charged-battery"
Icon.set(chargedBatteryItem, "LSA/fulgora/batteries/battery_short_charged")
chargedBatteryItem.burnt_result = "battery"
chargedBatteryItem.fuel_category = "battery"
chargedBatteryItem.fuel_emissions_multiplier = 0
chargedBatteryItem.fuel_value = "10MJ"
	-- Quick google says a real-life car battery is 4.3MJ.
	-- So per stack of 100, it's 1GJ, and per rocket of 1000, it's 10GJ.
	-- Compared to 8GJ in one nuclear fuel, per stack of 50 is 400GJ and per rocket of 10 is 80GJ.
	-- Compared to 12MJ solid fuel, per stack of 50 is 600MJ and per rocket of 1000 is 12GJ. Makes sense that solid fuel would be more per mass, I think.
	-- Seems that in real life, lithium-ion batteries are ~1GJ/ton while solid fuels are ~50GJ/ton.
-- Rather no spoiling, since I'm now adding personal battery generator equipment and spoiling would be annoying.
--chargedBatteryItem.spoil_ticks = 5 * HOURS
--chargedBatteryItem.spoil_result = "battery"
local holmiumBatteryItem = copy(batteryItem)
holmiumBatteryItem.name = "holmium-battery"
Icon.set(holmiumBatteryItem, "LSA/fulgora/batteries/holmium_battery_short")
local chargedHolmiumBatteryItem = copy(batteryItem)
chargedHolmiumBatteryItem.name = "charged-holmium-battery"
Icon.set(chargedHolmiumBatteryItem, "LSA/fulgora/batteries/holmium_battery_short_charged")
chargedHolmiumBatteryItem.burnt_result = "holmium-battery"
chargedHolmiumBatteryItem.fuel_category = "battery"
chargedHolmiumBatteryItem.fuel_emissions_multiplier = 0
chargedHolmiumBatteryItem.fuel_value = "100MJ"
	-- So 10x as much as a normal battery.
	-- Per stack of 200, it's 20GJ, and per rocket of 1000, it's 100GJ.
	-- Compare to nuclear fuel which is 80GJ/rocket.
extend({chargedBatteryItem, holmiumBatteryItem, chargedHolmiumBatteryItem})

-- Create recipe for holmium batteries.
local holmiumBatteryRecipe = copy(RECIPE["battery"])
holmiumBatteryRecipe.name = "holmium-battery"
holmiumBatteryRecipe.results = {{type = "item", name = "holmium-battery", amount = 1}}
Icon.set(holmiumBatteryRecipe, "LSA/fulgora/batteries/holmium_battery_short")
holmiumBatteryRecipe.ingredients = {
	{ type = "item", name = "holmium-plate", amount = 1 },
	{ type = "item", name = "tungsten-plate", amount = 1 },
	{ type = "fluid", name = "electrolyte", amount = 20 },
}
--holmiumBatteryRecipe.surface_conditions = { { property = "magnetic-field", min = 99, max = 99 } }
holmiumBatteryRecipe.category = "electromagnetics"
holmiumBatteryRecipe.allow_decomposition = true
extend({holmiumBatteryRecipe})

-- Create new tech for holmium battery. It gets unlocked after you've gotten science packs from both Fulgora and Vulcanus.
local holmiumBatteryTech = copy(TECH["battery-mk3-equipment"])
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
extend({holmiumBatteryTech})
Tech.addSciencePack("holmium-battery", "metallurgic-science-pack")

-- Change techs and recipes (advanced roboport, personal batteries, maybe more) to require holmium batteries.
Tech.replacePrereq("battery-mk3-equipment", "electromagnetic-science-pack", "holmium-battery")
Tech.addSciencePack("battery-mk3-equipment", "metallurgic-science-pack")
Tech.replacePrereq("mech-armor", "electromagnetic-science-pack", "holmium-battery")
Tech.addSciencePack("mech-armor", "metallurgic-science-pack")
Tech.addTechDependency("metallurgic-science-pack", "mech-armor")
Tech.replacePrereq("personal-roboport-mk2-equipment", "electromagnetic-science-pack", "holmium-battery")
Tech.addSciencePack("personal-roboport-mk2-equipment", "metallurgic-science-pack")
-- TODO more?

-- Create items and recipes for the charger/discharger buildings.
extend({
	{
		type = "item",
		name = "battery-charger",
		icon = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/icons/bp-battery-charger.png",
		stack_size = 20,
	},
	{
		type = "item",
		name = "battery-discharger",
		icon = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/icons/bp-battery-discharger.png",
		stack_size = 20,
	},
	{
		type = "recipe",
		name = "battery-charger",
		enabled = false,
		ingredients = {
			{ type = "item", name = "frame", amount = 2 },
			{ type = "item", name = "panel", amount = 5 },
			{ type = "item", name = "wiring", amount = 5 },
			{ type = "item", name = "electronic-circuit", amount = 5 },
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
			{ type = "item", name = "frame", amount = 2 },
			{ type = "item", name = "panel", amount = 10 },
			{ type = "item", name = "wiring", amount = 5 },
			{ type = "item", name = "electronic-circuit", amount = 5 },
		},
		results = {{type = "item", name = "battery-discharger", amount = 1}},
		energy_required = 10,
		category = "electronics",
	},
})
Tech.addRecipeToTech("battery-charger", "battery")
Tech.addRecipeToTech("battery-discharger", "battery")
Item.copySoundsTo("accumulator", "battery-charger")
Item.copySoundsTo("accumulator", "battery-discharger")
Item.copySoundsTo("assembling-machine-1", "er-hcg")

-- Picture and animation layers for charger and discharger - copied from Battery Powered mod.
local chargerPic = {
	layers = {
		{
			filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/entities/hr-charger.png",
			priority = "high",
			width = 128,
			height = 192,
			repeat_count = 24,
			shift = util.by_pixel(0, -16),
			scale = 0.5,
		},
		{
			filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/entities/hr-charger-shadow.png",
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
			filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/entities/hr-discharger.png",
			priority = "high",
			width = 128,
			height = 192,
			repeat_count = 24,
			shift = util.by_pixel(0, -16),
			scale = 0.5,
		},
		{
			filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/entities/hr-discharger-shadow.png",
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
			filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/entities/hr-charger-fizzle.png",
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
			filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/entities/hr-charger-worklight.png",
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
			filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/entities/hr-discharger-lightning.png",
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
			filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/entities/hr-discharger-worklight.png",
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
local accumulator = RAW.accumulator.accumulator
extend({
	{
		type = "furnace",
		name = "battery-charger",
		icon = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/icons/bp-battery-charger.png",
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
		damaged_trigger_effect = copy(accumulator.damaged_trigger_effect),
		crafting_speed = 1,
		source_inventory_size = 1,
		result_inventory_size = 1,
		show_recipe_icon = false,
		crafting_categories = { "charging" },
		energy_usage = "1MW",
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
		water_reflection = copy(accumulator.water_reflection),
		impact_category = accumulator.impact_category,
		open_sound = accumulator.open_sound,
		close_sound = accumulator.close_sound,
		working_sound = {
			sound = { filename = "__base__/sound/accumulator-working.ogg", volume = 0.4 },
			max_sounds_per_type = 3,
			audible_distance_modifier = 0.5,
			fade_in_ticks = 4,
			fade_out_ticks = 20,
		},
		allowed_effects = {"speed", "pollution"},
		allowed_module_categories = {"speed"},
	},
	{
		type = "burner-generator",
		name = "battery-discharger",
		icon = "__LegendarySpaceAge__/graphics/fulgora/batteries/from_battery_powered/icons/bp-battery-discharger.png",
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
		damaged_trigger_effect = copy(accumulator.damaged_trigger_effect),
		effectivity = 1,
		energy_source = {
			type = "electric",
			usage_priority = "tertiary",
			drain = "0kW",
			burner_usage = "discharge",
		},
		max_power_output = "2MW",
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
			burner_usage = "discharge",
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
		water_reflection = copy(accumulator.water_reflection),
		impact_category = accumulator.impact_category,
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
	{
		type = "burner-usage",
		name = "discharge",
		empty_slot_sprite = {
			filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/empty-battery-slot.png",
			priority = "extra-high-no-scale",
			size = 64,
			mipmap_count = 2,
			flags = {"gui-icon"},
		},
		empty_slot_caption = {"gui.discharge"},
		empty_slot_description = nil,
		icon = {
			filename = "__LegendarySpaceAge__/graphics/fulgora/batteries/battery-icon-red.png",
			priority = "extra-high-no-scale",
			width = 64,
			height = 64,
			flags = {"icon"}
		},
		no_fuel_status = {"entity-status.no-batteries"},
		accepted_fuel_key = "description.accepted-batteries",
		burned_in_key = "discharged-by", -- factoriopedia
	},
})
ITEM["battery-charger"].place_result = "battery-charger"
ITEM["battery-discharger"].place_result = "battery-discharger"

-- Quality shouldn't give the chargers greater charge speed, or you could make a loop for free energy, since their energy consumption isn't changed by quality.
-- TODO write control script to replace chargers on placement, and then remove no-quality mod as prereq.

-- Create recipes for charging batteries.
Recipe.make{
	copy = "battery",
	recipe = "charged-battery",
	ingredients = {"battery"},
	results = {
		{"charged-battery", 1, probability = 0.99},
	},
	time = 10, -- Charger uses 1MW, battery holds 10MJ.
	category = "charging",
	show_amount_in_title = false,
	allow_productivity = false,
	allow_quality = false,
	allow_speed = true,
	allow_consumption = false,
}
Recipe.make{
	copy = "charged-battery",
	recipe = "charged-holmium-battery",
	ingredients = {"holmium-battery"},
	results = {"charged-holmium-battery"},
	time = 100, -- Charger uses 1MW, battery holds 100MJ.
	category = "charging",
	show_amount_in_title = false,
}
Tech.addRecipeToTech("charged-battery", "battery", 2)
Tech.addRecipeToTech("charged-holmium-battery", "holmium-battery")

-- Reduce efficiency of lightning rods.
RAW["lightning-attractor"]["lightning-rod"].efficiency = .1 -- Changing 20% to 10%.
RAW["lightning-attractor"]["lightning-collector"].efficiency = .3 -- Changing 40% to 30%.