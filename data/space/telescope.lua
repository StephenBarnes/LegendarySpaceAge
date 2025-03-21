--[[ This file creates the telescope entity, item, recipe.
I'm reusing telescope graphics from Space Exploration (in separate mod space-exploration-graphics-4).
Space Exploration's graphics cannot be modified but they're fine to add as dependency mods and then load in other overhaul mods, such as this one.
Telescopes are built on Apollo's mountain ranges (mega-crater rims) to produce lunar science. This idea partly stolen from Lunar Landings mod.
Some code taken from Lunar Landings mod.
]]

---@type data.AssemblingMachinePrototype
local ent = copy(ASSEMBLER["assembling-machine-2"])
ent.name = "telescope"
ent.icon = "__space-exploration-graphics__/graphics/icons/telescope.png"
ent.minable.result = "telescope"
ent.alert_icon_shift = util.by_pixel(0, -12)
ent.collision_box = {{-1.2, -1.2}, {1.2, 1.2}}
ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
-- TODO corpse, dying explosion
-- TODO max health
-- TODO switch to passthrough fluid boxes.
-- TODO circuit connection.
-- TODO audio - probably combine assembling machine and radar.
ent.fluid_boxes = {
	{
		production_type = "input",
		pipe_picture = GreyPipes.pipeBlocks(),
		pipe_covers = pipecoverspictures(),
		volume = 20,
		always_draw_covers = true,
		secondary_draw_orders = {north = -1, east = -1, west = -1},
		pipe_connections = {
			{
				position = {0, 1},
				direction = SOUTH,
				flow_direction = "input-output",
			},
			{
				position = {0, -1},
				direction = NORTH,
				flow_direction = "input-output",
			},
		},
	},
	{
		production_type = "output",
		pipe_picture = GreyPipes.pipeBlocks(),
		pipe_covers = pipecoverspictures(),
		volume = 20,
		always_draw_covers = true,
		secondary_draw_orders = {north = -1, east = -1, west = -1},
		pipe_connections = {
			{
				position = {1, 0},
				direction = EAST,
				flow_direction = "input-output",
			},
			{
				position = {-1, 0},
				direction = WEST,
				flow_direction = "input-output",
			},
		},
	}
}
ent.fluid_boxes_off_when_no_fluid_recipe = false
ent.graphics_set = {
	animation = {
		layers = {
			{
				filename = "__space-exploration-graphics-4__/graphics/entity/telescope/telescope.png",
				priority = "high",
				width = 2080/8,
				height = 2128/8,
				frame_count = 64,
				line_length = 8,
				shift = util.by_pixel(6, -19),
				animation_speed = 0.2,
				scale = 0.5,
			},
			{
				draw_as_shadow = true,
				filename = "__space-exploration-graphics-4__/graphics/entity/telescope/telescope-shadow.png",
				priority = "high",
				width = 2608/8,
				height = 1552/8,
				frame_count = 64,
				line_length = 8,
				shift = util.by_pixel(32, 7),
				animation_speed = 0.2,
				scale = 0.5,
			},
		},
	},
}
ent.crafting_categories = {"telescope"}
ent.fixed_recipe = "lunar-science-pack"
ent.crafting_speed = 1
ent.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = {},
}
ent.energy_usage = "500kW" -- TODO decide.
local apolloGravity = RAW.planet.apollo.surface_properties.gravity
ent.surface_conditions = {
	{
		property = "gravity",
		min = apolloGravity,
		max = apolloGravity,
	},
}
extend{ent}
-- TODO exclusion zones?

-- Create crafting category.
extend{{
	type = "recipe-category",
	name = "telescope",
}}

-- Create item.
local item = copy(ITEM["assembling-machine-2"])
item.name = "telescope"
item.icon = "__space-exploration-graphics__/graphics/icons/telescope.png"
item.place_result = "telescope"
item.subgroup = ITEM["rocket-silo"].subgroup
extend{item}

-- TODO create recipe for making telescopes.

-- TODO create item for lunar science.
local scienceItem = copy(RAW.tool["space-science-pack"])
scienceItem.name = "lunar-science-pack"
extend{scienceItem}

-- TODO create recipe for lunar science.
Recipe.make{
	copy = "space-science-pack",
	recipe = "lunar-science-pack",
	category = "telescope",
	ingredients = {
		{"processing-unit", 1},
		{"liquid-nitrogen", 1, type="fluid"},
	},
	results = {
		{"lunar-science-pack", 1},
		{"nitrogen-gas", 1, type="fluid", ignored_by_productivity = 1}, -- TODO check.
	},
	main_product = "lunar-science-pack",
	allow_productivity = true,
	allow_quality = true,
	time = 10,
	enabled = true, -- TODO add to tech.
}

-- TODO add to tech.