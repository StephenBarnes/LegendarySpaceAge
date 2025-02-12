-- This file creates "basic electricity" tech based on Eradicator's Hand Crank Deluxe mod.
-- I disabled that mod's recipe and tech, going to create them again but different.

-- Create tech.
local handCrankTech = {
	type = "technology",
	name = "basic-electricity",
	icon = "__eradicators-hand-crank-redux__/sprite/hcg-technology.png",
	icon_size = 128,
	effects = {
		{type = "unlock-recipe", recipe = "er-hcg"},
		{type = "unlock-recipe", recipe = "small-electric-pole"},
		{type = "unlock-recipe", recipe = "copper-cable"},
		-- Power Overload notices that the small-electric-pole recipe is unlocked here, and adds the fuse recipe, which I then remove and move to electric-energy-distribution-1.
	},
	prerequisites = {},
	research_trigger = {
		type = "craft-item",
		item = "ingot-iron-hot",
		count = 10,
	},
	order = "000",
}
data:extend({handCrankTech})
Tech.removeRecipesFromTechs({"copper-cable", "small-electric-pole"}, {"electronics"})

-- Create recipe.
local handCrankRecipe = table.deepcopy(RECIPE["assembling-machine-1"])
handCrankRecipe.name = "er-hcg"
handCrankRecipe.ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
}
handCrankRecipe.results = {{type = "item", name = "er-hcg", amount = 1}}
handCrankRecipe.order = "a"
data:extend({handCrankRecipe})

-- Make the offshore pump require electricity, since we have a way to generate electricity before offshore pump now.
for _, name in pairs{"offshore-pump", "lava-pump"} do
	data.raw["offshore-pump"][name].energy_usage = "30kW"
	data.raw["offshore-pump"][name].energy_source = data.raw["assembling-machine"]["assembling-machine-1"].energy_source
end

-- Move to start of row.
ITEM["er-hcg"].order = "a1"