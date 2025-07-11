-- This file creates the gas-vent entity, item, building.
-- Graphics and some code taken from Flare Stack by GotLag, snouz, and others. https://mods.factorio.com/mod/Flare%20Stack
-- I chose not to include the Flare Stack mod as dependency, because it also adds incinerator, electric incinerator, vent stack, and various recipes that I don't want.

-- This modpack has gas heating tower for burnable gases, gas vent for non-burnable gases, fluid dump for fluids, and tossing-into-sea for items.

local FurnaceConst = require("const.furnace-const")

local GRAPHICS = "__LegendarySpaceAge__/graphics/gas-vent/"
---@diagnostic disable-next-line: assign-type-mismatch
local ventEnt = copy(FURNACE["steel-furnace"]) ---@type data.FurnacePrototype
ventEnt.type = "furnace"
ventEnt.name = "gas-vent"
ventEnt.icon = nil
ventEnt.icons = {
	{icon = GRAPHICS.."gas-vent-item.png", icon_size = 64},
	{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.25, shift = {-8, 8}},
}
ventEnt.minable = {mining_time = .5, result = "gas-vent"}
ventEnt.collision_box = {{-0.3, -0.3}, {0.3, 0.3}}
ventEnt.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
ventEnt.crafting_categories = {"gas-venting"}
ventEnt.crafting_speed = 1
ventEnt.show_recipe_icon = false -- Don't show the "void X" icon on the entity.
ventEnt.show_recipe_icon_on_map = false
ventEnt.factoriopedia_description = nil
ventEnt.energy_source = {
	type = "void",
	emissions_per_minute = {pollution = 1, spores = 1}, -- This gets multiplied by the emissions multiplier for the specific venting recipe.
}
ventEnt.energy_usage = "1kW"
ventEnt.source_inventory_size = 0
ventEnt.result_inventory_size = 0
ventEnt.drawing_box_vertical_extension = 3
ventEnt.stateless_visualisation = {
	{
		animation = {
			layers = {
				{
					filename = GRAPHICS.."entity/gas-vent.png",
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
ventEnt.match_animation_speed_to_activity = false
ventEnt.graphics_set = {
	working_visualisations = {
		{
			apply_recipe_tint = "primary", -- So it's tinted for the vented gas.
			animation = {
				layers = {
					{
						filename = GRAPHICS.."entity/vented-puff.png",
						priority = "high",
						frame_count = 29,
						width = 48,
						height = 105,
						scale = 0.5,
						shift = {0, -4.3},
						draw_as_glow = false, -- So it's not visible at night, TODO check
						run_mode = "backward",
					},
				},
			},
			constant_speed = true,
		}
	}
}
ventEnt.working_sound = {
	sound = { filename = "__base__/sound/oil-refinery.ogg" },
	idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
	apparent_volume = 2.5,
}
ventEnt.fluid_boxes = {
	{
		production_type = "input",
		pipe_covers = pipecoverspictures(), -- Seems to be already globally defined? TODO check
		volume = 240,
		pipe_connections = { { flow_direction = "input", direction = SOUTH, position = {0, 0} } },
	}
}
ventEnt.surface_conditions = nil -- Should be able to vent on space platforms too.
extend{ventEnt}

local ventItem = copy(ITEM["steel-furnace"])
ventItem.type = "item"
ventItem.name = "gas-vent"
ventItem.icon = nil
ventItem.icons = {
	{icon = GRAPHICS.."gas-vent-item.png", icon_size = 64},
	{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.25, shift = {-8, 8}},
}
ventItem.place_result = "gas-vent"
ventItem.stack_size = 20
extend{ventItem}

local ventRecipe = Recipe.make{
	copy = "steel-furnace",
	recipe = "gas-vent",
	ingredients = {
		{"frame", 5},
		{"fluid-fitting", 5},
	},
	resultCount = 1,
	time = 5,
}

-- Create invisible entity to automatically vent gases for stone furnaces.
---@type data.FurnacePrototype
local stoneFurnaceGasVent = {
	type = "furnace",
	name = "stone-furnace-gas-vent",
	icon = nil,
	icons = {
		{icon = "__base__/graphics/icons/stone-furnace.png", icon_size = 64},
		{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.25, shift = {-8, 8}},
	},
	crafting_categories = {"gas-venting"},
	crafting_speed = 1,
	energy_source = {
		type = "void",
	},
	energy_usage = "1W",
	hidden = true,
	hidden_in_factoriopedia = true,
	fluid_boxes = {
		{
			production_type = "input",
			volume = 1000,
			hide_connection_info = true,
			pipe_connections = { { flow_direction = "input", direction = SOUTH, position = {0, 0}, connection_type = "linked", linked_connection_id = FurnaceConst.outputLinkId } },
		}
	},
	source_inventory_size = 0,
	result_inventory_size = 0,
	selectable_in_game = false,
	flags = {"hide-alt-info", "not-rotatable", "not-blueprintable", "not-deconstructable", "not-flammable", "not-repairable", "not-on-map"},
	collision_mask = {layers={}},
	quality_indicator_scale = 0,
}
extend{stoneFurnaceGasVent}

-- Recipes for venting added in vent-recipes.lua.