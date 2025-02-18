-- This file checks that all recipes are either hidden, or enabled at start, or are unlocked by some tech.

local AutodebugUtil = require("data.autodebug.util")

-- Function that checks that a recipe is either hidden, enabled at start, or is unlocked by some tech.
---@param recipe data.RecipePrototype
---@param recipesUnlockedByTechs table<string, boolean>
---@return boolean
local function checkRecipeOk(recipe, recipesUnlockedByTechs)
	if AutodebugUtil.shouldIgnoreRecipe(recipe) then return true end
	if recipe.parameter then
		if recipesUnlockedByTechs[recipe.name] ~= nil then
			log("Legendary Space Age ERROR: recipe " .. recipe.name .. " is a parameter recipe but also unlocked by tech " .. recipesUnlockedByTechs[recipe.name] .. ".")
			return false
		end
		return true
	end
	if recipe.hidden then
		if recipesUnlockedByTechs[recipe.name] ~= nil then
			log("Legendary Space Age ERROR: recipe " .. recipe.name .. " is hidden but also unlocked by tech " .. recipesUnlockedByTechs[recipe.name] .. ".")
			return false
		end
		return true
	end
	if (recipe.enabled == nil or recipe.enabled) then -- Note .enabled == nil implies .enabled == true by default.
		if recipesUnlockedByTechs[recipe.name] ~= nil then
			log("Legendary Space Age ERROR: recipe " .. recipe.name .. " is enabled at start but also unlocked by tech " .. recipesUnlockedByTechs[recipe.name] .. ".")
			return false
		end
		return true
	end
	if recipesUnlockedByTechs[recipe.name] == nil then
		log("Legendary Space Age ERROR: recipe " .. recipe.name .. " is not unlocked by any tech, and is also not hidden or enabled at start.")
		return false
	end
	return true
end

---@return boolean
local function checkRecipesObtainable()
	local success = true

	-- Build set of all recipes that are unlocked by some enabled, non-hidden tech.
	local recipesUnlockedByTechs = {}
	for _, tech in pairs(TECH) do
		if (not tech.hidden) and (tech.enabled == nil or tech.enabled) then
			for _, effect in pairs(tech.effects or {}) do
				if effect.type == "unlock-recipe" then
					recipesUnlockedByTechs[effect.recipe] = tech.name
				end
			end
		end
	end

	-- Check all recipes.
	for _, recipe in pairs(RECIPE) do
		success = success and checkRecipeOk(recipe, recipesUnlockedByTechs)
	end

	return success
end

return checkRecipesObtainable