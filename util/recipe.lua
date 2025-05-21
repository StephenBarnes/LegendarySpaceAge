local Recipe = {}

Recipe.addIngredients = function(recipeName, extraIngredients)
	local recipe = RECIPE[recipeName]
	Table.extend(recipe.ingredients, extraIngredients)
end

Recipe.removeIngredient = function(recipeName, ingredientName)
	RECIPE[recipeName].ingredients = Table.filter(
			RECIPE[recipeName].ingredients,
			function(ingredient)
				return ingredientName ~= (ingredient.name or ingredient[1])
			end
		)
end

Recipe.substituteIngredient = function(recipeName, ingredientName, newIngredientName, newAmount)
	for _, ingredient in pairs(RECIPE[recipeName].ingredients) do
		if ingredientName == ingredient.name then
			ingredient.name = newIngredientName
			if newAmount ~= nil then
				ingredient.amount = newAmount
			end
			return
		end
	end
	log("Warning: ingredient not found: "..ingredientName.." in recipe "..recipeName)
end

Recipe.setIngredientFields = function(recipeName, ingredientName, fieldChanges)
	for _, ingredient in pairs(RECIPE[recipeName].ingredients) do
		if (ingredient.name or ingredient[1]) == ingredientName then
			for fieldName, value in pairs(fieldChanges) do
				ingredient[fieldName] = value
			end
		end
	end
end

Recipe.setIngredient = function(recipeName, ingredientName, newIngredient)
	local recipe = RECIPE[recipeName]
	for i, ingredient in pairs(recipe.ingredients) do
		if (ingredient.name or ingredient[1]) == ingredientName then
			recipe.ingredients[i] = newIngredient
			return
		end
	end
	log("Warning: ingredient not found: "..ingredientName.." in recipe "..recipeName)
end

Recipe.hide = function(recipeName)
	local recipe = RECIPE[recipeName]
	if recipe == nil then
		log("ERROR: Couldn't find recipe "..recipeName.." to hide.")
		return
	else
		recipe.hidden = true
		recipe.hidden_in_factoriopedia = true
	end
end

Recipe.copyIngredients = function(fromRecipeName, toRecipeName)
	local fromRecipe = RECIPE[fromRecipeName]
	if fromRecipe == nil then
		log("ERROR: Couldn't find recipe "..fromRecipeName.." to copy ingredients from.")
		return
	end
	local toRecipe = RECIPE[toRecipeName]
	if toRecipe == nil then
		log("ERROR: Couldn't find recipe "..toRecipeName.." to copy ingredients to.")
		return
	end
	toRecipe.ingredients = copy(fromRecipe.ingredients)
end

local function nameToItemOrFluid(name)
	if FLUID[name] ~= nil then -- Note this assumes the fluid has already been created. If not, need to give type="fluid" in the ingredient list.
		assert(not ITEM[name], "nameToItemOrFluid: "..name.." is both an item and a fluid")
			-- Note this doesn't catch the case where we create an item with the same name as a fluid later.
		return "fluid"
	else
		-- Here we could assert that the item proto exists in some item subtype. But it might not be created yet. And if it's not created, we'll get an error anyway.
		return "item"
	end
end

local recognizedIngredientOrResultFields = { -- Table of allowed fields in (Item/Fluid)(Ingredient/Product)Prototype.
	ingredients = {
		item = Table.listToSet{"name", "amount", "ignored_by_stats"},
		fluid = Table.listToSet{"name", "amount", "temperature", "minimum_temperature", "maximum_temperature", "ignored_by_stats", "fluidbox_index", "fluidbox_multiplier"},
	},
	results = {
		item = Table.listToSet{"name", "amount", "amount_min", "amount_max", "probability", "ignored_by_stats", "ignored_by_productivity", "show_details_in_recipe_tooltip", "extra_count_fraction", "percent_spoiled"},
		fluid = Table.listToSet{"name", "amount", "amount_min", "amount_max", "probability", "ignored_by_stats", "ignored_by_productivity", "temperature", "fluidbox_index", "show_details_in_recipe_tooltip"},
	},
}
---@param list ({[1]?:string, [2]?:number, name?:string, amount?:number, type?:string, item?:string, fluid?:string, ignored_by_stats?:boolean, fluidbox_index?:number, fluidbox_multiplier?:number, temperature?:number, minimum_temperature?:number, maximum_temperature?:number, ignored_by_productivity?:boolean, show_details_in_recipe_tooltip?:boolean, extra_count_fraction?:number, percent_spoiled?:number})[]
---@param ingredientOrResult "ingredients"|"results"
---@return (data.IngredientPrototype|data.ProductPrototype)[]
local function interpretIngredientsOrResults(list, ingredientOrResult)
	local result = {}
	for _, thing in pairs(list) do
		if type(thing) == "string" then
			table.insert(result, {type = nameToItemOrFluid(thing), name = thing, amount = 1})
		elseif type(thing) == "table" then
			local name = thing[1] or thing.name or thing.item or thing.fluid
			local amount = thing[2] or thing.amount or nil
			if thing["amount_min"] ~= nil or thing["amount_max"] ~= nil then
				assert(amount == nil)
			end
			local itemOrFluid = thing.type or nameToItemOrFluid(name)
			local newElement = {type = itemOrFluid, name = name, amount = amount}
			for k, v in pairs(thing) do
				if k ~= "name" and k ~= "amount" and k ~= 1 and k ~= 2 and k ~= "type" then
					assert(recognizedIngredientOrResultFields[ingredientOrResult][itemOrFluid][k],
						"interpretIngredientsOrResults: unknown field \""..k.."\" for "..itemOrFluid.." in "..ingredientOrResult)
					newElement[k] = v
				end
			end
			table.insert(result, newElement)
		else
			error("interpretIngredientsOrResults: unknown item "..tostring(thing))
		end
	end
	return result
