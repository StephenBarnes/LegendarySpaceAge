local Tech = {}

local Table = require("code.util.table")

Tech.addRecipeToTech = function(recipeName, techName, index)
	local unlock = {
		type = "unlock-recipe",
		recipe = recipeName,
	}
	local tech = data.raw.technology[techName]
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
	local tech = data.raw.technology[techName]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techName.." to add science pack "..sciencePackName.." to.")
		return
	end
	table.insert(tech.unit.ingredients, {sciencePackName, 1})
end

Tech.hideTech = function(techName)
	local tech = data.raw.technology[techName]
	if tech == nil then
		log("Couldn't find tech "..techName.." to hide.")
		return
	end
	tech.enabled = false
	tech.hidden = true
end

Tech.addTechDependency = function(firstTech, secondTech)
	local secondTechData = data.raw.technology[secondTech]
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
	if data.raw.technology[secondTech] ~= nil and data.raw.technology[firstTech] ~= nil then
		Tech.addTechDependency(firstTech, secondTech)
	end
end

Tech.replacePrereq = function(techName, oldPrereq, newPrereq)
	for i, prereq in pairs(data.raw.technology[techName].prerequisites) do
		if prereq == oldPrereq then
			data.raw.technology[techName].prerequisites[i] = newPrereq
			return
		end
	end
end

Tech.removePrereq = function(techName, oldPrereq)
	for i, prereq in pairs(data.raw.technology[techName].prerequisites) do
		if prereq == oldPrereq then
			table.remove(data.raw.technology[techName].prerequisites, i)
			return
		end
	end
end

Tech.removeRecipeFromTech = function(recipeName, techName)
	for i, effect in pairs(data.raw.technology[techName].effects) do
		if effect.type == "unlock-recipe" and effect.recipe == recipeName then
			table.remove(data.raw.technology[techName].effects, i)
			return
		end
	end
end

Tech.disable = function(techName)
	local tech = data.raw.technology[techName]
	if tech == nil then
		log("Couldn't find tech "..techName.." to disable.")
		return
	end
	tech.enabled = false
	tech.hidden = true
end

Tech.addEffect = function(tech, effect)
	if not tech.effects then
		tech.effects = {effect}
	else
		table.insert(tech.effects, effect)
	end
end

Tech.getPrereqList = function(tech)
	return tech.prerequisites or Table.maybeGet(tech.normal, "prerequisites") or Table.maybeGet(tech.expensive, "prerequisites") or {}
end

Tech.getRecursivePrereqs = function(rootTechId)
	-- Given a tech ID, returns a set of tech IDs that are prereqs of that tech, or prereqs of its prereqs, etc.
	-- Returns nil if there's an error.
	local maxLoops = 10000
	local foundPrereqs = {} -- Set of prereqs, mapped to true.
	local frontier = {} -- List of tech IDs to check.
	-- Add initial prereqs
	for _, prereq in pairs(Tech.getPrereqList(data.raw.technology[rootTechId])) do
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
			for _, prereq in pairs(Tech.getPrereqList(data.raw.technology[techId])) do
				table.insert(frontier, prereq)
			end
		end
	end
	return foundPrereqs
end

Tech.reorderRecipeUnlocks = function(techId, recipeIds)
	-- Reorders the recipe unlocks for a tech. Assumes all effects are recipes.
	local tech = data.raw.technology[techId]
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
	local tech = data.raw.technology[techId]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techId.." to set prereqs for.")
		return
	end
	tech.prerequisites = prereqs
end

---@param unit data.TechnologyUnit
Tech.setUnit = function(techId, unit)
	local tech = data.raw.technology[techId]
	if tech == nil then
		log("ERROR: Couldn't find tech "..techId.." to set unit for.")
		return
	end
	tech.unit = unit
end

Tech.copyUnit = function(fromTechId, toTechId)
	local fromTech = data.raw.technology[fromTechId]
	if fromTech == nil then
		log("ERROR: Couldn't find tech "..fromTechId.." to copy unit from.")
		return
	end
	Tech.setUnit(toTechId, fromTech.unit)
end

return Tech