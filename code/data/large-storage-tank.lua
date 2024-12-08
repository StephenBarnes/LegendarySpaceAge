-- For large storage tank: remove the tech, remove concrete from recipe.
data.raw.technology["large-storage-tank"].hidden = true
table.insert(data.raw.technology["fluid-handling"].effects, 2, {
	type = "unlock-recipe",
	recipe = "large-storage-tank"
})
data.raw.recipe["large-storage-tank"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 100 },
	{ type = "item", name = "steel-plate", amount = 20 },
}

-- TODO also add one of those mods with smaller inline storage tanks.