-- This file contains functions for creating variants of recipes with certain fluid inputs/outputs removed.

local RecipeVariants = {}

--[[ Given a recipe for furnaces, with gas input (air or oxygen) and gas outputs (flue gas etc), create variants for stone furnaces (which vent their gases) and Nauvis/Gleba furnaces (which get oxygen for free).
The arg is the canonical recipe, shown in Factoriopedia.
TODO rather refactor this to a file that runs in furnaces-dff, not a util file. Loop over all smelting recipes and add variants.
]]
---@param recipeName string
RecipeVariants.addSmeltingVariants = function(recipeName)
	local recipe = RECIPE[recipeName]
	assert(recipe ~= nil, "Recipe "..recipeName.." not found")
	-- TODO
end

-- Can't add this to carbon furnaces, since they would be able to do heating recipes without oxygen/air.
-- TODO add recipe variants for that too.

return RecipeVariants