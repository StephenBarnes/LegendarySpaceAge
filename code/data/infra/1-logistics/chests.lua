local Tech = require("code.util.tech")
local recipes = data.raw.recipe

-- Remove chest recipes, instead only use the steel one, and make it from factor intermediates.
for _, chestname in pairs{"wooden-chest", "iron-chest"} do
	for _, t in pairs{"item", "recipe", "container"} do
		data.raw[t][chestname].hidden = true
		data.raw[t][chestname].hidden_in_factoriopedia = true
	end
end
recipes["steel-chest"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "panel", amount = 5},
}
recipes["steel-chest"].enabled = true
recipes["steel-chest"].energy_required = 2
Tech.removeRecipeFromTech("steel-chest", "steel-processing")
