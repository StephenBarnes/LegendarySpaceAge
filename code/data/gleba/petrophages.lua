--[[ This file creates petrophages (items+recipes), which are bred using dry gas (and nutrients for biochambers) and decay to pitch (which can be processed into heavy fractions).
Petrophages are the only way to get heavy petro fractions on Gleba, which are needed for explosives, plastic, lubricant.
(After shipping Gleba science, you get techs that let you make plastic and lubricant more cheaply.)
Petrophages are also the only way to get heavier petrochem fractions on spaceships, which are needed for explosives, which are needed for missiles, which are needed for the trip to Aquilo.

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
data:extend{petrophage}

-- Create recipe.
local petrophageRecipe = table.deepcopy(data.raw.recipe["iron-bacteria-cultivation"])
petrophageRecipe.name = "petrophage"
petrophageRecipe.ingredients = {
	{type="fluid", name="dry-gas", amount=100},
	{type="item", name="petrophage", amount=1},
}
petrophageRecipe.results = {
	{type="item", name="petrophage", amount=2},
}
petrophageRecipe.always_show_products = true
petrophageRecipe.icon = nil -- So it defaults to the petrophage icon.
data:extend{petrophageRecipe}
