--[[ This file creates the "exothermic plant" building+item+recipe. Exothermic plants use cold heat shuttles as fuel, producing the heated version.
Using graphics by Hurricane - https://mods.factorio.com/user/Hurricane046
]]

local ENT_SIZE = 5 -- Size of entity in tiles, assumed square.

local ent = copy(ASSEMBLER["assembling-machine-3"])
ent.name = "exothermic-plant"
ent.icon = "__LegendarySpaceAge__/graphics/exothermic-plant/icon.png"
ent.minable = {mining_time = 2, result = "exothermic-plant"}
ent.crafting_speed = 1
ent.selection_box = {{-2.5, -2.5}, {2.5, 2.5}}
ent.collision_box = {{-2.5, -2.5}, {2.5, 2.5}} -- TODO
ent.tile_height = ENT_SIZE
ent.tile_width = ENT_SIZE
-- TODO fluid boxes
ent.fluid_boxes_off_when_no_fluid_recipe = true
ent.ingredient_count = nil
ent.energy_source.emissions_per_minute = {
	pollution = 20, -- TODO check
}
ent.crafting_categories = {"exothermic"}
ent.energy_usage = "200kW"
ent.energy_source.drain = "0W"
ent.heating_energy = "0W" -- Heats itself.
ent.energy_source = {
	type = "burner",
	fuel_inventory_size = 2,
	burnt_inventory_size = 2,
	burner_usage = "heat-absorber",
	fuel_categories = {"heat-absorber"},
}
local animationSpeed = 1 -- TODO check
local shift = {0, -.75} -- TODO
ent.graphics_set = {
	animation = {
		layers = {
			{
				filename = "__LegendarySpaceAge__/graphics/exothermic-plant/shadow.png",
				width = 900,
				height = 500,
				frame_count = 1,
				repeat_count = 80,
				animation_speed = animationSpeed,
				draw_as_shadow = true,
				scale = 0.5,
				shift = shift,
			},
			{
				width = 330,
				height = 410,
				frame_count = 80,
				animation_speed = animationSpeed,
				scale = 0.5,
				shift = shift,
				stripes = {
					{
						filename = "__LegendarySpaceAge__/graphics/exothermic-plant/animation-1.png",
						width_in_frames = 8,
						height_in_frames = 8,
					},
					{
						filename = "__LegendarySpaceAge__/graphics/exothermic-plant/animation-2.png",
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
			animation = {
				width = 330,
				height = 410,
				frame_count = 80,
				animation_speed = animationSpeed,
				scale = 0.5,
				shift = shift,
				draw_as_light = true,
				blend_mode = "additive",
				stripes = {
					{
						filename = "__LegendarySpaceAge__/graphics/exothermic-plant/emission-1.png",
						width_in_frames = 8,
						height_in_frames = 8,
					},
					{
						filename = "__LegendarySpaceAge__/graphics/exothermic-plant/emission-2.png",
						width_in_frames = 8,
						height_in_frames = 2,
					},
				},
			},
		}
	},
	reset_animation_when_frozen = true,
}
ent.working_sound = copy(RAW.generator["steam-turbine"].working_sound) -- TODO check
ent.open_sound = ASSEMBLER.foundry.open_sound -- sounds.steam_open, TODO check
ent.close_sound = ASSEMBLER.foundry.close_sound -- sounds.steam_close, TODO check
ent.build_sound = nil -- just default, TODO check
ent.corpse = "biochamber-remnants" -- TODO check
ent.dying_explosion = "steam-turbine-explosion" -- TODO check
ent.max_health = 800 -- TODO check
ent.circuit_connector = copy(ASSEMBLER["cryogenic-plant"].circuit_connector) -- TODO change
ent.surface_conditions = {}
-- TODO smoke emission
extend{ent}

local item = copy(ITEM["assembling-machine-3"])
item.name = "exothermic-plant"
item.icon = "__LegendarySpaceAge__/graphics/exothermic-plant/icon.png"
item.place_result = "exothermic-plant"
item.stack_size = 10
Item.perRocket(item, 20)
Item.copySoundsTo("steam-engine", item) -- TODO check
extend{item}

Recipe.make{
	copy = "assembling-machine-1",
	recipe = "exothermic-plant",
	resultCount = 1,
	time = 5,
	ingredients = {
		{"structure", 20},
		{"shielding", 10},
		{"fluid-fitting", 20},
		{"panel", 10},
	},
	enabled = true, -- TODO add tech
}

-- Create recipe category for exothermic plant recipes.
extend{{
	type = "recipe-category",
	name = "exothermic",
}}

-- Create dummy recipe for testing.
Recipe.make{
	copy = "iron-plate",
	recipe = "test-exothermic",
	ingredients = {
		{"iron-ore", 1},
	},
	results = {"iron-plate"},
	time = 10,
	enabled = true,
	category = "exothermic",
}

-- TODO create tech.