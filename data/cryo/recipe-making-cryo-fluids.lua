-- This file creates recipes that create new cryo fluids from non-cryo ingredients.

local nitrogenCompressionRecipe = RECIPE["nitrogen-compression"]

-- Create recipe for regenerative cooling: 50 liquid nitrogen + 200 nitrogen gas -> 200 compressed nitrogen gas
Recipe.make{
	copy = nitrogenCompressionRecipe,
	recipe = "regenerative-cooling",
	ingredients = {
		{"liquid-nitrogen", 50},
		{"nitrogen-gas", 200},
	},
	results = {
		{"compressed-nitrogen-gas", 200},
	},
	icons = {"nitrogen-gas", "liquid-nitrogen"}, -- TODO better icons
}
Tech.addRecipeToTech("regenerative-cooling", "cryogenic-plant") -- TODO add to its own tech, after cryogenic-plant.

-- Syngas reforming: 100 syngas + 100 steam -> 100 hydrogen gas (plus carbon dioxide, ignored)
Recipe.make{
	copy = nitrogenCompressionRecipe,
	recipe = "syngas-reforming",
	ingredients = {
		{"syngas", 100},
		{"steam", 100},
	},
	results = {
		{"hydrogen-gas", 100},
	},
	icons = {"hydrogen-gas", "syngas", "steam"}, -- TODO better icons
	category = "chemistry",
}
Tech.addRecipeToTech("syngas-reforming", "cryogenic-plant") -- TODO tech

-- Ammonia cracking: 20 ammonia -> 10 hydrogen + 10 nitrogen
-- TODO this should be slow, only worthwhile on Aquilo.
Recipe.make{
	copy = nitrogenCompressionRecipe,
	recipe = "ammonia-cracking",
	ingredients = {
		{"ammonia", 20},
	},
	results = {
		{"hydrogen-gas", 10},
		{"nitrogen-gas", 10},
	},
	icons = {"ammonia", "hydrogen-gas", "nitrogen-gas"}, -- TODO better icons
	iconArrangement = "decomposition",
	category = "chemistry",
}
Tech.addRecipeToTech("ammonia-cracking", "cryogenic-plant") -- TODO tech

-- Electrolysis: 20 water -> 10 hydrogen + 10 oxygen
-- TODO this should be slow, only worthwhile on Fulgora.
Recipe.make{
	copy = nitrogenCompressionRecipe,
	recipe = "electrolysis",
	ingredients = {
		{"water", 20},
	},
	results = {
		{"hydrogen-gas", 10},
		{"oxygen-gas", 10},
	},
	icons = {"water", "hydrogen-gas", "oxygen-gas"}, -- TODO better icons
	iconArrangement = "decomposition",
}
Tech.addRecipeToTech("electrolysis", "cryogenic-plant") -- TODO tech