-- This file creates the basic crusher machine. Some code taken from CrushingIndustry by SafTheLamb - mods.factorio.com/mod/crushing-industry

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")

---@type data.FurnacePrototype
local basicCrusherEnt = {
	type = "furnace",
	name = "basic-crusher",
	fast_replaceable_group = nil,
	icon = "__LegendarySpaceAge__/graphics/crushers/basic-crusher/icon.png",
	flags = { "placeable-neutral", "placeable-player", "player-creation" },
	minable = { mining_time = 0.2, result = "basic-crusher" },
	max_health = 250,
	corpse = "basic-crusher-remnants",
	dying_explosion = "assembling-machine-2-explosion",
	resistances = { { type = "fire", percent = 70 } },
	collision_box = { { -0.7, -0.7 }, { 0.7, 0.7 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	damaged_trigger_effect = hit_effects.entity(),
	circuit_wire_max_distance = assembling_machine_circuit_wire_max_distance,
	circuit_connector = circuit_connector_definitions.create_vector(universal_connector_template, {
		{ variation = 18, main_offset = util.by_pixel(16, 16), shadow_offset = util.by_pixel(24, 20), show_shadow = true },
		{ variation = 18, main_offset = util.by_pixel(16, 16), shadow_offset = util.by_pixel(24, 20), show_shadow = true },
		{ variation = 18, main_offset = util.by_pixel(16, 16), shadow_offset = util.by_pixel(24, 20), show_shadow = true },
		{ variation = 18, main_offset = util.by_pixel(16, 16), shadow_offset = util.by_pixel(24, 20), show_shadow = true }
	}),
	alert_icon_shift = util.by_pixel(0, -12),
	icon_draw_specification = { scale = 2 / 3, shift = { 0, -0.3 } },
	crafting_categories = { "crushing" },
	crafting_speed = 1,
	energy_source = {
		type = "burner",
		emissions_per_minute = {},
		fuel_categories = {"crusher-wheel"},
		fuel_inventory_size = 2,
		burnt_inventory_size = 2,
	},
	energy_usage = "100kW",
	source_inventory_size = 1,
	result_inventory_size = 3,
	open_sound = sounds.machine_open,
	close_sound = sounds.machine_close,
	allowed_effects = allowed_effects,
	module_slots = 0,
	effect_receiver = { uses_module_effects = true, uses_beacon_effects = true, uses_surface_effects = true },
	impact_category = "metal",
	working_sound = {
		sound = { filename = "__LegendarySpaceAge__/sound/crusher-loop.ogg", volume = 0.6 },
		audible_distance_modifier = 0.5,
		fade_in_ticks = 4,
		fade_out_ticks = 20,
		max_sounds_per_type = 3
	},
	graphics_set = {
		animation = {
			layers = {
				{
					filename = "__LegendarySpaceAge__/graphics/crushers/basic-crusher/base.png",
					priority = "high",
					width = 143,
					height = 151,
					repeat_count = 48,
					shift = util.by_pixel(0, 2),
					scale = 0.5
				},
				util.sprite_load("__LegendarySpaceAge__/graphics/crushers/basic-crusher/animation", {
					animation_speed = 0.5,
					frame_count = 48,
					shift = { 0.05, -0.26 },
					scale = 0.44
				}),
				{
					filename = "__LegendarySpaceAge__/graphics/crushers/basic-crusher/shadow.png",
					priority = "high",
					width = 148,
					height = 110,
					repeat_count = 48,
					draw_as_shadow = true,
					shift = util.by_pixel(8.5, 5),
					scale = 0.5
				}
			}
		}
	}
}
extend{basicCrusherEnt}

---@type data.AssemblingMachinePrototype
local bigCrusherEnt = {
	type = "assembling-machine",
	name = "big-crusher",
	icon = "__LegendarySpaceAge__/graphics/crushers/big-crusher/icon.png",
	flags = { "placeable-neutral", "placeable-player", "player-creation" },
	minable = { mining_time = 0.2, result = "big-crusher" },
	max_health = 500,
	corpse = "big-crusher-remnants",
	dying_explosion = "big-mining-drill-explosion",
	resistances = { { type = "fire", percent = 70 } },
	collision_box = { { -1.7, -1.7 }, { 1.7, 1.7 } },
	selection_box = { { -2.0, -2.0 }, { 2.0, 2.0 } },
	damaged_trigger_effect = hit_effects.entity(),
	circuit_wire_max_distance = assembling_machine_circuit_wire_max_distance,
	circuit_connector = circuit_connector_definitions.create_vector(universal_connector_template, {
		{ variation = 25, main_offset = util.by_pixel(-55.5, 29.5), shadow_offset = util.by_pixel(-41.5, 49.5), show_shadow = true },
		{ variation = 25, main_offset = util.by_pixel(-55.5, 29.5), shadow_offset = util.by_pixel(-41.5, 49.5), show_shadow = true },
		{ variation = 25, main_offset = util.by_pixel(-55.5, 29.5), shadow_offset = util.by_pixel(-41.5, 49.5), show_shadow = true },
		{ variation = 25, main_offset = util.by_pixel(-55.5, 29.5), shadow_offset = util.by_pixel(-41.5, 49.5), show_shadow = true }
	}),
	alert_icon_shift = util.by_pixel(0, -12),
	icon_draw_specification = { scale = 1.5, shift = { 0, -0.3 } },
	icons_positioning = {
		---@diagnostic disable-next-line: assign-type-mismatch
		{ inventory_index = defines.inventory.assembling_machine_modules, shift = { 0, 1 } }
	},
	crafting_categories = { "crushing" },
	crafting_speed = 2,
	energy_source = {
		type = "burner",
		emissions_per_minute = {},
		fuel_categories = {"crusher-wheel"},
		fuel_inventory_size = 2,
		burnt_inventory_size = 2,
	},
	energy_usage = "500kW",
	open_sound = sounds.mech_large_open,
	close_sound = sounds.mech_large_close,
	allowed_effects = allowed_effects,
	module_slots = 0,
	effect_receiver = { base_effect = { productivity = 0.5 } },
	impact_category = "metal",
	working_sound = {
		sound = { filename = "__LegendarySpaceAge__/sound/crusher-loop.ogg", volume = 0.6 },
		audible_distance_modifier = 0.5,
		fade_in_ticks = 4,
		fade_out_ticks = 20,
		max_sounds_per_type = 3
	},
	perceived_performance = { minimum = 0.25, maximum = 10 },
	graphics_set = {
		animation_speed = 0.5,
		animation = {
			layers = {
				{
					filename = "__LegendarySpaceAge__/graphics/crushers/big-crusher/still.png",
					priority = "high",
					width = 259,
					height = 259,
					repeat_count = 48,
					shift = util.by_pixel(0, -9.6),
					scale = 0.5
				},
				{
					filename = "__LegendarySpaceAge__/graphics/crushers/big-crusher/base.png",
					priority = "high",
					width = 214,
					height = 237,
					repeat_count = 48,
					shift = util.by_pixel(0, 1),
					scale = 2 / 3
				},
				util.sprite_load("__LegendarySpaceAge__/graphics/crushers/big-crusher/animation", {
					animation_speed = 0.5,
					frame_count = 48,
					shift = util.by_pixel(3, -17),
					scale = 0.44 * 4 / 3
				}),
				{
					filename = "__LegendarySpaceAge__/graphics/crushers/big-crusher/front.png",
					priority = "high",
					width = 258,
					height = 141,
					repeat_count = 48,
					shift = util.by_pixel(0, 25),
					scale = 0.5
				},
				{
					filename = "__LegendarySpaceAge__/graphics/crushers/big-crusher/shadow.png",
					priority = "high",
					width = 320,
					height = 220,
					repeat_count = 48,
					draw_as_shadow = true,
					shift = util.by_pixel(17, 8),
					scale = 0.5
				},
				{
					filename = "__LegendarySpaceAge__/graphics/crushers/big-crusher/shadow-2.png",
					priority = "high",
					width = 320,
					height = 260,
					repeat_count = 48,
					draw_as_shadow = true,
					shift = util.by_pixel(16, 1),
					scale = 0.5
				}
			}
		}
	},
	integration_patch = {
		filename = "__LegendarySpaceAge__/graphics/crushers/big-crusher/integration.png",
		priority = "high",
		width = 296,
		height = 295,
		shift = util.by_pixel(0, 5),
		scale = 0.5
	}
}
extend{bigCrusherEnt}

---@type data.CorpsePrototype
local basicCrusherRemnants = {
	type = "corpse",
	name = "basic-crusher-remnants",
	icon = "__LegendarySpaceAge__/graphics/crushers/basic-crusher/icon.png",
	flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
	hidden_in_factoriopedia = true,
	subgroup = "production-machine-remnants",
	order = "a-a-a",
	selection_box = { { -1, -1 }, { 1, 1 } },
	tile_width = 2,
	tile_height = 2,
	selectable_in_game = false,
	time_before_removed = 15 * minute,
	expires = false,
	final_render_layer = "remnants",
	animation = make_rotated_animation_variations_from_sheet(3, {
		filename = "__LegendarySpaceAge__/graphics/crushers/basic-crusher/remnants.png",
		line_length = 1,
		width = 219,
		height = 188,
		direction_count = 1,
		shift = util.by_pixel(0, 6.5),
		scale = 0.5
	})
}
extend{basicCrusherRemnants}

---@type data.CorpsePrototype
local bigCrusherRemnants = {
	type = "corpse",
	name = "big-crusher-remnants",
	icon = "__LegendarySpaceAge__/graphics/crushers/big-crusher/icon.png",
	flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
	hidden_in_factoriopedia = true,
	subgroup = "production-machine-remnants",
	order = "a-a-a",
	selection_box = { { -1, -1 }, { 1, 1 } },
	tile_width = 2,
	tile_height = 2,
	selectable_in_game = false,
	time_before_removed = 15 * minute,
	expires = false,
	final_render_layer = "remnants",
	animation = make_rotated_animation_variations_from_sheet(3, {
		filename = "__LegendarySpaceAge__/graphics/crushers/big-crusher/remnants.png",
		line_length = 1,
		width = 328,
		height = 282,
		direction_count = 1,
		shift = util.by_pixel(0, 6.5),
		scale = 2 / 3
	})
}
extend{bigCrusherRemnants}

---@type data.ItemPrototype
local basicCrusherItem = {
	type = "item",
	name = "basic-crusher",
	icon = "__LegendarySpaceAge__/graphics/crushers/basic-crusher/icon.png",
	inventory_move_sound = item_sounds.mechanical_inventory_move,
	pick_sound = item_sounds.mechanical_inventory_pickup,
	drop_sound = item_sounds.mechanical_inventory_move,
	place_result = "basic-crusher",
	random_tint_color = item_tints.iron_rust,
	stack_size = 50,
	weight = ROCKET / 50,
	auto_recycle = true,
}
extend{basicCrusherItem}

---@type data.ItemPrototype
local bigCrusherItem = {
	type = "item",
	name = "big-crusher",
	icon = "__LegendarySpaceAge__/graphics/crushers/big-crusher/icon.png",
	inventory_move_sound = item_sounds.mechanical_large_inventory_move,
	pick_sound = item_sounds.mechanical_large_inventory_move,
	drop_sound = item_sounds.mechanical_large_inventory_move,
	place_result = "big-crusher",
	stack_size = 20,
	default_import_location = "vulcanus",
	weight = ROCKET / 10,
	auto_recycle = true,
}
extend{bigCrusherItem}

-- Make recipes for the crushers.
Recipe.make{
	copy = "assembling-machine-1",
	recipe = "basic-crusher",
	ingredients = {
		{"frame", 1},
		{"mechanism", 5},
	},
	time = 5,
	resultCount = 1,
	icon = "LSA/crushers/basic-crusher/icon",
	enabled = true, -- TODO tech
}
Recipe.make{
	copy = "assembling-machine-2",
	recipe = "big-crusher",
	ingredients = {
		{"frame", 5},
		{"mechanism", 20},
	},
	time = 10,
	resultCount = 1,
	icon = "LSA/crushers/big-crusher/icon",
	enabled = true, -- TODO tech
}