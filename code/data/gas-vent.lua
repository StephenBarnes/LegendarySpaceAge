-- This file creates the gas-vent entity, item, building.
-- Graphics and some code taken from Flare Stack by GotLag, snouz, and others. https://mods.factorio.com/mod/Flare%20Stack
-- I chose not to include the Flare Stack mod as dependency, because it also adds incinerator, electric incinerator, vent stack, and various recipes that I don't want.

-- This modpack has gas heating tower for burnable gases, gas vent for non-burnable gases, fluid dump for fluids, and tossing-into-sea for items.

local Table = require("code.util.table")
local Tech = require("code.util.tech")

local newData = {}

local GRAPHICS = "__LegendarySpaceAge__/graphics/gas-vent/"
local ventEnt = Table.copyAndEdit(data.raw.furnace["steel-furnace"], {
	type = "furnace",
	name = "gas-vent",
	icon = "nil",
	icons = {{icon = GRAPHICS.."gas-vent-item.png", icon_size = 64}},
	minable = {mining_time = .5, result = "gas-vent"},
	collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	crafting_categories = {"gas-venting"},
	crafting_speed = 1,
	show_recipe_icon = false, -- Don't show the "void X" icon on the entity.
	show_recipe_icon_on_map = false,
	energy_source = {
		type = "void",
		emissions_per_minute = {pollution = 1}, -- This gets multiplied by the emissions multiplier for the specific venting recipe.
	},
	energy_usage = "1kW",
	source_inventory_size = 0,
	result_inventory_size = 0,
	stateless_visualisation = {
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
	},
	match_animation_speed_to_activity = false,
	graphics_set = {
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
	},
	working_sound = {
		sound = { filename = "__base__/sound/oil-refinery.ogg" },
		idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
		apparent_volume = 2.5,
	},
	fluid_boxes = {
		{
			production_type = "input",
			pipe_covers = pipecoverspictures(), -- Seems to be already globally defined? TODO check
			volume = 240,
			pipe_connections = { { flow_direction = "input", direction = defines.direction.south, position = {0, 0} } },
		}
	},
	surface_conditions = "nil", -- Should be able to vent on space platforms too.
})
table.insert(newData, ventEnt)

local ventItem = Table.copyAndEdit(data.raw.item["steel-furnace"], {
	type = "item",
	name = "gas-vent",
	icon = "nil",
	icons = {{icon = GRAPHICS.."gas-vent-item.png", icon_size = 64}},
	subgroup = "energy-pipe-distribution",
	order = "b[pipe]-e",
	place_result = "gas-vent",
	stack_size = 20,
})
table.insert(newData, ventItem)

local ventRecipe = Table.copyAndEdit(data.raw.recipe["steel-furnace"], {
	type = "recipe",
	name = "gas-vent",
	enabled = false,
	results = {{type = "item", name = "gas-vent", amount = 1}},
	-- TODO decide on ingredients
})
table.insert(newData, ventRecipe)

local ventRecipeCategory = Table.copyAndEdit(data.raw["recipe-category"]["crafting"], {
	name = "gas-venting",
})
table.insert(newData, ventRecipeCategory)

local ventableFluids = {
	-- Table of fluid names, emissions mults, and bool for whether it's only ventable in space.

	-- Gases - ventable anywhere.
	{"steam", 0, false},
	{"natural-gas", 2, false},
	{"petroleum-gas", 3, false},
	{"dry-gas", 4, false},
	{"syngas", 4, false},
	{"ammonia", 10, false},
	{"fluorine", 30, false},
	{"thruster-fuel", 0, true}, -- hydrogen
	{"thruster-oxidizer", 0, true}, -- oxygen

	-- Liquids - only ventable in space.
	{"water", 0, true},
	{"crude-oil", 0, true},
	{"tar", 0, true},
	{"heavy-oil", 0, true},
	{"light-oil", 0, true},
	{"cement", 0, true},
	{"latex", 0, true},
	{"lubricant", 0, true},
	{"molten-iron", 0, true},
	{"molten-copper", 0, true},
	{"molten-steel", 0, true},
	{"molten-tungsten", 0, true},
	{"holmium-solution", 0, true},
	{"electrolyte", 0, true},
	{"fluoroketone-hot", 0, true},
	{"fluoroketone-cold", 0, true},
}
for _, fluidData in pairs(ventableFluids) do
	local gasToVent = fluidData[1]
	local emissionsMult = fluidData[2]
	local onlyInSpace = fluidData[3]
	local fluid = data.raw.fluid[gasToVent]
	local gasIcon
	if fluid.icons then
		gasIcon = fluid.icons[1]
	else
		gasIcon = {icon = fluid.icon, icon_size = fluid.icon_size}
	end
	local thisGasVentRecipe = Table.copyAndEdit(ventRecipe, {
		name = "gas-vent-"..gasToVent,
		localised_name = {"recipe-name.gas-vent", {"fluid-name."..gasToVent}},
		category = "gas-venting",
		subgroup = "fluid",
		ingredients = {{type = "fluid", name = gasToVent, amount = 120}},
		results = {},
		enabled = true,
		hidden = false,
		hidden_in_factoriopedia = true,
		hide_from_player_crafting = true,
		icons = {
			gasIcon,
			{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64},
		},
		energy_required = 1,
		emissions_multiplier = emissionsMult,
		crafting_machine_tint = {
			primary = data.raw.fluid[gasToVent].base_color,
		},
	})
	if onlyInSpace then
		thisGasVentRecipe.surface_conditions = {{property = "gravity", max = 0}}
	end
	table.insert(newData, thisGasVentRecipe)
end

data:extend(newData)

Tech.addRecipeToTech("gas-vent", "oil-processing", 3)