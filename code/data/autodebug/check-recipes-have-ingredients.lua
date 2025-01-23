--- This file checks that for every recipe unlocked by a tech, the ingredients are available once that tech is unlocked.
--- This catches bugs where e.g. we unlock a recipe requiring rubber, before there are any recipes to produce rubber.

local Table = require("code.util.table")

---@return boolean
local function checkAllRecipesHaveIngredients(toposortedTechs, postTechSets)
	local success = true

	-- Sometimes it's expected that recipes will be unlocked before their ingredients are available.
	-- For example, the barrelling tech unlocks all barrelling recipes, even if the fluid isn't available yet.
	local ignoreMissingIngredients = Table.listToSet{
		-- Nothing currently.
	}
	-- Add the barrelling/unbarrelling recipes.
	local ignoreRecipeCategories = Table.listToSet{"barrelling", "unbarrelling"}
	for _, recipe in pairs(data.raw.recipe) do
		if ignoreRecipeCategories[recipe.category] then
			ignoreMissingIngredients[recipe.name] = true
		end
	end

	-- TODO
	return success
end

return checkAllRecipesHaveIngredients