-- TODO edit modules to instead be like +25% or +20%, not e.g. +30%.

-- Add resin to all recipes. TODO actually should just rewrite all module recipes.
for _, moduleType in pairs{"speed", "efficiency", "productivity"} do
	Recipe.addIngredients(moduleType.."-module", {{type = "item", name = "resin", amount = 1}})
end