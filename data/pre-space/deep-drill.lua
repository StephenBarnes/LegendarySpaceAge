--[[ This file creates the "deep borehole drill", a massive drill that can be built on any terrain (not on ores like regular drills).
It yields different resources depending on the planet - on Gleba it gives chitin (for making machine parts etc without metal), on Vulcanus it gives hydrocarbons, on Fulgora it gives sth, haven't decided. This is done by replacing it on build with a different entity for those planets.
Can't be built on Aquilo or space platforms.
There's a separate runtime script in control/deep-drill-recipe.lua that sets the recipe for the deep drill according to the surface it was built on.
Graphics from Hurricane046 - https://mods.factorio.com/user/Hurricane046
Some code taken from Finely Crafted Machine by plexpt - mods.factorio.com/mod/finely-crafted - This is code for using Hurricane's graphics above.
]]

local ent = copy(ASSEMBLER["assembling-machine-3"])
ent.name = "deep-drill"
ent.icon = "__LegendarySpaceAge__/graphics/deep-drill/item.png"
ent.minable = {mining_time = 1, result = "deep-drill"}
ent.crafting_speed = 1
ent.selection_box = {{-5.5, -5.5}, {5.5, 5.5}}
ent.collision_box = {{-5.45, -5.45}, {5.45, 5.45}}
ent.tile_height = 11
ent.tile_width = 11
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
item.icon = "__LegendarySpaceAge__/graphics/deep-drill/item.png"
item.place_result = "deep-drill"
item.stack_size = 10
item.weight = 1e7 -- Too heavy for rocket.
item.order = "a[items]-d"
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

-- Create deep drill recipe for Nauvis: no ingredients => 10 stone
local nauvisDrillingRecipe = copy(RECIPE["deep-drill"])
nauvisDrillingRecipe.name = "deep-drill-nauvis"
nauvisDrillingRecipe.ingredients = {}
nauvisDrillingRecipe.results = {
	{type = "item", name = "stone", amount = 10},
	{type = "fluid", name = "lake-water", amount = 10},
		-- TODO rename this to "groundwater" or sth, maybe allow filtering it for water and stone or sth.
}
nauvisDrillingRecipe.category = "deep-drill"
--nauvisDrillingRecipe.hidden = true
--nauvisDrillingRecipe.hidden_in_factoriopedia = true
nauvisDrillingRecipe.hide_from_player_crafting = true
nauvisDrillingRecipe.subgroup = "deep-drilling"
nauvisDrillingRecipe.order = "1"
nauvisDrillingRecipe.energy_required = 1
nauvisDrillingRecipe.localised_name = {"recipe-name.deep-drill-planet", {"space-location-name.nauvis"}}
nauvisDrillingRecipe.localised_description = {"recipe-description.deep-drill-planet", {"space-location-name.nauvis"}}
nauvisDrillingRecipe.icon = nil
nauvisDrillingRecipe.show_amount_in_title = false
nauvisDrillingRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/deep-drill/item.png"},
	{icon = "__base__/graphics/icons/nauvis.png", scale = 0.2, shift={-8,-8}},
}
extend{nauvisDrillingRecipe}
-- Create drilling recipes for other planets
for i, planetData in pairs{
	{"vulcanus", {
		--{type = "fluid", name = "lava", amount = 5}, -- Could make it produce lava, but then you could put lava in pipes.
		{ type = "fluid", name = "tar",   amount = 5 },
		{ type = "item",  name = "stone", amount = 10 },
		{ type = "item",  name = "pitch", amount = 1 },
		{ type = "item",  name = "ash", amount = 2 },
		-- Drill consumes 10MJ for each recipe, which can be reduced to 2MJ with modules. Each pitch is 3MJ, each tar is 200kJ.
	}},
	{"gleba", {
		{ type = "fluid", name = "geoplasm",         amount = 10 },
		{ type = "item",  name = "chitin-fragments", amount = 5 },
		{ type = "item",  name = "marrow",           amount = 5 },
	}},
	{"fulgora", {
		{type = "item", name = "stone", amount = 7},
		{type = "item", name = "scrap", amount = 3},
		{type = "fluid", name = "fulgoran-sludge", amount = 10},
	}},
} do
	local planetName = planetData[1]
	local drillingRecipe = copy(nauvisDrillingRecipe)
	drillingRecipe.name = "deep-drill-"..planetName
	drillingRecipe.results = planetData[2]
	drillingRecipe.order = tostring(i+1)
	drillingRecipe.localised_name[2][1] = "space-location-name."..planetName
	drillingRecipe.localised_description[2][1] = "space-location-name."..planetName
	drillingRecipe.icons[2].icon = "__space-age__/graphics/icons/"..planetName..".png"
	extend{drillingRecipe}
end

-- Create a subgroup for the drilling recipes
extend{{
	type = "item-subgroup",
	name = "deep-drilling",
	group = "intermediate-products",
	order = "z",
}}

-- Create tech for the deep drill recipe.
local tech = copy(TECH["electric-mining-drill"])
tech.name = "deep-drill"
tech.effects = {
	{type = "unlock-recipe", recipe = "deep-drill"},
	{type = "unlock-recipe", recipe = "deep-drill-nauvis"},
	{type = "unlock-recipe", recipe = "deep-drill-vulcanus"},
	{type = "unlock-recipe", recipe = "deep-drill-gleba"},
	{type = "unlock-recipe", recipe = "deep-drill-fulgora"},
}
tech.prerequisites = {"electric-mining-drill", "electric-engine"}
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

-- Gleba needs deep drill. Technically it's possible without that, but won't be fully self-sustaining.
Tech.addTechDependency("deep-drill", "planet-discovery-gleba")

-- Make the mining productivity techs also affect deep drills.
for i = 1, 3 do
	local tech = TECH["mining-productivity-"..i]
	if tech then
		for _, planet in pairs{"nauvis", "gleba", "vulcanus", "fulgora"} do
			table.insert(tech.effects, {
				type = "change-recipe-productivity",
				recipe = "deep-drill-"..planet,
				change = 0.1,
			})
		end
	end
end