--[[ This file creates the "air separator", a building that produces gases appropriate to whatever planet it's built on.
The air separator can't be placed within some area of any other air separator.
	This is interesting bc it gives the player reason to scatter them throughout the factory, which means their buildable land for other uses now has a bunch of holes in it.
		Or they can build them apart from the rest of the factory, using a lot of space.
	This is implemented using exclusion-zones.lua, which is read by child-entity-const.lua to add exclusion zone entities to the table of required child entities, which is then read by child-entities.lua which actually creates the exclusion zones and deletes them when the air separator is destroyed.
There's a separate runtime script in control/set-recipe-on-build.lua which sets the recipe for the air separator according to the surface it was built on.
Graphics from Hurricane046 - https://mods.factorio.com/user/Hurricane046
]]

local ENT_SIZE = 3 -- Size of air separator in tiles, assumed square.
local ent = copy(ASSEMBLER["assembling-machine-3"])
ent.name = "air-separator"
ent.icon = "__LegendarySpaceAge__/graphics/air-separator/icon.png"
ent.minable = {mining_time = 1, result = "air-separator"}
ent.crafting_speed = 1
ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
ent.collision_box = {{-1.45, -1.45}, {1.45, 1.45}}
ent.tile_height = ENT_SIZE
ent.tile_width = ENT_SIZE
local FLUIDBOX_INDEX = {
	leftRightMiddle = 1,
	upDownMiddle = 2,
	leftRightTop = 3,
	leftRightBottom = 4,
}
local em = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures")
local emPipePictures = copy(em.pipe_pictures)
local emPipePictureFrozen = copy(em.pipe_pictures_frozen)
-- Remove shadow layers from pipe pictures, bc they look wrong on air separator.
for _, sprite in pairs(emPipePictures) do
	local newLayers = {}
	for _, layer in pairs(sprite.layers) do
		if layer.draw_as_shadow ~= true then
			table.insert(newLayers, layer)
		end
	end
	sprite.layers = newLayers
end
ent.fluid_boxes = {
	{ -- Left-right output in the middle.
		production_type = "output",
		pipe_picture = emPipePictures,
		pipe_picture_frozen = emPipePictureFrozen,
		pipe_covers = pipecoverspictures(),
		base_area = 10,
		base_level = 1,
		volume = 5000,
		pipe_connections = {
			{flow_direction = "input-output", position = {-1, 0}, direction = WEST},
			{flow_direction = "input-output", position = {1, 0}, direction = EAST},
		},
		secondary_draw_orders = {north = -1, east = -1, west = -1},
		hide_connection_info = false,
	},
	{ -- Up-down output in the middle.
		production_type = "output",
		pipe_picture = emPipePictures,
		pipe_picture_frozen = emPipePictureFrozen,
		pipe_covers = pipecoverspictures(),
		base_area = 10,
		base_level = 1,
		volume = 5000,
		pipe_connections = {
			{flow_direction = "input-output", position = {0, -1}, direction = NORTH},
			{flow_direction = "input-output", position = {0,  1}, direction = SOUTH},
		},
		secondary_draw_orders = {north = -1, east = -1, west = -1},
		hide_connection_info = false,
	},
	{ -- Left-right output on top.
		production_type = "output",
		pipe_picture = emPipePictures,
		pipe_picture_frozen = emPipePictureFrozen,
		pipe_covers = pipecoverspictures(),
		base_area = 10,
		base_level = 1,
		volume = 5000,
		pipe_connections = {
			{flow_direction = "input-output", position = {-1, -1}, direction = WEST},
			{flow_direction = "input-output", position = {1, -1}, direction = EAST},
		},
		secondary_draw_orders = {north = -1, east = -1, west = -1},
		hide_connection_info = false,
	},
	{ -- Left-right output on bottom.
		production_type = "output",
		pipe_picture = emPipePictures,
		pipe_picture_frozen = emPipePictureFrozen,
		pipe_covers = pipecoverspictures(),
		base_area = 10,
		base_level = 1,
		volume = 5000,
		pipe_connections = {
			{flow_direction = "input-output", position = {-1, 1}, direction = WEST},
			{flow_direction = "input-output", position = {1,  1}, direction = EAST},
		},
		secondary_draw_orders = {north = -1, east = -1, west = -1},
		hide_connection_info = false,
	},
}
ent.fluid_boxes_off_when_no_fluid_recipe = false
ent.ingredient_count = 1
ent.energy_source.emissions_per_minute = {
	pollution = -4,
	spores = -4, -- For comparison, yumako tree is 15/harvest, and grows for 5m, so about 3/min spores.
}
ent.crafting_categories = {"air-separation"}
ent.energy_usage = "200kW"
ent.energy_source.drain = "0W"
ent.heating_energy = "200kW"
ent.show_recipe_icon = false
ent.show_recipe_icon_on_map = false
local animationSpeed = 0.5
local shift = {0, -.5}
ent.graphics_set = {
	animation = {
		layers = {
			{
				filename = "__LegendarySpaceAge__/graphics/air-separator/shadow.png",
				width = 400,
				height = 350,
				frame_count = 1,
				repeat_count = 60,
				animation_speed = animationSpeed,
				draw_as_shadow = true,
				scale = 0.5,
				shift = shift,
			},
			{
				width = 210,
				height = 290,
				line_length = 8,
				frame_count = 60,
				animation_speed = animationSpeed,
				scale = 0.5,
				filename = "__LegendarySpaceAge__/graphics/air-separator/animation.png",
				shift = shift,
			},
		},
	},
	reset_animation_when_frozen = true,
}
ent.working_sound = copy(RAW.generator["steam-turbine"].working_sound)
ent.open_sound = ASSEMBLER.foundry.open_sound -- sounds.steam_open
ent.close_sound = ASSEMBLER.foundry.close_sound -- sounds.steam_close
ent.build_sound = nil -- just default.
ent.corpse = "biochamber-remnants"
ent.dying_explosion = "steam-turbine-explosion"
ent.max_health = 200
ent.circuit_connector = copy(ASSEMBLER["cryogenic-plant"].circuit_connector)
ent.surface_conditions = {{property = "pressure", min = 10}} -- So it can't be built on space platforms.
extend{ent}

