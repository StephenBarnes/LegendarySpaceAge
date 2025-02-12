--- This file checks that each recipe is possible in all machines with matching crafting category.
--- This catches bugs where e.g. some recipe produces 3 fluid outputs, but none of the machines with its category has 3+ fluid outputs.

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
local function checkRecipeHasMachines(recipe, machinesWithCategory)
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
local function checkAllRecipesHaveMachines()
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
	for _, recipe in pairs(RECIPE) do
		local recipeCategory = recipe.category or "crafting" -- "crafting" is default.
		if recipeCategory ~= "parameters" then
			success = checkRecipeHasMachines(recipe, categoryToMachines[recipeCategory]) and success
		end
	end
	return success
end

return checkAllRecipesHaveMachines