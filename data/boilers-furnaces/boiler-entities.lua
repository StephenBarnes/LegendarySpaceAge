--[[ This file creates assembling-machine versions of boilers.

We change boilers to have type assembling-machine, so that we can do arbitrary recipes in them - boiling raw water, or pure water, and using air or pure oxygen, and outputting flue gas / CO2.
	The actual "boiler" type is sorta pointless? Seems to be a holdover from back when steam wasn't a separate fluid, just water with a different temperature. The BoilerPrototype still has an option for BoilerPrototype.mode = "heat-fluid-inside" which is no longer used in vanilla and I haven't seen it used in any mods.
Note boilers are kinda just like furnaces, or the electric heater - they use combustion or electricity to heat things up. So we could actually remove them entirely and just use furnaces.
	But I think I'll rather keep them in the game, and use them specifically for recipes that heat up fluids. Because we already have the graphics etc, and it looks a bit nicer to have boilers as a separate thing.

This mod has a dependency on Electric Boiler.

NOTE the order of fluid_boxes defined in this file must match up with the table in const/boiler-const.lua.
]]

local fluidBoxes = require("const.boiler-const-data").fluidBoxes

-- Function to convert graphics of boilers into assembling-machine graphics.
---@param boilerPictures data.BoilerPictureSet
---@return data.CraftingMachineGraphicsSet
local function convertBoilerGraphics(boilerPictures)
	---@type data.Animation4Way
	local animation = {
		north = {
			frame_count = 1,
			layers = boilerPictures.north.structure.layers,
		},
		south = {
			frame_count = 1,
			layers = boilerPictures.south.structure.layers,
		},
		east = {
			frame_count = 1,
			layers = boilerPictures.east.structure.layers,
		},
		west = {
			frame_count = 1,
			layers = boilerPictures.west.structure.layers,
		},
	}
	---@type data.WorkingVisualisations
	local workingVisualisations = {
		{
			north_animation = boilerPictures.north.fire,
			south_animation = boilerPictures.south.fire,
			east_animation = boilerPictures.east.fire,
			west_animation = boilerPictures.west.fire,
		},
		{
			north_animation = boilerPictures.north.fire_glow,
			south_animation = boilerPictures.south.fire_glow,
			east_animation = boilerPictures.east.fire_glow,
			west_animation = boilerPictures.west.fire_glow,
		},
	}
	return {animation = animation, working_visualisations = workingVisualisations}
end

-- Create the heat-shuttle boiler: 3x2, with the same graphics as the base-game's heat-shuttle boiler.
local baseBoiler = RAW.boiler.boiler
local baseHeatExchanger = RAW.boiler["heat-exchanger"]
---@type data.AssemblingMachinePrototype
---@diagnostic disable-next-line: assign-type-mismatch
local shuttleBoiler = copy(baseBoiler)
shuttleBoiler.name = "shuttle-boiler"
shuttleBoiler.localised_name = nil
shuttleBoiler.type = "assembling-machine"
shuttleBoiler.crafting_categories = {"non-burner-boiling"}
shuttleBoiler.crafting_speed = 1
shuttleBoiler.fast_replaceable_group = "boiler"
shuttleBoiler.energy_source = {
	type = "burner",
	emissions_per_minute = {pollution = 0},
	burner_usage = "heat-provider",
	fuel_inventory_size = 2,
	burnt_inventory_size = 2,
	smoke = nil,
	fuel_categories = {"heat-provider"},
	light_flicker = FURNACE["stone-furnace"].energy_source.light_flicker, -- No flicker.
	initial_fuel = nil,
	initial_fuel_percent = 0.1, -- Must be greater than 0.
}
shuttleBoiler.energy_usage = "2MW"
shuttleBoiler.heating_energy = nil
---@diagnostic disable-next-line: assign-type-mismatch
shuttleBoiler.graphics_set = convertBoilerGraphics(baseBoiler.pictures)
shuttleBoiler.icon = baseHeatExchanger.icon
shuttleBoiler.icons = baseHeatExchanger.icons
shuttleBoiler.placeable_by = {item = "shuttle-boiler", count = 1}
shuttleBoiler.minable.result = "shuttle-boiler"
shuttleBoiler.surface_conditions = nil
shuttleBoiler.factoriopedia_description = {"factoriopedia-description.shuttle-boiler"}
shuttleBoiler.fluid_boxes = {
	fluidBoxes.x3x2.input.water,
	fluidBoxes.x3x2.output.steam,
	fluidBoxes.x3x2.output.brine,
}
shuttleBoiler.fluid_boxes_off_when_no_fluid_recipe = false
shuttleBoiler.allowed_effects = {"speed", "pollution"}
shuttleBoiler.module_slots = 0
shuttleBoiler.allowed_module_categories = {"speed"}
-- Could allow circuit connections only for electric boiler, but not for the other 2 boilers since they're more analogue?
-- Or just allow it for all of them, since they're allowed for stone furnaces and I don't see a need to buff electric boilers.
shuttleBoiler.circuit_wire_max_distance = 9
shuttleBoiler.circuit_connector = circuit_connector_definitions.create_vector(universal_connector_template, {
	{ variation =  0, main_offset = util.by_pixel(-10.875,  0.5), shadow_offset = util.by_pixel(-10.875,  0.5), show_shadow = true },
	{ variation =  0, main_offset = util.by_pixel( 2.25,  7.625), shadow_offset = util.by_pixel( 2.25,  7.625), show_shadow = true },
	{ variation =  0, main_offset = util.by_pixel(-19.5, -4.75), shadow_offset = util.by_pixel(-19.5, -4.75), show_shadow = true },
	{ variation =  0, main_offset = util.by_pixel( 11.75,  16.5), shadow_offset = util.by_pixel( 11.75,  16.5), show_shadow = true }, 
})
Entity.unhide(shuttleBoiler)
extend{shuttleBoiler}
-- Create item for shuttle boiler.
local shuttleBoilerItem = copy(ITEM.boiler)
shuttleBoilerItem.name = "shuttle-boiler"
shuttleBoilerItem.localised_name = nil
shuttleBoilerItem.localised_description = nil
shuttleBoilerItem.place_result = "shuttle-boiler"
local baseHeatExchangerItem = copy(ITEM["heat-exchanger"])
shuttleBoilerItem.icon = baseHeatExchangerItem.icon
shuttleBoilerItem.icons = baseHeatExchangerItem.icons
extend{shuttleBoilerItem}
-- Create recipe for shuttle boiler.
Recipe.make{
	copy = "boiler",
	recipe = "shuttle-boiler",
	resultCount = 1,
	time = 5,
	ingredients = {
		{"structure", 1},
		{"fluid-fitting", 10},
		{"shielding", 1},
	},
	category = "crafting",
}

