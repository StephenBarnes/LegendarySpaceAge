-- This file will create the "volcanic gas" fluid, produced on Vulcanus by volcanic fumaroles, and the recipe to separate it into water, sulfur, and carbon.

-- Create the new fluid.
local volcanicGasColor = {0.788, 0.627, 0.167}
local volcanicGas = copy(FLUID["steam"])
volcanicGas.name = "volcanic-gas"
volcanicGas.base_color = volcanicGasColor
volcanicGas.flow_color = volcanicGasColor
volcanicGas.visualization_color = volcanicGasColor
Icon.set(volcanicGas, "LSA/fluids/volcanic-gas")
volcanicGas.order = "b[new-fluid]-b[vulcanus]-0[volcanic-gas]"
volcanicGas.max_temperature = nil
volcanicGas.heat_capacity = nil
extend{volcanicGas}

-- Create recipe for separating volcanic gas into water, sulfur, and carbon.
local separationRecipe = copy(RECIPE["steam-condensation"])
separationRecipe.name = "volcanic-gas-separation"
separationRecipe.localised_name = nil
separationRecipe.category = "chemistry-or-cryogenics"
separationRecipe.subgroup = "vulcanus-processes"
separationRecipe.order = "02"
separationRecipe.energy_required = 2
separationRecipe.ingredients = {
	{type = "fluid", name = "volcanic-gas", amount = 100},
}
separationRecipe.results = {
	{type = "item", name = "sulfur", amount = 2},
	{type = "item", name = "carbon", amount = 1},
	{type = "fluid", name = "water", amount = 20},
}
separationRecipe.enabled = false
separationRecipe.allow_decomposition = false
separationRecipe.allow_as_intermediate = false
separationRecipe.allow_quality = true
separationRecipe.allow_productivity = true
Icon.set(separationRecipe, {"volcanic-gas", "sulfur", "carbon", "water"}, "decomposition")
extend{separationRecipe}

-- Create a tech for volcanic gas separation.
---@type data.TechnologyPrototype
local volcanicGasSeparationTech = copy(TECH["tungsten-carbide"])
volcanicGasSeparationTech.name = "volcanic-gas-processing"
volcanicGasSeparationTech.effects = {
	{type = "unlock-recipe", recipe = "volcanic-gas-separation"},
}
Icon.set(volcanicGasSeparationTech, "LSA/vulcanus/geyser-tech")
volcanicGasSeparationTech.research_trigger.entity = "vulcanus-chimney"
extend{volcanicGasSeparationTech}
table.insert(TECH["foundry"].prerequisites, "volcanic-gas-processing")
-- TODO add lava as fluid type to the chem plants, since they're now doing the water boiling by lava recipe.

------------------------------------------------------------------------

-- Make the Vulcanus geysers produce volcanic gas, and a bit of sulfur.
-- In base Space Age, they give 10 sulfuric acid.
RAW.resource["sulfuric-acid-geyser"].minable.result = nil
RAW.resource["sulfuric-acid-geyser"].minable.results = {
	{type = "fluid", name = "volcanic-gas", amount = 10},
	{type = "item", name = "sulfur", amount = 1, probability = .02},
}