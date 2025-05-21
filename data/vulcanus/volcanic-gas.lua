-- This file will create the "volcanic gas" fluid, produced on Vulcanus by volcanic fumaroles, and the recipe to separate it into water, sulfur, and carbon.

-- Create the new fluid.
local volcanicGasColor = {0.788, 0.627, 0.167}
local brighterVolcanicGasColor = {0.996, 0.859, 0.31}
local volcanicGas = copy(FLUID["steam"])
volcanicGas.name = "volcanic-gas"
volcanicGas.base_color = volcanicGasColor
volcanicGas.flow_color = brighterVolcanicGasColor
volcanicGas.visualization_color = volcanicGasColor
volcanicGas.icon = nil
volcanicGas.icons = {
	{icon = "__LegendarySpaceAge__/graphics/fluids/gas-2.png", icon_size = 64, tint = brighterVolcanicGasColor},
}
Fluid.setSimpleTemp(volcanicGas, 200, false)
extend{volcanicGas}

-- Create recipe for separating volcanic gas into water, sulfur, and carbon.
-- Going to do this in filtration plant, so it consumes filters, which require carbon or water.
-- This produces nitrogen bc there's no other way to get nitrogen on Vulcanus, I think.
local separationRecipe = copy(RECIPE["steam-condensation"])
separationRecipe.name = "volcanic-gas-separation"
separationRecipe.localised_name = nil
separationRecipe.category = "filtration"
separationRecipe.energy_required = 1
separationRecipe.ingredients = {
	{type = "fluid", name = "volcanic-gas", amount = 100},
}
separationRecipe.results = {
	{type = "item", name = "sulfur", amount = 1},
	{type = "item", name = "carbon", amount = 1},
	{type = "fluid", name = "water", amount = 10, fluidbox_index = 1},
	{type = "fluid", name = "nitrogen-gas", amount = 10, fluidbox_index = 2},
}
separationRecipe.enabled = false
separationRecipe.allow_decomposition = false
separationRecipe.allow_as_intermediate = false
separationRecipe.allow_quality = true
separationRecipe.allow_productivity = true
separationRecipe.crafting_machine_tint = {
	primary = volcanicGasColor,
	secondary = brighterVolcanicGasColor,
}
--Icon.set(separationRecipe, {"volcanic-gas", "sulfur", "carbon", "water"}, "decomposition")
separationRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
	{icon = "__LegendarySpaceAge__/graphics/fluids/gas-2.png", icon_size = 64, tint = brighterVolcanicGasColor, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
}
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