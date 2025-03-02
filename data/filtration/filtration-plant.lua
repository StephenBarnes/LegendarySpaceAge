--[[ This file creates the filtration plant (modeled as a furnace entity) with its item, recipe, etc.
Initially this mod just used the chemical plant or assemblers for filtration, with recipes like this:
	clean filter + lake water -> clean water + spent filter + other crap.
	spent filter + bit of clean water -> clean filter.
But those recipes interact poorly with quality. If you have a high-quality filter item you can produce unlimited quality products. Which is unrealistic and overpowered.
Could just make those recipes not output spent filters, so you can't reuse them. That reduces the quality problem (since you can't use a quality filter multiple times), but doesn't completely eliminate it, since quality filters still let you get quality stuff. It also makes the whole system a lot simpler. Having filter washing and reuse is a bit complicated because you have to eg avoid using all your water on other things leaving none for the filter washing.
Plus, I ended up adding filtration as an important recipe to 4 of the 5 planets (not Vulcanus) so a separate building for it will see a lot of use.
]]

---@type data.FurnacePrototype
---@diagnostic disable-next-line: assign-type-mismatch
local ent = copy(ASSEMBLER["chemical-plant"])
ent.type = "furnace"
ent.name = "filtration-plant"
Icon.set(ent, "LSA/filtration/filtration-plant/icon")
ent.minable = {mining_time = 1, result = "filtration-plant"}
ent.crafting_categories = {"filtration"}
ent.crafting_speed = 1
ent.heating_energy = "200kW"
ent.emissions_per_second = nil
ent.energy_source.emissions_per_minute = nil
ent.max_health = 1000
ent.perceived_performance = {maximum = 1.5}
ent.fast_replaceable_group = nil
ent.energy_usage = "200kW" -- Filter is 1MJ, so 5 seconds per filter.
ent.energy_source = {
	type = "burner",
	fuel_categories = {"filter"},
	burner_usage = "filtration",
	effectivity = 1,
	burnt_inventory_size = 2,
	fuel_inventory_size = 2,
	light_flicker = { -- Setting to nil defaults to a white flicker, so we have to do this.
		minimum_intensity = 0,
		maximum_intensity = 0,
		derivation_change_frequency = 0,
		derivation_change_deviation = 0.,
		border_fix_speed = 0,
		minimum_light_size = 0,
		light_intensity_to_size_coefficient = 0.0,
		color = {0, 0, 0, 1}
	},
}
ent.selection_box = {{-3, -3}, {3, 3}}
ent.collision_box = {{-2.95, -2.95}, {2.95, 2.95}}
ent.tile_height = 6
ent.tile_width = 6
ent.source_inventory_size = 0
ent.result_inventory_size = 17
ent.dying_explosion = "agricultural-tower-explosion"
ent.corpse = "biochamber-remnants"
-- Circuit connector looks fine.
local pipeCovers = pipecoverspictures()
ent.fluid_boxes = {
	{
		production_type = "input",
		pipe_covers = pipeCovers,
		volume = 2000,
        pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
        pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
		secondary_draw_order = -1,
		pipe_connections = {
			{
				flow_direction = "input",
				direction = defines.direction.north,
				positions = {
					{-0.5, -2.5},
					{2.5, 0.5},
					{-0.5, 2.5},
					{-2.5, 0.5},
				},
			},
		},
	},
	{
		production_type = "output",
		pipe_covers = pipeCovers,
		volume = 2000,
		pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
		pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
		secondary_draw_order = -1,
		pipe_connections = {
			{
				flow_direction = "output",
				direction = defines.direction.south,
				positions = {
					{-0.5, 2.5},
					{-2.5, 0.5},
					{-0.5, -2.5},
					{2.5, 0.5},
				},
			},
		},
	},
}
local graphicsShift = {0, -0.25}
ent.graphics_set = {
	animation = {
		layers = {
			{
				filename = "__LegendarySpaceAge__/graphics/filtration/filtration-plant/shadow.png",
				width = 800,
				height = 600,
				frame_count = 1,
				repeat_count = 30,
				animation_speed = 0.5,
				draw_as_shadow = true,
				scale = 0.5,
				shift = graphicsShift,
			},
			{
				width = 400,
				height = 400,
				frame_count = 30,
				line_length = 4,
				animation_speed = 0.5,
				scale = 0.5,
				filename = "__LegendarySpaceAge__/graphics/filtration/filtration-plant/animation.png",
				shift = graphicsShift,
			},
		},
	},
	working_visualisations = {
		{ -- Light overlay.
			apply_recipe_tint = "primary",
			fadeout = true,
			animation = {
				width = 200,
				height = 200,
				frame_count = 30,
				line_length = 4,
				animation_speed = 0.5,
				scale = 1,
				draw_as_glow = true,
				blend_mode = "additive",
				filename = "__LegendarySpaceAge__/graphics/filtration/filtration-plant/light.png",
				shift = graphicsShift,
			},
		},
		{ -- Fluid overlay.
			apply_recipe_tint = "primary",
			fadeout = true,
			animation = {
				width = 400,
				height = 400,
				frame_count = 30,
				line_length = 4,
				animation_speed = 0.5,
				scale = 0.5,
				blend_mode = "normal",
				draw_as_glow = true,
				filename = "__LegendarySpaceAge__/graphics/filtration/filtration-plant/fluid-overlay.png",
				shift = graphicsShift,
			},
		},
	},
	reset_animation_when_frozen = true,
}
ent.working_sound = {
	main_sounds = {
		{
			sound = {
				filename = "__base__/sound/chemical-plant.ogg",
				volume = 0.25,
				audible_distance_modifier = 0.4,
			},
			fade_in_ticks = 4,
			fade_out_ticks = 20,
		},
	},
	sound_accents = {
		-- There's 30 frames, water fills up around frame 14, gone around framo 22.
		{
			sound = {
				--filename = "__space-age__/sound/entity/cryogenic-plant/cp-anim3-bubbles-rise.ogg",
				variations = sound_variations("__space-age__/sound/entity/foundry/foundry-fire-whoosh", 2, 0.8),
				audible_distance_modifier = 0.7,
			},
			frame = 4,
		},
		{
			sound = {
				filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-grappler-extend-stop.ogg",
				audible_distance_modifier = 1.5,
			},
			frame = 19,
		},
	},
}
extend{ent}

-- Create "burner usage" for filter.
extend{
	{
		type = "burner-usage",
		name = "filtration",
		empty_slot_sprite = {
			filename = "__core__/graphics/icons/mip/recipe-arrow.png",
			size = 32,
			mipmap_count = 2,
			flags = {"gui-icon"},
		},
		empty_slot_caption = {"gui.filtration"},
		empty_slot_description = {"gui.filtration-description"},
		icon = {
			filename = "__core__/graphics/icons/alerts/pipeline-disabled-icon.png",
			width = 64,
			height = 64,
			flags = {"icon"}
		},
		no_fuel_status = {"entity-status.no-filters"},
		accepted_fuel_key = "description.accepted-filters",
		burned_in_key = "filter-used-by", -- factoriopedia
	},
}

-- Create item.
local item = copy(ITEM["chemical-plant"])
item.name = "filtration-plant"
item.place_result = "filtration-plant"
Icon.set(item, "LSA/filtration/filtration-plant/icon")
extend{item}

-- Create recipe.
Recipe.make{
	copy = "chemical-plant",
	recipe = "filtration-plant",
	resultCount = 1,
	clearIcons = true,
	-- Will set ingredients in infra file.
}