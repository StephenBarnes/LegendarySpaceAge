--[[ This file checks that all recipes etc. have round numbers.

Define a notion of "complexity" of a number.
	The complexity of a power of 10 (like 0.1, 1, 10, 100) is zero.
	The complexity of 2 is 1. The complexity of 5 is 1.
	For other numbers, the complexity is the minimum number of times you need to multiply or divide any power of 10 by 2 or 5 to get to x.
		For example, the number 4 has complexity 2 because it's 1*2*2, or (10/5)*2, or (100/5)/5. Likewise the numbers 0.4 and 40 also have complexity 2.
	Ignoring factors of 10, here is each complexity with representative examples:
		0 - 1
		1 - 2, 5
		2 - 4, 0.25
		3 - 8, 0.125
		4 - 16, 0.0625
One goal of this modpack is to make all of the ratios in Factorio simple.
	For example, the ratio of copper miners to furnaces to circuit assemblers.
	I'll use the above definition of complexity to measure simplicity. Ideally all the ratios in the game should have complexity 3 or less.
	Contrast with the vanilla game, where 1 steam engine can power 4.28571 oil refineries. (1800kW / 420kW)
Ratios generally arise from dividing or multiplying various numbers.
If you divide or multiply two numbers with low complexity, the result will have low complexity.
	Factors of 2 and 5 combine into factors of 10, cancelling out.
So: I'll make all machines and recipes in the game have all their numbers low-complexity, so all the ratios are simple.
One problem with this: addition doesn't preserve complexity. Adding 1 (complexity 0) to 2 (complexity 1) gives 3 (complexity infinity).
	Generally this arises when adding power consumptions of subfactories. But it's not a big deal.
This file checks that all numbers (of machines and recipes) have low complexity.
]]

local Util = require("data.autodebug.util")

---@param energy data.Energy
---@return number
local function energyToNumber(energy)
	-- Convert a string like "5MJ" or "2.5W" or "10" to number 5 or 2.5 or 10.
	local num, _ = energy:match("^(%d*%.?%d*)%s*(%a*)$")
	if num == nil then error("Invalid energy string: " .. energy) end
	num = tonumber(num)
	assert(num ~= nil, "Invalid energy number: " .. energy)
	return num
end

---@param x number
---@return number
local function complexity(x)
	if x == 0 then return 0 end
	if x < 0 then x = -x end
	while x >= 10 do x = x / 10 end
	while x < 1 do x = x * 10 end
	if x == 1 then return 0 end
	if x == 2 or x == 5 then return 1 end
	if x == 4 or x == 2.5 then return 2 end
	if x == 8 or x == 1.25 then return 3 end
	if x == 1.6 or x == 6.25 then return 4 end
	return 10
end

---@param x number
---@return boolean
local function complexityOk(x)
	return complexity(x) <= 2
end

---@param recipe data.RecipePrototype
local function checkRecipe(recipe)
	if recipe.category == "recycling" then return true end -- Ignore recycling recipes.
	if Util.shouldIgnoreRecipe(recipe) then return true end
	local success = true
	for _, ingredient in pairs(recipe.ingredients or {}) do
		if ingredient.amount ~= nil then
			if not complexityOk(ingredient.amount) then
				log("Complexity of recipe " .. recipe.name .. " ingredient " .. ingredient.name .. " amount is too high: " .. ingredient.amount)
				success = false
			end
		end
	end
	for _, result in pairs(recipe.results or {}) do
		local effectiveAmount
		if result.amount ~= nil then effectiveAmount = result.amount end
		if result.amount_min ~= nil then effectiveAmount = (result.amount_min + result.amount_max) / 2 end
		assert(effectiveAmount ~= nil, "Could not find effective amount for recipe " .. recipe.name .. " result " .. result.name)
		if result.probability ~= nil then effectiveAmount = effectiveAmount * result.probability end
		if not complexityOk(effectiveAmount) then
			log("Complexity of recipe " .. recipe.name .. " result " .. result.name .. " effective-amount is too high: " .. effectiveAmount)
			success = false
		end
	end
	if not complexityOk(recipe.energy_required or 0.5) then
		log("Complexity of recipe " .. recipe.name .. " time is too high: " .. recipe.energy_required)
		success = false
	end
	return success
end

---@param machine data.CraftingMachinePrototype
local function checkCraftingMachine(machine)
	local success = true
	local energyUsage = energyToNumber(machine.energy_usage)
	local drain = energyToNumber(machine.energy_source.drain or "0W")
	for name, val in pairs{
		["energy usage"] = energyUsage,
		["crafting speed"] = machine.crafting_speed,
		["drain"] = drain,
		["drain plus active energy usage"] = drain + energyUsage,
		["heating energy"] = energyToNumber(machine.heating_energy or "0W"),
		-- TODO more?
	} do
		if not complexityOk(val) then
			log("Complexity of crafting machine " .. machine.name .. " value \"" .. name .. "\" is too high: " .. val)
			success = false
		end
	end
	return success
end

---@param item data.ItemPrototype
---@return boolean
local function checkItem(item)
	local success = true
	for name, val in pairs{
		["stack size"] = item.stack_size,
		["num per rocket"] = ROCKET / item.weight,
	} do
		if not complexityOk(val) then
			log("Complexity of item " .. item.name .. " value \"" .. name .. "\" is too high: " .. val)
			success = false
		end
	end
	return success
end

------------------------------------------------------------------------

---@return boolean
local function checkRoundNumbers()
	local success = true

	for _, recipe in pairs(data.raw.recipe) do
		success = checkRecipe(recipe) and success
	end

	for _, craftingMachineSubtype in pairs{"furnace", "assembling-machine", "rocket-silo"} do
		for _, craftingMachine in pairs(RAW[craftingMachineSubtype]) do
			success = checkCraftingMachine(craftingMachine) and success
		end
	end

	for _, item in pairs(ITEM) do
		success = checkItem(item) and success
	end

	-- TODO check furnaces
	-- TODO check assemblers and subtypes.
	-- TODO check miners, boilers, reactors

	-- TODO check whole list of prototypes for what types we need to check.
	-- TODO modules

	return success
end

return checkRoundNumbers