end

--[[Shorthand to adjust a recipe. Table `a` can contain:
	.recipe (prototype or name)
	.ingredients (in short format)
	.results (in short format)
	.resultCount (alternative to .results, assumes single result with the same name as the recipe)
	.time
	.icons and .iconArrangement (for icons - see the icon util file)
	.clearIcons (clear existing icons)
	.specialIcons (for explicitly specified multiple icons)
	.clearSubgroup
	.category, .enabled, .auto_recycle, .subgroup, .order, .localised_name, .localised_description, .main_product, .allow_decomposition, .allow_as_intermediate, .show_amount_in_title, .crafting_machine_tint (just copied over)
]]
local allowedFieldsEdit = Table.listToSet{ -- Apparently the LSP's type-checking doesn't notice non-existent fields in the arg (?????), so we need to check them here.
	"recipe", "ingredients", "results", "resultCount", "time", "icons", "icon", "iconArrangement", "clearIcons", "specialIcons", "clearSubgroup", "category", "enabled", "auto_recycle", "subgroup", "order", "localised_name", "localised_description", "main_product", "allow_decomposition", "allow_as_intermediate", "show_amount_in_title", "crafting_machine_tint", "allow_productivity", "allow_quality", "maximum_productivity", "result_is_always_fresh", "hide_from_stats", "allow_speed", "allow_consumption", "allow_pollution", "hidden", "hidden_in_factoriopedia", "surface_conditions", "clearSurfaceConditions", "clearLocalisedName", "hide_from_player_crafting", "iconsLiteral",
}
---@param a {recipe: string|data.RecipePrototype, ingredients?: any[], results?: any[], resultCount?: number, time?: number, icons?: any[], icon?: string, iconArrangement?: any, clearIcons?: boolean, specialIcons?: any[], clearSubgroup?: boolean, category?: string, enabled?: boolean, auto_recycle?: boolean, subgroup?: string, order?: string, localised_name?: data.LocalisedString, localised_description?: data.LocalisedString, main_product?: string, allow_decomposition?: boolean, allow_as_intermediate?: boolean, show_amount_in_title?: boolean, crafting_machine_tint?: any, allow_productivity?: boolean, allow_quality?: boolean, maximum_productivity?: number, result_is_always_fresh?: boolean, hide_from_stats?: boolean, allow_speed?: boolean, allow_consumption?: boolean, allow_pollution?: boolean, hidden?: boolean, hidden_in_factoriopedia?: boolean, surface_conditions?: data.SurfaceCondition[], clearSurfaceConditions?: boolean, clearLocalisedName?: boolean, hide_from_player_crafting?: boolean, iconsLiteral?: any}
---@return data.RecipePrototype
Recipe.edit = function(a)
	for field, _ in pairs(a) do
		assert(allowedFieldsEdit[field], "Recipe.edit: unknown field \""..field.."\" in arguments: ".. serpent.block(a))
	end
	local recipe = nil
	assert(a.recipe ~= nil, "Recipe.edit: recipe proto or name is required, arguments: ".. serpent.block(a))
	if type(a.recipe) == "string" then
		recipe = RECIPE[a.recipe]
		assert(recipe ~= nil, "Recipe.edit: recipe not found; arguments: ".. serpent.block(a))
	else
		recipe = a.recipe
		assert(type(recipe) == "table", "Recipe.edit: recipe must be a table or a string; arguments: ".. serpent.block(a))
		assert(recipe.type == "recipe", "Recipe.edit: recipe must be a recipe prototype; arguments: ".. serpent.block(a))
	end

	if a.ingredients ~= nil then
		recipe.ingredients = interpretIngredientsOrResults(a.ingredients, "ingredients")
	end
	if a.results ~= nil then
		assert(a.resultCount == nil)
		recipe.results = interpretIngredientsOrResults(a.results, "results")
	end
	if a.resultCount ~= nil then
		assert(a.results == nil)
		recipe.results = {{type = nameToItemOrFluid(recipe.name), name = recipe.name, amount = a.resultCount}}
	end
	if a.time ~= nil then
		recipe.energy_required = a.time
	end
	if a.specialIcons ~= nil then
		recipe.icons = a.specialIcons
		recipe.icon =  nil
	end
	if a.clearSubgroup == true then
		recipe.subgroup = nil
	end
	if a.clearSurfaceConditions == true then
		assert(recipe.surface_conditions ~= nil)
		recipe.surface_conditions = nil
	end
	if a.clearLocalisedName == true then
		recipe.localised_name = nil
	end

	-- Some fields just get copied over.
	for _, field in pairs{"category", "enabled", "auto_recycle", "subgroup", "order", "localised_name", "localised_description", "main_product", "allow_decomposition", "allow_as_intermediate", "show_amount_in_title", "crafting_machine_tint", "allow_productivity", "allow_quality", "maximum_productivity", "result_is_always_fresh", "hide_from_stats", "allow_speed", "allow_consumption", "allow_pollution", "hidden", "hidden_in_factoriopedia", "surface_conditions", "hide_from_player_crafting"} do
		if a[field] ~= nil then
			recipe[field] = a[field]
		end
	end

	if a.clearIcons ~= nil then
		assert(a.icons == nil)
		Icon.clear(recipe)
	end
	if a.icons ~= nil then
		assert(a.icon == nil)
		assert(a.iconsLiteral == nil)
		Icon.set(recipe, a.icons, a.iconArrangement)
	end
	if a.icon ~= nil then
		assert(a.icons == nil)
		assert(a.iconArrangement == nil)
		assert(a.iconsLiteral == nil)
		Icon.set(recipe, a.icon)
	end
	if a.iconsLiteral ~= nil then
		assert(a.icons == nil)
		assert(a.icon == nil)
		recipe.icons = a.iconsLiteral
	end
	return recipe
