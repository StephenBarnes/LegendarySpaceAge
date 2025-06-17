-- Create a second tech for molten metals.
local foundry2Tech = copy(TECH.foundry)
foundry2Tech.name = "foundry-2"
Icon.set(foundry2Tech, "SA/foundry")
Icon.set(TECH.foundry, "LSA/arc-furnace/tech")
foundry2Tech.prerequisites = {"big-mining-drill"}
foundry2Tech.localised_description = {"technology-description.foundry-2"}
foundry2Tech.effects = {} -- Will add effects in other files that make recipes.
extend{foundry2Tech}
TECH["tungsten-steel"].prerequisites = {"foundry-2"}

require("data.vulcanus.worldgen")
require("data.vulcanus.volcanic-gas")
require("data.vulcanus.arc-furnace")
require("data.vulcanus.arc-furnace-recipes")
require("data.vulcanus.foundry")
require("data.vulcanus.foundry-recipes")
require("data.vulcanus.tungsten-axe")
require("data.vulcanus.env-minables")

-- Move steam-to-water to Vulcanus tech, not calcite processing.
Tech.removeRecipeFromTech("steam-condensation", "calcite-processing")
Tech.addRecipeToTech("steam-condensation", "planet-discovery-vulcanus")

-- Change icon for calcite processing tech to show the circuit.
Icon.set(TECH["calcite-processing"], "LSA/vulcanus/ceramic-board-tech")

-- Add recipe for water heating with lava, in chem plant.
local lavaWaterHeatingRecipe = copy(RECIPE["steam-condensation"])
lavaWaterHeatingRecipe.name = "lava-water-heating"
lavaWaterHeatingRecipe.category = "chemistry"
lavaWaterHeatingRecipe.localised_name = nil
lavaWaterHeatingRecipe.energy_required = 5
lavaWaterHeatingRecipe.ingredients = {
	{type = "fluid", name = "lava", amount = 100},
	{type = "fluid", name = "water", amount = 50},
}
lavaWaterHeatingRecipe.results = {
	{type = "fluid", name = "steam", amount = 50, temperature = 500, ignored_by_productivity = 500},
	{type = "item", name = "stone", amount = 5},
}
lavaWaterHeatingRecipe.enabled = false
lavaWaterHeatingRecipe.allow_decomposition = false
lavaWaterHeatingRecipe.allow_as_intermediate = false
lavaWaterHeatingRecipe.allow_productivity = false
Icon.set(lavaWaterHeatingRecipe, {"steam", "lava"})
extend({lavaWaterHeatingRecipe})
Tech.addRecipeToTech("lava-water-heating", "planet-discovery-vulcanus")

-- Change Vulcanus tech triggers.
TECH["foundry"].research_trigger = {
	type = "craft-item",
	item = "tungsten-carbide",
	count = 20,
}
TECH["big-mining-drill"].research_trigger = {
	type = "craft-item",
	item = "arc-furnace",
	count = 1,
}
TECH["foundry-2"].research_trigger = {
	type = "craft-item",
	item = "big-mining-drill",
	count = 5,
}
TECH["tungsten-steel"].research_trigger = {
	type = "craft-item",
	item = "foundry",
	count = 20,
}
TECH["metallurgic-science-pack"].research_trigger = {
	type = "craft-item",
	item = "tungsten-plate",
	count = 100, -- TODO this should be a rate trigger.
}

-- Add tech for inverse vulcanization, to make plastic cheaper on Vulcanus.
local inverseVulcanizationTech = copy(TECH["cliff-explosives"])
inverseVulcanizationTech.name = "inverse-vulcanization"
inverseVulcanizationTech.effects = {{type = "unlock-recipe", recipe = "inverse-vulcanization"}}
inverseVulcanizationTech.prerequisites = {"metallurgic-science-pack"}
inverseVulcanizationTech.icons = {
	{icon = "__base__/graphics/technology/plastics.png", icon_size = 256, scale = 1},
	{icon = "__base__/graphics/technology/sulfur-processing.png", icon_size = 256, scale = 0.6, shift = {32, 25}},
}
inverseVulcanizationTech.unit = {
	count = 50,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
		{"space-science-pack", 1},
		-- No metallurgic science pack - I want it to be unlockable on Nauvis, while you're still on Vulcanus.
	},
	time = 30,
}
local inverseVulcanizationRecipe = copy(RECIPE["plastic-bar"])
inverseVulcanizationRecipe.name = "inverse-vulcanization"
inverseVulcanizationRecipe.ingredients = {
	{type = "item", name = "sulfur", amount = 5},
	{type = "fluid", name = "tar", amount = 10},
}
inverseVulcanizationRecipe.results = {
	{type = "item", name = "plastic-bar", amount = 3},
	{type = "item", name = "resin", amount = 1},
}
inverseVulcanizationRecipe.main_product = "plastic-bar"
Icon.set(inverseVulcanizationRecipe, {"plastic-bar", "tar"})
extend({inverseVulcanizationTech, inverseVulcanizationRecipe})

-- Clear temperature spam for fluids.
Fluid.setSimpleTemp(FLUID["lava"], 5000, true, 1500)
Fluid.setSimpleTemp(FLUID["molten-iron"], 5000, true, 1500)
Fluid.setSimpleTemp(FLUID["molten-copper"], 5000, true, 1500)
Fluid.setSimpleTemp(FLUID["molten-steel"], 5000, true, 1500)