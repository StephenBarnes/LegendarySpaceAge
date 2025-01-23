-- This file will run automated checks. For example, checking that when the player unlocks a recipe, he has the ingredients available.

local GlobalParams = require("code.global-params")
local Table = require("code.util.table")

---@param machine data.CraftingMachinePrototype
---@return number, number
local function machineFluidInputsOutputs(machine)
	return
		Table.countIf(machine.fluid_boxes or {}, function(box) return box.production_type == "input" end),
		Table.countIf(machine.fluid_boxes or {}, function(box) return box.production_type == "output" end)
end

---@param recipe data.RecipePrototype
---@return number, number
local function recipeFluidInputsOutputs(recipe)
	return
		Table.countIf(recipe.ingredients, function(ingredient) return ingredient.type == "fluid" end),
		Table.countIf(recipe.results, function(result) return result.type == "fluid" end)
end

-- Check that recipe is doable by all assembling-machines and furnaces with its recipe category. This checks number of fluid inputs and outputs, maybe more.
---@param recipe data.RecipePrototype
---@param machinesWithCategory data.CraftingMachinePrototype[]
---@return boolean
local function checkRecipeDoable(recipe, machinesWithCategory)
	if not machinesWithCategory then
		log("Legendary Space Age ERROR: recipe " .. recipe.name .. " has no machines with its category: " .. (recipe.category or "crafting"))
		return false
	end
	local success = true
	local recipeFluidInputs, recipeFluidOutputs = recipeFluidInputsOutputs(recipe)
	for _, machine in pairs(machinesWithCategory) do
		local machineFluidInputs, machineFluidOutputs = machineFluidInputsOutputs(machine)
		if recipeFluidInputs > machineFluidInputs then
			log("Legendary Space Age ERROR: recipe " .. recipe.name .. " has " .. recipeFluidInputs .. " fluid inputs, but machine " .. machine.name .. " has only " .. machineFluidInputs .. " fluid inputs.")
			success = false
		end
		if recipeFluidOutputs > machineFluidOutputs then
			log("Legendary Space Age ERROR: recipe " .. recipe.name .. " has " .. recipeFluidOutputs .. " fluid outputs, but machine " .. machine.name .. " has only " .. machineFluidOutputs .. " fluid outputs.")
			success = false
		end
	end
	return success
end

-- Check that all recipes are doable by all assembling-machines and furnaces with their recipe categories.
---@return boolean
local function checkAllRecipesDoable()
	local success = true
	-- Build a table from crafting category to list of machines.
	local categoryToMachines = {}
	for _, machineType in pairs{"assembling-machine", "furnace", "rocket-silo"} do
		for _, machine in pairs(data.raw[machineType]) do
			for _, category in pairs(machine.crafting_categories) do
				categoryToMachines[category] = categoryToMachines[category] or {}
				table.insert(categoryToMachines[category], machine)
			end
		end
	end
	-- Create a dummy machine for handcrafting.
	local dummyMachine = {
		type = "character",
		name = "character",
	}
	for _, category in pairs(data.raw.character.character.crafting_categories) do
		categoryToMachines[category] = categoryToMachines[category] or {}
		table.insert(categoryToMachines[category], dummyMachine)
	end
	-- Check all recipes.
	for _, recipe in pairs(data.raw.recipe) do
		local recipeCategory = recipe.category or "crafting" -- "crafting" is default.
		if recipeCategory ~= "parameters" then
			success = checkRecipeDoable(recipe, categoryToMachines[recipeCategory]) and success
		end
	end
	return success
end


-- TODO more

local function runFullDebug()
	log("Legendary Space Age: running full progression debug.")
	local success = true
	--success = toposortTechsAndCache() and success
	--if not success then return end -- if we can't toposort the techs, many other checks won't work anyway.
	success = checkAllRecipesDoable() and success
	if success then
		log("Legendary Space Age: full progression debug passed.")
	else
		log("Legendary Space Age ERROR: one or more progression debug checks failed.")
	end
end

if GlobalParams.runProgressionChecks then
	runFullDebug()
end