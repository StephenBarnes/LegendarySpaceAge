--[[ This file is experimental. Want to see if it's possible to make a 1x1 assembler that gets automatically loaded by belt, and unloads into another belt.

Observations from making this:
* In control-stage code (child-created handler), setting loader.drop_target to the parent entity doesn't work, value stores nil after setting it.
* In control-stage code (child-created handler), setting loader.drop_position to the parent entity's position doesn't work, throws error saying it's "not an inserter".
* Can create loader on top of assembler, but it still belongs to a specific tile, and will put items into the tile 1 in that direction. So, not into the assembler.
* Trying to put a loader at non-integer coordinates doesn't work, it gets rounded to nearest map tile.
* Loader.container_distance = 0 does work! Moves stuff into the 
]]

local miniAssembler = copy(ASSEMBLER["assembling-machine-1"])
miniAssembler.name = "mini-assembler"
miniAssembler.tile_height = 2
miniAssembler.tile_width = 1
miniAssembler.minable = {mining_time = 0.1, result = "mini-assembler"}
miniAssembler.crafting_categories = {"crafting"}
miniAssembler.placeable_by = {item = "mini-assembler", count = 1}
miniAssembler.graphics_set = {
	animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1.png",
				priority = "high",
				width = 214,
				height = 226,
				frame_count = 32,
				line_length = 8,
				shift = {0, -0.5},
				scale = 0.5 / 3,
			},
			{
				filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1.png",
				priority = "high",
				width = 214,
				height = 226,
				frame_count = 32,
				line_length = 8,
				shift = {0, 0.5},
				scale = 0.5 / 3,
			},
			{
				filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1.png",
				priority = "high",
				width = 214,
				height = 226,
				frame_count = 32,
				line_length = 8,
				shift = {0, 0},
				scale = 0.5 / 3,
			},
			{
				filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1-shadow.png",
				priority = "high",
				width = 190,
				height = 165,
				line_length = 1,
				repeat_count = 32,
				draw_as_shadow = true,
				shift = util.by_pixel(8.5, 5),
				scale = 0.5 / 3,
			}
		}
	}
}
miniAssembler.selection_box = {{-0.5, -1}, {0.5, 1}}
miniAssembler.collision_box = {{-0.5, -1}, {0.5, 1}}
miniAssembler.next_upgrade = nil
miniAssembler.fast_replaceable_group = nil
miniAssembler.crafting_speed = 10
extend{miniAssembler}

local miniAssemblerItem = copy(ITEM["assembling-machine-1"])
miniAssemblerItem.name = "mini-assembler"
miniAssemblerItem.place_result = "mini-assembler"
extend{miniAssemblerItem}

local hiddenLoader = copy(data.raw["loader-1x1"]["loader-1x1"])
hiddenLoader.name = "lsa-loader"
hiddenLoader.structure = nil
hiddenLoader.container_distance = 0
hiddenLoader.allow_container_interaction = true
hiddenLoader.selection_priority = 200 -- TODO temporary
hiddenLoader.selection_box = {{-0.3, -0.3}, {0.3, 0.3}}
hiddenLoader.flags = {
	"no-automated-item-removal",
	"no-automated-item-insertion",
	"player-creation",
	"not-on-map",
	"not-blueprintable",
	"not-deconstructable",
	"not-on-map",
	--"not-selectable-in-game",
}
hiddenLoader.collision_mask = {layers={transport_belt=true}}
extend{hiddenLoader}