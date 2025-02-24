--[[ This file creates entity/item/recipe for the circuit primer and superclocker.
Using graphics from Hurricane046 - https://mods.factorio.com/user/Hurricane046
]]

local GRAPHICS_FOLDER = "__LegendarySpaceAge__/graphics/primer/"

-- Some functions to shift circuit connectors.
local function shift(v, x, y)
	return {v[1] + x, v[2] + y}
end
local function shiftConnector(connector, x, y)
	connector.sprites.blue_led_light_offset = shift(connector.sprites.blue_led_light_offset, x, y)
end

-- Create circuit primer entity.
local primerEnt = copy(FURNACE["electric-furnace"])
primerEnt.name = "circuit-primer"
primerEnt.icon = GRAPHICS_FOLDER.."1/icon.png"
primerEnt.minable = {mining_time = 1, result = "circuit-primer"}
primerEnt.placeable_by = {item = "circuit-primer", count = 1}
primerEnt.crafting_speed = 1
primerEnt.selection_box = {{-2.5, -3}, {2.5, 3}}
primerEnt.collision_box = {{-2.4, -2.5}, {2.4, 2.92}}
primerEnt.tile_height = 6
primerEnt.tile_width = 5
primerEnt.crafting_categories = {"circuit-priming"}
primerEnt.energy_usage = "500kW"
primerEnt.energy_source.drain = "500kW"
primerEnt.heating_energy = "200kW"
primerEnt.emissions_per_second = nil
primerEnt.energy_source.emissions_per_minute = nil
primerEnt.max_health = 500
primerEnt.cant_insert_at_source_message_key = "inventory-restriction.cant-be-primed"
primerEnt.perceived_performance = {maximum = 1.5} -- So it doesn't become crazy fast when beaconed.
primerEnt.allowed_effects = {"consumption", "speed", "pollution"} -- Not prod or quality.
primerEnt.fast_replaceable_group = nil
primerEnt.resistances = copy(ASSEMBLER["electromagnetic-plant"].resistances)
primerEnt.graphics_set = {
	animation = {
		layers = {
			{
				filename = GRAPHICS_FOLDER.."1/shadow.png",
				width = 1200,
				height = 700,
				frame_count = 1,
				repeat_count = 80,
				animation_speed = 1,
				draw_as_shadow = true,
				scale = 0.5,
			},
			{
				width = 330,
				height = 390,
				frame_count = 80,
				animation_speed = 1,
				scale = 0.5,
				stripes = {
					{
						filename = GRAPHICS_FOLDER.."1/animation-1.png",
						width_in_frames = 8,
						height_in_frames = 8,
					},
					{
						filename = GRAPHICS_FOLDER.."1/animation-2.png",
						width_in_frames = 8,
						height_in_frames = 2,
					},
				},
			},
		},
	},
	working_visualisations = {
		{
			fadeout = true,
			name = "main",
			apply_recipe_tint = "primary",
			animation = {
				width = 330,
				height = 390,
				frame_count = 80,
				animation_speed = 1,
				scale = 0.5,
				draw_as_glow = true,
				blend_mode = "additive",
				stripes = {
					{
						filename = GRAPHICS_FOLDER.."1/emission-1.png",
						width_in_frames = 8,
						height_in_frames = 8,
					},
					{
						filename = GRAPHICS_FOLDER.."1/emission-2.png",
						width_in_frames = 8,
						height_in_frames = 2,
					},
				},
			},
		}
	},
	reset_animation_when_frozen = true,
}
primerEnt.working_sound = { -- Copying sounds from EM plant, with some changes.
	main_sounds = {
		{
			sound = {
				filename = "__space-age__/sound/entity/electromagnetic-plant/electromagnetic-plant-loop.ogg",
				volume = 0.2,
				audible_distance_modifier = 0.4,
			},
			fade_in_ticks = 4,
			fade_out_ticks = 20,
		},
	},
	sound_accents = {
		-- There's 80 frames, Hatch opens frame 1, closes frame 47. Lightning frames 52-62, and smaller one 6-16.
		{
			sound = {
				variations = sound_variations("__space-age__/sound/entity/electromagnetic-plant/emp-coil", 2, 0.7),
				audible_distance_modifier = 0.5,
			},
			play_for_working_visualisation = "main",
			frame = 53,
		},
		{
			sound = {
				variations = sound_variations("__space-age__/sound/entity/electromagnetic-plant/emp-coil", 2, 0.7),
				audible_distance_modifier = 0.5,
			},
			play_for_working_visualisation = "main",
			frame = 62,
		},
		{
			sound = {
				variations = sound_variations("__space-age__/sound/entity/electromagnetic-plant/emp-coil", 2, 0.6),
				audible_distance_modifier = 0.5,
			},
			play_for_working_visualisation = "main",
			frame = 12,
		},

		{
			sound = {
				variations = sound_variations("__space-age__/sound/entity/electromagnetic-plant/emp-riser-stop", 2, 0.3),
				audible_distance_modifier = 0.3,
			},
			play_for_working_visualisation = "main",
			frame = 47,
		},
		{
			sound = {
				filename = "__space-age__/sound/entity/electromagnetic-plant/emp-bridge-open.ogg", volume = 0.3,
				audible_distance_modifier = 0.3,
			},
			play_for_working_visualisation = "main",
			frame = 3, -- A bit after it opens.
		},
	},
}
primerEnt.dying_explosion = "fusion-reactor-explosion"
primerEnt.corpse = "tesla-turret-remnants"
local primerConnector = copy(RAW.reactor["heating-tower"].circuit_connector)
---@diagnostic disable-next-line: undefined-field, inject-field
primerEnt.circuit_connector = {primerConnector, primerConnector, primerConnector, primerConnector}
extend{primerEnt}

