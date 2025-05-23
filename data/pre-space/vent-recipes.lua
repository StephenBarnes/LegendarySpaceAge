-- This file creates the recipes for venting gases and liquids, in the gas vent and waste pump.

local VentableConst = require("const.ventable-const")
local MiscConst = require("const.misc-const")
local gasVentEmissionsMult = MiscConst.gasVentRate / 100
local wastePumpEmissionsMult = MiscConst.wastePumpRate * MiscConst.wastePumpPollutionMult / 100

-- Create recipe categories and subgroups.
extend{
	{
		name = "gas-venting-on-surface",
		type = "item-subgroup",
		group = "fluids",
		order = "a", -- Will be reassigned by item-recipe-arrangement code.
	},
	{
		name = "gas-venting-in-space",
		type = "item-subgroup",
		group = "fluids",
		order = "b",
	},
	{
		name = "waste-pump",
		type = "item-subgroup",
		group = "fluids",
		order = "c",
	},
	{
		name = "gas-venting",
		type = "recipe-category",
	},
	{
		name = "waste-pump",
		type = "recipe-category",
	},
}

-- Create venting recipes.
for fluidName, ventData in pairs(VentableConst) do
	local emissionsMult = ventData[1]
	local isLiquid = ventData[2]
	local fluid = FLUID[fluidName]

	local fluidIcon
	if fluid.icons then
		fluidIcon = copy(fluid.icons[1])
	else
		fluidIcon = {icon = fluid.icon, icon_size = fluid.icon_size}
	end
	fluidIcon.scale = 0.3
	fluidIcon.shift = {4, -4}

	if not isLiquid then
		Recipe.make{
			recipe = "gas-vent-"..fluidName,
			category = "gas-venting",
			ingredients = {{type = "fluid", name = fluidName, amount = MiscConst.gasVentRate}},
			results = {},
			enabled = true,
			localised_name = {"recipe-name.gas-vent", {"fluid-name."..fluidName}},
			localised_description = {"recipe-description.gas-vent"},
			subgroup = "gas-vent-on-surface",
			hidden = false,
			hidden_in_factoriopedia = false, -- I'm not hiding these recipes - rather show the player eg what pollution mult will be, whether it's a gas or not, etc.
			hide_from_player_crafting = true,
			allow_productivity = false,
			allow_quality = false,
			emissions_multiplier = emissionsMult * gasVentEmissionsMult,
			crafting_machine_tint = {
				primary = FLUID[fluidName].base_color,
			},
			time = 1,
			iconsLiteral = {
				fluidIcon,
				{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.21, shift = {4, -4}},
				{icon = "__LegendarySpaceAge__/graphics/gas-vent/gas-vent-item.png", icon_size = 64, scale = 0.25, shift = {-4, 4}},
			},
		}
	else -- If it's liquid, make 2 recipes. One for venting in space using gas vent, and one for pumping into lakes/seas using waste pump.
		Recipe.make{ -- Make recipe for venting in space.
			recipe = "gas-vent-"..fluidName,
			category = "gas-venting",
			ingredients = {{type = "fluid", name = fluidName, amount = MiscConst.gasVentRate}},
			results = {},
			enabled = true,
			localised_name = {"recipe-name.gas-vent-space", {"fluid-name."..fluidName}},
			localised_description = {"recipe-description.gas-vent-space"},
			subgroup = "gas-vent-in-space",
			hidden = false,
			hidden_in_factoriopedia = false,
			hide_from_player_crafting = true,
			allow_productivity = false,
			allow_quality = false,
			emissions_multiplier = nil, -- No pollution in space.
			time = 1,
			iconsLiteral = {
				fluidIcon,
				{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.21, shift = {4, -4}},
				{icon = "__LegendarySpaceAge__/graphics/gas-vent/gas-vent-item.png", icon_size = 64, scale = 0.25, shift = {-4, 4}},
			},
			surface_conditions = {{property = "gravity", max = 0}},
		}
		Recipe.make{ -- Make recipe for waste pump.
			recipe = "waste-pump-"..fluidName,
			category = "waste-pump",
			ingredients = {{type = "fluid", name = fluidName, amount = MiscConst.wastePumpRate}},
			results = {},
			enabled = true,
			localised_name = {"recipe-name.waste-pumping", {"fluid-name."..fluidName}},
			localised_description = {"recipe-description.waste-pumping"},
			subgroup = "waste-pump",
			hidden = false,
			hidden_in_factoriopedia = false,
			hide_from_player_crafting = true,
			allow_productivity = false,
			allow_quality = false,
			emissions_multiplier = emissionsMult * wastePumpEmissionsMult,
			time = 1,
			iconsLiteral = {
				fluidIcon,
				{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.21, shift = {4, -4}},
				{icon = "__base__/graphics/icons/offshore-pump.png", icon_size = 64, scale = 0.2, shift = {-4, 4}},
			},
		}
	end
end