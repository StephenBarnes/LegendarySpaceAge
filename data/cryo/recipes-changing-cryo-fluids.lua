-- This file creates recipes that change cryo fluids (N/O/H liquid/gas) into other cryo fluids.

-- TODO add crafting machine tints for all of these recipes.
-- TODO check these recipes' categories - some should be in chem plant, some in chem plant and EM plant, etc.

-- Create recipe for nitrogen compression and heat exchange.
-- 100 nitrogen gas + 10 water + significant electricity -> 100 compressed nitrogen gas + 100 steam
local nitrogenCompressionRecipe = Recipe.make{
	copy = "fluoroketone-cooling",
	recipe = "nitrogen-compression",
	clearLocalisedName = true,
	ingredients = {
		{"nitrogen-gas", 100},
		{"water", 10},
	},
	results = {
		{"compressed-nitrogen-gas", 100},
		{"steam", 100},
	},
	enabled = false,
	icons = {"compressed-nitrogen-gas", "nitrogen-gas", "water"}, -- TODO better icons
}
Tech.addRecipeToTech("nitrogen-compression", "cryogenic-plant") -- TODO add to something else

-- Create recipe for nitrogen expansion: 100 compressed nitrogen gas -> 50 liquid nitrogen + 50 nitrogen gas
Recipe.make{
	copy = "nitrogen-compression",
	recipe = "nitrogen-expansion",
	ingredients = {
		{"compressed-nitrogen-gas", 100},
	},
	results = {
		{"liquid-nitrogen", 50},
		{"nitrogen-gas", 50},
	},
	icons = {"compressed-nitrogen-gas", "liquid-nitrogen", "nitrogen-gas"}, -- TODO better icons
	iconArrangement = "decomposition",
}
Tech.addRecipeToTech("nitrogen-expansion", "cryogenic-plant") -- TODO add to something else

-- Create recipe for oxygen cascade cooling: 100 oxygen gas + 100 liquid nitrogen -> 50 liquid oxygen + 50 oxygen gas + 100 nitrogen gas
Recipe.make{
	copy = nitrogenCompressionRecipe,
	recipe = "oxygen-cascade-cooling",
	ingredients = {
		{"oxygen-gas", 100},
		{"liquid-nitrogen", 100},
	},
	results = {
		{"thruster-oxidizer", 50},
		{"oxygen-gas", 50},
		{"nitrogen-gas", 100},
	},
	icons = {"thruster-oxidizer", "liquid-nitrogen"}, -- TODO better icons
}
Tech.addRecipeToTech("oxygen-cascade-cooling", "cryogenic-plant") -- TODO add to something else

-- Create recipe for hydrogen cascade cooling: 100 hydrogen gas + 100 liquid oxygen + 100 liquid nitrogen -> 50 liquid hydrogen + 50 hydrogen gas + 100 oxygen gas + 100 nitrogen gas
Recipe.make{
	copy = nitrogenCompressionRecipe,
	recipe = "hydrogen-cascade-cooling",
	ingredients = {
		{"hydrogen-gas", 100},
		{"thruster-oxidizer", 100},
		{"liquid-nitrogen", 100},
	},
	results = {
		{"thruster-fuel", 50},
		{"hydrogen-gas", 50},
		{"oxygen-gas", 100},
		{"nitrogen-gas", 100},
	},
	icons = {"thruster-fuel", "thruster-oxidizer"}, -- TODO better icons
}
Tech.addRecipeToTech("hydrogen-cascade-cooling", "cryogenic-plant") -- TODO add to something else
-- TODO add more fluid I/O to cryogenic plant, so this actually works.