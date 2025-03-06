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
		{"steam", 10, temperature = 100},
	},
	-- So, this recipe produces 100 steam at 100C, which holds 1 MJ, which is 800kJ in turbine (80% efficiency). So if it takes 5s, then it's 160kW in steam. Machine uses 1MW, but can be reduced to 200kW with efficiency modules. Need to disable speed modules, because otherwise you can eg double the output but still use 200kW with more efficiency modules.
	time = 5,
	allow_quality = false,
	allow_productivity = false,
	allow_speed = false,
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
	allow_quality = false,
	allow_productivity = false,
	allow_speed = true,
	time = 1,
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
	allow_quality = false,
	allow_productivity = false,
	allow_speed = true,
	time = 5,
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
	allow_quality = false,
	allow_productivity = false,
	allow_speed = true,
	time = 10,
}
Tech.addRecipeToTech("hydrogen-cascade-cooling", "cryogenic-plant") -- TODO add to something else
-- TODO add more fluid I/O to cryogenic plant, so this actually works.

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
	allow_speed = true,
	time = 2,
}
-- Will be added to cryogenic-plant-2 tech when that's created.

-- Disable the Space Age recipes for thruster fuel and oxidizer.
Recipe.hide("thruster-fuel")
Recipe.hide("thruster-oxidizer")
Tech.removeRecipeFromTech("thruster-fuel", "space-platform-thruster")
Tech.removeRecipeFromTech("thruster-oxidizer", "space-platform-thruster")
Recipe.hide("advanced-thruster-fuel")
Recipe.hide("advanced-thruster-oxidizer")
Tech.removeRecipeFromTech("advanced-thruster-fuel", "advanced-asteroid-processing")
Tech.removeRecipeFromTech("advanced-thruster-oxidizer", "advanced-asteroid-processing")
