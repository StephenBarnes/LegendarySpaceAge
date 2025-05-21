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
ent.tile_width = 3
ent.tile_height = 3
ent.corpse = "big-remnants"
ent.dying_explosion = "medium-explosion"
ent.max_health = 300
ent.next_upgrade = nil
ent.fast_replaceable_group = nil
-- Circuit connection looks fine.
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
				width = 2080/8,
				height = 2128/8,
				frame_count = 64,
				line_length = 8,
				shift = util.by_pixel(6, -19),
				animation_speed = 0.25,
				scale = 0.5,
			},
			{
				draw_as_shadow = true,
				filename = "__space-exploration-graphics-4__/graphics/entity/telescope/telescope-shadow.png",
				width = 2608/8,
				height = 1552/8,
				frame_count = 64,
				line_length = 8,
				shift = util.by_pixel(32, 7),
				animation_speed = 0.25,
				scale = 0.5,
			},
		},
	},
}
ent.working_sound = {
	--[[
	idle_sound = {
		filename = "__base__/sound/idle1.ogg",
		volume = 0.6
	},]]
	main_sounds = {
		{
			--sound = {filename = "__base__/sound/idle1.ogg", volume = 0.4},
			sound = {filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-arm-extend-loop.ogg", volume = 0.27},
			audible_distance_modifier = 0.5,
			fade_in_ticks = 4,
			fade_out_ticks = 30,
		},
	},
	sound_accents = {
		--[[ Frame counts:
			There's 64 frames.
			Inclines upwards around 6-17.
			Sweeps around 19-40. (Smaller rotation.)
			Declines downwards 41-56.
			Sweeps back 57-64. (Larger rotation.)
			]]
		--[[
		{ -- Incline
			sound = {filename = "__base__/sound/inserter-long-handed-2.ogg", volume = 0.8, audible_distance_modifier = 0.6},
			frame = 5, -- 7 is too late.
		},
		{ -- Rotate 1
			sound = {filename = "__base__/sound/roboport-door.ogg", volume = 0.8, audible_distance_modifier = 0.6},
			frame = 18,
		},
		{ -- Decline
			sound = {filename = "__space-age__/sound/entity/recycler/recycler-mechanic-3.ogg", volume = 0.8, audible_distance_modifier = 0.6},
			frame = 40, -- 42 is too late.
		},
		{ -- Rotate 2
			sound = {filename = "__space-age__/sound/entity/recycler/recycler-mechanic-3.ogg", volume = 0.8, audible_distance_modifier = 0.6},
			frame = 55, -- 57 is too late.
		},
		]]
		-- Rather doing click sounds at velocity changes / extremes of range-of-motion.
		{ -- Start of incline.
			sound = {
				filename = "__space-age__/sound/entity/rocket-turret/rocket-turret-rotation-stop.ogg",
				volume = 0.65,
				audible_distance_modifier = 0.5,
				probability = .4,
			},
			frame = 2,
		},
		{ -- Start of rotate 2
			sound = {
				filename = "__space-age__/sound/entity/rocket-turret/rocket-turret-rotation-stop.ogg",
				volume = 0.65,
				audible_distance_modifier = 0.5,
				probability = .4,
			},
			frame = 47,
		},
	},
}
ent.crafting_categories = {"telescope"}
ent.fixed_recipe = "space-science-pack"
ent.crafting_speed = 1
ent.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = {},
	drain = "0W",
}
ent.energy_usage = "500kW" -- Solar panels on Apollo are 120kW, so I think this is reasonable.
local apolloGravity = RAW.planet.apollo.surface_properties.gravity
ent.surface_conditions = {
	{
		property = "gravity",
		min = apolloGravity,
		max = apolloGravity,
	},
}
ent.tile_buildability_rules = {{ -- Only allow building on high tiles.
	area = ent.collision_box,
	required_tiles = {layers = {allows_telescope=true}},
}}
extend{ent}

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
extend{item}

-- Create recipe for making telescopes.
Recipe.make{
	copy = "assembling-machine-2",
	recipe = "telescope",
	ingredients = {
		{"electric-engine-unit", 20},
		{"fluid-fitting", 10},
		{"sensor", 50},
	},
	resultCount = 1,
	time = 50,
	enabled = false,
		-- Added to Apollo tech when that's created.
}

-- Not creating a new item for lunar science. Instead using existing space-science-pack.

-- Create recipe for lunar science.
Recipe.edit{
	recipe = "space-science-pack",
	category = "telescope",
	ingredients = {
		{"processing-unit", 1},
		{"liquid-nitrogen", 1, type="fluid"},
	},
	results = {
		{"space-science-pack", 1},
		{"nitrogen-gas", 1, type="fluid", ignored_by_productivity = 1},
	},
	main_product = "space-science-pack",
	allow_productivity = true,
	allow_quality = true,
	time = 10,
	enabled = false,
		-- Added to Apollo tech when that's created.
	surface_conditions = ent.surface_conditions,
}

-- Create exclusion zones.
ExclusionZones.create(ASSEMBLER["telescope"])