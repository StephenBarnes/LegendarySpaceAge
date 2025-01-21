require("code.data.vulcanus.worldgen")
require("code.data.vulcanus.volcanic-gas")
require("code.data.vulcanus.foundry-recipes")

local Table = require("code.util.table")
local Tech = require("code.util.tech")

-- Move steam-to-water to Vulcanus tech, not calcite processing.
Tech.removeRecipeFromTech("steam-condensation", "calcite-processing")
Tech.addRecipeToTech("steam-condensation", "planet-discovery-vulcanus")

-- Change icon for calcite processing tech to show the circuit.
data.raw.technology["calcite-processing"].icon = nil
data.raw.technology["calcite-processing"].icons = {{
	icon = "__LegendarySpaceAge__/graphics/vulcanus/ceramic-board-tech.png",
	icon_size = 256,
}}

-- Add recipe for water heating with lava, in chem plant.
local lavaWaterHeatingRecipe = Table.copyAndEdit(data.raw.recipe["steam-condensation"], {
	name = "lava-water-heating",
	category = "chemistry",
	subgroup = "vulcanus-processes",
	localised_name = "nil",
	order = "01",
	energy_required = 2,
	ingredients = {
		{type = "fluid", name = "lava", amount = 100},
		{type = "fluid", name = "water", amount = 50},
	},
	results = {
		{type = "fluid", name = "steam", amount = 500, temperature = 500, ignored_by_productivity = 500},
		{type = "item", name = "stone", amount = 4},
	},
	enabled = false,
	allow_decomposition = false,
	allow_as_intermediate = false,
	allow_productivity = false,
	icon = "nil",
	icons = {
		{icon = "__base__/graphics/icons/fluid/steam.png", icon_size = 64, scale = 0.5},
		{icon = "__space-age__/graphics/icons/fluid/lava.png", icon_size = 64, scale = 0.27, shift = {-6, -7}, mipmap_count=4},
	},
})
data:extend({lavaWaterHeatingRecipe})
Tech.addRecipeToTech("lava-water-heating", "planet-discovery-vulcanus")

-- Change the science pack to use lava.
data.raw.recipe["metallurgic-science-pack"].ingredients = {
	{type = "item", name = "tungsten-carbide", amount = 3},
	{type = "item", name = "tungsten-plate", amount = 2},
	{type = "fluid", name = "lava", amount = 200},
}

-- Change Vulcanus tech triggers to need larger amounts.
data.raw.technology["foundry"].research_trigger.count = 20 -- tungsten carbide
data.raw.technology["big-mining-drill"].research_trigger.count = 4 -- foundries
data.raw.technology["tungsten-steel"].research_trigger.count = 4 -- big mining drills
data.raw.technology["metallurgic-science-pack"].research_trigger.count = 20 -- tungsten steel plates

-- Add tech for inverse vulcanization, to make plastic cheaper on Vulcanus.
local inverseVulcanizationTech = table.deepcopy(data.raw.technology["cliff-explosives"])
inverseVulcanizationTech.name = "inverse-vulcanization"
inverseVulcanizationTech.effects = {{type = "unlock-recipe", recipe = "inverse-vulcanization"}}
inverseVulcanizationTech.prerequisites = {"metallurgic-science-pack"}
inverseVulcanizationTech.icons = {
	{icon = "__base__/graphics/technology/plastics.png", icon_size = 256, scale = 1},
	{icon = "__base__/graphics/technology/sulfur-processing.png", icon_size = 256, scale = 0.6, shift = {32, 25}},
}
local inverseVulcanizationRecipe = table.deepcopy(data.raw.recipe["plastic-bar"])
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
inverseVulcanizationRecipe.order = data.raw.item["plastic-bar"].order.."-2"
inverseVulcanizationRecipe.icons = {
	{icon = "__base__/graphics/icons/plastic-bar.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/tar.png", icon_size = 64, scale = 0.27, shift = {-6, -7}, mipmap_count=4},
}
data:extend({inverseVulcanizationTech, inverseVulcanizationRecipe})