--[[ This file creates the "deep borehole drill", a massive drill that can be built on any terrain (not on ores like regular drills).
It yields different resources depending on the planet - on Gleba it gives chitin (for making machine parts etc without metal), on Vulcanus it gives hydrocarbons, on Fulgora it gives sth, haven't decided. This is done by replacing it on build with a different entity for those planets.
Can't be built on Aquilo or space platforms.
There's a separate runtime script in control/deep-drill-recipe.lua that sets the recipe for the deep drill according to the surface it was built on.
Graphics from Hurricane046 - https://mods.factorio.com/user/Hurricane046
Some code taken from Finely Crafted Machine by plexpt - mods.factorio.com/mod/finely-crafted - This is code for using Hurricane's graphics above.
]]

local ENT_SIZE = 11 -- Size of deep drill in tiles, assumed square.
local ent = copy(ASSEMBLER["assembling-machine-3"])
ent.name = "deep-drill"
ent.icon = "__LegendarySpaceAge__/graphics/deep-drill/icon.png"
ent.minable = {mining_time = 1, result = "deep-drill"}
ent.crafting_speed = 1
ent.selection_box = {{-5.5, -5.5}, {5.5, 5.5}}
ent.collision_box = {{-5.45, -5.45}, {5.45, 5.45}}
ent.tile_height = ENT_SIZE
ent.tile_width = ENT_SIZE
ent.fluid_boxes = {
	{
		production_type = "output",
		pipe_picture = GreyPipes.pipeBlocksDeepDrill(),
		pipe_covers = pipecoverspictures(),
		base_area = 10,
		base_level = 1,
		volume = 200,
		pipe_connections = {
			{flow_direction = "input-output", position = {0, -5}, direction = NORTH},
			{flow_direction = "input-output", position = {0,  5}, direction = SOUTH},
		},
		secondary_draw_orders = draworders,
		hide_connection_info = false,
	},
}
ent.fluid_boxes_off_when_no_fluid_recipe = false
ent.vector_to_place_result = {6, 5}
ent.ingredient_count = 0
ent.energy_source.emissions_per_minute = {
	pollution = 20,
	spores = 10, -- For comparison, yumako tree is 15/harvest, and grows for 5m, so about 3/min spores.
}
ent.ignore_output_full = false -- Stop mining when output reaches count 50.
ent.crafting_categories = {"deep-drill"}
ent.surface_conditions = {{property = "surface-stability", min = 80}}
ent.energy_usage = "4800kW" -- So it's 5MW with drain.
ent.energy_source.drain = "200kW"
ent.show_recipe_icon = false
ent.show_recipe_icon_on_map = false
local animationSpeed = 0.5
ent.graphics_set = {
	animation = {
		layers = {
			{
				filename = "__LegendarySpaceAge__/graphics/deep-drill/shadow.png",
				width = 1400,
				height = 1400,
				frame_count = 1,
				repeat_count = 60,
				animation_speed = animationSpeed,
				draw_as_shadow = true,
				scale = 0.5,
			},
			{
				width = 704,
				height = 704,
				frame_count = 60,
				animation_speed = animationSpeed,
				scale = 0.5,
				stripes = {
					{
						filename = "__LegendarySpaceAge__/graphics/deep-drill/animation-1.png",
						width_in_frames = 4,
						height_in_frames = 8,
					},
					{
						filename = "__LegendarySpaceAge__/graphics/deep-drill/animation-2.png",
						width_in_frames = 4,
						height_in_frames = 7,
					},
				},
			},
		},
	},
	working_visualisations = {
		{
			fadeout = true,
			animation = {
				width = 352,
				height = 352,
				--shift = util.by_pixel_hr(0, 92),
				frame_count = 60,
				animation_speed = animationSpeed,
				scale = 1,
				draw_as_light = true,
				blend_mode = "additive",
				stripes = {
					{
						filename = "__LegendarySpaceAge__/graphics/deep-drill/emission-1.png",
						width_in_frames = 4,
						height_in_frames = 8,
					},
					{
						filename = "__LegendarySpaceAge__/graphics/deep-drill/emission-2.png",
						width_in_frames = 4,
						height_in_frames = 7,
					},
				},
			},
		}
	},
	reset_animation_when_frozen = true,
}
ent.working_sound = {
	main_sounds = {
		{
			sound = {filename = "__space-age__/sound/entity/big-mining-drill/big-mining-drill-loop.ogg", volume = 0.45}, -- vs 0.3 for big drill
			audible_distance_modifier = 0.5,
			fade_in_ticks = 4,
			fade_out_ticks = 30
		},
		{
			sound = {filename = "__space-age__/sound/entity/big-mining-drill/big-mining-drill-moving-loop.ogg", volume = 0.45},
			audible_distance_modifier = 0.5,
			fade_in_ticks = 4,
			fade_out_ticks = 30
		},
	},
	sound_accents = {
		{ -- loud bang, timed to when drill hits bottom
			sound = {filename = "__space-age__/sound/entity/big-mining-drill/big-mining-drill-moving-stop.ogg", volume = 0.95, audible_distance_modifier = 0.9},
			frame = 10, -- 11 is too late, 9 too early.
		},
		{ -- puff of dirt sound, timed to when drill moves up
			sound = {filename = "__space-age__/sound/entity/big-mining-drill/big-mining-drill-start.ogg", volume = 0.75, audible_distance_modifier = 0.5},
			frame = 36, -- 40 is too late, 38 maybe too late
		},
	},
	--max_sounds_per_prototype = 3,
}
ent.build_sound = ASSEMBLER.foundry.build_sound
ent.open_sound = ASSEMBLER.foundry.open_sound
ent.close_sound = ASSEMBLER.foundry.close_sound
ent.corpse = "rocket-silo-remnants"
ent.dying_explosion = "rocket-silo-explosion"
ent.max_health = 1000
ent.circuit_connector = copy(RAW["rocket-silo"]["rocket-silo"].circuit_connector)
extend{ent}

