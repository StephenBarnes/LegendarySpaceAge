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
		{type = "fluid", name = "steam", amount = 500, temperature = 500},
		{type = "item", name = "stone", amount = 4},
	},
	enabled = false,
	allow_decomposition = false,
	allow_as_intermediate = false,
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