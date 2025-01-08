-- This file makes the waste pump, used to dump waste fluids into lakes.

local Table = require("code.util.table")
local Tech = require("code.util.tech")

local newData = {}

local wastePump = Table.copyAndEdit(data.raw["offshore-pump"]["offshore-pump"], {
	type = "furnace",
	name = "waste-pump",
	crafting_categories = {"waste-pump"},
	crafting_speed = 1,
	source_inventory_size = 0,
	result_inventory_size = 0,
	energy_source = Table.copyAndEdit(data.raw.pump.pump.energy_source, {
		emissions_per_minute = {pollution = 1}, -- This gets multiplied by the emissions multiplier for the specific venting recipe.
	}),
	energy_usage = "60kW", -- Energy used when crafting. Engine sets drain to 1/30 of this.
	PowerMultiplier_ignore = true,
	minable = Table.copyAndEdit(data.raw.pump.pump.minable, {
		result = "waste-pump",
	}),
	fluid_boxes = {
		{
			production_type = "input",
			pipe_covers = pipecoverspictures(),
			base_area = 1,
			base_level = -1,
			volume = 2400,
			pipe_connections = {
				{position = {0, 0}, flow_direction = "input", direction = defines.direction.south},
			},
		},
	},
})
table.insert(newData, wastePump)
-- TODO allow placing in lava, and allow lava to enter it.

local wastePumpCraftingCategory = Table.copyAndEdit(data.raw["recipe-category"]["crafting"], {
	name = "waste-pump",
})
table.insert(newData, wastePumpCraftingCategory)

-- Create recipe.
local wastePumpRecipe = Table.copyAndEdit(data.raw.recipe["pump"], {
	name = "waste-pump",
	results = {{type = "item", name = "waste-pump", amount = 1}},
})
table.insert(newData, wastePumpRecipe)

-- Create item.
local wastePumpItem = Table.copyAndEdit(data.raw.item["pump"], {
	name = "waste-pump",
	place_result = "waste-pump",
	icon = "nil",
	icons = {
		{icon = "__base__/graphics/icons/offshore-pump.png", icon_size = 64, scale = 0.5},
		{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.5},
	},
})
table.insert(newData, wastePumpItem)

-- Create fluid-venting recipes.
local effluentFluidsAndPollution = {
	{"water", 0},
	{"crude-oil", 20},
	{"tar", 30},
	{"heavy-oil", 25},
	{"light-oil", 15},
	{"lubricant", 20},
	{"thruster-fuel", 0},
	{"thruster-oxidizer", 0},
	{"lava", 0},
	{"holmium-solution", 0},
	{"fulgoran-sludge", 0},
	{"electrolyte", 0},
	{"ammoniacal-solution", 0},
	{"ammonia", 0},
	{"fluoroketone-hot", 0}, -- TODO remove this later, will replace fluoroketone with refrigerant and liquid nitrogen
	{"fluoroketone-cold", 0}, -- TODO remove this later, will replace fluoroketone with refrigerant and liquid nitrogen
	{"lithium-brine", 0},
}
for _, effluentFluidAndPollution in pairs(effluentFluidsAndPollution) do
	local effluentFluid = effluentFluidAndPollution[1]
	local effluentPollution = effluentFluidAndPollution[2]
	local fluid = data.raw.fluid[effluentFluid]
	local fluidIcon
	if fluid.icons then
		fluidIcon = fluid.icons[1]
	else
		fluidIcon = {icon = fluid.icon, icon_size = fluid.icon_size}
	end
	local effluentRecipe = Table.copyAndEdit(data.raw.recipe["offshore-pump"], {
		name = "vent-" .. effluentFluid,
		localised_name = {"recipe-name.waste-pumping", {"fluid-name."..effluentFluid}},
		enabled = true,
		ingredients = {{type = "fluid", name = effluentFluid, amount = 1200}},
		results = {},
		energy_required = 1,
		hidden = false,
		hidden_in_factoriopedia = true,
		hide_from_player_crafting = true,
		emissions_multiplier = effluentPollution,
		crafting_machine_tint = { -- Not sure this is ever used.
			primary = fluid.flow_color,
		},
		category = "waste-pump",
		subgroup = "fluid",
		icons = {
			fluidIcon,
			{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64},
		},
	})
	table.insert(newData, effluentRecipe)
end

data:extend(newData)

Tech.addRecipeToTech("waste-pump", "fluid-handling", 5)