local item = copy(ITEM["big-mining-drill"])
item.name = "deep-drill"
item.icon = "__LegendarySpaceAge__/graphics/deep-drill/icon.png"
item.place_result = "deep-drill"
item.stack_size = 10
item.weight = 1e7 -- Too heavy for rocket.
extend{item}

Recipe.make{
	copy = "electric-mining-drill",
	recipe = "deep-drill",
	resultCount = 1,
	time = 20,
	ingredients = {
		{"frame", 50},
		{"structure", 50},
		{"mechanism", 50},
		{"electric-engine-unit", 50},
	},
}

-- Create recipe category for deep drilling. Can only be performed in deep drills. Recipe is auto-assigned by control script.
extend{{
	type = "recipe-category",
	name = "deep-drill",
}}

-- Create drilling recipe for each planet.
for i, planetData in pairs{
	{"nauvis", {
		{"raw-seawater", 10, type = "fluid"}, -- TODO change this to rich brine.
		{"stone", 10},
	}},
	{"apollo", {
		{"sand", 5},
		{"stone", 5},
		-- TODO later maybe add titanium or regolith or sth.
	}},
	{"vulcanus", {
		{"tar", 5, type = "fluid"},
		{"stone", 10},
		{"pitch", 1},
		{"ash", 2},
		-- Drill consumes 10MJ for each recipe, which can be reduced to 2MJ with modules. Each pitch is 3MJ, each tar is 200kJ.
		-- Could make it produce lava, but then you could put lava in pipes.
	}},
	{"gleba", {
		{"geoplasm", 10, type = "fluid"},
		{"chitin-fragments", 5},
		{"marrow", 5},
	}},
	{"fulgora", {
		{"stone", 7},
		{"scrap", 3},
		{"fulgoran-sludge", 10, type = "fluid"},
	}},
} do
	local planetName = planetData[1]
	Recipe.make{
		copy = "deep-drill",
		recipe = "deep-drill-"..planetName,
		ingredients = {},
		results = planetData[2],
		localised_name = {"recipe-name.deep-drill-planet", {"space-location-name."..planetName}},
		localised_description = {"recipe-description.deep-drill-planet", {"space-location-name."..planetName}},
		icons = {"deep-drill", "planet/"..planetName},
		iconArrangement = "planetFixed",
		category = "deep-drill",
		allow_productivity = true,
		allow_quality = true,
		hide_from_player_crafting = true,
		show_amount_in_title = false,
		time = 1,
	}
end

-- Create tech for the deep drill recipe.
local tech = copy(TECH["electric-mining-drill"])
tech.name = "deep-drill"
tech.effects = {
	{type = "unlock-recipe", recipe = "deep-drill"},
	{type = "unlock-recipe", recipe = "deep-drill-nauvis"},
}
tech.prerequisites = {"electric-mining-drill", "electric-engine-2"}
Icon.set(tech, "LSA/deep-drill/tech")
tech.unit = {
	count = 100,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
	},
}
extend{tech}

-- Add drilling recipe to each planet tech.
for _, planet in pairs{"vulcanus", "gleba", "fulgora"} do
	Tech.addRecipeToTech("deep-drill-"..planet, "planet-discovery-"..planet)
end

-- Gleba needs deep drill. Technically it's possible without that, but won't be fully self-sustaining.
Tech.addTechDependency("deep-drill", "planet-discovery-gleba")

-- Make the mining productivity techs also affect deep drills.
for i = 1, 3 do
	local prodTech = TECH["mining-productivity-"..i]
	if prodTech then
		for _, planet in pairs{"nauvis", "gleba", "vulcanus", "fulgora", "apollo"} do
			table.insert(prodTech.effects, {
				type = "change-recipe-productivity",
				recipe = "deep-drill-"..planet,
				change = 0.1,
			})
		end
	end
end

-- Create exclusion zones.
ExclusionZones.create(ASSEMBLER["deep-drill"])