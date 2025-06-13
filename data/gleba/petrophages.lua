--[[ This file creates petrophages (items+recipes), which are bred using dry gas (and nutrients for biochambers) and decay to pitch (which can be processed into heavy fractions).
Petrophages are the only way to get heavy petro fractions on Gleba, which are needed for explosives, plastic, lubricant.
(After shipping Gleba science, you get techs that let you make plastic and lubricant more cheaply.)
Petrophages are also the only way to get heavier petrochem fractions on spaceships, which are needed for explosives, which are needed for missiles, which are needed for the trip to Aquilo.

Petrophage breeding increases the number of petrophages, but they keep spoilage from ancestors. Have to sacrifice some to reduce spoilage or they all spoil and die out.

Pitch is 3MJ. Dry gas is 700kJ. Recipe converts 1 to 2 petrophages, with up to 50% prod, so produces up to 6MJ, so should consume at least 6 / .7 = 8.6 dry gas.
	Unless we want it to be net positive carbon or energy, maybe? Positive-carbon could be interesting on Vulcanus. TODO think about this more
]]

-- Create item.
local petrophage = copy(ITEM["iron-bacteria"])
petrophage.name = "petrophage"
Icon.set(petrophage, "LSA/gleba/petrophages/1")
Icon.variants(petrophage, "LSA/gleba/petrophages/%", 4)
petrophage.spoil_ticks = 2 * MINUTES
petrophage.spoil_result = "pitch"
Item.unhide(petrophage)
extend{petrophage}

-- Create recipe for breeding petrophages.
local cultivationRecipe = Recipe.make{
	copy = "iron-bacteria-cultivation",
	recipe = "petrophage-cultivation",
	ingredients = {
		{"dry-gas", 10, type = "fluid"},
		{"petrophage", 1},
	},
	results = {
		{"petrophage", 2},
	},
	time = 5,
	allow_productivity = true,
	maximum_productivity = 0.5,
	allow_quality = true,
	unhide = true,
}
cultivationRecipe.surface_conditions = nil
cultivationRecipe.icon = nil
cultivationRecipe.icons = {
	copy(FLUID["dry-gas"].icons[1]),
	{icon = "__LegendarySpaceAge__/graphics/gleba/petrophages/4.png", icon_size = 64, scale=0.4, mipmap_count=4, shift={4, 4}},
}
cultivationRecipe.icons[1].scale = 0.4
cultivationRecipe.icons[1].shift = {-4, -4}

-- Create recipe for refreshing petrophages.
Recipe.make{
	copy = cultivationRecipe,
	recipe = "refresh-petrophages",
	ingredients = {
		{"petrophage", 3},
	},
	results = {
		{"petrophage", 1, percent_spoiled = 0},
	},
	time = 1,
	result_is_always_fresh = true,
	allow_productivity = true,
	allow_quality = true,
	maximum_productivity = 2,
	icon = "LSA/gleba/petrophages/refresh",
}

-- Adjust the bacteria-cultivation tech to include the new recipes.
local tech = TECH["bacteria-cultivation"]
tech.effects = {
	{type = "unlock-recipe", recipe = "petrophage-cultivation"},
	{type = "unlock-recipe", recipe = "refresh-petrophages"},
}
Icon.set(tech, "LSA/gleba/petrophages/tech")
tech.prerequisites = {"filtration-gleban-slime"}
tech.research_trigger = {
	type = "craft-item",
	item = "petrophage",
	amount = 1,
}