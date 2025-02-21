-- Modifying the gas boiler, from Adamo's Gas Furnace mod.

local gasBoilerEnt = RAW.boiler["gas-boiler"]
local item = ITEM["gas-boiler"]

-- Should only be able to place where there's oxygen.
gasBoilerEnt.surface_conditions = RAW["mining-drill"]["burner-mining-drill"].surface_conditions

-- Move gas boiler to steam-power tech.
Tech.removeRecipeFromTech("gas-boiler", "fluid-handling")
-- Adding it to steam-power in tech-progression.lua.

-- Change icon to be consistent with other fluid-fuelled stuff.
item.icons = {
	{icon = "__gas-boiler__/graphics/icons/gas-boiler.png", icon_size = 32, scale = 1, shift = {2, 0}},
	{icon = FLUID["petroleum-gas"].icons[1].icon, icon_size = 64, scale = 0.3, shift = {-5, 6}, tint = FLUID["petroleum-gas"].icons[1].tint},
}