end

-- Create a recipe by copying an existing recipe and adjusting it. The a.copy field is the recipe to copy, rest of args the same as Recipe.edit.
local allowedFieldsMake = Table.listToSet{
	"copy", "recipe", "ingredients", "results", "resultCount", "time", "icons", "icon", "iconArrangement", "clearIcons", "specialIcons", "clearSubgroup", "category", "enabled", "auto_recycle", "subgroup", "order", "localised_name", "localised_description", "main_product", "allow_decomposition", "allow_as_intermediate", "show_amount_in_title", "crafting_machine_tint", "allow_productivity", "allow_quality", "maximum_productivity", "result_is_always_fresh", "hide_from_stats", "allow_speed", "allow_consumption", "allow_pollution", "hidden", "hidden_in_factoriopedia", "surface_conditions", "clearSurfaceConditions", "clearLocalisedName", "hide_from_player_crafting", "addToTech", "addToTechIndex"
}
---@param a {copy: string|data.RecipePrototype, recipe: string, ingredients?: any[], results?: any[], resultCount?: number, time?: number, icons?: any[], icon?: string, iconArrangement?: any, clearIcons?: boolean, specialIcons?: any[], clearSubgroup?: boolean, category?: string, enabled?: boolean, auto_recycle?: boolean, subgroup?: string, order?: string, localised_name?: data.LocalisedString, localised_description?: data.LocalisedString, main_product?: string, allow_decomposition?: boolean, allow_as_intermediate?: boolean, show_amount_in_title?: boolean, crafting_machine_tint?: any, allow_productivity?: boolean, allow_quality?: boolean, maximum_productivity?: number, result_is_always_fresh?: boolean, hide_from_stats?: boolean, allow_speed?: boolean, allow_consumption?: boolean, allow_pollution?: boolean, hidden?: boolean, hidden_in_factoriopedia?: boolean, surface_conditions?: data.SurfaceCondition[], clearSurfaceConditions?: boolean, clearLocalisedName?: boolean, hide_from_player_crafting?: boolean, addToTech?: string, addToTechIndex?: number}
Recipe.make = function(a)
	for field, _ in pairs(a) do
		assert(allowedFieldsMake[field], "Recipe.make: unknown field \""..field.."\" in arguments: ".. serpent.block(a))
	end
	assert(a.copy ~= nil, "Recipe.make: copy is required, arguments: ".. serpent.block(a))
	assert(a.recipe ~= nil, "Recipe.make: recipe name is required, arguments: ".. serpent.block(a))
	assert(type(a.recipe) == "string", "Recipe.make: recipe name must be a string, arguments: ".. serpent.block(a))

	if a.addToTech ~= nil then
		Tech.addRecipeToTech(a.recipe, a.addToTech, a.addToTechIndex, false)
		a.addToTech = nil
		a.addToTechIndex = nil
		assert(a.enabled ~= true, "Recipe.make: recipe "..a.recipe.." is enabled, but we're adding it to a tech, so it should be disabled.")
		a.enabled = false
	else
		assert(a.addToTechIndex == nil, "Recipe.make: addToTechIndex is not allowed if addToTech is not set.")
	end

	local recipe
	if type(a.copy) == "string" then
		assert(RECIPE[a.copy] ~= nil, "Recipe.make: asked to copy non-existent recipe "..a.copy)
		recipe = copy(RECIPE[a.copy])
	else
		assert(type(a.copy) == "table", "Recipe.make: copy must be a table or a string, arguments: ".. serpent.block(a))
		assert(a.copy.type == "recipe", "Recipe.make: copy must be a recipe prototype, arguments: ".. serpent.block(a))
		recipe = copy(a.copy)
	end
	assert(recipe ~= nil)

	---@diagnostic disable-next-line: assign-type-mismatch
	recipe.name = a.recipe
	---@diagnostic disable-next-line: assign-type-mismatch
	a.recipe = recipe
	a.copy = nil
	---@diagnostic disable-next-line: param-type-mismatch
	Recipe.edit(a)
	recipe = recipe ---@type data.RecipePrototype
	extend{recipe}
	return RECIPE[recipe.name]
