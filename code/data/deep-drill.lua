--[[ This file creates the "deep drill", a massive drill that can be built on any terrain (not on ores like regular drills).
It yields different resources depending on the planet - on Gleba it gives chitin (for making machine parts etc without metal), on Vulcanus it gives hydrocarbons, on Fulgora it gives sth, haven't decided. This is done by replacing it on build with a different entity for those planets.
Can't be built on Aquilo or space platforms.
There's a separate runtime script in control/deep-drill-recipe.lua that sets the recipe for the deep drill according to the surface it was built on.
Graphics from Hurricane046 - https://mods.factorio.com/user/Hurricane046
Some code taken from Ancient Drill by RaulMoreau - https://github.com/GafarovMaxim/ancient-drill/blob/main/prototypes/entity.lua
]]

local ent = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
ent.name = "deep-drill"
ent.icon = "__LegendarySpaceAge__/graphics/deep-drill/item.png"
ent.minable.result = "deep-drill"
ent.minable.mining_time = 1
ent.crafting_speed = 1
ent.selection_box = {{-5.5, -5.5}, {5.5, 5.5}}
ent.collision_box = {{-5.5, -5.5}, {5.5, 5.5}}
ent.fluid_boxes = nil
ent.vector_to_place_result = {6, 5}
ent.ingredient_count = 0
ent.crafting_categories = {"deep-drill"}
ent.surface_conditions = {{property = "surface-stability", min = 80}}
ent.energy_usage = "10MW"
ent.energy_source.drain = "200kW"
---@diagnostic disable-next-line: inject-field
ent.PowerMultiplier_ignore = true
ent.show_recipe_icon = false
ent.show_recipe_icon_on_map = false
ent.graphics_set = {
	animation = {
		layers = {
			{
				filename = "__LegendarySpaceAge__/graphics/deep-drill/hr-shadow.png",
				priority = "high",
				width = 1400,
				height = 1400,
				frame_count = 1,
				repeat_count = 120,
				animation_speed = 0.5,
				draw_as_shadow = true,
				scale = 0.5,
			},
			{
				priority = "high",
				width = 704,
				height = 704,
				frame_count = 120,
				animation_speed = 0.5,
				scale = 0.5,
				stripes = {
					{
						filename = "__LegendarySpaceAge__/graphics/deep-drill/hr-animation-1.png",
						width_in_frames = 8,
						height_in_frames = 8,
					},
					{
						filename = "__LegendarySpaceAge__/graphics/deep-drill/hr-animation-2.png",
						width_in_frames = 8,
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
				priority = "high",
				width = 704,
				height = 400,
				shift = util.by_pixel_hr(0, 92),
				frame_count = 120,
				animation_speed = 0.5,
				scale = 0.5,
				draw_as_light = true,
				blend_mode = "additive",
				stripes = {
					{
						filename = "__LegendarySpaceAge__/graphics/deep-drill/hr-emission-1.png",
						width_in_frames = 8,
						height_in_frames = 8,
					},
					{
						filename = "__LegendarySpaceAge__/graphics/deep-drill/hr-emission-2.png",
						width_in_frames = 8,
						height_in_frames = 7, -- TODO
					},
				},
			},
		}
	},
	reset_animation_when_frozen = true,
}
data:extend{ent}

local item = table.deepcopy(data.raw.item["electric-mining-drill"])
item.name = "deep-drill"
item.icon = "__LegendarySpaceAge__/graphics/deep-drill/item.png"
item.place_result = "deep-drill"
item.stack_size = 10
item.weight = 1e7 -- Too heavy for rocket.
item.order = "a[items]-d"
data:extend{item}

local recipe = table.deepcopy(data.raw.recipe["electric-mining-drill"])
recipe.name = "deep-drill"
recipe.results = {{type = "item", name = "deep-drill", amount = 1}}
recipe.ingredients = {
	{type = "item", name = "frame", amount = 50},
	{type = "item", name = "structure", amount = 100},
	{type = "item", name = "mechanism", amount = 200},
}
data:extend{recipe}

-- Create recipe category for deep drilling. Can only be performed in deep drills. Recipe is auto-assigned by control script.
data:extend{{
	type = "recipe-category",
	name = "deep-drill",
}}

-- Create deep drill recipe for Nauvis: no ingredients => 10 stone
local nauvisDrillingRecipe = table.deepcopy(data.raw.recipe["deep-drill"])
nauvisDrillingRecipe.name = "deep-drill-nauvis"
nauvisDrillingRecipe.ingredients = {}
nauvisDrillingRecipe.results = {
	{type = "item", name = "stone", amount = 10},
}
nauvisDrillingRecipe.category = "deep-drill"
--nauvisDrillingRecipe.hidden = true
--nauvisDrillingRecipe.hidden_in_factoriopedia = true
nauvisDrillingRecipe.hide_from_player_crafting = true
nauvisDrillingRecipe.subgroup = "deep-drilling"
nauvisDrillingRecipe.order = "1"
nauvisDrillingRecipe.enabled = true
nauvisDrillingRecipe.energy_required = 1
nauvisDrillingRecipe.localised_name = {"recipe-name.deep-drill-planet", {"space-location-name.nauvis"}}
nauvisDrillingRecipe.localised_description = {"recipe-description.deep-drill-planet", {"space-location-name.nauvis"}}
nauvisDrillingRecipe.icon = nil
nauvisDrillingRecipe.show_amount_in_title = false
nauvisDrillingRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/deep-drill/item.png"},
	{icon = "__base__/graphics/icons/nauvis.png", scale = 0.2, shift={-8,-8}},
}
data:extend{nauvisDrillingRecipe}
-- Create drilling recipes for other planets
for i, planetData in pairs{
	{"vulcanus", {{type = "item", name = "stone", amount = 8}, {type = "item", name = "carbon", amount = 2}}},
		-- Drill consumes 10MJ for each recipe. Each carbon is 2MJ. So you get back 4MJ of fuel. With efficiency modules you could reduce energy cost to 2MJ, so 2MW profit.
	{"gleba", {{type = "item", name = "spoilage", amount = 5}, {type = "item", name = "stone", amount = 5}}},
		-- TODO change stone to chitin
	{"fulgora", {{type = "item", name = "stone", amount = 8}, {type = "item", name = "scrap", amount = 2}}},
} do
	local planetName = planetData[1]
	local drillingRecipe = table.deepcopy(nauvisDrillingRecipe)
	drillingRecipe.name = "deep-drill-"..planetName
	drillingRecipe.results = planetData[2]
	drillingRecipe.order = tostring(i+1)
	drillingRecipe.localised_name[2][1] = "space-location-name."..planetName
	drillingRecipe.localised_description[2][1] = "space-location-name."..planetName
	drillingRecipe.icons[2].icon = "__space-age__/graphics/icons/"..planetName..".png"
	data:extend{drillingRecipe}
end

-- Create a subgroup for the drilling recipes
data:extend{{
	type = "item-subgroup",
	name = "deep-drilling",
	group = "intermediate-products",
	order = "z",
}}

-- Create tech for the deep drill recipe.
local tech = table.deepcopy(data.raw.technology["electric-mining-drill"])
tech.name = "deep-drill"
tech.effects = {
	{type = "unlock-recipe", recipe = "deep-drill"},
	{type = "unlock-recipe", recipe = "deep-drill-nauvis"},
	{type = "unlock-recipe", recipe = "deep-drill-vulcanus"},
	{type = "unlock-recipe", recipe = "deep-drill-gleba"},
	{type = "unlock-recipe", recipe = "deep-drill-fulgora"},
}
tech.prerequisites = {"electric-mining-drill", "cement", "chemical-science-pack"}
tech.icon = "__LegendarySpaceAge__/graphics/deep-drill/tech.png"
tech.unit = {
	count = 100,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
	},
}
data:extend{tech}