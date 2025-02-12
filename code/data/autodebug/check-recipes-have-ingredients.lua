--- This file checks that for every recipe unlocked by a tech, the ingredients are available once that tech is unlocked.
--- This catches bugs where e.g. we unlock a recipe requiring rubber, before there are any recipes to produce rubber.

local Util = require("code.data.autodebug.util")

local function availableOnAnyPlanet(postTechSets, item)
	for planetName, _ in pairs(Util.allPlanets) do
		if postTechSets["planet:"..planetName] then
			if postTechSets[planetName..":"..item] then
				return true
			end
		end
	end
	return false
end

---@param toposortedTechs string[]
---@param postTechSets any
---@return boolean
local function checkAllRecipesHaveIngredients(toposortedTechs, postTechSets)
	local success = true

	-- Sometimes it's expected that recipes will be unlocked before their ingredients are available.
	-- For example, the barrelling tech unlocks all barrelling recipes, even if the fluid isn't available yet.
	local ignoreRecipes = Table.listToSet{
		-- Nothing currently.
	}
	-- Add the barrelling/unbarrelling recipes.
	local ignoreRecipeSubgroups = Table.listToSet{"fill-barrel", "empty-barrel", "fill-gas-tank", "empty-gas-tank"}
	for _, recipe in pairs(RECIPE) do
		if ignoreRecipeSubgroups[recipe.subgroup] then
			ignoreRecipes[recipe.name] = true
		end
	end

	-- For all techs, check all recipes unlocked by that tech.
	for _, techName in pairs(toposortedTechs) do
		local availablePostTech = postTechSets[techName]
		assert(availablePostTech ~= nil, techName)
		for _, effect in pairs(TECH[techName].effects or {}) do
			if effect.type == "unlock-recipe" then
				local recipeName = effect.recipe
				if not ignoreRecipes[recipeName] then
					local recipe = RECIPE[recipeName]
					assert(recipe ~= nil, recipeName)

					local missingIngredients = {}
					for _, ingredient in pairs(recipe.ingredients) do
						local ingredientName = Util.getCanonicalName(ingredient)
						if not availableOnAnyPlanet(availablePostTech, ingredientName) then
							table.insert(missingIngredients, ingredientName)
						end
					end
					if #missingIngredients ~= 0 then
						log("ERROR: Tech "..techName.." unlocks recipe "..recipeName.." with missing ingredients: "..serpent.line(missingIngredients))
						success = false
					end
				end
			end
		end
	end

	return success
end

return checkAllRecipesHaveIngredients