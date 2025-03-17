--[[ This file makes tiles for Apollo.
TODO most of the fields haven't been carefully set, eg sounds, walking speed, vehicle speed.

NOTE all my tilesets are modified versions of vanilla:
* dust-flat -> doughy.
* volcanic-soil-dark -> dirt.
* volcanic-ash-soil -> clay.
* volcanic-pumice-stones -> sandy-rock.
* fulgoran-rock -> rocky. (This one has different layout from all the rest.)
* (dust-lumpy -> was going to use, but it seems to just be volcanic-pumice-stones with calcite stains)
]]

-- Create a subgroup for lunar tiles.
extend{{
    type = "item-subgroup",
    name = "lunar-tiles",
    order = "b2", -- After Nauvis, before Vulcanus.
    group = "tiles",
}}

local tile_trigger_effects = require("__base__/prototypes/tile/tile-trigger-effects")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local base_sounds = require("__base__/prototypes/entity/sounds")
local base_tile_sounds = require("__base__/prototypes/tile/tile-sounds")
local tile_sounds = require("__space-age__/prototypes/tile/tile-sounds")

local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

local patch_for_inner_corner_of_transition_between_transition = tile_graphics.patch_for_inner_corner_of_transition_between_transition

local lunarTileOffset = 40
    -- Controls transition drawing priority. Vulcanus file says it should be above 33 (nuclear ground), below 100 (concrete). Vulcanus is 40, so setting to the same.
local lunarTileAbsorptions = { pollution = 0.00003 } -- Setting it the same as most other tiles. Doesn't really matter since there's no enemies.

-- Function for the spritesheet format used for all my spritesheets except rocky.
function tile_variations_template_with_transitions(high_res_picture, options)
    local result = tile_variations_template(high_res_picture, high_res_picture, options)
    if result.transition then
        result.transition.layout = {
            scale                    = 0.5,
            inner_corner_x           = 1216 * 2,
            outer_corner_x           = 1504 * 2,
            side_x                   = 1792 * 2,
            u_transition_x           = 1056 * 2,
            o_transition_x           = 544 * 2,
            inner_corner_count       = 8,
            outer_corner_count       = 8,
            side_count               = 8,
            u_transition_count       = 1,
            o_transition_count       = 1,
            u_transition_line_length = 4,
            o_transition_line_length = 4,
            overlay                  = { x_offset = 0 }
        }
    end
    return result
end

-- Transitions between tiles. Mostly copying the transitions from Vulcanus tiles.
local lava_stone_transitions = {
    {
        to_tiles = water_tile_type_names,
        transition_group = water_transition_group_id,
        spritesheet = "__space-age__/graphics/terrain/water-transitions/lava-stone-cold.png",
        layout = tile_spritesheet_layout.transition_16_16_16_4_4,
        effect_map_layout = {
            spritesheet = "__base__/graphics/terrain/effect-maps/water-dirt-mask.png",
            inner_corner_count = 8,
            outer_corner_count = 8,
            side_count = 8,
            u_transition_count = 2,
            o_transition_count = 1
        }
    },
    {
        to_tiles = {"out-of-map","empty-space","oil-ocean-shallow"},
        transition_group = out_of_map_transition_group_id,
        background_layer_offset = 1,
        background_layer_group = "zero",
        offset_background_layer_by_tile_layer = true,
        spritesheet = "__space-age__/graphics/terrain/out-of-map-transition/volcanic-out-of-map-transition.png",
        layout = tile_spritesheet_layout.transition_4_4_8_1_1,
        overlay_enabled = false
    }
}
local lava_stone_transitions_between_transitions = {
    {
        transition_group1 = default_transition_group_id,
        transition_group2 = water_transition_group_id,

        spritesheet = "__space-age__/graphics/terrain/water-transitions/lava-stone-cold-transition.png",
        layout = tile_spritesheet_layout.transition_3_3_3_1_0,
        effect_map_layout = {
            spritesheet = "__space-age__/graphics/terrain/effect-maps/lava-dirt-to-land-mask.png",
            o_transition_count = 0
        },
    },
    {
        transition_group1 = water_transition_group_id,
        transition_group2 = out_of_map_transition_group_id,
        background_layer_offset = 1,
        background_layer_group = "zero",
        offset_background_layer_by_tile_layer = true,
        spritesheet = "__space-age__/graphics/terrain/out-of-map-transition/lava-stone-cold-shore-out-of-map-transition.png",
        layout = tile_spritesheet_layout.transition_3_3_3_1_0,
        effect_map_layout = {
            spritesheet = "__base__/graphics/terrain/effect-maps/water-dirt-to-out-of-map-mask.png",
            o_transition_count = 0
        }
    },
    {
        transition_group1 = default_transition_group_id,
        transition_group2 = out_of_map_transition_group_id,
        background_layer_offset = 1,
        background_layer_group = "zero",
        offset_background_layer_by_tile_layer = true,
        spritesheet = "__space-age__/graphics/terrain/out-of-map-transition/volcanic-out-of-map-transition-transition.png",
        layout = tile_spritesheet_layout.transition_3_3_3_1_0,
        overlay_enabled = false
    }
}

