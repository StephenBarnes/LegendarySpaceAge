--[[ This file implements shotgun turrets - entity, item, recipe, tech.
Includes significant graphics and code from Cannon Turret mod (mods.factorio.com/mod/vtk-cannon-turret) by VortiK, from original mod by AmbulatoryCortex, original graphics by YuokiTani, graphics improvements by JavitoVk and snouz.
]]

local sounds = require("__base__.prototypes.entity.sounds")
local graphics = "__LegendarySpaceAge__/graphics/shotgun-turret/"

-- Define animation layers.
local turretAnimation = {
	layers = {
		{
			filename = graphics .. "sheet-shadow.png",
			priority = "medium",
			scale = 0.5,
			width = 192,
			height = 192,
			direction_count = 64,
			frame_count = 1,
			line_length = 8,
			axially_symmetrical = false,
			run_mode = "forward",
			shift = {0.25, -0.3},
			draw_as_shadow = true,
		},
		{
			filename = graphics .. "sheet.png",
			priority = "medium",
			scale = 0.5,
			width = 192,
			height = 192,
			direction_count = 64,
			frame_count = 1,
			line_length = 8,
			axially_symmetrical = false,
			run_mode = "forward",
			shift = {0.25, -0.3},
		},
		{
			filename = graphics .. "mask.png",
			scale = 0.75,
			flags = {"mask"},
			width = 128,
			height = 128,
			direction_count = 64,
			frame_count = nil,
			line_length = 8,
			axially_symmetrical = false,
			run_mode = "forward",
			shift = { 0.25, -0.3 },
			apply_runtime_tint = true,
		},
	},
}

-- Create turret entity.
local turret = copy(RAW["ammo-turret"]["gun-turret"])
turret.name = "shotgun-turret"
turret.icon = graphics .. "item.png"
turret.minable.result = "shotgun-turret"
turret.order = "z-b[turret]-0"
turret.placeable_by = { item = "shotgun-turret", count = 1 }
turret.max_health = 800 -- compare to 400 for gun turret, 350 for wall.
turret.corpse = "medium-remnants"
turret.rotation_speed = .005 -- compare .015 for gun turret.
turret.preparing_speed = .04 -- compare .08 for gun turret.
turret.folding_speed = .04 -- compare .08 for gun turret.
turret.attacking_speed = .5 -- compare .5 for gun turret.
-- I'm not sure these folding and preparing animations actually do anything. I think it's for missile turrets to eg rise up from the base.
turret.folding_animation = turretAnimation
turret.folded_animation = turretAnimation
turret.preparing_animation = turretAnimation
turret.prepared_animation = turretAnimation
turret.attacking_animation = turretAnimation
turret.graphics_set = {
	base_visualisation = {
		animation = {
			layers = {
				{
					filename = graphics .. "base.png",
					priority = "medium",
					width = 128,
					height = 128,
					shift = {0, 0},
					scale = 0.5
				},
				{
					filename = graphics .. "base-mask.png",
					flags = {"mask", "low-object"},
					line_length = 1,
					width = 128,
					height = 128,
					shift = {0, 0},
					apply_runtime_tint = true,
					scale = 0.5
				}
			}
		}
	}
}
turret.attack_parameters = {
	type = "projectile",
	ammo_categories = {"shotgun-shell"},
	cooldown = 60, -- Compare to normal shotgun at 60, and combat shotgun at 30
	projectile_creation_distance = 1.5, -- TODO adjust - it's 1.5 for cannon turret, 0.125 for shotgun.
	-- No shell particle.
	range = 15, -- Compare to 15 for shotgun and combat shotgun.
	min_range = nil,
	prepare_range = 30,
	shoot_in_prepare_state = false,
	use_shooter_direction = true,
	sound = sounds.shotgun,
	projectile_center = {0, 0.35}, -- Chose this to make it look like the shots are actually coming out of the barrel.
}
extend{turret}

-- Create item.
local item = copy(ITEM["gun-turret"])
item.name = "shotgun-turret"
item.icon = graphics .. "item.png"
item.place_result = "shotgun-turret"
item.order = "b[turret]-0"
extend{item}

-- Create recipe.
local recipe = copy(RECIPE["gun-turret"])
recipe.name = "shotgun-turret"
recipe.results = {{type = "item", name = "shotgun-turret", amount = 1}}
recipe.ingredients = {
	{type = "item", name = "structure", amount = 1},
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 1},
}
recipe.order = "b[turret]-0"
Icon.clear(recipe)
extend{recipe}

-- Create tech.
local tech = copy(TECH["gun-turret"])
tech.name = "shotgun-turret"
tech.effects = {
	{type = "unlock-recipe", recipe = "shotgun-turret"},
}
tech.prerequisites = {"gunpowder", "automation"}
tech.research_trigger = {
	type = "craft-item",
	item = "shotgun-shell",
	count = 100,
}
tech.unit = nil
tech.icon = graphics .. "tech.png"
extend{tech}
