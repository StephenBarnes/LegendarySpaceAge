-- This file creates recipes that create new cryo fluids from non-cryo ingredients.

local nitrogenCompressionRecipe = RECIPE["nitrogen-compression"]

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
Tech.addRecipeToTech("syngas-reforming", "cryogenic-plant")

-- Ammonia cracking: 20 ammonia -> 10 hydrogen + 10 nitrogen
-- Checked: ammonia cracking is NOT very similar to water electrolysis. So not going to unlock them together, probably.
-- Checked: ammonia cracking uses a catalyst, often nickel or iron-based.
-- TODO this should be slow, worthwhile on Aquilo but only maybe-worthwhile on Nauvis. (Ie getting nitrogen via wood->ammonia should be generally harder than getting it via syngas.)
Recipe.make{
	copy = nitrogenCompressionRecipe,
	recipe = "ammonia-cracking",
	ingredients = {
		{"ammonia", 100},
		{"iron-plate", 1},
	},
	results = {
		{"hydrogen-gas", 100},
		{"nitrogen-gas", 100},
	},
	time = 10,
	icons = {"ammonia", "hydrogen-gas", "nitrogen-gas"},
	iconArrangement = "decomposition",
	category = "chemistry",
	allow_quality = false,
	allow_productivity = false,
}
-- Added to ammonia-2 tech when that's created.

-- Electrolysis: 20 water -> 10 hydrogen + 10 oxygen
-- Checked: electrolysis generally done with liquid water, not steam.
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
	time = 10,
	icons = {"water", "hydrogen-gas", "oxygen-gas"}, -- TODO better icons
	iconArrangement = "decomposition",
	category = "chemistry-or-electronics",
}
-- Added to tech in cryo/techs.lua.