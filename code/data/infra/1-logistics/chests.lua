-- Remove chest recipes, instead only use the steel one, and make it from factor intermediates.
for _, chestname in pairs{"wooden-chest", "iron-chest"} do
	for _, t in pairs{"item", "recipe", "container"} do
		data.raw[t][chestname].hidden = true
		data.raw[t][chestname].hidden_in_factoriopedia = true
	end
end
RECIPE["steel-chest"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "panel", amount = 5},
}
RECIPE["steel-chest"].enabled = true
RECIPE["steel-chest"].energy_required = 2
Tech.removeRecipeFromTech("steel-chest", "steel-processing")
