-- This file creates cryogenic fluids and recipes - nitrogen/oxygen/hydrogen gases and liquids.

local noh = {
	-- Base/flow colors for oxygen/hydrogen taken from Space Age. Nitrogen colors chosen by analogy.
	nitrogen = {
		baseColor = {.1, .53, 0},
		flowColor = {.68, .93, .2},
		boilsAt = -196,
	},
	oxygen = {
		baseColor = {0.0, 0.1, 0.53},
		flowColor = {0.2, 0.68, 0.93},
		boilsAt = -183,
	},
	hydrogen = {
		baseColor = {0.53, 0.1, 0},
		flowColor = {0.93, 0.68, 0.2},
		boilsAt = -253,
	},
}

-- Create gases.
for name, data in pairs(noh) do
	local gas = copy(FLUID.fluorine)
	gas.name = name .. "-gas"
	gas.auto_barrel = true
	Icon.set(gas, "LSA/cryo/" .. name .. "-gas")
	gas.base_color = data.baseColor
	gas.flow_color = data.flowColor
	Fluid.setSimpleTemp(gas, data.boilsAt, false, 10)
	extend{gas}
end

-- Create compressed nitrogen gas.
local cn = copy(FLUID["nitrogen-gas"])
cn.name = "compressed-nitrogen-gas"
cn.auto_barrel = true
Icon.set(cn, "LSA/cryo/compressed-nitrogen-gas")
extend{cn}

-- Create liquid nitrogen.
local liquidNitrogen = copy(FLUID["fluoroketone-cold"])
liquidNitrogen.name = "liquid-nitrogen"
liquidNitrogen.auto_barrel = true
Icon.set(liquidNitrogen, "LSA/cryo/liquid-nitrogen")
liquidNitrogen.base_color = {.1, .53, 0}
liquidNitrogen.flow_color = {.68, .93, .2}
Fluid.setSimpleTemp(liquidNitrogen, noh.nitrogen.boilsAt, true, 10)
extend{liquidNitrogen}

-- Set temps for liquid O/H.
Fluid.setSimpleTemp(FLUID["thruster-oxidizer"], noh.oxygen.boilsAt, true, 10)
Fluid.setSimpleTemp(FLUID["thruster-fuel"], noh.hydrogen.boilsAt, true, 10)

-- Edit thruster fuel and oxidizer (which we're renaming to liquid hydrogen and oxygen respectively) to use new icons.
Icon.set(FLUID["thruster-fuel"], "LSA/cryo/liquid-hydrogen")
Icon.set(FLUID["thruster-oxidizer"], "LSA/cryo/liquid-oxygen")

------------------------------------------------------------------------
--- REFRIGERATION RECIPES.

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

------------------------------------------------------------------------
--- RECIPES FOR OBTAINING GASES.

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

-- Syngas separation: 100 syngas -> 50 hydrogen gas
Recipe.make{
	copy = nitrogenCompressionRecipe,
	recipe = "syngas-separation",
	ingredients = {
		{"syngas", 100},
	},
	results = {
		{"hydrogen-gas", 50},
	},
	icons = {"hydrogen-gas", "syngas"}, -- TODO better icons
}
Tech.addRecipeToTech("syngas-separation", "cryogenic-plant") -- TODO tech

-- Air separation: (air) -> 100 nitrogen + 100 oxygen
-- TODO add surface condition so you can't do this on Fulgora.
-- TODO probably add air separator as a separate building? Since Hurricane has graphics for air filterer.
Recipe.make{
	copy = nitrogenCompressionRecipe,
	recipe = "air-separation",
	ingredients = {
	},
	results = {
		{"nitrogen-gas", 100},
		{"oxygen-gas", 100},
	},
	icons = {"nitrogen-gas", "oxygen-gas"}, -- TODO better icons
}
Tech.addRecipeToTech("air-separation", "cryogenic-plant") -- TODO tech

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