-- This file creates the gas-vent entity, item, building.
-- Graphics and some code taken from Flare Stack by GotLag, snouz, and others. https://mods.factorio.com/mod/Flare%20Stack
-- I chose not to include the Flare Stack mod as dependency, because it also adds incinerator, electric incinerator, vent stack, and various recipes that I don't want.

-- This modpack has gas heating tower for burnable gases, gas vent for non-burnable gases, fluid dump for fluids, and tossing-into-sea for items.

local GRAPHICS = "__LegendarySpaceAge__/graphics/gas-vent/"
local ventEnt = copy(FURNACE["steel-furnace"])
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
ventItem.subgroup = "fluid-logistics"
ventItem.order = "b[pipe]-e"
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

local ventRecipeCategory = copy(RAW["recipe-category"]["crafting"])
ventRecipeCategory.name = "gas-venting"
extend{ventRecipeCategory}

local ventableFluids = {
	-- Table of fluid names, emissions mults, and bool for whether it's only ventable in space.

	-- Gases - ventable anywhere.
	{"steam", 0, false},
	{"natural-gas", 2, false},
	{"petroleum-gas", 3, false},
	{"dry-gas", 4, false},
	{"syngas", 4, false},
	{"ammonia", 10, false},
	{"volcanic-gas", 10, false},
	{"spore-gas", 20, false},
	{"fluorine", 30, false},

	{"compressed-nitrogen-gas", 0, false},
	{"nitrogen-gas", 0, false},
	{"oxygen-gas", 0, false},
	{"hydrogen-gas", 0, false},

	-- Liquids - only ventable in space.
	{"thruster-fuel", 0, true}, -- hydrogen
	{"thruster-oxidizer", 0, true}, -- oxygen
	{"liquid-nitrogen", 0, true},
	{"water", 0, true},
	{"sulfuric-acid", 0, true},
	{"crude-oil", 0, true},
	{"tar", 0, true},
	{"heavy-oil", 0, true},
	{"light-oil", 0, true},
	{"diesel", 0, true},
	{"cement", 0, true},
	{"latex", 0, true},
	{"lubricant", 0, true},
	{"fulgoran-sludge", 0, true},
	{"slime", 0, true},
	{"geoplasm", 0, true},
	{"chitin-broth", 0, true},
	{"molten-iron", 0, true},
	{"molten-copper", 0, true},
	{"molten-steel", 0, true},
	{"molten-tungsten", 0, true},
	{"holmium-solution", 0, true},
	{"electrolyte", 0, true},
	{"lithium-brine", 0, true},
	{"fluoroketone-hot", 0, true},
	{"fluoroketone-cold", 0, true},
}
for _, fluidData in pairs(ventableFluids) do
	local gasToVent = fluidData[1]
	local emissionsMult = fluidData[2]
	local onlyInSpace = fluidData[3]
	local fluid = FLUID[gasToVent]
	local thisGasVentRecipe = copy(ventRecipe)
	thisGasVentRecipe.name = "gas-vent-"..gasToVent
	if onlyInSpace then
		thisGasVentRecipe.localised_name = {"recipe-name.gas-vent-space", {"fluid-name."..gasToVent}}
		thisGasVentRecipe.localised_description = {"recipe-description.gas-vent-space"}
		thisGasVentRecipe.subgroup = "gas-vent-in-space"
	else
		thisGasVentRecipe.localised_name = {"recipe-name.gas-vent", {"fluid-name."..gasToVent}}
		thisGasVentRecipe.localised_description = {"recipe-description.gas-vent"}
		thisGasVentRecipe.subgroup = "gas-vent-on-surface"
	end
	thisGasVentRecipe.category = "gas-venting"
	thisGasVentRecipe.ingredients = {{type = "fluid", name = gasToVent, amount = 100}}
	thisGasVentRecipe.results = {}
	thisGasVentRecipe.enabled = true
	-- I'm not hiding these recipes - rather show the player eg what pollution mult will be, whether it's a gas or not, etc.
	thisGasVentRecipe.hidden = false
	thisGasVentRecipe.hidden_in_factoriopedia = false
	thisGasVentRecipe.hide_from_player_crafting = true
	thisGasVentRecipe.allow_productivity = false
	thisGasVentRecipe.allow_quality = false

	local gasIcon
	if fluid.icons then
		gasIcon = copy(fluid.icons[1])
	else
		gasIcon = {icon = fluid.icon, icon_size = fluid.icon_size}
	end
	gasIcon.scale = 0.3
	gasIcon.shift = {4, -4}
	local machineIcon = Gen.ifThenElse(onlyInSpace, "__space-age__/graphics/icons/space-platform-surface.png", "__LegendarySpaceAge__/graphics/gas-vent/gas-vent-item.png")
	local machineScale = Gen.ifThenElse(onlyInSpace, 0.15, 0.25)
	thisGasVentRecipe.icons = {
		gasIcon,
		{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.21, shift = {4, -4}},
		{icon = machineIcon, icon_size = 64, scale = machineScale, shift = {-4, 4}},
	}

	thisGasVentRecipe.energy_required = 1
	thisGasVentRecipe.emissions_multiplier = emissionsMult
	thisGasVentRecipe.crafting_machine_tint = {
		primary = FLUID[gasToVent].base_color,
	}
	if onlyInSpace then
		thisGasVentRecipe.surface_conditions = {{property = "gravity", max = 0}}
	end
	extend{thisGasVentRecipe}
end