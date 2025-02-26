--[[ This file checks that various tradeoffs are as intended.
]]

-- I want coal coking to be energy-positive, but only if you burn the sulfur. So this file checks things like that.
local function checkCoalCoking()
	local coalCokingRecipe = RECIPE["coal-coking"]
	local ingredientJoules = 0
	local resultJoulesCarbonic = 0
	local resultJoulesSulfur = 0
	for _, ingredient in pairs(coalCokingRecipe.ingredients) do
		ingredientJoules = ingredientJoules + Item.getJoules(ingredient.name)
	end
	for _, result in pairs(coalCokingRecipe.results) do
		assert(result.type == "item", "Result "..result.name.." is not an item.")
		local resultItem = Item.getIncludingSubtypes(result.name)
		if resultItem.fuel_value ~= nil then
			local joules = Gen.toJoules(resultItem.fuel_value)
			if resultItem.fuel_category == "non-carbon" then
				resultJoulesSulfur = resultJoulesSulfur + joules
			else
				resultJoulesCarbonic = resultJoulesCarbonic + joules
			end
		end
	end
	assert(resultJoulesSulfur > 0, "Coal coking should produce non-carbonic fuel.")
	assert(resultJoulesCarbonic > 0, "Coal coking should produce carbonic fuel.")
	assert(resultJoulesCarbonic <= ingredientJoules, "Coal coking shouldn't be energy-positive with only carbonic fuel.")
	assert(resultJoulesCarbonic + resultJoulesSulfur > ingredientJoules, "Coal coking should be energy-positive if you burn the sulfur.")
	return true
end

local function checkIntendedTradeoffs()
	local success = true

	success = checkCoalCoking() and success
	-- TODO more checks here.

	return success
end

return checkIntendedTradeoffs