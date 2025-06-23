--[[ This file creates the crystallizer building.

This will be used for recipes like:
* crystallizing salt from rich brine
* crystallizing magnesium salt from bitterns
* growing zeolite crystals from silica, alumina, lye, steam, crystal seeds.
* growing silicon crystal ingots from seed crystals, polysilicon, phosphorus, acetone.
* getting pure sulfur crystals?
* maybe other stuff? Like promethium processing, or something.

Currently this is basically just a chem plant. Would be nice to add some kind of special mechanic, like maybe it requires a heat provider, or it's slower in polluted chunks, or something?
]]

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
ent.tile_width = 4
ent.tile_height = 4
ent.selection_box = {{-2, -2}, {2, 2}}
ent.collision_box = {{-1.9, -1.9}, {1.9, 1.9}}
ent.fluid_boxes = {
	{
		production_type = "input",
		volume = 200,
		pipe_covers = pipecoverspictures(),
		pipe_picture = GreyPipes.pipeBlocksSouth(),
		pipe_connections = {
			{flow_direction = "input-output", position = {-0.5, -1.5}, direction = NORTH},
			{flow_direction = "input-output", position = {0.5, 1.5}, direction = SOUTH},
		}
	},
	{
		production_type = "output",
		volume = 200,
		pipe_covers = pipecoverspictures(),
		pipe_picture = GreyPipes.pipeBlocksSouth(),
		pipe_connections = {
			{flow_direction = "input-output", position = {-1.5, -0.5}, direction = WEST},
			{flow_direction = "input-output", position = {1.5, 0.5}, direction = EAST},
		}
	},
}
-- TODO circuit connections
-- TODO sounds
-- TODO energy source and energy usage
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
	quaternary = {0, .5, 0, .5},
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

-- TODO recipe category
-- TODO recipes