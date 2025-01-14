-- Modifying the gas boiler, from Adamo's Gas Furnace mod.

local Tech = require("code.util.tech")

local gasBoilerEnt = data.raw.boiler["gas-boiler"]

-- Change recipe (from pump + boiler) to pipe + stone brick + iron.
data.raw.recipe["gas-boiler"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 4 },
	{ type = "item", name = "stone-brick", amount = 10 },
	{ type = "item", name = "pipe", amount = 8 },
}

-- Also change the non-fluid boiler, shouldn't require stone furnaces.
data.raw.recipe["boiler"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 8 },
	{ type = "item", name = "stone-brick", amount = 10 },
	{ type = "item", name = "pipe", amount = 4 },
}

-- Should only be able to place where there's oxygen.
gasBoilerEnt.surface_conditions = data.raw["mining-drill"]["burner-mining-drill"].surface_conditions

-- Move gas boiler to steam-power tech.
Tech.removeRecipeFromTech("gas-boiler", "fluid-handling")
-- Adding it to steam-power in tech-progression.lua.