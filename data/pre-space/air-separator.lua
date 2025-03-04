--[[ This file creates the "air separator", a building that produces gases appropriate to whatever planet it's built on.
The air separator can't be placed within some area of any other air separator.
	This is interesting bc it gives the player reason to build lots of them everywhere, which means their buildable land for other uses now has a bunch of holes in it.
There's a separate runtime script in control/air-separator.lua which:
	* sets the recipe for the air separator according to the surface it was built on, similar to the borehole mining drill.
	* creates or destroys the "air-separator-exclusion" entities when air separators are built or destroyed, including blueprints.
Graphics from Hurricane046 - https://mods.factorio.com/user/Hurricane046

TODO:
	Create entity.
		Graphics.
		Sounds.
	Create exclusion zone entities.
	Create item.
	Create recipes.
	Control script:
		Create and destroy exclusion zone entities when air separators are built or destroyed.
		Set recipe according to surface, when air separator is built.
]]

local ALLOW_SELECT_EXCLUSIONS = false -- Whether to allow selection of the exclusion zones - for debugging.
local EXCLUSION_DIMS = {27, 21} -- Tested with both odd; I think they could be even too.
	-- Note that control/air-separator.lua computes distance from center of air separator to center of exclusion zone, using the 2nd number here (y) as y/2 + 1.5. Making the 2nd number smaller than the 1st number is best, so that it's more rounded rather than cross-shaped.

local ent = copy(ASSEMBLER["assembling-machine-3"])
ent.name = "air-separator"
ent.icon = "__LegendarySpaceAge__/graphics/air-separator/icon.png"
ent.minable = {mining_time = 1, result = "air-separator"}
ent.crafting_speed = 1
ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
ent.collision_box = {{-1.45, -1.45}, {1.45, 1.45}} -- TODO check.
log(serpent.block(RAW["utility-constants"]))
if ent.collision_mask == nil then
	ent.collision_mask = copy(RAW["utility-constants"].default.building_collision_mask)
