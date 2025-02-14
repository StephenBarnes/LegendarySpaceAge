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
	if FLUID[name] ~= nil then
		return "fluid"
	else
		return "item"
	end
end

local function interpretIngredientsOrResults(list)
	local result = {}
	for _, thing in pairs(list) do
		if type(thing) == "string" then
			table.insert(result, {type = nameToItemOrFluid(thing), name = thing, amount = 1})
		elseif type(thing) == "table" then
			local name = thing[1] or thing.name or thing.item or thing.fluid
			local amount = thing[2] or thing.amount or thing.count
			local newElement = {type = nameToItemOrFluid(name), name = name, amount = amount}
			for k, v in pairs(thing) do
				if k ~= "name" and k ~= "amount" then
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
	.recipe (prototype)
	.name (alternative to .recipe)
	.ingredients
	.results
	.resultCount (alternative to .results, assumes single result with the same name as the recipe)
	.time
	.category
]]
local recognizedFields = Table.listToSet{"recipe", "name", "ingredients", "results", "resultCount", "time", "category", "copy"}
Recipe.adjust = function(a)
	for k, _ in pairs(a) do
		assert(recognizedFields[k], "Recipe.adjust: unknown field "..k)
	end
	local recipe
	if a.recipe ~= nil then
		recipe = a.recipe
	elseif a.name ~= nil then
		recipe = RECIPE[a.name]
	else
		error("Recipe.adjust: no recipe or name provided")
	end

	if a.ingredients ~= nil then
		recipe.ingredients = interpretIngredientsOrResults(a.ingredients)
	end
	if a.results ~= nil then
		assert(a.resultCount == nil)
		recipe.results = interpretIngredientsOrResults(a.results)
	end
	if a.resultCount ~= nil then
		assert(a.results == nil)
		recipe.results = {{type = nameToItemOrFluid(recipe.name), name = recipe.name, amount = a.resultCount}}
	end
	if a.category ~= nil then
		recipe.category = a.category
	end
	if a.time ~= nil then
		recipe.energy_required = a.time
	end
end

-- Create a recipe by copying an existing recipe and adjusting it. The a.copy field is the recipe to copy, rest of args the same as Recipe.adjust.
Recipe.make = function(a)
	assert(a.copy ~= nil, "Recipe.make: copy is required")
	assert(a.name ~= nil, "Recipe.make: name is required")
	assert(a.recipe == nil, "Recipe.make: recipe is not allowed")
	assert(RECIPE[a.copy] ~= nil, "Recipe.make: asked to copy non-existent recipe "..a.copy)
	local recipe = copy(RECIPE[a.copy])
	a.recipe = recipe
	Recipe.adjust(a)
	extend{recipe}
	return RECIPE[a.name]
end

return Recipe