-- Create electric boiler (3x2, using graphics from Space Exploration).
local electricBoiler = copy(shuttleBoiler)
electricBoiler.name = "electric-boiler"
electricBoiler.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = {pollution = 0},
	drain = "0W",
}
electricBoiler.placeable_by = {item = "electric-boiler", count = 1}
electricBoiler.minable.result = "electric-boiler"
electricBoiler.factoriopedia_description = {"factoriopedia-description.electric-boiler"}
electricBoiler.fluid_boxes = {
	fluidBoxes.x3x2.input.water,
	fluidBoxes.x3x2.output.steam,
	fluidBoxes.x3x2.output.brine,
}
Icon.set(electricBoiler, "SE/electric-boiler")
electricBoiler.allowed_effects = {"speed", "pollution"}
electricBoiler.module_slots = 0
electricBoiler.allowed_module_categories = {"speed"}
-- Set graphics of electric boiler - code from Space Exploration. (Technically that mod is under a no-derivatives license, but the mod creator put the graphics files in a separate mod specifically so other mods could use them. And there's no way to use them without putting the graphics on the entity using code functionally equivalent to SE. So I'll assume it's fine.)
electricBoiler.graphics_set = {
	animation = {
		north = {
			layers = {
				{
					filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-n.png",
					width = 268,
					height = 220,
					priority = "extra-high",
					shift = util.by_pixel(-1.25, 5.25),
					scale = 0.5,
				},
				{
					filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-n-shadow.png",
					width = 274,
					height = 164,
					priority = "extra-high",
					shift = util.by_pixel(20.5, 9),
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
		south = {
			layers = {
				{
					filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-s.png",
					width = 260,
					height = 200,
					priority = "extra-high",
					shift = util.by_pixel(4, 10.75),
					scale = 0.5,
				},
				{
					filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-s-shadow.png",
					width = 310,
					height = 130,
					priority = "extra-high",
					shift = util.by_pixel(29.75, 15.75),
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
		east = {
			layers = {
				{
					filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-e.png",
					width = 210,
					height = 300,
					priority = "extra-high",
					shift = util.by_pixel(-1.75, 1.25),
					scale = 0.5,
				},
				{
					filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-e-shadow.png",
					width = 184,
					height = 194,
					priority = "extra-high",
					shift = util.by_pixel(30, 9.5),
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
		west = {
			layers = {
				{
					filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-w.png",
					width = 196,
					height = 272,
					priority = "extra-high",
					shift = util.by_pixel(1.5, 7.75),
					scale = 0.5,
				},
				{
					filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-w-shadow.png",
					width = 206,
					height = 218,
					priority = "extra-high",
					shift = util.by_pixel(19.5, 6.5),
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
	},
	working_visualisations = {
		{
			north_animation = {
				layers = {
					{
						filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-n-light.png",
						priority = "extra-high",
						width = 268,
						height = 220,
						shift = util.by_pixel(-1.25, 5.25),
						blend_mode = "additive",
						--draw_as_light = true, -- This makes it vanish when player flashlight is on it, so don't do this.
						draw_as_glow = true,
						scale = 0.5,
					},
				},
			},
			south_animation = {
				layers = {
					{
						filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-s-light.png",
						priority = "extra-high",
						width = 260,
						height = 200,
						shift = util.by_pixel(4, 10.75),
						blend_mode = "additive",
						draw_as_glow = true,
						scale = 0.5,
					},
				},
			},
			east_animation = {
				layers = {
					{
						filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-e-light.png",
						priority = "extra-high",
						width = 210,
						height = 300,
						shift = util.by_pixel(-1.75, 1.25),
						blend_mode = "additive",
						draw_as_glow = true,
						scale = 0.5,
					},
				},
			},
			west_animation = {
				layers = {
					{
						filename = "__space-exploration-graphics-3__/graphics/entity/electric-boiler/electric-boiler-w-light.png",
						priority = "extra-high",
						width = 196,
						height = 272,
						shift = util.by_pixel(1.5, 7.75),
						blend_mode = "additive",
						draw_as_glow = true,
						scale = 0.5,
					},
				},
			},
		},
		-- Rather no uranium-glow effect, since we already have the light layer above.
	},
}
extend{electricBoiler}
-- Create item for electric boiler.
local electricBoilerItem = copy(shuttleBoilerItem)
electricBoilerItem.name = "electric-boiler"
electricBoilerItem.place_result = "electric-boiler"
Icon.set(electricBoilerItem, "SE/electric-boiler")
extend{electricBoilerItem}
-- Create recipe for electric boiler.
Recipe.make{
	copy = "shuttle-boiler",
	recipe = "electric-boiler",
	resultCount = 1,
	time = 5,
	ingredients = {
		{"structure", 1},
		{"fluid-fitting", 10},
		{"shielding", 1},
		{"electronic-components", 20},
	},
}

-- Create 5x3 burner boiler, using graphics from Space Exploration's fluid-burner-generator.
-- I'm making it bigger and using SE's graphics, because we need to fit in like 3 fluid outputs (steam, flue, and brine) and 2 inputs (air/oxygen and water), and ideally the water and flue would be passthrough, so we need like 7 fluid connections, which can't fit on the 3x2 boiler (only has space for 6 without overlaps).
local burnerBoiler = copy(shuttleBoiler)
burnerBoiler.name = "burner-boiler"
burnerBoiler.crafting_categories = {"burner-boiling"}
burnerBoiler.energy_source = {
	type = "burner",
	emissions_per_minute = {},
	burner_usage = "fuel",
	fuel_inventory_size = 2,
	burnt_inventory_size = 2,
	smoke = nil,
	fuel_categories = {"chemical"},
	light_flicker = FURNACE["stone-furnace"].energy_source.light_flicker,
}
burnerBoiler.minable.result = "burner-boiler"
burnerBoiler.placeable_by = {item = "burner-boiler", count = 1}
burnerBoiler.factoriopedia_description = {"factoriopedia-description.burner-boiler"}
burnerBoiler.fluid_boxes = {
	fluidBoxes.x5x3.input.water,
	fluidBoxes.x5x3.input.air,
	--fluidBoxes.x5x3.input.airLinked, -- No air link, since this is the version for planets without ambient air.

	fluidBoxes.x5x3.output.steam,
	fluidBoxes.x5x3.output.flue,
	fluidBoxes.x5x3.output.brine,
}
burnerBoiler.fast_replaceable_group = nil
Icon.set(burnerBoiler, "SE/fluid-burner-generator")
burnerBoiler.allowed_effects = {"speed", "pollution"}
burnerBoiler.module_slots = 0
burnerBoiler.allowed_module_categories = {"speed"}
burnerBoiler.collision_box = {{-1.35, -2.35}, {1.35, 2.35}}
burnerBoiler.selection_box = {{-1.5, -2.5}, {1.5, 2.5}}
-- Sounds - copying from SE
burnerBoiler.working_sound = {
	sound = {
		filename = "__base__/sound/steam-engine-90bpm.ogg",
		volume = 0.6,
		audible_distance_modifier = 0.5,
	},
	match_speed_to_activity = false,
	fade_in_ticks = 15,
	fade_out_ticks = 30,
}
-- Set graphics of burner boiler - using Space Exploration's graphics. Except I'm using only 1 frame for when it's inactive, and 1 different frame for when it's inactive, with fadeout.
local verticalOff = {layers = {
	{
		filename = "__space-exploration-graphics-3__/graphics/entity/fluid-burner-generator/fluid-burner-generator-v.png",
		width = 216,
		height = 346,
		frame_count = 1,
		shift = util.by_pixel(5, 6.5),
		animation_speed = 1,
		scale = 0.5,
	},
	{
		filename = "__space-exploration-graphics-3__/graphics/entity/fluid-burner-generator/fluid-burner-generator-v-shadow.png",
		width = 256,
		height = 260,
		frame_count = 1,
		draw_as_shadow = true,
		shift = util.by_pixel(9.5, 14.5),
		animation_speed = 1,
		scale = 0.5,
	},
}}
local horizontalOff = {layers = {
	{
		filename = "__space-exploration-graphics-3__/graphics/entity/fluid-burner-generator/fluid-burner-generator-h.png",
		width = 320,
		height = 244,
		frame_count = 1,
		shift = util.by_pixel(0, -2.75),
		animation_speed = 1,
		scale = 0.5,
	},
	{
		filename = "__space-exploration-graphics-3__/graphics/entity/fluid-burner-generator/fluid-burner-generator-h-shadow.png",
		width = 434,
		height = 150,
		frame_count = 1,
		draw_as_shadow = true,
		shift = util.by_pixel(28.5, 18),
		animation_speed = 1,
		scale = 0.5,
	},
}}
local verticalLit = {layers = {
	{
		filename = "__space-exploration-graphics-3__/graphics/entity/fluid-burner-generator/fluid-burner-generator-v.png",
		width = 216,
		height = 346,
		frame_count = 1,
		shift = util.by_pixel(5, 6.5),
		animation_speed = 1,
		scale = 0.5,
		y = 346,
		x = 0,
	},
}}
local horizontalLit = {layers = {
	{
		filename = "__space-exploration-graphics-3__/graphics/entity/fluid-burner-generator/fluid-burner-generator-h.png",
		width = 320,
		height = 244,
		frame_count = 1,
		shift = util.by_pixel(0, -2.75),
		animation_speed = 1,
		scale = 0.5,
		y = 244,
		x = 0,
	},
}}
burnerBoiler.graphics_set = {
	animation = {
		north = verticalOff,
		south = verticalOff,
		east = horizontalOff,
		west = horizontalOff,
	},
	working_visualisations = {
		{
			fadeout = true,
			north_animation = verticalLit,
			south_animation = verticalLit,
			east_animation = horizontalLit,
			west_animation = horizontalLit,
		},
		{
			effect = "flicker",
			light = {intensity = 0.7, size = 8, shift = {0, -0.55}, color = {r = 1, g = 0.9, b = 0.5}, flicker_min_modifier = 2},
			fadeout = true,
		},
	},
}
burnerBoiler.circuit_wire_max_distance = 9
burnerBoiler.circuit_connector = circuit_connector_definitions.create_vector(universal_connector_template, {
	{ variation = 12, main_offset = util.by_pixel( 29.375, 0), shadow_offset = util.by_pixel( 29.375, 0), show_shadow = true },
	{ variation =  0, main_offset = util.by_pixel( 24.75,  2.25), shadow_offset = util.by_pixel( 24.75,  2.25), show_shadow = true },
	{ variation = 12, main_offset = util.by_pixel( 29.375, 0), shadow_offset = util.by_pixel( 29.375, 0), show_shadow = true },
	{ variation =  0, main_offset = util.by_pixel( 24.75,  2.25), shadow_offset = util.by_pixel( 24.75,  2.25), show_shadow = true },
})
extend{burnerBoiler}
-- Create item for burner boiler.
local burnerBoilerItem = copy(shuttleBoilerItem)
burnerBoilerItem.name = "burner-boiler"
burnerBoilerItem.place_result = "burner-boiler"
Icon.set(burnerBoilerItem, "SE/fluid-burner-generator")
extend{burnerBoilerItem}
-- Create recipe for burner boiler.
Recipe.make{
	copy = "shuttle-boiler",
	recipe = "burner-boiler",
	resultCount = 1,
	time = 5,
	ingredients = {
		{"structure", 1},
		{"fluid-fitting", 20},
		{"shielding", 5},
	},
}

-- Hide the original boiler item, entity, and recipe.
Entity.hide(baseBoiler)
Item.hide("boiler")
Recipe.hide("boiler")