-- Makes a list of each thing (item or fluid) to recipes that use it as ingredient.

local Util = require("data.autodebug.util")

function getThingToRecipes()
	local result = {}
	for _, recipe in pairs(RECIPE) do
		if not recipe.parameter then
			if recipe.ingredients == nil then
				log("Legendary Space Age WARNING: recipe " .. recipe.name .. " has no ingredients.")
			end
			for _, ingredient in pairs(recipe.ingredients or {}) do
				local ingredientName = Util.getCanonicalName(ingredient, nil)
				Table.addToValList(result, ingredientName, recipe.name)
			end
		end
	end
	return result
end

return getThingToRecipes