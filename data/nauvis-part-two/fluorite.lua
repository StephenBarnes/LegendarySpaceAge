-- This file adds fluorite item, hydrofluoric acid, and adjusts uranium patches on Nauvis to also produce some fluorite.

-- Create fluorite item.
local item = copy(ITEM["uranium-ore"])
item.name = "fluorite"
item.order = item.order .. "-2"
Icon.set(item, "LSA/nuclear/fluorite-2")
Icon.variants(item, "LSA/nuclear/fluorite-%", 3)
extend{item}

-- Create hydrofluoric acid fluid
local hydrofluoricAcid = copy(FLUID["fluoroketone-cold"])
hydrofluoricAcid.name = "hydrofluoric-acid"
hydrofluoricAcid.auto_barrel = true -- Apparently people ship it regularly IRL.
-- TODO maybe a different icon?
-- TODO maybe different fluid flow colors.
hydrofluoricAcid.heat_capacity = nil
hydrofluoricAcid.max_temperature = nil
hydrofluoricAcid.default_temperature = 25
hydrofluoricAcid.gas_temperature = 100 -- to make it a liquid.
extend{hydrofluoricAcid}

-- In chem plant: 1 fluorite + 1 sulfuric acid + 1 water -> 1 hydrofluoric acid + 1 stone (representing gypsum)
local hydrofluoricAcidRecipe = Recipe.make{
	copy = "ammoniacal-solution-separation",
	recipe = "hydrofluoric-acid",
	ingredients = {
		{"fluorite", 1},
		{"sulfuric-acid", 10},
		{"water", 10},
	},
	results = {
		{"hydrofluoric-acid", 10, type = "fluid"},
		--{"stone", 1, show_details_in_recipe_tooltip = false},
	},
	main_product = "hydrofluoric-acid",
	clearIcons = true,
	category = "chemistry",
	allow_decomposition = true,
	allow_as_intermediate = true,
	allow_quality = true,
	allow_productivity = true,
}

-- Add fluorite to uranium patches.
-- Going to make Nauvis have lots of uranium but not enough fluorite to process it all; and then Aquilo is the opposite, lots of fluorine but not enough uranium. So the player gains a lot by shipping uranium or fluorine between the two.
RAW.resource["uranium-ore"].minable.results = {
	{type = "item", name = "uranium-ore", amount = 1},
	{type = "item", name = "fluorite", amount = 1, probability = 0.05},
}
RAW.resource["uranium-ore"].subgroup = ITEM["uranium-ore"].subgroup
RAW.resource["uranium-ore"].category = "hard-solid" -- Only minable by tungsten mining drills.