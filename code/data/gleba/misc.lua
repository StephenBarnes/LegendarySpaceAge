local Tech = require("code.util.tech")
local Item = require("code.util.item")

-- Change Gleba rocket fuel recipe to require carbon, produced from spoilage.
-- Originally 2 bioflux + 30 jelly + water.
table.insert(data.raw.recipe["rocket-fuel-from-jelly"].ingredients,
	{ type = "item", name = "carbon", amount = 2 })

-- Change Gleba biolubricant recipe to require water and bioflux.
table.insert(data.raw.recipe["biolubricant"].ingredients,
	{ type = "fluid", name = "water", amount = 10 })
table.insert(data.raw.recipe["biolubricant"].ingredients,
	{ type = "item", name = "bioflux", amount = 1 })

-- Gleba: remove recipes for making iron/copper bacteria from jelly/mash.
Tech.removeRecipeFromTech("iron-bacteria", "jellynut")
Tech.removeRecipeFromTech("copper-bacteria", "yumako")

-- Gleba: increase spoilage time of iron/copper bacteria.
Item.multiplySpoilTime("iron-bacteria", 3)
Item.multiplySpoilTime("copper-bacteria", 3)

-- Gleba: create recipe for turning iron/copper bacteria into ore and fresh bacteria.
-- Note these don't accept prod modules, but biochamber has +50% prod which does apply.
local bacteriaFilterRecipes = {}
for i, metal in pairs({"copper", "iron"}) do
	local filterMetalRecipe = table.deepcopy(data.raw.recipe[metal.."-bacteria-cultivation"])
	filterMetalRecipe.name = "filter-"..metal.."-bacteria"
	filterMetalRecipe.ingredients = {
		{ type = "item", name = metal.."-bacteria", amount = 6 },
	}
	filterMetalRecipe.results = {
		{ type = "item", name = metal.."-ore", amount = 2 },
		{ type = "item", name = metal.."-bacteria", amount = 1,  },
	}
	filterMetalRecipe.result_is_always_fresh = true
	filterMetalRecipe.main_product = metal.."-bacteria"
	filterMetalRecipe.order = "f-"..i
	filterMetalRecipe.category = "organic"
	filterMetalRecipe.surface_conditions = nil
	filterMetalRecipe.icons = {
		{
			icon = "__space-age__/graphics/icons/"..metal.."-bacteria.png",
			scale = 0.4,
			shift = {0, 0},
		},
		{
			icon = "__base__/graphics/icons/" .. metal .. "-ore.png",
			scale = 0.25,
			shift = {7, 7},
		},
	}
	table.insert(bacteriaFilterRecipes, filterMetalRecipe)
	Tech.addRecipeToTech(filterMetalRecipe.name, "bacteria-cultivation", i+2)
end
data:extend(bacteriaFilterRecipes)

-- Allow bacteria cultivation on any surface.
data.raw.recipe["iron-bacteria-cultivation"].surface_conditions = nil
data.raw.recipe["copper-bacteria-cultivation"].surface_conditions = nil

-- Double rocket capacity for bioflux
-- Decided against this bc it's already high, don't want to remove the incentive to set up toxophages etc.
--Item.multiplyWeight("bioflux", 0.5, "capsule")

-- Gleba: Change ingredients of biological science pack.
data.raw.recipe["agricultural-science-pack"].ingredients = {
	{ type = "item", name = "nutrients", amount = 4 },
	{ type = "item", name = "pentapod-egg", amount = 1 },
	{ type = "item", name = "iron-bacteria", amount = 1 },
	{ type = "item", name = "copper-bacteria", amount = 1 },
}