--[[ This file creates "regulators", which are simple beacons that don't need modules.
Graphics taken from Krastorio2's "singularity beacons" and modified.
Some code from Krastorio2.
]]

-- Tint for highlights. TODO later expand to color variants (efficiency/speed/prod/quality, also pollution).
--local tint = {.1, .1, .8}
local tint = {.9, .1, .1}

-- Create item.
local regulatorItem = copy(RAW.item.beacon)
regulatorItem.name = "regulator"
Icon.set(regulatorItem, {{"LSA/regulator/icon-base"}, {"LSA/regulator/icon-tint", tint=tint}}, "overlay")
regulatorItem.place_result = "regulator"
extend{regulatorItem}

-- Create entity.
local graphicsScale = 0.25
local animationSpeed = 0.25
local baseGraphicsShift = util.by_pixel(0, -3.5)
local animationGraphicsShift = util.by_pixel(0, -6.75)
local reflectionShift = util.by_pixel(0, 25)
local regulatorEnt = copy(RAW.beacon.beacon)
regulatorEnt.name = "regulator"
regulatorEnt.minable = {mining_time = 0.5, result = "regulator"}
regulatorEnt.max_health = 100
regulatorEnt.collision_box = {{-.45, -.45}, {.45, .45}}
regulatorEnt.selection_box = {{-.5, -.5}, {.5, .5}}
regulatorEnt.tile_height = 1
regulatorEnt.tile_width = 1
regulatorEnt.drawing_box_vertical_extension = 0
regulatorEnt.corpse = "small-remnants"
regulatorEnt.supply_area_distance = 1 -- Gets added to .45 to make 1.45. Can't be non-integer, so we can't make it 1.5 like it should be.
regulatorEnt.module_slots = 0
regulatorEnt.created_smoke = nil
regulatorEnt.graphics_set = {
	module_icons_suppressed = true,
	random_animation_offset = true,
	apply_module_tint = nil,
	module_tint_mode = nil,
	no_modules_tint = nil,
	animation_list = {
		{ -- Beacon base
			render_layer = "object",
			always_draw = true,
			animation = {
				layers = {
					{ -- Base
						filename = "__LegendarySpaceAge__/graphics/regulator/base.png",
						width = 115,
						height = 145,
						shift = baseGraphicsShift,
						scale = graphicsScale,
					},
					{ -- Color overlay
						filename = "__LegendarySpaceAge__/graphics/regulator/base-tint.png",
						width = 105,
						height = 124,
						shift = baseGraphicsShift,
						scale = graphicsScale,
						tint = tint,
					},
					{ -- Shadow
						filename = "__LegendarySpaceAge__/graphics/regulator/shadow.png",
						width = 179,
						height = 145,
						shift = baseGraphicsShift,
						scale = graphicsScale,
						draw_as_shadow = true,
					},
				}
			}
		},
		{ -- Lights
			render_layer = "object",
			apply_tint = false, -- So it doesn't get tints from modules.
			always_draw = false, -- So it stops drawing when power is off.
			animation = {
				filename = "__LegendarySpaceAge__/graphics/regulator/lights.png",
				line_length = 5,
				width = 95,
				height = 107,
				frame_count = 10,
				animation_speed = animationSpeed,
				scale = graphicsScale,
				shift = animationGraphicsShift,
				--blend_mode = "additive",
				draw_as_glow = true,
				tint = tint,
			},
		},
	},
}
regulatorEnt.water_reflection = {
	pictures = {
		filename = "__LegendarySpaceAge__/graphics/regulator/reflection.png",
		priority = "extra-high",
		width = 10,
		height = 12.5,
		shift = reflectionShift,
		variation_count = 1,
		scale = 10 * graphicsScale,
	},
	rotate = false,
	orientation_to_variation = false
}
regulatorEnt.icon = nil
regulatorEnt.icons = copy(regulatorItem.icons)
regulatorEnt.minable.result = "regulator"
regulatorEnt.placeable_by = {
	item = "regulator",
	count = 1,
}
regulatorEnt.fast_replaceable_group = "beacon-1x1"
regulatorEnt.energy_source = {
	type = "electric",
	usage_priority = "secondary-input", -- Same as vanilla beacon.
}
regulatorEnt.energy_usage = "10kW"
regulatorEnt.profile = {}
-- Create profile: linear up to 5, then we want num*profile = 5, so profile = 5/num.
for i = 1, 50 do
	if i <= 5 then
		regulatorEnt.profile[i] = 1
	else
		regulatorEnt.profile[i] = 5 / i
	end
end
extend{regulatorEnt}

-- Create hidden beacon that actually applies the effect, for all regulator types.
local hiddenBeacon = { ---@type data.BeaconPrototype
	type = "beacon",
	name = "regulator-hidden-beacon",
	icons = copy(regulatorItem.icons),
	radius_visualisation_picture = nil,
	supply_area_distance = 1,
	energy_source = {
		type = "electric",
		usage_priority = "secondary-input", -- Same as vanilla beacon.
	},
	energy_usage = "1W", -- The visible regulator ent consumes most of the energy. This is just so the hidden one also turns off when power is out.
	module_slots = 1,
	allowed_effects = {"consumption", "speed", "pollution", "quality", "productivity"},
	distribution_effectivity = 1,
	beacon_counter = "same_type",
	tile_width = 1,
	tile_height = 1,
	selection_box = copy(regulatorEnt.selection_box),
	collision_mask = {layers = {}},
	selection_priority = 0,
	selectable_in_game = false,
	hidden = true,
	hidden_in_factoriopedia = true,
	flags = {"not-on-map", "not-repairable", "not-deconstructable", "not-flammable", "not-blueprintable", "placeable-player", "player-creation", "hide-alt-info"},
	profile = regulatorEnt.profile,
}
extend{hiddenBeacon}

-- Create hidden modules for regulators.
local hiddenModule = copy(RAW.module["productivity-module"])
hiddenModule.name = "regulator-module"
hiddenModule.hidden = true
hiddenModule.hidden_in_factoriopedia = true
hiddenModule.effect = {
	productivity = 0.1,
	consumption = 0.1,
}
extend{hiddenModule}