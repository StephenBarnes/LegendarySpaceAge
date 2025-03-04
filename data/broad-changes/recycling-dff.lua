-- This file makes final edits to recycling recipes, in the data-final-fixes stage.

local Recycling = require("__quality__.prototypes.recycling")

-- For spoilable stuff, I don't want to give a way to store them permanently in the form of biochambers etc. Just going to remove them from outputs completely.
-- But not all spoilable stuff, eg iron-plates are spoilable.
local recyclingResultReplacements = {
	["nutrients"] = "spoilage",
	["pentapod-egg"] = "spoilage",
	["slipstack-pearl"] = "spoilage",
	["raw-fish"] = "spoilage",
	["jelly"] = "spoilage",
	["biter-egg"] = "spoilage",
	["boomsac"] = "spoilage",
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
	-- Combines results's numbers. Doesn't work in all edge cases. TODO check if any of those edge cases happen in the game.
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
	local newResult = copy(result1)
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
for _, recipe in pairs(RECIPE) do
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
-- This happens bc the "quality" mod creates self-recycling recipes for all items that don't have recycling recipes.
local TECH_RATES = require("util.const.tech-rates")
for _, vals in pairs(TECH_RATES) do
	local name = vals.showPerMinute and (vals.item .. "-per-minute-recycling") or (vals.item .. "-per-second-recycling")
	assert(RECIPE[name] ~= nil, "Expected recycling recipe for " .. name)
	RECIPE[name] = nil
end

-- Hide recycling recipes for items that are not recyclable.
for _, item in pairs{
	"assembled-rocket-part",
	"blueprint",
	"deconstruction-planner",
	"upgrade-planner",
	"blueprint-book",
	"copper-wire",
	"green-wire",
	"red-wire",
	"spidertron-remote",
	"discharge-defense-remote",
	"artillery-targeting-remote",
} do
	RECIPE[item .. "-recycling"] = nil
	-- Setting .hidden_in_factoriopedia to true doesn't work, still shows up in factoriopedia.
end

-- Space biolabs should have recycling recipe.
-- Actually, looks like there's a hard-coded exception for recipe named "biolab". So let's generate it ourselves.
Recycling.generate_recycling_recipe(RECIPE.biolab, (function(_) return true end))

-- Change charged battery recycling recipes to just discharge the batteries.
if RECIPE["charged-battery-recycling"] then
	RECIPE["charged-battery-recycling"].results = {{type = "item", name = "battery", amount = 1}}
end
if RECIPE["charged-holmium-battery-recycling"] then
	RECIPE["charged-holmium-battery-recycling"].results = {{type = "item", name = "holmium-battery", amount = 1}}
end

-- Add sulfuric acid product to some recycling recipes.
for _, recipeName in pairs{
	"battery",
	"sulfuric-acid-barrel",
} do
	local recyclingRecipeName = recipeName .. "-recycling"
	local recyclingRecipe = RECIPE[recyclingRecipeName]
	local baseRecipe = RECIPE[recipeName]
	assert(recyclingRecipe ~= nil, "Expected recycling recipe for " .. recyclingRecipeName)
	assert(baseRecipe ~= nil, "Expected base recipe for " .. recipeName)
	local saIngredient = Recipe.getIngredient(baseRecipe, "sulfuric-acid")
	assert(saIngredient ~= nil)
	local amount = saIngredient.amount * 0.25
	-- No extra_count_fraction, it doesn't work for fluids. Plus you can have fractional result amounts for fluids.
	table.insert(recyclingRecipe.results, {
			type = "fluid",
			name = "sulfuric-acid",
			amount = amount,
	})
end

-- Change concrete recycling to give back stone. (Ingredient is fluid, but it solidifies.)
RECIPE["concrete-recycling"].results = {
	{type = "item", name = "stone", amount = 1, extra_count_fraction = .25},
	{type = "item", name = "sand", amount = 1, extra_count_fraction = .25},
}

-- Change refined concrete recycling to give back stone and sand.
table.insert(RECIPE["refined-concrete-recycling"].results, {type = "item", name = "stone", amount = 1, extra_count_fraction = .25})
table.insert(RECIPE["refined-concrete-recycling"].results, {type = "item", name = "sand", amount = 1, extra_count_fraction = .25})

-- TODO edit recycling recipe times, and recycler speed.