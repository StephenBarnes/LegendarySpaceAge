--[[ This file creates "clean assemblers" (better name?).
These are assemblers that suffer a big productivity hit in polluted chunks, but also generate zero pollution.
These are necessary for making microchips (like "cleanrooms" in real microchip manufacturing).
So the basic challenge is that they have to be placed far away from the main factory, shipping in ingredients and shipping out products and waste.

I'll also allow all other assembler recipes in them too. So players COULD choose a strategy of only using clean assemblers for everything, but then they need to put all polluting buildings in their factory (like boilers) far away and use lots of air filters etc.
]]

-- TODO get sprites (assembler building but white?)
-- TODO use control-stage scripting to create an invisible beacon inside every clean assembler, and use control-stage scripting to check pollution and put modules in them depending on pollution level. Also cache table of all clean assemblers.
-- TODO ban them completely on Gleba? Since ambient air has spores? Or ban based on spore level?
-- TODO what to do for Fulgora and Vulcanus?

-- Create clean assembler entity.
local ent = copy(ASSEMBLER["assembling-machine-2"])
local animationSpeed = 1
local graphicsShift = {0, -0.45}
local graphicsScale = 0.42
local shadowShift = {0.65, 0.18}
local shadowScale = 0.7
ent.name = "clean-assembler"
ent.minable.result = "clean-assembler"
ent.corpse = "medium-remnants"
ent.dying_explosion = "assembling-machine-1-explosion"
ent.next_upgrade = nil
ent.fast_replaceable_group = nil
ent.collision_box = {{-1.35, -1.35}, {1.35, 1.35}}
ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
ent.tile_width = 3
ent.tile_height = 3
ent.graphics_set = {
	animation = {
		layers = {
			{
				filename = "__LegendarySpaceAge__/graphics/clean-assembler/ent.png",
				priority = "high",
				width = 256,
				height = 254,
				frame_count = 8,
				line_length = 4,
				shift = graphicsShift,
				scale = graphicsScale,
				animation_speed = animationSpeed,
			},
			{
				filename = "__LegendarySpaceAge__/graphics/clean-assembler/shadow.png",
				priority = "high",
				width = 171,
				height = 91,
				frame_count = 1,
				repeat_count = 8,
				draw_as_shadow = true,
				shift = shadowShift,
				scale = shadowScale,
			}
		}
	}
}
-- TODO passthrough fluidboxes
-- TODO needs different fluidbox covers, current GreyPipes is too big.
ent.fluid_boxes = {
	{
		production_type = "input",
		pipe_picture = GreyPipes.pipeBlocks(),
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = {
			{ flow_direction = "input-output", direction = NORTH, position = { 0, -1 } },
			{ flow_direction = "input-output", direction = SOUTH, position = { 0, 1 } },
		},
		secondary_draw_orders = { north = -1 },
	},
	{
		production_type = "output",
		pipe_picture = GreyPipes.pipeBlocks(),
		pipe_covers = pipecoverspictures(),
		volume = 1000,
		pipe_connections = {
			{ flow_direction = "input-output", direction = WEST, position = { -1, 0 } },
			{ flow_direction = "input-output", direction = EAST, position = { 1, 0 } },
		},
		secondary_draw_orders = { north = -1 },
	}
}
Icon.set(ent, "LSA/clean-assembler/icon")
ent.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions = {},
	drain = "100kW",
}
ent.energy_usage = "400kW"
ent.crafting_categories = {"crafting", "crafting-with-fluid", "clean-assembling"}
ent.crafting_speed = 1
-- TODO signal connector
-- TODO sound of fan
extend{ent}

-- Create crafting category.
extend{{
	type = "recipe-category",
	name = "clean-assembling",
}}

-- TODO implement productivity malus in polluted chunks.

-- Create clean assembler item.
local item = copy(ITEM["assembling-machine-2"])
item.name = "clean-assembler"
item.place_result = "clean-assembler"
Icon.set(item, "LSA/clean-assembler/icon")
extend{item}

-- TODO create recipe.