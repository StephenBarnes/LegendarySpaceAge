-- This file creates the gasifier entity, item, building.

local Table = require("code.util.table")
local Tech = require("code.util.tech")

local newData = {}

local GRAPHICS = "__LegendarySpaceAge__/graphics/gas-vent/"
local gasifierEnt = Table.copyAndEdit(data.raw.furnace["steel-furnace"], {
	type = "assembling-machine",
	name = "gasifier",
	fixed_recipe = "syngas",
	placeable_by = {item = "gasifier", count = 1},
	icon = "nil",
	icons = {{icon = GRAPHICS.."gasifier-item.png", icon_size = 64}},
	minable = {mining_time = .5, result = "gasifier"},
	collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	crafting_categories = {"gasifier"},
	crafting_speed = 1,
	show_recipe_icon = false, -- Since there's only 1 recipe.
	show_recipe_icon_on_map = true,
	energy_source = {
		type = "burner",
		emissions_per_minute = {pollution = 20}, -- For comparison, heating towers produce 100/m.
		fuel_inventory_size = 2,
		burnt_inventory_size = 1,
		smoke = {{
			name = "smoke",
			north_position = {0, -3.5},
			south_position = {0, -3.5},
			east_position = {0, -3.5},
			west_position = {0, -3.5},
			frequency = 1,
			starting_vertical_speed = 0.11,
			starting_frame_deviation = 60,
			deviation = {0.075,0.075}
		}},
		light_flicker = {
			color = {r=1,g=0.3,b=0.3},
			minimum_light_size = 0.1,
			light_intensity_to_size_coefficient = 0.6,
			-- Sucks there's no way to move the light flicker up to the top of the sprite.
		},
	},
	energy_usage = "2MW", -- TODO check for balance.
	PowerMultiplier_ignore = true, -- For PowerMultiplier mod, disables power changes to this entity.
	source_inventory_size = 0,
	result_inventory_size = 0,
	stateless_visualisation = {
		{
			animation = {
				layers = {
					{
						filename = GRAPHICS.."entity/gasifier.png",
						priority = "high",
						width = 320,
						height = 320,
						scale = 0.5,
						frame_count = 1,
						shift = {1.5, -1.59375}
					},
					{
						filename = GRAPHICS.."entity/shadow.png",
						priority = "high",
						width = 320,
						height = 320,
						scale = 0.5,
						frame_count = 1,
						shift = {1.5, -1.59375},
						draw_as_shadow = true
					},
				}
			}
		}
	},
	match_animation_speed_to_activity = false,
	graphics_set = {
		working_visualisations = {
			{
				animation = {
					layers = {
						{
							filename = GRAPHICS .. "entity/gasifier-fire.png",
							priority = "high",
							frame_count = 29,
							width = 48,
							height = 105,
							scale = 0.5,
							shift = {0, -4.3},
							draw_as_glow = true,
							run_mode = "backward"
						},
						{
							filename = GRAPHICS .. "entity/gasifier-glow-top.png",
							priority = "high",
							repeat_count = 29,
							width = 320,
							height = 320,
							scale = 0.5,
							shift = {1.5, -1.59375},
							draw_as_light = true,
						},
					}
				},
				light = {intensity = 0.1, size = 5},
				constant_speed = true,
			}
		}
	},
	working_sound = {
		sound = { filename = "__base__/sound/oil-refinery.ogg" },
		idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
		apparent_volume = 2.5,
	},
	fluid_boxes = {
		{
			production_type = "input",
			pipe_covers = pipecoverspictures(), -- Seems to be already globally defined.
			volume = 20,
			pipe_connections = { { flow_direction = "input", direction = defines.direction.west, position = {0, 0} } },
			filter = "steam",
		},
		{
			production_type = "output",
			pipe_covers = pipecoverspictures(),
			volume = 20,
			pipe_connections = { { flow_direction = "output", direction = defines.direction.east, position = {0, 0} } },
			filter = "syngas",
		},
	},
	surface_conditions = "nil",
})
table.insert(newData, gasifierEnt)

