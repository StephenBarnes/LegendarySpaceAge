-- Logistic system tech: require quantum processor tech, and quantum processors as ingredients.
TECH["logistic-system"].prerequisites = {"quantum-processor"}
TECH["logistic-system"].unit = copy(TECH["quantum-processor"].unit)
TECH["logistic-system"].unit.count = TECH["logistic-system"].unit.count * 2
for _, effect in pairs(TECH["logistic-system"].effects) do
	if effect.type == "unlock-recipe" then
		local recipeName = effect.recipe
		RECIPE[recipeName].ingredients = {
			{ type = "item", name = "quantum-processor", amount = 2 },
			{ type = "item", name = "steel-chest", amount = 1 },
		}
	end
end