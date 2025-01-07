-- Modifying the gas boiler, from Adamo's Gas Furnace mod.
-- local gasBoilerEnt = data.raw.boiler["gas-boiler"]

-- Change recipe (from pump + boiler) to pipe + stone brick + steel.
data.raw.recipe["gas-boiler"].ingredients = {
	{ type = "item", name = "steel-plate", amount = 4 },
	{ type = "item", name = "stone-brick", amount = 10 },
	{ type = "item", name = "pipe", amount = 8 },
}

-- Also change the non-fluid boiler, shouldn't require stone furnaces.
data.raw.recipe["boiler"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 8 },
	{ type = "item", name = "stone-brick", amount = 10 },
	{ type = "item", name = "pipe", amount = 4 },
}