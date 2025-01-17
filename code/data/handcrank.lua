-- This file creates "basic electricity" tech based on Eradicator's Hand Crank Deluxe mod.
-- I disabled that mod's recipe and tech, going to create them again but different.

local Table = require("code.util.table")
local Tech = require("code.util.tech")

-- Create tech.
local handCrankTech = {
	type = "technology",
	name = "basic-electricity",
	icon = "__eradicators-hand-crank-redux__/sprite/hcg-technology.png",
	icon_size = 128,
	effects = {
		{type = "unlock-recipe", recipe = "copper-cable"},
		{type = "unlock-recipe", recipe = "er-hcg"},
		{type = "unlock-recipe", recipe = "small-electric-pole"},
		-- Power Overload notices that the small-electric-pole recipe is unlocked here, and adds the fuse recipe.
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
local handCrankRecipe = Table.copyAndEdit(data.raw.recipe["assembling-machine-1"], {
	name = "er-hcg",
	ingredients = {
		{type = "item", name = "iron-plate", amount = 4},
		{type = "item", name = "iron-gear-wheel", amount = 4},
		{type = "item", name = "copper-cable", amount = 2},
	},
	results = {
		{type = "item", name = "er-hcg", amount = 1},
	},
})
data:extend({handCrankRecipe})

-- Make the offshore pump require electricity, since we have a way to generate electricity before offshore pump now.
for _, name in pairs{"offshore-pump", "lava-pump"} do
	data.raw["offshore-pump"][name].energy_usage = "30kW"
	data.raw["offshore-pump"][name].energy_source = data.raw["assembling-machine"]["assembling-machine-1"].energy_source
end