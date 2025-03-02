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
ent.energy_source.emissions_per_minute = { pollution = 20 }
ent.energy_source.drain = "1MW"
ent.energy_usage = "4MW"
ent.heating_energy = "1MW"
ent.perceived_performance = {maximum = 4}
local animationSpeed = 0.15
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
--[[ Thinking about what fluid boxes we need.
Recipes, thinking only about fluids:
	Metals from lava: lava + oxygen -> molten iron + molten copper
	Molten iron/copper: oxygen -> molten metal
	Molten steel: molten iron + oxygen -> molten steel
	Molten tungsten: oxygen + hydrogen -> molten tungsten
So we need either 1 or 2 input lines (gas+gas or fluid+gas or just gas) and either 1 or 2 output lines (fluid or fluid+fluid).
I'd prefer straight passthrough lines, like for the foundry.
So, I'll make 2 inputs going horizontally, 2 outputs going vertically. Don't need to explicitly assign fluidboxes in recipes, just order them so oxygen is at least consistent. If only one input/output, it'll use both lines automatically.
	Checked: if it has eg 2 input fluidboxes, and only 1 is used, and source is connected to the one, but another machine is connected to the other, it'll work - the two input fluidboxes get automatically connected to each other.

Note we can't have input fluidboxes also being input-output, because that lets you circumvent the no-lava-in-pipes restriction - can connect pipes to those outputs.
Also because we have the tungsten heating recipe, we want inputs and outputs to be distinguishable.
Actually, we can have input fluidboxes also being input-output, but just set fluidbox_index for lava ingredients so it's input-only.
	Except, that doesn't work even if it looks like it should. Fluid just won't go into the unidirectional input, sometimes.
]]
ent.fluid_boxes_off_when_no_fluid_recipe = false
local emPipePictures = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures")
local pipeCovers = pipecoverspictures()
---@return data.FluidBox
local function makePassthroughFluidLine(production_type, positionList, dirList, bidirectional)
	local pipe_connections = {}
	local flowDir = Gen.ifThenElse(bidirectional, "input-output", production_type)
	for i, position in pairs(positionList) do
		table.insert(pipe_connections, {
			flow_direction = flowDir,
			direction = dirList[i],
			position = position,
			show_bar_in_fluid_gui = true,
		})
	end
	local volume = Gen.ifThenElse(production_type == "input", 1000, 100) -- TODO investigate this - shouldn't output be higher in case of high speed and prod etc?
	return {
		production_type = production_type,
		pipe_picture = emPipePictures.pipe_pictures,
		pipe_picture_frozen = emPipePictures.pipe_pictures_frozen,
		pipe_covers = pipeCovers,
		always_draw_covers = false,
		volume = volume,
		secondary_draw_order = -1,
		pipe_connections = pipe_connections,
	}
end
local fluidIOGroup = {
	input = {
		{ -- North-south west
			positionList = {{-1, -2}, {-1, 2}},
			dirList = {NORTH, SOUTH},
			bidirectional = false,
		},
		{ -- North-south east
			positionList = {{1, -2}, {1, 2}},
			dirList = {NORTH, SOUTH},
			bidirectional = false,
		},
	},
	output = {
		{ -- East-west north
			positionList = {{-2, -1}, {2, -1}},
			dirList = {WEST, EAST},
			bidirectional = true,
		},
		{ -- East-west south
			positionList = {{-2, 1}, {2, 1}},
			dirList = {WEST, EAST},
			bidirectional = true,
		},
	},
}
local arcFurnaceFluidBoxes = {}
for productionType, fluidSets in pairs(fluidIOGroup) do
	for _, fluidSet in pairs(fluidSets) do
		local fluidBox = makePassthroughFluidLine(productionType, fluidSet.positionList, fluidSet.dirList, fluidSet.bidirectional)
		table.insert(arcFurnaceFluidBoxes, fluidBox)
	end
end
ent.fluid_boxes = arcFurnaceFluidBoxes
ent.working_sound = {
	sound = {
		filename = "__base__/sound/electric-furnace.ogg",
		--variations = sound_variations("__space-age__/sound/entity/platform-thruster/thruster-engine", 3, 0.8),
		--variations = sound_variations("__base__/sound/centrifuge", 3, 0.15),
		volume = 0.8,
		audible_distance_modifier = 0.7,
	},
	fade_in_ticks = 4,
	fade_out_ticks = 20,
	-- Considered sound accents, but decided against, bc animation doesn't really do anything that seems like it would be enhanced by sound accents.
	--[[
	sound_accents = {
		--{sound = {variations = sound_variations("__space-age__/sound/entity/platform-thruster/thruster-engine-deactivate", 3, 0.8), audible_distance_modifier = 0.7}, frame = 40},
		{sound = {variations = sound_variations("__space-age__/sound/entity/platform-thruster/thruster-engine", 3, 0.8), audible_distance_modifier = 0.7}, frame = 15},
	},
	]]
	max_sounds_per_prototype = 2,
}
-- Dying explosion is fine. No better corpse.
ent.circuit_connector = copy(ASSEMBLER["oil-refinery"].circuit_connector)
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
	enabled = false,
	category = "crafting",
}
Tech.addRecipeToTech("arc-furnace", "foundry", 1)


-- TODO add better fluidboxes to the arc furnace. Preferably passthrough, so you can run multiple arc furnaces from lava.