local fluidGasifierEnt = Table.copyAndEdit(gasifierEnt, {
	name = "fluid-fuelled-gasifier",
	energy_source = {
		type = "fluid",
		emissions_per_minute = gasifierEnt.energy_source.emissions_per_minute,
		fluid_box = {
			base_area = 1,
			height = 1,
			volume = 200,
			pipe_picture = furnacepipepictures,
			pipe_covers = pipecoverspictures(),
			pipe_connections = {
				{flow_direction = "input", position = { 0, 0}, direction = defines.direction.north},
			},
			secondary_draw_orders = draworders,
			hide_connection_info = false,
		},
		burns_fluid = true,
		scale_fluid_usage = true,
		smoke = gasifierEnt.energy_source.smoke,
		light_flicker = gasifierEnt.energy_source.light_flicker,
	},
	placeable_by = {item = "fluid-fuelled-gasifier", count = 1},
	minable = {mining_time = .5, result = "fluid-fuelled-gasifier"},
	icons = {
		{icon = GRAPHICS.."gasifier-item.png", icon_size = 64, scale = 0.5, shift = {2, 0}},
		{icon = data.raw.fluid["petroleum-gas"].icons[1].icon, icon_size = 64, scale = 0.3, shift = {-5, 6}, tint = data.raw.fluid["petroleum-gas"].icons[1].tint},
	},
})
table.insert(newData, fluidGasifierEnt)

local gasifierItem = Table.copyAndEdit(data.raw.item["steel-furnace"], {
	type = "item",
	name = "gasifier",
	icon = "nil",
	icons = {{icon = GRAPHICS.."gasifier-item.png", icon_size = 64}},
	order = "z",
	subgroup = data.raw.item["heating-tower"].subgroup,
	place_result = "gasifier",
	stack_size = 20,
})
table.insert(newData, gasifierItem)

local fluidGasifierItem = Table.copyAndEdit(gasifierItem, {
	name = "fluid-fuelled-gasifier",
	place_result = "fluid-fuelled-gasifier",
	icons = fluidGasifierEnt.icons,
	order = "zz",
})
table.insert(newData, fluidGasifierItem)

local gasifierRecipe = Table.copyAndEdit(data.raw.recipe["steel-furnace"], {
	type = "recipe",
	name = "gasifier",
	enabled = false,
	results = {{type = "item", name = "gasifier", amount = 1}},
	-- TODO decide on ingredients
})
table.insert(newData, gasifierRecipe)

local fluidGasifierRecipe = Table.copyAndEdit(gasifierRecipe, {
	name = "fluid-fuelled-gasifier",
	results = {{type = "item", name = "fluid-fuelled-gasifier", amount = 1}},
})
table.insert(newData, fluidGasifierRecipe)

local gasifierRecipeCategory = Table.copyAndEdit(data.raw["recipe-category"]["crafting"], {
	name = "gasifier",
})
table.insert(newData, gasifierRecipeCategory)

--[[ Steam gasification: 20 fuel + 10 steam -> 10 syngas + 1 pitch + 1 sulfur
		This fuel can be coal, wood, spoilage, or burnable liquids like syngas or crude oil.
			(TODO add a fluid-fuelled gasifier.)
		However, it can't be sulfur (since that would burn to SO2, not CO).
		We want to keep it so 1 unit of every petro fluid is roughly equivalent, so this recipe must produce less syngas+tar than the input fuel; it's a lossy conversion to avoid a loop that creates infinite free fluids.
]]
local gasificationRecipe = Table.copyAndEdit(data.raw.recipe["solid-fuel-from-light-oil"], {
	type = "recipe",
	name = "syngas",
	enabled = false,
	category = "gasifier",
	ingredients = {
		{type="fluid", name="steam", amount=100},
	},
	results = {
		{type="fluid", name="syngas", amount=100, show_details_in_recipe_tooltip = true},
		{type="item", name="pitch", amount=1, show_details_in_recipe_tooltip = false},
		{type="item", name="sulfur", amount=1, show_details_in_recipe_tooltip = false},
	},
	main_result = "syngas",
	energy_required = 10,
	icon = "nil",
	icons = data.raw.fluid.syngas.icons,
	allow_productivity = false,
	allow_speed = false,
	allow_consumption = false, -- No efficiency effects from beacons.
	hidden = false,
	hide_from_player_crafting = false,
	subgroup = "complex-fluid-recipes",
	order = "a[coal-liquefaction]-a",
})
table.insert(newData, gasificationRecipe)

data:extend(newData)

Tech.addRecipeToTech("syngas", "coal-liquefaction", 1)
Tech.addRecipeToTech("gasifier", "coal-liquefaction")
Tech.addRecipeToTech("fluid-fuelled-gasifier", "coal-liquefaction")

-- Adjust pic for syngas tech, so it has a picture of the gasifier.
data.raw.technology["coal-liquefaction"].icon = nil
data.raw.technology["coal-liquefaction"].icons = {
	{icon = "__LegendarySpaceAge__/graphics/gas-vent/tech.png", icon_size = 256, scale = 0.8, shift = {-24, 0}},
	{icon = "__base__/graphics/technology/coal-liquefaction.png", icon_size = 256, scale = 0.5, shift = {24, 0}},
}