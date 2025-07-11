local Tech = {}

-- Table of science packs in order of progression. Some are at the same level, eg the planetary science packs.
Tech.sciencePackOrder = {
	automation = 1,
	logistic = 2,
	military = 3,
	chemical = 3,
	production = 4,
	utility = 5,
	space = 6,
	asteroid = 7,
	metallurgic = 8,
	agricultural = 8,
	electromagnetic = 8,
	nuclear = 9,
	cryogenic = 10,
	promethium = 11,
}

---@param recipeName string
---@param techName string
---@param index number?
---@param assertRecipeExists boolean?
Tech.addRecipeToTech = function(recipeName, techName, index, assertRecipeExists)
	if assertRecipeExists == true then
		assert(RECIPE[recipeName] ~= nil, "Recipe "..recipeName.." not found.")
		RECIPE[recipeName].enabled = false -- Don't enable at start.
	end
	local unlock = {
		type = "unlock-recipe",
		recipe = recipeName,
	}
	local tech = TECH[techName]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techName.." to add recipe "..recipeName.." to.")
		return
	end
	if not tech.effects then
		tech.effects = {unlock}
	else
		if index == nil then
			table.insert(tech.effects, unlock)
		else
			table.insert(tech.effects, index, unlock)
		end
	end
end

Tech.addSciencePack = function(techName, sciencePackName)
	local tech = TECH[techName]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techName.." to add science pack "..sciencePackName.." to.")
		return
	end
	-- Check if it already has the science pack.
	for _, ingredient in pairs(tech.unit.ingredients) do
		if ingredient[1] == sciencePackName then
			return
		end
	end
	table.insert(tech.unit.ingredients, {sciencePackName, 1})
end

Tech.hide = function(techOrName)
	local tech = nil
	if type(techOrName) == "string" then
		tech = TECH[techOrName]
	else
		tech = techOrName
	end
	if tech == nil then
		log("Couldn't find tech "..serpent.line(techOrName).." to hide.")
		return
	end
	tech.enabled = false
	tech.hidden = true
end

Tech.setEffects = function(techName, effects)
	local tech = TECH[techName]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techName.." to set effects for.")
		return
	end
	tech.effects = effects
end

Tech.moveRecipeToTech = function(recipeName, oldTechName, newTechName, index)
	Tech.removeRecipeFromTech(recipeName, oldTechName)
	Tech.addRecipeToTech(recipeName, newTechName, index)
end

Tech.addTechDependency = function(firstTech, secondTech)
	local secondTechData = TECH[secondTech]
	if secondTechData == nil then
		log("ERROR: Couldn't find tech "..secondTech.." to add dependency "..firstTech.." to.")
		return
	end
	if secondTechData.prerequisites == nil then
		secondTechData.prerequisites = {firstTech}
	else
		table.insert(secondTechData.prerequisites, firstTech)
	end
end

Tech.tryAddTechDependency = function(firstTech, secondTech)
	if TECH[secondTech] ~= nil and TECH[firstTech] ~= nil then
		Tech.addTechDependency(firstTech, secondTech)
	end
end

Tech.replacePrereq = function(techName, oldPrereq, newPrereq)
	local tech = TECH[techName]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techName.." to replace prereq "..oldPrereq.." with "..newPrereq..".")
		return
	end
	if tech.prerequisites == nil then
		log("ERROR: Tech "..techName.." has no prerequisites.")
	end
	for i, prereq in pairs(tech.prerequisites or {}) do
		if prereq == oldPrereq then
			tech.prerequisites[i] = newPrereq
			return
		end
	end
end

Tech.removePrereq = function(techName, oldPrereq)
	for i, prereq in pairs(TECH[techName].prerequisites) do
		if prereq == oldPrereq then
			table.remove(TECH[techName].prerequisites, i)
			return
		end
	end
end

Tech.hasPrereq = function(techName, prereqName)
	local tech = TECH[techName]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techName.." to check for prereq "..prereqName..".")
		return false
	end
	return Table.hasEntry(prereqName, tech.prerequisites or {})
end

