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

Recipe.orderRecipes = function(recipeNames)
	local order = 1
	for _, recipeName in pairs(recipeNames) do
		local recipe = RECIPE[recipeName]
		if recipe == nil then
			log("ERROR: Couldn't find recipe "..recipeName.." to order.")
			return
		end
		recipe.order = string.format("%02d", order)
		order = order + 1
	end
end

Recipe.hide = function(recipeName)
	local recipe = RECIPE[recipeName]
	if recipe == nil then
		log("ERROR: Couldn't find recipe "..recipeName.." to hide.")
		return
	else
		recipe.hidden = true
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
						"interpretIngredientsOrResults: unknown field "..k.." for "..itemOrFluid.." in "..ingredientOrResult)
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
	.variants and .variantCount and .variantAdditional (for variant pictures - see the icon util file)
	.clearIcons (clear existing icons)
	.specialIcons (for explicitly specified multiple icons)
	.category, .enabled, .auto_recycle, .subgroup, .order, .localised_name, .localised_description, .main_product, .allow_decomposition, .allow_as_intermediate, .show_amount_in_title, .crafting_machine_tint (just copied over)
]]
local possibleArgs = Table.listToSet{"recipe", "ingredients", "results", "resultCount", "time",
	"icons", "iconArrangement", "variants", "variantCount", "variantAdditional", "clearIcons", "specialIcons",
	"category", "enabled", "auto_recycle", "subgroup", "order", "localised_name", "localised_description", "main_product", "allow_decomposition", "allow_as_intermediate", "show_amount_in_title", "crafting_machine_tint",
}
Recipe.edit = function(a)
	for k, _ in pairs(a) do
		assert(possibleArgs[k], "Recipe.edit: unknown field "..k)
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

	-- Some fields just get copied over.
	for _, field in pairs{"category", "enabled", "auto_recycle", "subgroup", "order", "localised_name", "localised_description", "main_product", "allow_decomposition", "allow_as_intermediate", "show_amount_in_title", "crafting_machine_tint"} do
		if a[field] ~= nil then
			recipe[field] = a[field]
		end
	end

	if a.clearIcons ~= nil then
		assert(a.icons == nil, "Recipe.edit: clearIcons and icons cannot both be set")
		Icon.clear(recipe)
	end
	if a.icons ~= nil then
		Icon.set(recipe, a.icons, a.iconArrangement)
	end
	if a.variants ~= nil then
		Icon.variants(recipe, a.variants, a.variantCount, a.variantAdditional)
	end
end

-- Create a recipe by copying an existing recipe and adjusting it. The a.copy field is the recipe to copy, rest of args the same as Recipe.edit.
Recipe.make = function(a)
	assert(a.copy ~= nil, "Recipe.make: copy is required, arguments: ".. serpent.block(a))
	assert(a.recipe ~= nil, "Recipe.make: recipe name is required, arguments: ".. serpent.block(a))
	assert(type(a.recipe) == "string", "Recipe.make: recipe name must be a string, arguments: ".. serpent.block(a))
	assert(RECIPE[a.copy] ~= nil, "Recipe.make: asked to copy non-existent recipe "..a.copy)
	local recipe = copy(RECIPE[a.copy])
	assert(recipe ~= nil, "Recipe.make: copy failed")
	---@diagnostic disable-next-line: assign-type-mismatch
	recipe.name = a.recipe
	a.recipe = recipe
	a.copy = nil
	Recipe.edit(a)
	extend{recipe}
	return RECIPE[recipe.name]
end

return Recipe