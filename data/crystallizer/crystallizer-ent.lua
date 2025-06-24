--[[ This file creates the crystallizer building.

This will be used for recipes like:
* crystallizing salt from rich brine
* crystallizing magnesium salt from bitterns
* growing zeolite crystals from silica, alumina, lye, steam, crystal seeds.
* growing silicon crystal ingots from seed crystals, polysilicon, phosphorus, acetone.
* getting pure sulfur crystals?
* maybe other stuff? Like promethium processing, or something.

Currently this is basically just a chem plant that needs mild heat. Would be nice to add some kind of special mechanic too, maybe.
]]

local sounds = require("__base__.prototypes.entity.sounds")

---@type data.AssemblingMachinePrototype
---@diagnostic disable-next-line: assign-type-mismatch
local ent = copy(ASSEMBLER["chemical-plant"])
ent.name = "crystallizer"
ent.localised_name = {"entity-name.crystallizer"}
ent.localised_description = {"entity-description.crystallizer"}
Entity.unhide(ent)
ent.minable.result = "crystallizer"
ent.fluid_boxes_off_when_no_fluid_recipe = false
ent.placeable_by = {item = "crystallizer", count = 1}
Icon.set(ent, "LSA/crystallizer/icon")
ent.crafting_categories = {"crystallizer"}
ent.tile_width = 4
ent.tile_height = 4
ent.selection_box = {{-2, -2}, {2, 2}}
ent.collision_box = {{-1.9, -1.9}, {1.9, 1.9}}
ent.fluid_boxes = { -- Give it 2 separate input and 2 separate output fluidboxes, but still make them input-output. So if there's only 1 input, it'll use both pipes and be effectively passthrough.
	{
		production_type = "input",
		volume = 200,
		pipe_covers = pipecoverspictures(),
		pipe_picture = GreyPipes.pipeBlocksSouth(),
		pipe_connections = {
			{flow_direction = "input-output", position = {-0.5, -1.5}, direction = NORTH},
		},
	},
	{
		production_type = "input",
		volume = 200,
		pipe_covers = pipecoverspictures(),
		pipe_picture = GreyPipes.pipeBlocksSouth(),
		pipe_connections = {
			{flow_direction = "input-output", position = {0.5, 1.5}, direction = SOUTH},
		},
	},
	{
		production_type = "output",
		volume = 200,
		pipe_covers = pipecoverspictures(),
		pipe_picture = GreyPipes.pipeBlocksSouth(),
		pipe_connections = {
			{flow_direction = "input-output", position = {-1.5, -0.5}, direction = WEST},
		},
	},
	{
		production_type = "output",
		volume = 200,
		pipe_covers = pipecoverspictures(),
		pipe_picture = GreyPipes.pipeBlocksSouth(),
		pipe_connections = {
			{flow_direction = "input-output", position = {1.5, 0.5}, direction = EAST},
		},
	},
}
local circuitConnector = { variation =  0, main_offset = util.by_pixel( 15.375,  47.375), shadow_offset = util.by_pixel( 15.375,  47.375), show_shadow = true }
ent.circuit_connector = circuit_connector_definitions.create_vector(universal_connector_template, {
	circuitConnector, circuitConnector, circuitConnector, circuitConnector
})
ent.working_sound = { main_sounds = {
	{
		sound = sound_variations("__base__/sound/chemical-plant", 3, 0.4),
		fade_in_ticks = 4,
		fade_out_ticks = 20
	},
	{
		sound = { filename = "__space-age__/sound/entity/cryogenic-plant/cryogenic-plant.ogg", volume = 0.3 },
		fade_in_ticks = 4,
		fade_out_ticks = 30,
	},
}}
ent.energy_source = {
	type = "burner",
	emissions_per_minute = {pollution = 0},
	burner_usage = "heat-provider",
	fuel_inventory_size = 2,
	burnt_inventory_size = 2,
	smoke = nil,
	fuel_categories = {"heat-provider"},
	light_flicker = FURNACE["stone-furnace"].energy_source.light_flicker, -- No flicker.
	initial_fuel = nil,
	initial_fuel_percent = 0.1, -- Must be greater than 0.
}
ent.energy_usage = "100kW"
ent.open_sound = sounds.metal_large_open
ent.close_sound = sounds.metal_large_close
local file1Width = 2160
local file1Height = 2480
local file1Rows = 8
local file1Columns = 8
local file2Width = 2160
local file2Height = 620
local file2Rows = 2
local file2Columns = 8
local frameWidth = file1Width / file1Columns
local frameHeight = file1Height / file1Rows
local frameCount = file1Columns * file1Rows + file2Columns * file2Rows
local machineScale = 0.5
local shadowScale = 0.5
local machineShift = {0, -0.42}
local shadowShift = {0, -0.42}
local defaultTint = { -- Using primary tint for the "bulb"/tank part, secondary tint for the moving ores, tertiary for lights on bulb, quaternary for lights on bottom-right.
	primary = {.82, .361, .22},
	secondary = {.733, .698, .667},
	tertiary = {0, 0, .3, .3},
	quaternary = {0, 0, 0, 0}, -- No lights by default.
}
ent.graphics_set = {
	reset_animation_when_frozen = true,
	default_recipe_tint = defaultTint,
	recipe_not_set_tint = defaultTint,
	animation = {layers = {
		{
			width = frameWidth,
			height = frameHeight,
			shift = machineShift,
			scale = machineScale,
			frame_count = frameCount, -- Still draw all frames. It won't actually play the animation unless it's turned on.
			stripes = {
				{
					filename = "__LegendarySpaceAge__/graphics/crystallizer/base-1.png",
					width_in_frames = file1Columns,
					height_in_frames = file1Rows,
				},
				{
					filename = "__LegendarySpaceAge__/graphics/crystallizer/base-2.png",
					width_in_frames = file2Columns,
					height_in_frames = file2Rows,
				},
			},
		},
		{
			filename = "__LegendarySpaceAge__/graphics/crystallizer/shadow.png",
			draw_as_shadow = true,
			width = 500,
			height = 350,
			scale = shadowScale,
			shift = shadowShift,
			repeat_count = frameCount,
		},
	}},
	working_visualisations = {
		{ -- Layer for cover over the "dome", tinted for recipe. Also the colored stripe at the front.
			apply_recipe_tint = "primary",
			always_draw = true, -- Set always_draw so it shows recipe color even when machine isn't active.
			animation = {
				width = frameWidth,
				height = frameHeight,
				scale = machineScale,
				shift = machineShift,
				frame_count = frameCount,
				stripes = {
					{
						filename = "__LegendarySpaceAge__/graphics/crystallizer/overlays/color1-1.png",
						width_in_frames = file1Columns,
						height_in_frames = file1Rows,
					},
					{
						filename = "__LegendarySpaceAge__/graphics/crystallizer/overlays/color1-2.png",
						width_in_frames = file2Columns,
						height_in_frames = file2Rows,
					},
				},
			},
		},
		{ -- Layer for moving ores.
			apply_recipe_tint = "secondary",
			always_draw = true, -- Set always_draw so it shows recipe color even when machine isn't active.
			animation = {
				width = frameWidth,
				height = frameHeight,
				scale = machineScale,
				shift = machineShift,
				frame_count = frameCount,
				stripes = {
					{
						filename = "__LegendarySpaceAge__/graphics/crystallizer/overlays/color2-1.png",
						width_in_frames = file1Columns,
						height_in_frames = file1Rows,
					},
					{
						filename = "__LegendarySpaceAge__/graphics/crystallizer/overlays/color2-2.png",
						width_in_frames = file2Columns,
						height_in_frames = file2Rows,
					},
				},
			},
		},
		{ -- Layer for lights on the bulb.
			apply_recipe_tint = "tertiary",
			always_draw = false,
			fadeout = true,
			animation = {
				draw_as_glow = true, -- Looks better than draw_as_light (which disappears when flashlight is pointed at it).
				width = frameWidth,
				height = frameHeight,
				scale = machineScale,
				shift = machineShift,
				frame_count = frameCount,
				stripes = {
					{
						filename = "__LegendarySpaceAge__/graphics/crystallizer/overlays/color3-1.png",
						width_in_frames = file1Columns,
						height_in_frames = file1Rows,
					},
					{
						filename = "__LegendarySpaceAge__/graphics/crystallizer/overlays/color3-2.png",
						width_in_frames = file2Columns,
						height_in_frames = file2Rows,
					},
				},
			},
		},
		{ -- Layer for lights on the bottom-right.
			apply_recipe_tint = "quaternary",
			always_draw = false,
			fadeout = true,
			animation = {
				draw_as_glow = true,
				width = frameWidth,
				height = frameHeight,
				scale = machineScale,
				shift = machineShift,
				frame_count = frameCount,
				stripes = {
					{
						filename = "__LegendarySpaceAge__/graphics/crystallizer/overlays/color4-1.png",
						width_in_frames = file1Columns,
						height_in_frames = file1Rows,
					},
					{
						filename = "__LegendarySpaceAge__/graphics/crystallizer/overlays/color4-2.png",
						width_in_frames = file2Columns,
						height_in_frames = file2Rows,
					},
				},
			},
		},
	},
	frozen_patch = {
		filename = "__LegendarySpaceAge__/graphics/crystallizer/frozen.png",
		width = frameWidth,
		height = frameHeight,
		scale = machineScale,
		shift = machineShift,
	},
}
extend{ent}

local item = copy(ITEM["chemical-plant"])
item.name = "crystallizer"
item.localised_name = nil
item.localised_description = nil
Icon.set(item, "LSA/crystallizer/icon")
item.place_result = "crystallizer"
extend{item}

Recipe.make{
	recipe = "crystallizer",
	copy = "chemical-plant",
	resultCount = 1,
	clearIcons = true,
	ingredients = {
		{"fluid-fitting", 50},
		{"frame", 10},
		{"mechanism", 10},
		{"sensor", 10},
	},
	time = 10,
	enabled = true, -- TODO tech
}

extend{{
	type = "recipe-category",
	name = "crystallizer",
}}