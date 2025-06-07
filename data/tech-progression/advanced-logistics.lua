-- Logistic system tech: require white circuits tech, and superclocked white circuits as ingredients.
TECH["logistic-system"].prerequisites = {"electromagnetic-science-pack"}
TECH["logistic-system"].unit = Tech.makeUnit("electromagnetic", 1500)
for _, effect in pairs(TECH["logistic-system"].effects) do
	if effect.type == "unlock-recipe" then
		local recipeName = effect.recipe
		RECIPE[recipeName].ingredients = {
			{ type = "item", name = "white-circuit-superclocked", amount = 2 },
			{ type = "item", name = "steel-chest", amount = 1 },
		}
	end
end