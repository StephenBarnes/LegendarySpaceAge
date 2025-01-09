local Tech = require("code.util.tech")

-- Move iron rod to be enabled from the start, and remove it from techs.
-- Needs to be in data-final-fixes bc rust mod adds stick derusting in data-final-fixes.
data.raw.recipe["iron-stick"].enabled = true
data.raw.recipe["rocs-rusting-iron-iron-stick-derusting"].enabled = true
Tech.removeRecipesFromTechs(
	{"iron-stick", "rocs-rusting-iron-iron-stick-derusting"},
	{"railway", "circuit-network", "electric-energy-distribution-1", "concrete"})
-- And add iron rod as ingredient in some recipes.
data.raw.recipe["burner-inserter"].ingredients = {
	{ type = "item", name = "iron-stick", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 2 },
}
data.raw.recipe["inserter"].ingredients = {
	{ type = "item", name = "iron-stick", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 2 },
	{ type = "item", name = "electronic-circuit", amount = 1 },
}
data.raw.recipe["long-handed-inserter"].ingredients = {
	{ type = "item", name = "iron-stick", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 2 },
	{ type = "item", name = "inserter", amount = 1 },
}
data.raw.recipe["radar"].ingredients = {
	{ type = "item", name = "iron-stick", amount = 5 },
	{ type = "item", name = "iron-plate", amount = 10 },
	{ type = "item", name = "iron-gear-wheel", amount = 5 },
	{ type = "item", name = "electronic-circuit", amount = 5 },
}