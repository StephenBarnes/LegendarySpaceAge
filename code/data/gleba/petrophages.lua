--[[ This file creates petrophages (items+recipes), which are bred using dry gas (and nutrients for biochambers) and decay to pitch (which can be processed into heavy fractions).
Petrophages are the only way to get heavy petro fractions on Gleba, which are needed for explosives, plastic, lubricant.
(After shipping Gleba science, you get techs that let you make plastic and lubricant more cheaply.)
Petrophages are also the only way to get heavier petrochem fractions on spaceships, which are needed for explosives, which are needed for missiles, which are needed for the trip to Aquilo.

Petrophage breeding increases the number of petrophages, but they keep spoilage from ancestors. Have to spend bioflux to refresh them.

Pitch is 3MJ. Dry gas is 800kJ. Recipe 1 -> 2 is actually ->3 from biochamber, so produces 6MJ, so should consume 7.5 dry gas.
]]

local petrophageDir = "__LegendarySpaceAge__/graphics/gleba/petrophages/"

-- Create item.
local petrophage = table.deepcopy(data.raw.item["iron-bacteria"])
petrophage.name = "petrophage"
petrophage.icon = petrophageDir .. "1.png"
petrophage.pictures = {}
for i=1,4 do
	petrophage.pictures[i] = {
		filename = petrophageDir .. i .. ".png",
		width = 64,
		height = 64,
	}
end
petrophage.spoil_ticks = 60 * 60 * 2 -- 2 minutes
petrophage.spoil_result = "pitch"
petrophage.hidden = false
petrophage.hidden_in_factoriopedia = false
petrophage.subgroup = "slipstacks-and-boompuffs"
petrophage.order = "21"
data:extend{petrophage}

-- Create recipe for breeding petrophages.
local cultivationRecipe = table.deepcopy(data.raw.recipe["iron-bacteria-cultivation"])
cultivationRecipe.name = "petrophage-cultivation"
cultivationRecipe.ingredients = {
	{type="fluid", name="dry-gas", amount=10},
	{type="item", name="petrophage", amount=1},
}
cultivationRecipe.results = {
	{type="item", name="petrophage", amount=2},
}
cultivationRecipe.energy_required = 2
cultivationRecipe.icon = nil
cultivationRecipe.icons = {
	table.deepcopy(data.raw.fluid["dry-gas"].icons[1]),
	{icon = petrophageDir .. "4.png", icon_size = 64, scale=0.4, mipmap_count=4, shift={4, 4}},
}
cultivationRecipe.icons[1].scale = 0.4
cultivationRecipe.icons[1].shift = {-4, -4}
cultivationRecipe.hidden = false
cultivationRecipe.hidden_in_factoriopedia = false
cultivationRecipe.surface_conditions = nil
cultivationRecipe.subgroup = "slipstacks-and-boompuffs"
cultivationRecipe.order = "22"
data:extend{cultivationRecipe}

-- Create recipe for refreshing petrophages.
local refreshRecipe = table.deepcopy(cultivationRecipe)
refreshRecipe.name = "refresh-petrophages"
refreshRecipe.ingredients = {
	{type="item", name="petrophage", amount=3},
}
refreshRecipe.results = {
	{type="item", name="petrophage", amount=1, percent_spoiled = 0},
}
refreshRecipe.result_is_always_fresh = true
refreshRecipe.icon = petrophageDir .. "refresh.png"
refreshRecipe.icons = nil
refreshRecipe.subgroup = "slipstacks-and-boompuffs"
refreshRecipe.order = "23"
data:extend{refreshRecipe}

-- Adjust the bacteria-cultivation tech to include the new recipes.
local tech = data.raw.technology["bacteria-cultivation"]
tech.effects = {
	{type = "unlock-recipe", recipe = "petrophage-cultivation"},
	{type = "unlock-recipe", recipe = "refresh-petrophages"},
}
tech.icon = petrophageDir .. "tech.png"
tech.prerequisites = {"filtration-gleban-slime"}
tech.research_trigger = {
	type = "craft-item",
	item = "petrophage",
	amount = 1,
}