-- This file will create the "volcanic gas" fluid, produced on Vulcanus by volcanic fumaroles, and the recipe to separate it into water, sulfur, and carbon.
-- TODO

local Table = require("code.util.table")

local newData = {}

-- Create the new fluid.
local volcanicGasColor = {0.788, 0.627, 0.167}
local volcanicGas = table.deepcopy(data.raw.fluid["steam"])
volcanicGas.name = "volcanic-gas"
volcanicGas.base_color = volcanicGasColor
volcanicGas.flow_color = volcanicGasColor
volcanicGas.visualization_color = volcanicGasColor
volcanicGas.icon = nil
volcanicGas.icons = {
	{icon = "__LegendarySpaceAge__/graphics/fluids/volcanic-gas.png", icon_size = 64, scale = 0.5},
}
volcanicGas.order = "b[new-fluid]-b[vulcanus]-0[volcanic-gas]"
table.insert(newData, volcanicGas)

-- Create recipe for separating volcanic gas into water, sulfur, and carbon.
local volcanicGasSeparationRecipe = table.deepcopy(data.raw.recipe["steam-condensation"])
volcanicGasSeparationRecipe.name = "volcanic-gas-separation"
volcanicGasSeparationRecipe.localised_name = nil
volcanicGasSeparationRecipe.category = "chemistry-or-cryogenics"
volcanicGasSeparationRecipe.subgroup = "vulcanus-processes"
volcanicGasSeparationRecipe.order = "02"
volcanicGasSeparationRecipe.energy_required = 2
volcanicGasSeparationRecipe.ingredients = {
	{type = "fluid", name = "volcanic-gas", amount = 100},
}
volcanicGasSeparationRecipe.results = {
	{type = "item", name = "sulfur", amount = 2},
	{type = "item", name = "carbon", amount = 1},
	{type = "fluid", name = "water", amount = 20},
}
volcanicGasSeparationRecipe.enabled = false
volcanicGasSeparationRecipe.allow_decomposition = false
volcanicGasSeparationRecipe.allow_as_intermediate = false
volcanicGasSeparationRecipe.icon = nil
volcanicGasSeparationRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/fluids/volcanic-gas.png", icon_size = 64, scale = 0.38, shift = {0, -5}},
	{icon = "__base__/graphics/icons/sulfur.png", icon_size = 64, scale = 0.15, shift = {-8, 1}},
	{icon = "__space-age__/graphics/icons/carbon.png", icon_size = 64, scale = 0.15, shift = {8, 2}},
	{icon = "__base__/graphics/icons/fluid/water.png", icon_size = 64, scale = 0.24, shift = {0, 4}},
}
table.insert(newData, volcanicGasSeparationRecipe)

-- Create a tech for volcanic gas separation.
---@type data.TechnologyPrototype
local volcanicGasSeparationTech = table.deepcopy(data.raw.technology["tungsten-carbide"])
volcanicGasSeparationTech.name = "volcanic-gas-processing"
volcanicGasSeparationTech.effects = {
	{type = "unlock-recipe", recipe = "volcanic-gas-separation"},
}
volcanicGasSeparationTech.icon = nil
volcanicGasSeparationTech.icons = {{
	icon = "__LegendarySpaceAge__/graphics/vulcanus/geyser-tech.png",
	icon_size = 256,
}}
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