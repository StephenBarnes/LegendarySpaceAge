--[[ This file is experimental. Want to see if it's possible to make a 1x1 assembler that gets automatically loaded by belt, and unloads into another belt.

Observations while trying to make this:
* In control-stage code (child-created handler), setting loader.drop_target to the parent entity doesn't work, value stores nil after setting it.
* In control-stage code (child-created handler), setting loader.drop_position to the parent entity's position doesn't work, throws error saying it's "not an inserter".
* Trying to put a loader at non-integer coordinates doesn't work, it gets rounded to nearest map tile.
* Can create loader on top of assembler, but it still belongs to a specific tile, so can't put 2 in one tile.
* By setting loader.container_distance = 0, it outputs into the same tile it's currently on, which is inside the assembler. So this is the solution used here - make assembler 2x1, with 2 loaders overlapping the assembler, each loader loading into its own tile (ie into the assembler).
]]

local miniAssembler = copy(ASSEMBLER["assembling-machine-1"])
miniAssembler.name = "mini-assembler"
miniAssembler.tile_height = 2
miniAssembler.tile_width = 1
miniAssembler.minable = {mining_time = 0.1, result = "mini-assembler"}
miniAssembler.crafting_categories = {"mini-assembling"}
miniAssembler.placeable_by = {item = "mini-assembler", count = 1}
local graphicsDir = "__LegendarySpaceAge__/graphics/mini-assembler/"
local graphicsScale = 0.5
local graphicsShiftEW = {0, 0.05} -- Looks fine.
local graphicsShiftNS = {0, 0.12} -- Looks fine.
miniAssembler.graphics_set = {
	animation = {
		north = {
			layers = {
				{
					filename = graphicsDir .. "S.png",
					width = 70,
					height = 99,
					frame_count = 1,
					line_length = 1,
					shift = graphicsShiftNS,
					scale = graphicsScale,
				},
				{
					filename = graphicsDir .. "NS_shadow.png",
					width = 111,
					height = 100,
					frame_count = 1,
					line_length = 1,
					shift = graphicsShiftNS,
					scale = graphicsScale,
					draw_as_shadow = true,
				},
			}
		},
		south = {
			layers = {
				{
					filename = graphicsDir .. "N.png",
					width = 70,
					height = 99,
					frame_count = 1,
					line_length = 1,
					shift = graphicsShiftNS,
					scale = graphicsScale,
				},
				{
					filename = graphicsDir .. "NS_shadow.png",
					width = 111,
					height = 100,
					frame_count = 1,
					line_length = 1,
					shift = graphicsShiftNS,
					scale = graphicsScale,
					draw_as_shadow = true,
				},
			}
		},
		east = {
			layers = {
				{
					filename = graphicsDir .. "W.png",
					width = 68,
					height = 77,
					frame_count = 1,
					line_length = 1,
					shift = graphicsShiftEW,
					scale = graphicsScale,
				},
				{
					filename = graphicsDir .. "EW_shadow.png",
					width = 123,
					height = 80,
					frame_count = 1,
					line_length = 1,
					shift = graphicsShiftEW,
					scale = graphicsScale,
					draw_as_shadow = true,
				},
			}
		},
		west = {
			layers = {
				{
					filename = graphicsDir .. "E.png",
					width = 68,
					height = 77,
					frame_count = 1,
					line_length = 1,
					shift = graphicsShiftEW,
					scale = graphicsScale,
				},
				{
					filename = graphicsDir .. "EW_shadow.png",
					width = 123,
					height = 80,
					frame_count = 1,
					line_length = 1,
					shift = graphicsShiftEW,
					scale = graphicsScale,
					draw_as_shadow = true,
				},
			}
		},
	}
}
-- NOTE there's weird engine behavior where 2x1 assemblers with no fluidboxes behave weirdly when you rotate them. Rotation event gets fired but the assembler's .direction doesn't change, and directional sprites don't update, and assigning assembler.direction / .mirroring / .orientation does nothing, value stays the same. So I'll add a fluidbox so that rotations work as expected.
miniAssembler.fluid_boxes_off_when_no_fluid_recipe = false
miniAssembler.fluid_boxes = {
	{
		production_type = "input",
		volume = 10,
		pipe_connections = {
			{
				position = {0, 0.5},
				direction = WEST,
				connection_type = "linked",
				linked_connection_id = 1,
			}
		}
	}
}
miniAssembler.selection_box = {{-0.5, -1}, {0.5, 1}}
miniAssembler.collision_box = {{-0.45, -1}, {0.45, 1}}
miniAssembler.next_upgrade = nil
miniAssembler.fast_replaceable_group = nil
miniAssembler.crafting_speed = 1
miniAssembler.open_sound = copy(data.raw.container["iron-chest"].open_sound)
miniAssembler.close_sound = copy(data.raw.container["iron-chest"].close_sound)
miniAssembler.working_sound = nil
miniAssembler.build_sound = nil -- I think it's by default set to iron-chest sound? TODO
miniAssembler.mined_sound = nil -- I think it's by default set to iron-chest sound? TODO
-- Circuit connectors, using https://mods.factorio.com/mod/circuit-connector-placement-helper
miniAssembler.circuit_connector = circuit_connector_definitions.create_vector(
	universal_connector_template,
	{
		{ variation = 28, main_offset = util.by_pixel( 17.25, -0.25), shadow_offset = util.by_pixel( 17.25, -0.25), show_shadow = true },
		{ variation = 0,  main_offset = util.by_pixel(5.375, 12.875),   shadow_offset = util.by_pixel(5.375, 12.875),   show_shadow = true },
		{ variation = 28, main_offset = util.by_pixel( 17.25, -0.25), shadow_offset = util.by_pixel( 17.25, -0.25), show_shadow = true },
		{ variation = 0,  main_offset = util.by_pixel(5.375, 12.875),   shadow_offset = util.by_pixel(5.375, 12.875),   show_shadow = true },
	}
)
miniAssembler.alert_icon_shift = {0, -0.2}
miniAssembler.icon_draw_specification.shift = {0, -0.15}
miniAssembler.energy_source = {
	type = "void",
}
miniAssembler.max_health = 150
miniAssembler.icon = "__LegendarySpaceAge__/graphics/mini-assembler/icon.png"
miniAssembler.icons = nil
miniAssembler.allowed_effects = {}
miniAssembler.allowed_module_categories = {}
extend{miniAssembler}

