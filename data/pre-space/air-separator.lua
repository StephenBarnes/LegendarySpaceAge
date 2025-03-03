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

local ALLOW_SELECT_EXCLUSIONS = true -- Whether to allow selection of the exclusion zones - for debugging.
local EXCLUSION_DIMS = {15, 9} -- Tested with both odd; I think they could be even too.
	-- Note that control/air-separator.lua computes distance from center of air separator to center of exclusion zone, using the 2nd number here (y) as y/2 + 1.5. Making the 2nd number smaller than the 1st number is best, so that it's more rounded rather than cross-shaped.
local EXCLUSION_LONG_SIDE = EXCLUSION_DIMS[1]
local EXCLUSION_SHORT_SIDE = EXCLUSION_DIMS[2]

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
		volume = 200,
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
		volume = 200,
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
		volume = 200,
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
		volume = 200,
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
--[[ent.placeable_position_visualization = { -- TODO testing.
	filename = "__core__/graphics/cursor-boxes-32x32.png",
	priority = "extra-high-no-scale",
	size = 64,
	scale = 0.5,
	x = 3*64, -- Image file is a row of box images. This selects which image to use.
}]]
local trim = 0.05
local function trimBounds(bounds)
	return {
		{bounds[1][1] + trim, bounds[1][2] + trim},
		{bounds[2][1] - trim, bounds[2][2] - trim},
	}
end
local entBounds = trimBounds{{-1.5, -1.5}, {1.5, 1.5}}
local buildabilityRules = {
	{area = entBounds, required_tiles = {layers = {ground_tile = true}}, remove_on_collision = false},
}
for _, exclusionBox in pairs{
	trimBounds{{-EXCLUSION_LONG_SIDE/2, -1.5-EXCLUSION_SHORT_SIDE}, {EXCLUSION_LONG_SIDE/2, -1.5}}, -- Box above the air-separator.
	trimBounds{{-1.5-EXCLUSION_SHORT_SIDE, -EXCLUSION_LONG_SIDE/2}, {-1.5, EXCLUSION_LONG_SIDE/2}}, -- Box to the left of the air-separator.
	trimBounds{{1.5, -EXCLUSION_LONG_SIDE/2}, {1.5+EXCLUSION_SHORT_SIDE, EXCLUSION_LONG_SIDE/2}}, -- Box to the right of the air-separator.
	trimBounds{{-EXCLUSION_LONG_SIDE/2, 1.5}, {EXCLUSION_LONG_SIDE/2, 1.5+EXCLUSION_SHORT_SIDE}}, -- Box below the air-separator.
} do
	table.insert(buildabilityRules, {
		area = exclusionBox,
		required_tiles = {layers = {ground_tile = true, water_tile = true,}},
		--colliding_tiles = {layers = {air_separator_exclusion = true}},
		colliding_tiles = {layers = {empty_space = true}},
		remove_on_collision = false,
	})
end
ent.tile_buildability_rules = buildabilityRules
-- NOTE I was thinking maybe we could ONLY do tile_buildability_rules, instead of doing control-stage creation of exclusion zone entities. BUT the tile_buildability_rules are only checked against TILES, not entities. So they won't collide with other air separators.
-- NOTE Was also thinking about adding buildability rules just to highlight some tiles. Could do that.
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

-- Create air separator recipe for Nauvis: no ingredients => 10 stone
local nauvisAirRecipe = Recipe.make{
	copy = "air-separator",
	recipe = "air-separation-nauvis",
	ingredients = {
		{"filter", 1},
	},
	results = {
		{"nitrogen-gas", 100, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightMiddle},
		{"oxygen-gas", 20, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.upDownMiddle},
		{"spent-filter", 1, ignored_by_productivity = 1},
	},
	category = "air-separation",
	time = 10,
	allow_productivity = true,
	allow_quality = false,
	hide_from_player_crafting = true,
	subgroup = "air-separation",
	order = "1",
	localised_name = {"recipe-name.air-separation-planet", {"space-location-name.nauvis"}},
	localised_description = {"recipe-description.air-separation-planet", {"space-location-name.nauvis"}},
	icon = nil,
	show_amount_in_title = false,
}
nauvisAirRecipe.icons = { -- TODO rather have a standard iconArrangement for this, used by deep drill and air separator.
	{icon = "__LegendarySpaceAge__/graphics/air-separator/icon.png"},
	{icon = "__base__/graphics/icons/nauvis.png", scale = 0.2, shift={-8,-8}},
}
extend{nauvisAirRecipe}

-- Create air separation recipes for other planets
for i, planetData in pairs{
	{"vulcanus", {
		{"volcanic-gas", 20, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightMiddle},
	}},
	{"gleba", {
		{"nitrogen-gas", 50, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightTop},
		{"oxygen-gas", 50, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightBottom},
		{"dry-gas", 5, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.upDownMiddle},
	}},
	{"fulgora", {
		{"nitrogen-gas", 50, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightMiddle},
		{"dry-gas", 5, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.upDownMiddle},
	}},
	{"aquilo", {
		{"nitrogen-gas", 100, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.upDownMiddle},
		{"ammonia", 10, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightTop},
		{"dry-gas", 5, type = "fluid", fluidbox_index = FLUIDBOX_INDEX.leftRightBottom},
	}},
} do
	local planetName = planetData[1]
	local results = planetData[2]
	table.insert(results, {"spent-filter", 1, ignored_by_productivity = 1})
	local airSepRecipe = Recipe.make{
		copy = nauvisAirRecipe,
		recipe = "air-separation-"..planetName,
		ingredients = {"filter"},
		results = results,
		order = tostring(i+1),
		localised_name = {"recipe-name.air-separation-planet", {"space-location-name."..planetName}},
		localised_description = {"recipe-description.air-separation-planet", {"space-location-name."..planetName}},
	}
	airSepRecipe.icons[2].icon = "__space-age__/graphics/icons/"..planetName..".png"
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
	{type = "unlock-recipe", recipe = "air-separation-vulcanus"},
	{type = "unlock-recipe", recipe = "air-separation-gleba"},
	{type = "unlock-recipe", recipe = "air-separation-fulgora"},
	{type = "unlock-recipe", recipe = "air-separation-aquilo"},
}
tech.prerequisites = {"electric-mining-drill", "electric-engine"} -- TODO
Icon.set(tech, "LSA/air-separator/tech")
tech.unit = { -- TODO
	count = 100,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
	},
}
extend{tech}

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
local flags = {"not-on-map", "not-repairable", "not-deconstructable", "not-flammable", "not-blueprintable", "placeable-neutral"}
if not ALLOW_SELECT_EXCLUSIONS then
	table.insert(flags, "non-selectable")
end
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
	flags = flags,
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