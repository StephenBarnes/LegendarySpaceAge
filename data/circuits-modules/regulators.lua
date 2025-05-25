--[[ This file creates "regulators", which are simple beacons that don't need modules.
Graphics taken from Krastorio2's "singularity beacons" and modified.
Some code from Krastorio2.
]]

-- Tint for highlights. TODO later expand to 4 color variants.
local tint = {1, 0, 0}

-- Create item.
local regulatorItem = copy(RAW.item.beacon)
regulatorItem.name = "regulator"
Icon.set(regulatorItem, {{"LSA/regulator/icon-base"}, {"LSA/regulator/icon-tint", tint=tint}}, "overlay")
regulatorItem.place_result = "regulator"
extend{regulatorItem}

-- Create entity.
local graphicsScale = 0.25
local animationSpeed = 0.25
local baseGraphicsShift = util.by_pixel(0, -7)
local animationGraphicsShift = util.by_pixel(0, -13.5)
local reflectionShift = util.by_pixel(0, 50)
local regulatorEnt = copy(RAW.beacon.beacon)
regulatorEnt.name = "regulator"
regulatorEnt.minable = {mining_time = 0.5, result = "regulator"}
regulatorEnt.max_health = 300
regulatorEnt.collision_box = {{-0.75, -0.75}, {0.75, 0.75}}
regulatorEnt.selection_box = {{-1, -1}, {1, 1}}
regulatorEnt.corpse = "medium-remnants"
regulatorEnt.supply_area_distance = 2.0
-- TODO edit graphics to look less advanced.
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
						width = 230,
						height = 290,
						shift = baseGraphicsShift,
						scale = graphicsScale,
					},
					{ -- Color overlay
						filename = "__LegendarySpaceAge__/graphics/regulator/base-tint.png",
						width = 210,
						height = 248,
						shift = baseGraphicsShift,
						scale = graphicsScale,
						tint = tint,
					},
					{ -- Shadow
						filename = "__LegendarySpaceAge__/graphics/regulator/shadow.png",
						width = 358,
						height = 290,
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
				width = 190,
				height = 214,
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
		width = 20,
		height = 25,
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
regulatorEnt.fast_replaceable_group = "beacon-2x2"
extend{regulatorEnt}