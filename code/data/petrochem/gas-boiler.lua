-- Modifying the gas boiler, from Adamo's Gas Furnace mod.

local gasBoilerEnt = data.raw.boiler["gas-boiler"]

-- Should only be able to place where there's oxygen.
gasBoilerEnt.surface_conditions = data.raw["mining-drill"]["burner-mining-drill"].surface_conditions

-- Move gas boiler to steam-power tech.
Tech.removeRecipeFromTech("gas-boiler", "fluid-handling")
-- Adding it to steam-power in tech-progression.lua.