---@param args { name: string, order: string, autoplaceProb: string, variants: data.TileTransitionsVariants, walkingSound: ((string|data.SoundDefinition.struct)[]|data.Sound.struct)?, landingStepsSound: ((string|data.SoundDefinition.struct)[]|data.Sound.struct)?, drivingSound: ((string|data.SoundDefinition.struct)[]|data.Sound.struct)?, mapColor: data.Color, walkingSpeedModifier: number, vehicleFrictionModifier: number, layerOffset: number }
---@return data.TilePrototype
local function makeTilePrototype(args)
    return {
		type = "tile",
		name = args.name,
		subgroup = "lunar-tiles",
		order = args.order,
		collision_mask = tile_collision_masks.ground(),
		autoplace = {
			probability_expression = args.autoplaceProb,
		},
		layer = lunarTileOffset + args.layerOffset,
		sprite_usage_surface = "any",
		variants = args.variants,
		transitions = lava_stone_transitions,
		transitions_between_transitions = lava_stone_transitions_between_transitions,
		walking_sound = args.walkingSound,
		landing_steps_sound = args.landingStepsSound,
		driving_sound = args.drivingSound,
		map_color = args.mapColor,
		walking_speed_modifier = args.walkingSpeedModifier,
		vehicle_friction_modifier = args.vehicleFrictionModifier,
		absorptions_per_second = lunarTileAbsorptions,
	}
end

local lunarDoughy = makeTilePrototype{
    name = "lunar-doughy",
    order = "01",
    autoplaceProb = "lunar_doughy",
    variants = tile_variations_template_with_transitions( -- Copied from dust-flat.
        "__LegendarySpaceAge__/graphics/apollo/tiles/doughy.png",
        {
            max_size = 4,
            [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
            [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
            [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015 }, },
        }
    ),
    walkingSound = tile_sounds.walking.soft_sand({}),
	landingStepsSound = tile_sounds.landing.sand,
	drivingSound = base_tile_sounds.driving.sand,
	mapColor = { r = 100, g = 100, b = 100 }, -- TODO
	walkingSpeedModifier = 1,
	vehicleFrictionModifier = 1,
    layerOffset = 20,
}
extend{lunarDoughy}

local lunarDirt = makeTilePrototype{
    name = "lunar-dirt",
    order = "02",
    autoplaceProb = "lunar_dirt",
    variants = tile_variations_template_with_transitions( -- Copied from volcanic-soil-dark, with some changes.
        "__LegendarySpaceAge__/graphics/apollo/tiles/dirt.png",
		{
			max_size = 4,
			[1] = { weights = { 0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
			[2] = { probability = 1, weights = { 0.070, 0.070, 0.025, 0.070, 0.070, 0.070, 0.007, 0.025, 0.070, 0.050, 0.015, 0.026, 0.030, 0.005, 0.070, 0.027 } },
			[4] = { probability = 1.00, weights = { 0.070, 0.070, 0.070, 0.070, 0.070, 0.070, 0.015, 0.070, 0.070, 0.070, 0.015, 0.050, 0.070, 0.070, 0.065, 0.070 }, },
		}
	),
	walkingSound = tile_sounds.walking.soft_sand({}),
	landingStepsSound = tile_sounds.landing.sand,
	drivingSound = base_tile_sounds.driving.sand,
	mapColor = { r = 100, g = 100, b = 100 }, -- TODO
	walkingSpeedModifier = 1,
	vehicleFrictionModifier = 1,
    layerOffset = 7,
}
extend{lunarDirt}

local lunarClay = makeTilePrototype{
    name = "lunar-clay",
    order = "03",
    autoplaceProb = "lunar_clay",
    variants = tile_variations_template_with_transitions( -- Copied from volcanic-ash-soil.
        "__LegendarySpaceAge__/graphics/apollo/tiles/clay.png",
        {
            max_size = 4,
            [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
            [2] = { probability = 1, weights = {0.070, 0.070, 0.025, 0.070, 0.070, 0.070, 0.007, 0.025, 0.070, 0.050, 0.015, 0.026, 0.030, 0.005, 0.070, 0.027 } },
            [4] = { probability = 1.00, weights = {0.070, 0.070, 0.070, 0.070, 0.070, 0.070, 0.015, 0.070, 0.070, 0.070, 0.015, 0.050, 0.070, 0.070, 0.065, 0.070 }, },
        }
    ),
    walkingSound = tile_sounds.walking.soft_sand({}),
	landingStepsSound = tile_sounds.landing.sand,
	drivingSound = base_tile_sounds.driving.sand,
	mapColor = { r = 100, g = 100, b = 100 }, -- TODO
	walkingSpeedModifier = 1,
	vehicleFrictionModifier = 1,
    layerOffset = 11,
}
extend{lunarClay}

local lunarSandyRock = makeTilePrototype{
    name = "lunar-sandy-rock",
    order = "04",
    autoplaceProb = "lunar_sandy_rock",
    variants = tile_variations_template_with_transitions( -- Copied from volcanic-pumice-stones.
        "__LegendarySpaceAge__/graphics/apollo/tiles/sandy-rock.png",
        {
            max_size = 4,
            [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
            [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
            [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
        }
    ),
    walkingSound = tile_sounds.walking.soft_sand({}),
	landingStepsSound = tile_sounds.landing.sand,
	drivingSound = base_tile_sounds.driving.sand,
	mapColor = { r = 100, g = 100, b = 100 }, -- TODO
	walkingSpeedModifier = 1,
	vehicleFrictionModifier = 1,
    layerOffset = 15,
}
extend{lunarSandyRock}

-- TODO still need to do Fulgoran rock.