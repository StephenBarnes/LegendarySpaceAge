-- Logistic system tech: require quantum processor tech, and quantum processors as ingredients.
data.raw.technology["logistic-system"].prerequisites = {"quantum-processor"}
data.raw.technology["logistic-system"].unit = table.deepcopy(data.raw.technology["quantum-processor"].unit)
data.raw.technology["logistic-system"].unit.count = data.raw.technology["logistic-system"].unit.count * 2
for _, effect in pairs(data.raw.technology["logistic-system"].effects) do
	if effect.type == "unlock-recipe" then
		local recipeName = effect.recipe
		data.raw.recipe[recipeName].ingredients = {
			{ type = "item", name = "quantum-processor", amount = 2 },
			{ type = "item", name = "steel-chest", amount = 1 },
		}
	end
end