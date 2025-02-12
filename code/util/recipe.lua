local Table = require("code.util.table")

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
	toRecipe.ingredients = table.deepcopy(fromRecipe.ingredients)
end

return Recipe