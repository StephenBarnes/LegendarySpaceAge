-- Adjusts recipes, runs in data-final-fixes stage.

-- All recipes that have multiple products, or non-1 count, or probability, should always show products in the tooltip.
---@param recipe data.RecipePrototype
local function recipeShouldAlwaysShowProducts(recipe)
	-- Would be nice to return false if recipe was added by another mod, but we can't access prototype history in data stage, it seems.
	if recipe.results == nil then
		log("recipe " .. recipe.name .. " has no results")
		return false
	end
	if #recipe.results ~= 1 then return true end
	local result = recipe.results[1]
	if result.amount ~= 1 then return true end
	if result.probability ~= nil and result.probability ~= 1 then return true end
	if result.amount_min ~= nil or result.amount_max ~= nil then return true end
	if result.extra_count_fraction ~= nil then return true end
	return false
end
for _, recipe in pairs(RECIPE) do
	if not recipe.parameter then
		if recipeShouldAlwaysShowProducts(recipe) then
			recipe.always_show_products = true
		else
			if recipe.always_show_products == true then
				log("recipe " .. recipe.name .. " has always_show_products set to true, but should not")
			end
			recipe.always_show_products = false
		end
	end
end

-- All recipes should always show buildings made in, since I'm changing that a lot, and creating new crafting categories, etc.
for _, recipe in pairs(RECIPE) do
	if not recipe.parameter then
		if recipe.always_show_made_in == false then
			log("WARNING: recipe " .. recipe.name .. " has always_show_made_in set to false")
		end
		recipe.always_show_made_in = true
	end
end