local miniAssemblerItem = copy(ITEM["assembling-machine-1"])
miniAssemblerItem.name = "mini-assembler"
miniAssemblerItem.place_result = "mini-assembler"
miniAssemblerItem.icon = miniAssembler.icon
miniAssemblerItem.icons = nil
miniAssemblerItem.stack_size = 100
miniAssemblerItem.weight = ROCKET / 200
extend{miniAssemblerItem}

local hiddenLoader = copy(data.raw["loader-1x1"]["loader-1x1"])
hiddenLoader.name = "lsa-loader"
hiddenLoader.structure = nil
hiddenLoader.container_distance = 0
hiddenLoader.allow_container_interaction = true
hiddenLoader.selection_priority = 200 -- So it can be selected in editor mode.
hiddenLoader.selection_box = {{-0.3, -0.3}, {0.3, 0.3}}
hiddenLoader.flags = {
	"no-automated-item-removal",
	"no-automated-item-insertion",
	"player-creation",
	"not-on-map",
	"not-blueprintable",
	"not-deconstructable",
	"not-on-map",
}
hiddenLoader.selectable_in_game = false
hiddenLoader.collision_mask = {layers={transport_belt=true}}
hiddenLoader.speed = 10 / 480 -- We want 10 items per second, and this speed property holds 1/480 of items per second according to docs.
extend{hiddenLoader}

-- Create recipe. Will be edited in infra files.
Recipe.make{
	recipe = "mini-assembler",
	resultCount = 1,
	time = 1,
	addToTech = "automation",
}

-- Create recipe category.
extend{{
	type = "recipe-category",
	name = "mini-assembling",
}}