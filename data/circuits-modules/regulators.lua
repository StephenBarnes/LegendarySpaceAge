--[[ This file creates "regulators", which are simple beacons that don't need modules.
Graphics taken from Krastorio2's "singularity beacons" and modified.
Some code from Krastorio2.
]]

local Const = require("const.regulator-const")

local qualityBonus = 0.25 -- Bonus to distribution effectivity per quality level.
local selectionBox = {{-.5, -.5}, {.5, .5}}
local collisionBox = {{-.45, -.45}, {.45, .45}}

-- Graphics constants.
local graphicsScale = 0.28
local defaultAnimationSpeed = 0.3
local baseGraphicsShift = util.by_pixel(0, -5.5)
local animationGraphicsShift = util.by_pixel(0, -8.75)
local reflectionShift = util.by_pixel(0, 15)

-- Create profile: linear up to max number of regulators, then we want num*profile = maxRegulators, so profile = maxRegulators/num.
local maxRegulators = 1
local regulatorProfile = {}
for i = 1, 50 do
	if i <= maxRegulators then
		regulatorProfile[i] = 1
	else
		regulatorProfile[i] = maxRegulators / i
	end
end

for regulatorName, regulatorVals in pairs(Const) do
	-- Create item.
	local regulatorItem = copy(RAW.item.beacon)
	regulatorItem.name = regulatorName .. "-regulator"
	Icon.set(regulatorItem, {{"LSA/regulator/icon-base"}, {"LSA/regulator/icon-tint", tint=regulatorVals.baseColor}}, "overlay")
	regulatorItem.place_result = regulatorName .. "-regulator"
	extend{regulatorItem}

	-- Create entity.
	local animationSpeed = defaultAnimationSpeed * (regulatorVals.animationSpeedMult or 1)
	local regulatorEnt = copy(RAW.beacon.beacon)
	regulatorEnt.name = regulatorName .. "-regulator"
	regulatorEnt.localised_name = {"entity-name.x-regulator", {"regulator-type." .. regulatorName}}
	regulatorEnt.localised_description = {"entity-description.x-regulator", {"entity-description.regulator-type-" .. regulatorName}}
	regulatorEnt.minable = {mining_time = 0.5, result = regulatorName .. "-regulator"}
	regulatorEnt.max_health = 100
	regulatorEnt.collision_box = collisionBox
	regulatorEnt.selection_box = selectionBox
	regulatorEnt.tile_height = 1
	regulatorEnt.tile_width = 1
	regulatorEnt.drawing_box_vertical_extension = 0
	regulatorEnt.corpse = "small-remnants"
	regulatorEnt.supply_area_distance = 1 -- Gets added to .45 to make 1.45. Can't be non-integer, so we can't make it 1.5 like it should be.
	regulatorEnt.module_slots = 0
	regulatorEnt.created_smoke = nil
	regulatorEnt.distribution_effectivity_bonus_per_quality_level = qualityBonus
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
							tint = regulatorVals.baseColor,
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
					tint = regulatorVals.lightColor,
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
			scale = 15 * graphicsScale,
		},
		rotate = false,
		orientation_to_variation = false
	}
	regulatorEnt.icon = nil
	regulatorEnt.icons = copy(regulatorItem.icons)
	regulatorEnt.minable.result = regulatorName .. "-regulator"
	regulatorEnt.placeable_by = {
		item = regulatorName .. "-regulator",
		count = 1,
	}
	regulatorEnt.fast_replaceable_group = "beacon-1x1"
	regulatorEnt.energy_source = {
		type = "electric",
		usage_priority = "secondary-input", -- Same as vanilla beacon.
	}
	regulatorEnt.energy_usage = "25kW"
	regulatorEnt.profile = regulatorProfile
	extend{regulatorEnt}

	-- Create hidden module for this regulator.
	local hiddenModule = copy(RAW.module[regulatorName .. "-module"])
	hiddenModule.name = regulatorName .. "-regulator-module"
	hiddenModule.localised_name = {"item-name.hidden-regulator-module", {"regulator-type." .. regulatorName}}
	Item.hide(hiddenModule)
	hiddenModule.effect = regulatorVals.effect
	extend{hiddenModule}

	-- Create recipe.
	Recipe.make{
		copy = "assembling-machine-1",
		recipe = regulatorName .. "-regulator",
		ingredients = {
			{"frame", 1},
			{"panel", 2},
			{"sensor", 2},
			{"electronic-components", 10},
		},
		enabled = true, -- TODO later add to a tech.
		time = 2,
		clearIcons = true,
		resultCount = 1,
	}
end

-- Create hidden beacon that actually applies the effect, for all regulator types.
local hiddenBeacon = { ---@type data.BeaconPrototype
	type = "beacon",
	name = "regulator-hidden-beacon",
	icons = copy(ITEM["quality-regulator"].icons),
	radius_visualisation_picture = nil,
	supply_area_distance = 1,
	energy_source = {
		type = "electric",
		usage_priority = "secondary-input", -- Same as vanilla beacon.
		hidden = true,
	},
	energy_usage = "1W", -- The visible regulator ent consumes most of the energy. This is just so the hidden one also turns off when power is out.
	module_slots = 1,
	allowed_effects = {"consumption", "speed", "pollution", "quality", "productivity"},
	distribution_effectivity = 1,
	beacon_counter = "same_type",
	tile_width = 1,
	tile_height = 1,
	selection_box = selectionBox,
	collision_mask = {layers = {}},
	selection_priority = 0,
	selectable_in_game = false,
	hidden = true,
	hidden_in_factoriopedia = true,
	flags = {"not-on-map", "not-repairable", "not-deconstructable", "not-flammable", "not-blueprintable", "placeable-player", "player-creation", "hide-alt-info"},
	profile = regulatorProfile,
	distribution_effectivity_bonus_per_quality_level = qualityBonus,
	-- Bug: these still show up in electricity usage stats.
}
extend{hiddenBeacon}

-- TODO need to add this into the tech progression, and ensure some non-normal quality is unlocked when quality regulators are unlocked.