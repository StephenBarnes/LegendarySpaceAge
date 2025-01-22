-- This file makes final edits to recycling recipes, in the data-final-fixes stage.

local Recipe = require("code.util.recipe")
local Recycling = require("__quality__.prototypes.recycling")

-- For spoilable stuff, I don't want to give a way to store them permanently in the form of biochambers etc. Just going to remove them from outputs completely.
-- But not all spoilable stuff, eg iron-plates are spoilable.
local recyclingResultReplacements = {
	["nutrients"] = "spoilage",
	["pentapod-egg"] = "spoilage",
	["slipstack-pearl"] = "spoilage",
	["raw-fish"] = "spoilage",
	["jelly"] = "spoilage",
	["biter-egg"] = "NOTHING",
}
local function recipeNeedsChanging(recipe)
	for _, result in pairs(recipe.results) do
		if recyclingResultReplacements[result.name] ~= nil then
			return true
		end
	end
	return false
end
---@param result1 data.ItemProductPrototype
---@param result2 data.ItemProductPrototype
local function combineResults(result1, result2)
	-- Combines results's numbers. Doesn't work in all edge cases. It doesn't really need to work in all cases, since it's just for recycling, which is not a big mechanic now that quality is gone.
	local comboMin = 0
	local comboMax = 0
	for _, r in pairs({result1, result2}) do
		if r.amount_min ~= nil then comboMin = comboMin + r.amount_min end
		if r.amount_max ~= nil then comboMax = comboMax + r.amount_max end
		if r.amount ~= nil then
			local amount = r.amount
			if r.probability ~= nil then amount = amount * r.probability end
			comboMin = comboMin + amount
			comboMax = comboMax + amount
		end
		if r.extra_count_fraction ~= nil then
			comboMin = comboMin + r.extra_count_fraction
			comboMax = comboMax + r.extra_count_fraction
		end
	end
	local newResult = table.deepcopy(result1)
	if comboMin == comboMax then
		local floor = math.floor(comboMin)
		newResult.amount = floor
		newResult.amount_min = nil
		newResult.amount_max = nil
		if (comboMin - floor) > .1 then newResult.extra_count_fraction = comboMin - floor end
	else
		newResult.amount_min = math.floor(comboMin)
		newResult.amount_max = math.floor(comboMax)
		if newResult.amount_max == 0 then
			newResult.extra_count_fraction = (comboMin + comboMax) / 2
		end
	end
	return newResult
end
local function fixRecyclingRecipe(recipe)
	local needsChanging = recipeNeedsChanging(recipe)
	if not needsChanging then return end
	--log("changing results of "..recipe.name .. ": "..serpent.block(recipe.results))
	local newResultsByName = {}
	for _, result in pairs(recipe.results) do
		local targetName = recyclingResultReplacements[result.name] or result.name
		if targetName ~= "NOTHING" then
			if newResultsByName[targetName] == nil then
				newResultsByName[targetName] = result
			else
				newResultsByName[targetName] = combineResults(newResultsByName[targetName], result)
			end
		end
	end
	local newResults = {}
	for resultName, result in pairs(newResultsByName) do
		result.name = resultName
		table.insert(newResults, result)
	end
	recipe.results = newResults
	--log("changed results of "..recipe.name .. " to "..serpent.block(recipe.results))
end
for _, recipe in pairs(data.raw.recipe) do
	if recipe.category == "recycling" then
		if recipe.results ~= nil and #recipe.results > 0 then
			fixRecyclingRecipe(recipe)
			if recipe.results == nil or #recipe.results == 0 then
				recipe.hidden = true
				log("Hid recycling recipe "..recipe.name.." because all results have been removed.")
			end
		end
	end
end

-- Hide rate-trigger items' recycling recipes.
-- Apparently hiding the recipe isn't enough, need to delete it.
--data.raw.recipe["iron-gear-wheel-per-minute-recycling"] = nil
--data.raw.recipe["electronic-circuit-per-minute-recycling"] = nil
-- TODO check why this is necessary - there's no recipe, so why is this necessary?

-- Space biolabs should have recycling recipe.
-- Actually, looks like there's a hard-coded exception for recipe named "biolab". So let's generate it ourselves.
Recycling.generate_recycling_recipe(data.raw.recipe.biolab, (function(_) return true end))