Tech.removeRecipesFromTechs = function(recipeList, techNames)
	local recipeSet = Table.listToSet(recipeList)

	local recipeHasBeenRemoved = {}
	for _, recipe in pairs(recipeList) do
		recipeHasBeenRemoved[recipe] = false
	end

	for _, techName in pairs(techNames) do
		local tech = TECH[techName]
		if tech == nil then
			log("Error: Couldn't find tech "..techName.." to remove recipes from.")
		else
			local anyChanges = false
			local newEffects = {}
			for _, effect in pairs(tech.effects) do
				if effect.type ~= "unlock-recipe" or not recipeSet[effect.recipe] then
					table.insert(newEffects, effect)
				else
					anyChanges = true
					recipeHasBeenRemoved[effect.recipe] = true
				end
			end
			tech.effects = newEffects
			if not anyChanges then
				log("Warning: No recipes to remove from tech "..techName..".")
			end
		end
	end

	for recipe, removed in pairs(recipeHasBeenRemoved) do
		if not removed then
			log("Warning: Recipe "..recipe.." was not removed from any techs.")
		end
	end
end

Tech.removeRecipeFromTech = function(recipeName, techName)
	Tech.removeRecipesFromTechs({recipeName}, {techName})
end

Tech.disable = function(techName)
	local tech = TECH[techName]
	if tech == nil then
		log("Couldn't find tech "..techName.." to disable.")
		return
	end
	tech.enabled = false
	tech.hidden = true
end

Tech.addEffect = function(tech, effect, index)
	if type(tech) == "string" then tech = TECH[tech] end
	if not tech.effects then
		tech.effects = {effect}
	else
		table.insert(tech.effects, index, effect)
	end
end

Tech.getRecursivePrereqs = function(rootTechId)
	-- Given a tech ID, returns a set of tech IDs that are prereqs of that tech, or prereqs of its prereqs, etc.
	-- Returns nil if there's an error.
	local maxLoops = 10000
	local foundPrereqs = {} -- Set of prereqs, mapped to true.
	local frontier = {} -- List of tech IDs to check.
	-- Add initial prereqs
	for _, prereq in pairs(TECH[rootTechId].prerequisites or {}) do
		table.insert(frontier, prereq)
	end
	local loops = 0 -- To prevent infinite loops.
	while #frontier > 0 do
		loops = loops + 1
		if loops > maxLoops then
			log("ERROR: Too many iterations when finding prereqs of tech "..rootTechId..".")
			return nil
		end
		local techId = table.remove(frontier)
		if techId == rootTechId then
			log("ERROR: Tech "..rootTechId.." has a prereq cycle.")
			return nil
		end
		if not foundPrereqs[techId] then
			foundPrereqs[techId] = true
			for _, prereq in pairs(TECH[techId].prerequisites or {}) do
				table.insert(frontier, prereq)
			end
		end
	end
	return foundPrereqs
end

Tech.reorderRecipeUnlocks = function(techId, recipeIds)
	-- Reorders the recipe unlocks for a tech. Assumes all effects are recipes.
	local tech = TECH[techId]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techId.." to reorder recipe unlocks for.")
		return
	end
	local unlocks = tech.effects
	if unlocks == nil then
		log("ERROR: Nil unlocks for tech "..techId..".")
		return
	end
	if #unlocks ~= #recipeIds then
		log("ERROR: Number of recipe unlocks for tech "..techId.." doesn't match number of recipe IDs given: "..#unlocks.." vs "..#recipeIds)
		return
	end
	local recipeIdsSet = {}
	for _, recipeId in pairs(recipeIds) do
		recipeIdsSet[recipeId] = true
	end
	for _, unlock in pairs(unlocks) do
		if unlock.type ~= "unlock-recipe" then
			log("ERROR: Effect "..unlock.type.." for tech "..techId.." is not a recipe unlock.")
			return
		end
		if recipeIdsSet[unlock.recipe] == nil then
			log("ERROR: Unlock "..unlock.recipe.." for tech "..techId.." is not in recipe IDs.")
			return
		end
	end
	local newEffects = {}
	for _, recipeId in pairs(recipeIds) do
		table.insert(newEffects, {type = "unlock-recipe", recipe = recipeId})
	end
	tech.effects = newEffects
end

Tech.setPrereqs = function(techId, prereqs)
	local tech = TECH[techId]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techId.." to set prereqs for.")
		return
	end
	tech.prerequisites = prereqs
