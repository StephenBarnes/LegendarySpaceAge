-- This file creates the arc furnace entity, item, recipe.

-- Create entity.
local ent = copy(ASSEMBLER["foundry"])
ent.name = "arc-furnace"
Icon.set(ent, "LSA/arc-furnace/icon")
ent.minable = {mining_time = 1, result = "arc-furnace"}
ent.placeable_by = {item = "arc-furnace", count = 1}
ent.selection_box = {{-2.5, -2.5}, {2.5, 2.5}}
ent.collision_box = {{-2.3, -2.3}, {2.3, 2.3}} -- TODO make tighter.
ent.tile_height = 5
ent.tile_width = 5
ent.crafting_categories = {"arc-furnace"}
ent.crafting_speed = 1
ent.effect_receiver.base_effect = nil -- Remove base productivity bonus.
	-- Considered giving it a starting -50% prod. But negative productivity doesn't actually work, gets coerced to 0.
ent.energy_source.emissions_per_minute = { pollution = 10 }
ent.energy_source.drain = "1MW"
ent.energy_usage = "9MW"
ent.heating_energy = "1MW"
ent.perceived_performance = {maximum = 1.5} -- So it doesn't look ridiculously fast.
local animationSpeed = 0.4
ent.graphics_set = {
	animation = {
		layers = {
			{
				filename = "__LegendarySpaceAge__/graphics/arc-furnace/shadow.png",
				width = 600,
				height = 400,
				frame_count = 1,
				repeat_count = 50,
				animation_speed = animationSpeed,
				draw_as_shadow = true,
				scale = 0.5,
			},
			{
				width = 320,
				height = 320,
				frame_count = 50,
				line_length = 8,
				animation_speed = animationSpeed,
				scale = 0.5,
				filename = "__LegendarySpaceAge__/graphics/arc-furnace/animation.png",
			},
		},
	},
	working_visualisations = {
		{ -- Light overlay.
			apply_recipe_tint = "primary", -- TODO check recipe tints.
			fadeout = true,
			animation = {
				width = 320,
				height = 320,
				frame_count = 50,
				line_length = 8,
				animation_speed = animationSpeed,
				scale = .5,
				draw_as_glow = true,
				blend_mode = "additive",
				filename = "__LegendarySpaceAge__/graphics/arc-furnace/light.png",
			},
		},
	},
	reset_animation_when_frozen = true,
}
-- TODO add fluid boxes and pipes, and check the .enable_working_visualisations in the foundry.
-- Adding fluid boxes. We need at least 2 inputs and 2 outputs. Eg lava and oxygen to molten iron and molten copper. Or molten iron and oxygen to molten steel.
ent.fluid_boxes_off_when_no_fluid_recipe = false
local pipeCovers = pipecoverspictures()
local northPipePos = {
	{-1, -2},
	{2, 1},
	{-1, 2},
	{-2, 1},
}
local function rotatePipePositions(n)
	return {
		northPipePos[(0+n) % 4 + 1],
		northPipePos[(1+n) % 4 + 1],
		northPipePos[(2+n) % 4 + 1],
		northPipePos[(3+n) % 4 + 1],
	}
end
---@return data.FluidBox
local function makeFluidBox(productionType, flowDir, dir, pipePositions)
	return {
		production_type = productionType,
		pipe_covers = pipeCovers,
		volume = 1000,
		pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
		pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
		secondary_draw_order = -1,
		pipe_connections = {
			{
				flow_direction = flowDir,
				direction = dir,
				positions = pipePositions,
			},
		},
	}
end
ent.fluid_boxes = {
	makeFluidBox("input", "input", defines.direction.north, northPipePos),
	makeFluidBox("input", "input", defines.direction.east, rotatePipePositions(1)),
	makeFluidBox("output", "output", defines.direction.south, rotatePipePositions(2)),
	makeFluidBox("output", "output", defines.direction.west, rotatePipePositions(3)),
}
-- TODO add sounds
-- TODO add dying_explosion
-- TODO add corpse
-- TODO add circuit_connector
extend{ent}

-- Create item.
local item = copy(ITEM["foundry"])
item.name = "arc-furnace"
Icon.set(item, "LSA/arc-furnace/icon")
item.place_result = "arc-furnace"
item.weight = ROCKET / 20
item.stack_size = 20
extend{item}

-- Create recipe.
Recipe.make{
	copy = "foundry",
	recipe = "arc-furnace",
	ingredients = {"steel-plate"}, -- TODO write proper recipe
	resultCount = 1,
	enabled = true, -- TODO add tech
}
