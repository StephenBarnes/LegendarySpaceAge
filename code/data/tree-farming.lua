--[[ This file adjusts tree farming, adds recipes for fertilizer, etc.
TODO
]]

local Table = require("code.util.table")
local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

-- Move tree farming tech to early game.
data.raw.technology["fish-breeding"].prerequisites = {"agricultural-science-pack"}
data.raw.technology["tree-seeding"].prerequisites = {"automation"}
-- TODO here we should also make the ammonia tech a prereq, and then add fertilizer tree-seeding tech.
data.raw.technology["tree-seeding"].unit = {
	count = 10,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
	},
}
data.raw.technology["tree-seeding"].effects = {
	{
		type = "unlock-recipe",
		recipe = "agricultural-tower",
	},
	-- TODO add unlocks for fertilizer item, and "tree planter" item (fertilizer+seeds).
}

-- Hide the "wood processing" recipe. It converts wood to seeds; we're rather having trees directly yield seeds.
Recipe.hide("wood-processing")

-- Cut out the agriculture tech on Gleba.
Tech.hideTech("agriculture")
for _, techName in pairs{"jellynut", "yumako", "slipstack-propagation"} do
	data.raw.technology[techName].prerequisites = {"planet-discovery-gleba"}
end

-- Nutrients-from-spoilage recipe should be only in biochambers, and then put it in biochamber tech. (It was in agriculture tech, which we're hiding.)
Tech.addRecipeToTech("nutrients-from-spoilage", "biochamber", 3)
data.raw.recipe["nutrients-from-spoilage"].category = "organic"