end

---@param unit data.TechnologyUnit
Tech.setUnit = function(techId, unit)
	local tech = TECH[techId]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techId.." to set unit for.")
		return
	end
	tech.unit = unit
end

Tech.copyUnit = function(fromTechId, toTechId)
	local fromTech = TECH[fromTechId]
	assert(fromTech ~= nil, "Couldn't find tech "..fromTechId.." to copy unit from.")
	assert(fromTech.unit ~= nil, "Tech "..fromTechId.." has no unit.")
	Tech.setUnit(toTechId, fromTech.unit)
end

Tech.removeSciencePack = function(sciencePackName, techName)
	local tech = TECH[techName]
	assert(tech ~= nil, "Couldn't find tech "..techName.." to remove science pack "..sciencePackName.." from.")
	assert(tech.unit ~= nil, "Tech "..techName.." has no unit.")
	local newIngredients = {}
	local found = false
	for _, ingredient in pairs(tech.unit.ingredients) do
		if ingredient[1] == sciencePackName then
			found = true
		else
			table.insert(newIngredients, ingredient)
		end
	end
	assert(found, "Science pack "..sciencePackName.." not found in tech "..techName..".")
	tech.unit.ingredients = newIngredients
end

Tech.replaceSciencePack = function(techName, oldSciencePackName, newSciencePackName)
	local tech = TECH[techName]
	assert(tech ~= nil, "Couldn't find tech "..techName.." to replace science pack "..oldSciencePackName.." with "..newSciencePackName..".")
	assert(tech.unit ~= nil, "Tech "..techName.." has no unit.")
	local found = false
	for i, ingredient in pairs(tech.unit.ingredients) do
		assert(ingredient[1] ~= newSciencePackName, "Science pack "..newSciencePackName.." already exists in tech "..techName..".")
		if ingredient[1] == oldSciencePackName then
			tech.unit.ingredients[i] = {newSciencePackName, ingredient[2]}
			found = true
		end
	end
	assert(found, "Science pack "..oldSciencePackName.." not found in tech "..techName..".")
end

Tech.replaceRecipeInTech = function(oldRecipeName, newRecipeName, techName)
	for _, effect in pairs(TECH[techName].effects) do
		if effect.type == "unlock-recipe" and effect.recipe == oldRecipeName then
			effect.recipe = newRecipeName
			return
		end
	end
	log("ERROR: Couldn't find recipe "..oldRecipeName.." in tech "..techName.." to replace with "..newRecipeName..".")
end

---@param maxSciencePacks string|string[]
---@param count number
---@return data.TechnologyUnit
Tech.makeUnit = function(maxSciencePacks, count)
	if type(maxSciencePacks) == "string" then
		maxSciencePacks = {maxSciencePacks}
	end
	local maxSciencePackLevel = -1
	for _, sciencePackPrefix in pairs(maxSciencePacks) do
		local sciencePackLevel = Tech.sciencePackOrder[sciencePackPrefix]
		assert(sciencePackLevel ~= nil, "Science pack \""..sciencePackPrefix.."\" not found in order.")
		maxSciencePackLevel = math.max(maxSciencePackLevel, sciencePackLevel)
	end
	assert(maxSciencePackLevel ~= -1, "No science packs found in order.")
	local ingredients = {}
	for sciencePack, level in pairs(Tech.sciencePackOrder) do
		if level < maxSciencePackLevel then
			ingredients[sciencePack] = 1
		end
	end
	for _, sciencePack in pairs(maxSciencePacks) do
		ingredients[sciencePack] = 1
	end
	local ingredientsList = {}
	for sciencePack, amount in pairs(ingredients) do
		table.insert(ingredientsList, {sciencePack .. "-science-pack", amount})
	end
	return {count = count, ingredients = ingredientsList, time = 3600} -- 3600 ticks = 60 seconds.
end

return Tech