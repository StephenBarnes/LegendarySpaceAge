--[[ This file creates a new techs for barrelling and gas tanks, moves barrelling recipes to the new tech, and creates gas tanks and their recipes, etc. Also adds fuel values to barrels and tanks. ]]

-- Create the new tech.
local gasTankTech = copy(TECH["oil-processing"])
gasTankTech.name = "fluid-containers"
gasTankTech.prerequisites = {"fluid-handling"}
gasTankTech.effects = {
	{type = "unlock-recipe", recipe = "barrel"},
	{type = "unlock-recipe", recipe = "gas-tank"},
}
Icon.set(gasTankTech, "LSA/gas-tanks/tech")
gasTankTech.research_trigger = nil
gasTankTech.unit = {
	count = 50,
	time = 15,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
	},
}
extend{gasTankTech}

-- Create the new empty gas tank item.
local emptyGasTankTint = {.3, .3, .3}
local emptyGasTankItem = copy(ITEM["barrel"])
emptyGasTankItem.name = "gas-tank"
emptyGasTankItem.icon = nil
emptyGasTankItem.icons = {
	{icon = "__LegendarySpaceAge__/graphics/gas-tanks/straight/tank.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/gas-tanks/straight/overlay-side.png", icon_size = 64, scale = 0.5, tint = emptyGasTankTint},
	{icon = "__LegendarySpaceAge__/graphics/gas-tanks/straight/overlay-top.png", icon_size = 64, scale = 0.5, tint = emptyGasTankTint},
}
emptyGasTankItem.order = ITEM["barrel"].order .. "-1"
extend{emptyGasTankItem}

-- Create recipe for empty gas tank.
local emptyGasTankRecipe = copy(RECIPE["barrel"])
emptyGasTankRecipe.name = "gas-tank"
emptyGasTankRecipe.ingredients = {
	{type = "item", name = "panel", amount = 1},
	{type = "item", name = "fluid-fitting", amount = 1},
}
emptyGasTankRecipe.results = {{type = "item", name = "gas-tank", amount = 1}}
extend{emptyGasTankRecipe}

-- Edit recipe for barrel - previously only 1 steel plate.
RECIPE["barrel"].ingredients = {
	{type = "item", name = "panel", amount = 1},
	{type = "item", name = "frame", amount = 1},
}

-- TODO look through fluids, maybe add more barrelling recipes. Eg for Gleban slime.
-- Allow more fluids in barrels and tanks.
FLUID["steam"].auto_barrel = false -- In the real world, seems it's hard to do without constant heating and some amount of condensation.
FLUID["holmium-solution"].auto_barrel = true
FLUID["electrolyte"].auto_barrel = true
FLUID["thruster-oxidizer"].auto_barrel = true
FLUID["thruster-fuel"].auto_barrel = true
FLUID["ammonia"].auto_barrel = true
FLUID["fluorine"].auto_barrel = true -- It's not that hard to barrel and transport IRL, so I'll allow it.
FLUID["lithium-brine"].auto_barrel = true
FLUID["fulgoran-sludge"].auto_barrel = true -- Could be interesting to ship it around and filter it elsewhere.

-- Fluid wagon stores 50k fluid. Cargo wagon stores 40 stacks of 10 barrels, each having 100 fluid, so 40k total.
-- So, I'll nerf fluid wagons to 10k, so there's reason to use barrels.
RAW["fluid-wagon"]["fluid-wagon"].capacity = 10000