local item = copy(ITEM["assembling-machine-3"])
item.name = "air-separator"
item.icon = "__LegendarySpaceAge__/graphics/air-separator/icon.png"
item.place_result = "air-separator"
item.stack_size = 20
Item.perRocket(item, 40)
Item.copySoundsTo("steam-engine", item)
extend{item}

Recipe.make{
	copy = "assembling-machine-1",
	recipe = "air-separator",
	resultCount = 1,
	time = 5,
	ingredients = {
		{"frame", 10},
		{"mechanism", 5},
		{"fluid-fitting", 10},
		{"panel", 10},
	},
}

-- Create recipe category for air separator. Can only be performed in air separators. Recipe is auto-assigned by control script.
extend{{
	type = "recipe-category",
	name = "air-separation",
}}

-- Create air separation recipes for each planet.
-- I'm making every recipe take 20 seconds, and then adjusting how many filters they use, rather than changing the recipe time to control rate of filter use.
-- Note all these recipes produce no solid products except the spent filter, so I think it's the one case where having filters as ingredients (rather than fuel) makes sense, since it doesn't create quality exploits.
for i, planetData in pairs{
	{"nauvis", {
		results = {
			{"nitrogen-gas", 200, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightMiddle},
			{"oxygen-gas", 50, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.upDownMiddle},
		},
		filtersPer50s = 1,
	}},
	{"vulcanus", {
		results = {
			{"volcanic-gas", 100, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.upDownMiddle},
			{"oxygen-gas", 10, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightTop},
			{"steam", 10, type = "fluid", temperature = 100, fluidbox_index = FLUIDBOX_INDEX.leftRightBottom},
		},
		filtersPer50s = 2,
		-- Every 100 volcanic gas is 1 carbon (before prod), so this uses 2 filters (<=2*0.5 carbon) to make ~1 carbon, so net even with carbon. But you can use prod modules to get net profit.
		-- Player needs some way to get nitrogen, so added that to volcanic gas separation outputs.
	}},
	{"gleba", {
		results = {
			{"nitrogen-gas", 100, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightTop},
			{"oxygen-gas", 100, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightBottom},
			{"spore-gas", 20, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.upDownMiddle},
		},
		filtersPer50s = 2,
	}},
	{"fulgora", {
		results = {
			{"nitrogen-gas", 200, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightMiddle},
			{"dry-gas", 50, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.upDownMiddle},
		},
		filtersPer50s = 5, -- Lots of filters, partly bc I want to incentivize throwing away the spent filters instead of cleaning them.
	}},
	{"aquilo", {
		results = {
			{"nitrogen-gas", 200, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.upDownMiddle},
			{"dry-gas", 20, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightTop},
			{"ammonia", 20, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightBottom},
		},
		filtersPer50s = 1,
	}},
} do
	local planetName = planetData[1]

	local filtersPer50s = planetData[2].filtersPer50s
	assert(filtersPer50s ~= nil, "No filtersPer50s specified for planet "..planetName)
	local results = planetData[2].results
	table.insert(results, {"spent-filter", filtersPer50s, ignored_by_productivity = filtersPer50s})

	Recipe.make{
		copy = "air-separator",
		recipe = "air-separation-"..planetName,
		ingredients = {{"filter", filtersPer50s}},
		results = results,
		time = 50,
		localised_name = {"recipe-name.air-separation-planet", {"space-location-name."..planetName}},
		localised_description = {"recipe-description.air-separation-planet", {"space-location-name."..planetName}},
		category = "air-separation",
		allow_productivity = true,
		allow_quality = false,
		hide_from_player_crafting = true,
		show_amount_in_title = false,
		icons = {"air-separator", "planet/"..planetName},
		iconArrangement = "planetFixed",
	}
end

-- Create tech for the air separator recipe.
local tech = copy(TECH["electric-mining-drill"])
tech.name = "air-separation"
tech.effects = {
	{type = "unlock-recipe", recipe = "air-separator"},
	{type = "unlock-recipe", recipe = "air-separation-nauvis"},
}
tech.prerequisites = {"fluid-handling"}
Icon.set(tech, "LSA/air-separator/tech")
tech.unit = {
	count = 100,
	time = 15,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
	},
}
extend{tech}

-- Add air separation recipe to each planet tech.
for _, planet in pairs{"vulcanus", "gleba", "fulgora", "aquilo"} do
	Tech.addRecipeToTech("air-separation-"..planet, "planet-discovery-"..planet)
end

-- Create ents etc. for exclusion zones.
ExclusionZones.create(ASSEMBLER["air-separator"])

-- Could add productivity techs for air separation, but I'm not sure prod techs in general are a good idea.