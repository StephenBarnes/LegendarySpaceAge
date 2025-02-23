require("data.vulcanus.worldgen")
require("data.vulcanus.volcanic-gas")
require("data.vulcanus.foundry-recipes")
require("data.vulcanus.apprentice-foundry")
require("data.vulcanus.tungsten-axe")

-- Move steam-to-water to Vulcanus tech, not calcite processing.
Tech.removeRecipeFromTech("steam-condensation", "calcite-processing")
Tech.addRecipeToTech("steam-condensation", "planet-discovery-vulcanus")

-- Change icon for calcite processing tech to show the circuit.
Icon.set(TECH["calcite-processing"], "LSA/vulcanus/ceramic-board-tech")

-- Add recipe for water heating with lava, in chem plant.
local lavaWaterHeatingRecipe = copy(RECIPE["steam-condensation"])
lavaWaterHeatingRecipe.name = "lava-water-heating"
lavaWaterHeatingRecipe.category = "chemistry"
lavaWaterHeatingRecipe.subgroup = "vulcanus-processes"
lavaWaterHeatingRecipe.localised_name = nil
lavaWaterHeatingRecipe.order = "01"
lavaWaterHeatingRecipe.energy_required = 5
lavaWaterHeatingRecipe.ingredients = {
	{type = "fluid", name = "lava", amount = 100},
	{type = "fluid", name = "water", amount = 50},
}
lavaWaterHeatingRecipe.results = {
	{type = "fluid", name = "steam", amount = 500, temperature = 500, ignored_by_productivity = 500},
	{type = "item", name = "stone", amount = 5},
}
lavaWaterHeatingRecipe.enabled = false
lavaWaterHeatingRecipe.allow_decomposition = false
lavaWaterHeatingRecipe.allow_as_intermediate = false
lavaWaterHeatingRecipe.allow_productivity = false
Icon.set(lavaWaterHeatingRecipe, {"steam", "lava"})
extend({lavaWaterHeatingRecipe})
Tech.addRecipeToTech("lava-water-heating", "planet-discovery-vulcanus")

-- Change the science pack to use lava.
RECIPE["metallurgic-science-pack"].ingredients = {
	{type = "item", name = "tungsten-carbide", amount = 3},
	{type = "item", name = "tungsten-plate", amount = 2},
	{type = "fluid", name = "lava", amount = 200},
}
-- Remove surface condition for the science pack. But there's no lava anywhere else. TODO add recipe for artificial lava maybe.
RECIPE["metallurgic-science-pack"].surface_conditions = nil

-- Change Vulcanus tech triggers to need larger amounts.
TECH["foundry"].research_trigger.count = 20 -- tungsten carbide
TECH["big-mining-drill"].research_trigger.count = 4 -- foundries
TECH["tungsten-steel"].research_trigger.count = 4 -- big mining drills
TECH["metallurgic-science-pack"].research_trigger.count = 20 -- tungsten steel plates

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
inverseVulcanizationRecipe.subgroup = "raw-material"
inverseVulcanizationRecipe.ingredients = {
	{type = "item", name = "sulfur", amount = 5},
	{type = "fluid", name = "tar", amount = 5},
}
inverseVulcanizationRecipe.results = {
	{type = "item", name = "plastic-bar", amount = 3},
	{type = "item", name = "resin", amount = 1},
}
inverseVulcanizationRecipe.main_product = "plastic-bar"
inverseVulcanizationRecipe.order = ITEM["plastic-bar"].order.."-2"
Icon.set(inverseVulcanizationRecipe, {"plastic-bar", "tar"})
extend({inverseVulcanizationTech, inverseVulcanizationRecipe})