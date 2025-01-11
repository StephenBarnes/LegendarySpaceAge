-- This file will create the "volcanic gas" fluid, produced on Vulcanus by volcanic fumaroles, and the recipe to separate it into water, sulfur, and carbon.
-- TODO

local Table = require("code.util.table")

local newData = {}

-- Create the new fluid.
local volcanicGasColor = {0.788, 0.627, 0.167}
local volcanicGas = Table.copyAndEdit(data.raw.fluid["steam"], {
	name = "volcanic-gas",
	base_color = volcanicGasColor,
	flow_color = volcanicGasColor,
	visualization_color = volcanicGasColor,
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/fluids/volcanic-gas.png", icon_size = 64, scale = 0.5},
	},
	order = "b[new-fluid]-b[vulcanus]-0[volcanic-gas]",
})
table.insert(newData, volcanicGas)

-- Create recipe for separating volcanic gas into water, sulfur, and carbon.
local volcanicGasSeparationRecipe = Table.copyAndEdit(data.raw.recipe["steam-condensation"], {
	name = "volcanic-gas-separation",
	localised_name = "nil",
	category = "chemistry-or-cryogenics",
	subgroup = "vulcanus-processes",
	order = "0",
	energy_required = 2,
	ingredients = {
		{type = "fluid", name = "volcanic-gas", amount = 100},
	},
	results = {
		{type = "item", name = "sulfur", amount = 2},
		{type = "item", name = "carbon", amount = 1},
		{type = "fluid", name = "water", amount = 20},
	},
	enabled = false,
	allow_decomposition = false,
	allow_as_intermediate = false,
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/fluids/volcanic-gas.png", icon_size = 64, scale = 0.38, shift = {0, -5}},
		{icon = "__base__/graphics/icons/sulfur.png", icon_size = 64, scale = 0.2, shift = {-8, 2}},
		{icon = "__space-age__/graphics/icons/carbon.png", icon_size = 64, scale = 0.24, shift = {8, 2}},
		{icon = "__base__/graphics/icons/fluid/water.png", icon_size = 64, scale = 0.2, shift = {0, 4}},
	},
})
table.insert(newData, volcanicGasSeparationRecipe)

-- Create a tech for volcanic gas separation.
---@type data.TechnologyPrototype
local volcanicGasSeparationTech = Table.copyAndEdit(data.raw.technology["tungsten-carbide"], {
	name = "volcanic-gas-processing",
	effects = {
		{type = "unlock-recipe", recipe = "volcanic-gas-separation"},
	},
	icon = "nil",
	icons = {{
		icon = "__LegendarySpaceAge__/graphics/vulcanus/geyser-tech.png",
		icon_size = 256,
	}},
})
volcanicGasSeparationTech.research_trigger.entity = "vulcanus-chimney"
table.insert(newData, volcanicGasSeparationTech)
table.insert(data.raw.technology["foundry"].prerequisites, "volcanic-gas-processing")
-- TODO add lava as fluid type to the chem plants, since they're now doing the water boiling by lava recipe.

------------------------------------------------------------------------
data:extend(newData)
------------------------------------------------------------------------

-- Make the Vulcanus geysers produce volcanic gas, and a bit of sulfur.
-- In base Space Age, they give 10 sulfuric acid.
data.raw.resource["sulfuric-acid-geyser"].minable.result = nil
data.raw.resource["sulfuric-acid-geyser"].minable.results = {
	{type = "fluid", name = "volcanic-gas", amount = 10},
	{type = "item", name = "sulfur", amount = 1, probability = .02},
}