--local coreUtil = require("__core__/lualib/util") -- for deepcopy?
local Tech = require("code.util.tech")
local Item = require("code.util.item")

require("code.data.labs")
require("code.data.large-storage-tank")

-- Nerf heating towers' efficiency, and reduce energy consumption.
data.raw.reactor["heating-tower"].energy_source.effectivity = 1 -- 2.5 to 1
data.raw.reactor["heating-tower"].consumption = "8MW"

-- Logistic system tech: require quantum processor tech, and quantum processors as ingredients.
data.raw.technology["logistic-system"].prerequisites = {"quantum-processor"}
data.raw.technology["logistic-system"].unit = table.deepcopy(data.raw.technology["quantum-processor"].unit)
data.raw.technology["logistic-system"].unit.count = data.raw.technology["logistic-system"].unit.count * 2
for _, effect in pairs(data.raw.technology["logistic-system"].effects) do
	if effect.type == "unlock-recipe" then
		local recipeName = effect.recipe
		data.raw.recipe[recipeName].ingredients = {
			{ type = "item", name = "quantum-processor", amount = 2 },
			{ type = "item", name = "steel-chest", amount = 1 },
		}
	end
end

-- Make space platform tiles more complex and expensive to produce.
-- Originally 20 steel plate + 20 copper cable.
data.raw.recipe["space-platform-foundation"].ingredients = {
	{ type = "item", name = "low-density-structure", amount = 10 },
		-- Effectively 200 copper plate, 20 steel plate, 50 plastic.
	{ type = "item", name = "copper-cable", amount = 10 },
	{ type = "item", name = "electric-engine-unit", amount = 1 },
		-- Effectively lubricant plus metals.
	{ type = "item", name = "processing-unit", amount = 1 },
		-- Effectively sulfuric acid + plastic + metals.
}

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

-- Fulgora: scrap now yields toxophages when mined.
local toxophageSources = {
	--["fulgoran-ruin-small"] = {0, .1},
	--["fulgoran-ruin-medium"] = {0, .1},
	["fulgoran-ruin-stonehenge"] = {0, .2},
	["fulgoran-ruin-big"] = {0, .3},
	["fulgoran-ruin-huge"] = {0, .5},
	["fulgoran-ruin-colossal"] = {0, .8},
	["fulgoran-ruin-vault"] = {2, nil},
	--["fulgoran-ruin-attractor"] = {0, .1},
}
for entName, amountAndChance in pairs(toxophageSources) do
	table.insert(data.raw["simple-entity"][entName].minable.results, {
		type = "item",
		name = "toxophage",
		amount = amountAndChance[1],
		extra_count_fraction = amountAndChance[2],
	})
end

-- Toxophages now spoil to spoilage, not nutrients.
data.raw.item["toxophage"].spoil_result = "spoilage"

-- Fulgoran enemies: make boss units (spawned by mining the vaults) have much lower health.
-- Mod gives them max health of 100k times level. Level is 1-10 determined by evolution.
-- For comparison, behemoth biter has 3k health.
for level = 1, 10 do
	local name = "walking-electric-unit-boss-"..level
	data.raw.unit[name].max_health = level * 1000
end

-- Fulgoran enemies: still require mining the vault ruin.
data.raw.technology["recycling"].research_trigger.entity="fulgoran-ruin-vault"

-- Fulgoran enemies: remove scrap drop from enemies.
for _, unit in pairs(data.raw.unit) do
	if unit.loot and #unit.loot == 1 and unit.loot[1].item == "scrap" then
		unit.loot = nil
	end
end

-- TODO in future, maybe allow mining and growing fulgorites?
--table.insert(data.raw["simple-entity"]["fulgurite"].minable.results, { -- The ID is fulgurite with a U, but the name is fulgorite with an O.
--table.insert(data.raw["simple-entity"]["fulgurite-small"].minable.results, {