end

---@param recipe data.RecipePrototype
Recipe.hasOnlyFluidOutputs = function(recipe)
	for _, result in pairs(recipe.results or {}) do
		if result.type ~= "fluid" then return false end
	end
	return true
end

---@param recipe data.RecipePrototype
Recipe.isBarrellingRecipe = function(recipe)
	return recipe.subgroup == "fill-barrel" or recipe.subgroup == "empty-barrel" or recipe.subgroup == "fill-gas-tank" or recipe.subgroup == "empty-gas-tank"
end

---@param ingredientOrResult data.IngredientPrototype|data.ProductPrototype
---@param allowZero boolean?
---@return number
Recipe.ingredientOrResultJoules = function(ingredientOrResult, allowZero)
	if ingredientOrResult.type == "item" then
		return Item.getJoules(ingredientOrResult.name, allowZero)
	else
		return Fluid.getJoules(ingredientOrResult.name, allowZero)
	end
end

---@param recipeSide (data.IngredientPrototype|data.ProductPrototype)[]
---@return number
Recipe.recipeSideJoules = function(recipeSide)
	local joules = 0
	for _, ingredientOrResult in pairs(recipeSide) do
		joules = joules + Recipe.ingredientOrResultJoules(ingredientOrResult)
	end
	return joules
end

---@param recipe data.RecipePrototype|string
---@param sideName "ingredients"|"results"
---@param name string
---@return data.IngredientPrototype|data.ProductPrototype?
Recipe.getIngredientOrResult = function(recipe, sideName, name)
	if type(recipe) == "string" then
		recipe = RECIPE[recipe]
		assert(recipe ~= nil, "Recipe.getIngredientOrResult: recipe not found: "..recipe)
	end
	for _, ingredientOrResult in pairs(recipe[sideName]) do
		if ingredientOrResult.name == name then
			return ingredientOrResult
		end
	end
	return nil
end
---@param recipe data.RecipePrototype|string
---@param ingredientName string
---@return data.IngredientPrototype?
Recipe.getIngredient = function(recipe, ingredientName)
	---@diagnostic disable-next-line: return-type-mismatch
	return Recipe.getIngredientOrResult(recipe, "ingredients", ingredientName)
end
---@param recipe data.RecipePrototype|string
---@param resultName string
---@return data.ProductPrototype?
Recipe.getResult = function(recipe, resultName)
	---@diagnostic disable-next-line: return-type-mismatch
	return Recipe.getIngredientOrResult(recipe, "results", resultName)
end

---@param oldName string
---@param newName string
Recipe.renameRecipe = function(oldName, newName, copyKind)
	local recipe = RECIPE[oldName]
	recipe.name = newName
	extend{recipe}
	RECIPE[oldName] = nil
	if copyKind ~= nil then
		recipe.localised_name = {copyKind.."-name."..oldName}
		recipe.localised_description = {copyKind.."-description."..oldName}
	end
end


return Recipe