-- This file creates the gasifier entity, item, building.

local GRAPHICS = "__LegendarySpaceAge__/graphics/gas-vent/"
---@type data.AssemblingMachinePrototype
---@diagnostic disable-next-line: assign-type-mismatch
local gasifierEnt = copy(FURNACE["steel-furnace"])
gasifierEnt.type = "assembling-machine"
gasifierEnt.name = "gasifier"
gasifierEnt.fixed_recipe = "syngas"
gasifierEnt.placeable_by = {item = "gasifier", count = 1}
gasifierEnt.icon = nil
gasifierEnt.icons = {{icon = GRAPHICS.."gasifier-item.png", icon_size = 64}}
gasifierEnt.minable = {mining_time = .5, result = "gasifier"}
gasifierEnt.collision_box = {{-0.3, -0.3}, {0.3, 0.3}}
gasifierEnt.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
gasifierEnt.crafting_categories = {"gasifier"}
gasifierEnt.crafting_speed = 1
gasifierEnt.show_recipe_icon = false -- Since there's only 1 recipe.
gasifierEnt.show_recipe_icon_on_map = true
gasifierEnt.energy_source = {
	type = "burner",
	emissions_per_minute = {
		pollution = 100, -- For comparison, heating towers consume 8MW and produce 100/m.
		spores = 10,
	},
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
}
gasifierEnt.energy_usage = "20MW" -- TODO check for balance.
gasifierEnt.trash_inventory_size = 0
gasifierEnt.stateless_visualisation = {
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
}
gasifierEnt.match_animation_speed_to_activity = false
gasifierEnt.graphics_set = {
	animation = { -- Needed or else the blueprint ghost doesn't have any graphics.
		filename = GRAPHICS.."entity/gasifier.png",
		priority = "high",
		width = 320,
		height = 320,
		scale = 0.5,
		frame_count = 1,
		shift = {1.5, -1.59375}
	},
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
}
gasifierEnt.working_sound = {
	sound = { filename = "__base__/sound/oil-refinery.ogg" },
	idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
	apparent_volume = 2.5,
}
gasifierEnt.fluid_boxes = {
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
}
gasifierEnt.surface_conditions = RAW["mining-drill"]["burner-mining-drill"].surface_conditions
extend{gasifierEnt}

---@type data.AssemblingMachinePrototype
local fluidGasifierEnt = copy(gasifierEnt)
fluidGasifierEnt.name = "fluid-fuelled-gasifier"
fluidGasifierEnt.minable.result = "fluid-fuelled-gasifier"
fluidGasifierEnt.placeable_by = {item = "fluid-fuelled-gasifier", count = 1}
fluidGasifierEnt.energy_source = {
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
}
fluidGasifierEnt.icons = {
	{icon = GRAPHICS.."gasifier-item.png", icon_size = 64, scale = 0.5, shift = {2, 0}},
	{icon = FLUID["petroleum-gas"].icons[1].icon, icon_size = 64, scale = 0.3, shift = {-5, 6}, tint = FLUID["petroleum-gas"].icons[1].tint},
}
extend{fluidGasifierEnt}

local gasifierItem = copy(ITEM["steel-furnace"])
gasifierItem.type = "item"
gasifierItem.name = "gasifier"
gasifierItem.icon = nil
gasifierItem.icons = {{icon = GRAPHICS.."gasifier-item.png", icon_size = 64}}
gasifierItem.order = "z"
gasifierItem.subgroup = "chemical-processing"
gasifierItem.place_result = "gasifier"
gasifierItem.stack_size = 20
extend{gasifierItem}

local fluidGasifierItem = copy(gasifierItem)
fluidGasifierItem.name = "fluid-fuelled-gasifier"
fluidGasifierItem.place_result = "fluid-fuelled-gasifier"
fluidGasifierItem.icons = fluidGasifierEnt.icons
fluidGasifierItem.order = "zz"
extend{fluidGasifierItem}

local gasifierRecipe = Recipe.make{
	copy = "steel-furnace",
	recipe = "gasifier",
	enabled = false,
	resultCount = 1,
	ingredients = {
		{"frame", 5},
		{"fluid-fitting", 10},
	},
	time = 5,
}

local fluidGasifierRecipe = Recipe.make{
	copy = gasifierRecipe,
	recipe = "fluid-fuelled-gasifier",
	enabled = false,
	resultCount = 1,
	ingredients = {
		{"frame", 5},
		{"fluid-fitting", 15},
	},
}

local gasifierRecipeCategory = copy(RAW["recipe-category"]["crafting"])
gasifierRecipeCategory.name = "gasifier"
extend{gasifierRecipeCategory}

--[[ Steam gasification: 20 fuel + 10 steam -> 10 syngas + 1 pitch + 1 sulfur
		This fuel can be coal, wood, spoilage, or burnable liquids like syngas or crude oil.
		However, it can't be sulfur (since that would burn to SO2, not CO).
		We want to keep it so 1 unit of every petro fluid is roughly equivalent, so this recipe must produce less syngas+tar than the input fuel; it's a lossy conversion to avoid a loop that creates infinite free fluids.
]]
local gasificationRecipe = copy(RECIPE["solid-fuel-from-light-oil"])
gasificationRecipe.type = "recipe"
gasificationRecipe.name = "syngas"
gasificationRecipe.enabled = false
gasificationRecipe.category = "gasifier"
gasificationRecipe.ingredients = {
	{type="fluid", name="steam", amount=100},
}
gasificationRecipe.results = {
	{type="fluid", name="syngas", amount=100, show_details_in_recipe_tooltip = true},
	--{type="item", name="pitch", amount=1, show_details_in_recipe_tooltip = false},
		-- This is realistic, but makes it too easy to get heavy fractions on Gleba.
	{type="item", name="sulfur", amount=1, show_details_in_recipe_tooltip = false},
}
gasificationRecipe.main_product = "syngas"
gasificationRecipe.energy_required = 1
gasificationRecipe.icon = nil
gasificationRecipe.icons = FLUID.syngas.icons
gasificationRecipe.allow_productivity = false
gasificationRecipe.allow_speed = false
gasificationRecipe.allow_consumption = false -- No efficiency effects from beacons.
gasificationRecipe.hidden = false
gasificationRecipe.hide_from_player_crafting = false
gasificationRecipe.subgroup = "complex-fluid-recipes"
gasificationRecipe.order = "a[coal-liquefaction]-a"
extend{gasificationRecipe}

Tech.addRecipeToTech("syngas", "coal-liquefaction", 1)
Tech.addRecipeToTech("gasifier", "coal-liquefaction")
Tech.addRecipeToTech("fluid-fuelled-gasifier", "coal-liquefaction")

-- Adjust pic for syngas tech, so it has a picture of the gasifier.
TECH["coal-liquefaction"].icon = nil
TECH["coal-liquefaction"].icons = {
	{icon = "__LegendarySpaceAge__/graphics/gas-vent/tech.png", icon_size = 256, scale = 0.8, shift = {-24, 0}},
	{icon = "__base__/graphics/technology/coal-liquefaction.png", icon_size = 256, scale = 0.5, shift = {24, 0}},
}