require("code.data.vulcanus.worldgen")
require("code.data.vulcanus.volcanic-gas")
require("code.data.vulcanus.foundry-recipes")
require("code.data.vulcanus.apprentice-foundry")
require("code.data.vulcanus.tungsten-axe")

local Tech = require("code.util.tech")

-- Move steam-to-water to Vulcanus tech, not calcite processing.
Tech.removeRecipeFromTech("steam-condensation", "calcite-processing")
Tech.addRecipeToTech("steam-condensation", "planet-discovery-vulcanus")

-- Change icon for calcite processing tech to show the circuit.
TECH["calcite-processing"].icon = nil
TECH["calcite-processing"].icons = {{
	icon = "__LegendarySpaceAge__/graphics/vulcanus/ceramic-board-tech.png",
	icon_size = 256,
}}

-- Add recipe for water heating with lava, in chem plant.
local lavaWaterHeatingRecipe = table.deepcopy(RECIPE["steam-condensation"])
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
lavaWaterHeatingRecipe.icon = nil
lavaWaterHeatingRecipe.icons = {
	{icon = "__base__/graphics/icons/fluid/steam.png", icon_size = 64, scale = 0.5},
	{icon = "__space-age__/graphics/icons/fluid/lava.png", icon_size = 64, scale = 0.27, shift = {-6, -7}, mipmap_count=4},
}
data:extend({lavaWaterHeatingRecipe})
Tech.addRecipeToTech("lava-water-heating", "planet-discovery-vulcanus")

-- Change the science pack to use lava.
RECIPE["metallurgic-science-pack"].ingredients = {
	{type = "item", name = "tungsten-carbide", amount = 3},
	{type = "item", name = "tungsten-plate", amount = 2},
	{type = "fluid", name = "lava", amount = 200},
}

-- Change Vulcanus tech triggers to need larger amounts.
TECH["foundry"].research_trigger.count = 20 -- tungsten carbide
TECH["big-mining-drill"].research_trigger.count = 4 -- foundries
TECH["tungsten-steel"].research_trigger.count = 4 -- big mining drills
TECH["metallurgic-science-pack"].research_trigger.count = 20 -- tungsten steel plates

-- Add tech for inverse vulcanization, to make plastic cheaper on Vulcanus.
local inverseVulcanizationTech = table.deepcopy(TECH["cliff-explosives"])
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
local inverseVulcanizationRecipe = table.deepcopy(RECIPE["plastic-bar"])
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
inverseVulcanizationRecipe.icons = {
	{icon = "__base__/graphics/icons/plastic-bar.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/tar.png", icon_size = 64, scale = 0.27, shift = {-6, -7}, mipmap_count=4},
}
data:extend({inverseVulcanizationTech, inverseVulcanizationRecipe})

-- Adjust stats of foundry.
local foundry = data.raw["assembling-machine"]["foundry"]
foundry.crafting_speed = 1 -- Instead of 4, we set it to base 1, increasing to 10.
foundry.effect_receiver = nil -- Remove base productivity bonus.
foundry.energy_source.emissions_per_minute = { pollution = 50 }
foundry.energy_source.drain = "1MW"
foundry.energy_usage = "9MW"