-- Create item for primer.
local primerItem = copy(ITEM["electric-furnace"])
primerItem.name = "circuit-primer"
primerItem.icon = GRAPHICS_FOLDER.."1/icon.png"
primerItem.place_result = "circuit-primer"
primerItem.stack_size = 20
primerItem.weight = ROCKET / 20
extend{primerItem}

-- Create recipe for primer.
Recipe.make{
	copy = "electric-furnace",
	recipe = "circuit-primer",
	ingredients = {"iron-plate", "copper-plate"}, -- Overwritten in infra file.
	resultCount = 1,
	enabled = false,
}

-- Create superclocker entity.
local superclockerEnt = copy(primerEnt)
superclockerEnt.name = "superclocker"
superclockerEnt.icon = GRAPHICS_FOLDER.."2/icon.png"
superclockerEnt.minable = {mining_time = 1, result = "superclocker"}
superclockerEnt.placeable_by = {item = "superclocker", count = 1}
superclockerEnt.selection_box = {{-3, -3}, {3, 3}}
superclockerEnt.collision_box = {{-2.9, -2.3}, {2.9, 2.85}}
superclockerEnt.tile_height = 6
superclockerEnt.tile_width = 6
superclockerEnt.crafting_categories = {"circuit-superclocking"}
superclockerEnt.energy_usage = "9MW"
superclockerEnt.energy_source.drain = "1MW"
superclockerEnt.heating_energy = "1MW"
superclockerEnt.cant_insert_at_source_message_key = "inventory-restriction.cant-be-superclocked"
superclockerEnt.graphics_set = {
	animation = {
		layers = {
			{
				filename = GRAPHICS_FOLDER.."2/shadow.png",
				width = 900,
				height = 420,
				frame_count = 1,
				repeat_count = 100,
				animation_speed = 1,
				scale = 0.5,
				draw_as_shadow = true,
			},
			{
				width = 410,
				height = 410,
				frame_count = 100,
				animation_speed = 1,
				scale = 0.5,
				stripes = {
					{
						filename = GRAPHICS_FOLDER.."2/animation-1.png",
						width_in_frames = 8,
						height_in_frames = 8,
					},
					{
						filename = GRAPHICS_FOLDER.."2/animation-2.png",
						width_in_frames = 8,
						height_in_frames = 5,
					},
				},
			},
		},
	},
	working_visualisations = {
		{
			fadeout = true,
			apply_recipe_tint = "primary",
			name = "main",
			animation = {
				width = 410,
				height = 410,
				frame_count = 100,
				animation_speed = 1,
				scale = 0.5,
				draw_as_glow = true,
				blend_mode = "additive",
				stripes = {
					{
						filename = GRAPHICS_FOLDER.."2/emission-1.png",
						width_in_frames = 8,
						height_in_frames = 8,
					},
					{
						filename = GRAPHICS_FOLDER.."2/emission-2.png",
						width_in_frames = 8,
						height_in_frames = 5,
					},
				},
			},
		},
	},
	reset_animation_when_frozen = true,
}
superclockerEnt.working_sound = {
	main_sounds = {
		{
			sound = {
				--filename = "__space-age__/sound/entity/fusion/fusion-reactor.ogg",
				filename = "__space-age__/sound/entity/tesla-turret/tesla-turret-rotation-loop.ogg",
				volume = 0.5,
				audible_distance_modifier = 0.4,
			},
			fade_in_ticks = 4,
			fade_out_ticks = 20,
		},
	},
}
superclockerEnt.dying_explosion = "oil-refinery-explosion"
superclockerEnt.corpse = "oil-refinery-remnants"
---@diagnostic disable-next-line: undefined-field, inject-field
superclockerEnt.circuit_connector = copy(ASSEMBLER["foundry"].circuit_connector)
extend{superclockerEnt}

-- Create item for superclocker.
local superclockerItem = copy(primerItem)
superclockerItem.name = "superclocker"
superclockerItem.icon = GRAPHICS_FOLDER.."2/icon.png"
superclockerItem.place_result = "superclocker"
superclockerItem.stack_size = 10
superclockerItem.weight = ROCKET / 10
Item.copySoundsTo("energy-shield-equipment", superclockerItem)
extend{superclockerItem}

-- Create recipe for superclocker.
Recipe.make{
	copy = "circuit-primer",
	recipe = "superclocker",
	ingredients = {"iron-plate", "copper-plate"}, -- Overwritten in infra file.
	resultCount = 1,
}

-- TODO change emissions graphics to use recipe's colors, and then set primary/secondary colors of all priming recipes.

-- Create tech for superclocking.
local superclockingTech = copy(TECH["effect-transmission"])
superclockingTech.name = "superclocked-circuits"
superclockingTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "superclocker",
	},
	{
		type = "unlock-recipe",
		recipe = "electronic-circuit-superclocked",
	},
	{
		type = "unlock-recipe",
		recipe = "advanced-circuit-superclocked",
	},
	{
		type = "unlock-recipe",
		recipe = "processing-unit-superclocked",
	},
}
superclockingTech.prerequisites = {"electric-engine"}
superclockingTech.unit = {
	count = 300,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
	},
	time = 30,
}
Icon.set(superclockingTech, "LSA/primer/2/tech")
extend{superclockingTech}