end
ent.collision_mask.layers["air_separator_exclusion"] = true
ent.tile_height = 3
ent.tile_width = 3
local FLUIDBOX_INDEX = {
	leftRightMiddle = 1,
	upDownMiddle = 2,
	leftRightTop = 3,
	leftRightBottom = 4,
}
local emPipePicture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures
local emPipePictureFrozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen
ent.fluid_boxes = {
	{ -- Left-right output in the middle.
		production_type = "output",
		pipe_picture = emPipePicture,
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
		pipe_picture = emPipePicture,
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
		pipe_picture = emPipePicture,
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
		pipe_picture = emPipePicture,
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
ent.energy_usage = "200kW" -- So it's 5MW with drain.
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
ent.working_sound = nil -- TODO
ent.build_sound = ASSEMBLER.foundry.build_sound -- TODO
ent.open_sound = ASSEMBLER.foundry.open_sound -- TODO
ent.close_sound = ASSEMBLER.foundry.close_sound -- TODO
ent.corpse = "rocket-silo-remnants" -- TODO
ent.dying_explosion = "rocket-silo-explosion" -- TODO
ent.max_health = 200
ent.circuit_connector = copy(RAW["rocket-silo"]["rocket-silo"].circuit_connector) -- TODO
ent.surface_conditions = {{property = "pressure", min = 10}} -- So it can't be built on space platforms.
-- NOTE I was thinking maybe we could ONLY do tile_buildability_rules, instead of doing control-stage creation of exclusion zone entities. BUT the tile_buildability_rules are only checked against TILES, not entities. So they won't collide with other air separators.
-- NOTE Was also thinking about adding buildability rules just to highlight some tiles. Tried that but it doesn't really work, the squares only get shown when they're going to block building due to tile collisions, which never happens unless their collision layers are misconfigured, so never mind.
-- Instead, using Entity.radius_visualisation_specification to show the exclusion zone.
ent.radius_visualisation_specification = {
	sprite = {
		filename = "__LegendarySpaceAge__/graphics/air-separator/grid_27_21.png",
		priority = "extra-high-no-scale",
		width = 45,
		height = 45,
	},
	distance = EXCLUSION_DIMS[2] + 1.5,
}
extend{ent}

local item = copy(ITEM["assembling-machine-3"])
item.name = "air-separator"
item.icon = "__LegendarySpaceAge__/graphics/air-separator/icon.png"
item.place_result = "air-separator"
item.stack_size = 20
Item.perRocket(item, 40)
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

	local recipe = Recipe.make{
		copy = "air-separator",
		recipe = "air-separation-"..planetName,
		ingredients = {{"filter", filtersPer50s}},
		results = results,
		time = 50,
		order = tostring(i),
		localised_name = {"recipe-name.air-separation-planet", {"space-location-name."..planetName}},
		localised_description = {"recipe-description.air-separation-planet", {"space-location-name."..planetName}},
		category = "air-separation",
		allow_productivity = true,
		allow_quality = false,
		hide_from_player_crafting = true,
		subgroup = "air-separation",
		show_amount_in_title = false,
		icons = {"air-separator", "planet/"..planetName},
		iconArrangement = "planetFixed",
	}
end

-- Create a subgroup for the air separator recipes
extend{{
	type = "item-subgroup",
	name = "air-separation",
	group = "intermediate-products",
	order = "z",
}}

-- Create tech for the air separator recipe.
local tech = copy(TECH["electric-mining-drill"])
tech.name = "air-separation"
tech.effects = {
	{type = "unlock-recipe", recipe = "air-separator"},
	{type = "unlock-recipe", recipe = "air-separation-nauvis"},
}
tech.prerequisites = {"fluid-handling"}
Icon.set(tech, "LSA/air-separator/tech")
tech.unit = { -- TODO
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

-- Create a collision layer for the air separator exclusion zones.
extend{
	{
		type = "collision-layer",
		name = "air_separator_exclusion",
	},
}

-- Create simple-entities for the air separator exclusion zones. One is more horizontal, the other more vertical.
-- We place 4 of these around the air separator, one on each side. That way we leave a gap in the middle for the air separator to be built. This is necessary for ghosts to not get destroyed by their own exclusion zones.
local collisionBox = {{-EXCLUSION_DIMS[1]/2, -EXCLUSION_DIMS[2]/2}, {EXCLUSION_DIMS[1]/2, EXCLUSION_DIMS[2]/2}}
---@type data.SimpleEntityPrototype
local exclusion1 = {
	type = "simple-entity",
	name = "air-separator-exclusion-1",
	icons = {
		{
			icon = "__LegendarySpaceAge__/graphics/air-separator/icon.png",
			icon_size = 64,
			scale = 0.5,
		},
		{
			icon = "__LegendarySpaceAge__/graphics/misc/no.png",
			icon_size = 64,
			scale = 0.5,
			shift = {0, 0},
		},
	},
	selection_box = Gen.ifThenElse(ALLOW_SELECT_EXCLUSIONS, collisionBox, nil),
	collision_box = collisionBox,
	selection_priority = 1, -- So other stuff on top of it gets selected instead of this. Seems chests are 50, setting this to 0 makes it actually 50 in-game. So I'm guessing 0 doesn't work, but other than that higher number gets selected preferentially.
	selectable_in_game = ALLOW_SELECT_EXCLUSIONS,
	collision_mask = {layers={["air_separator_exclusion"] = true}},
	localised_name = {"entity-name.air-separator-exclusion"},
	localised_description = {"entity-description.air-separator-exclusion"},
	remove_decoratives = "false",
	flags = {"not-on-map", "not-repairable", "not-deconstructable", "not-flammable", "not-blueprintable", "placeable-neutral"},
	allow_copy_paste = false,
	hidden_in_factoriopedia = true,
}
local exclusion2 = copy(exclusion1)
exclusion2.name = "air-separator-exclusion-2"
local collisionBox2 = {{-EXCLUSION_DIMS[2]/2, -EXCLUSION_DIMS[1]/2}, {EXCLUSION_DIMS[2]/2, EXCLUSION_DIMS[1]/2}}
exclusion2.selection_box = Gen.ifThenElse(ALLOW_SELECT_EXCLUSIONS, collisionBox2, nil)
exclusion2.collision_box = collisionBox2
extend{exclusion1, exclusion2}

-- TODO try attaching placeable position visualizations to the air separator.

-- TODO add air separation productivity techs. Should be easy, just copy mining productivity techs.