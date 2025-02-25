-- This file adds early ammonia tech and recipes, and later ammonia using syngas.

-- Create ammonia 1 tech, for ammonia from spoilage and spoilage from wood.
local ammonia1Tech = copy(TECH["logistics"])
ammonia1Tech.name = "ammonia-1"
ammonia1Tech.localised_name = {"technology-name.ammonia-1"}
ammonia1Tech.localised_description = {"technology-description.ammonia-1"}
ammonia1Tech.prerequisites = {"filtration-lake-water"}
Icon.set(ammonia1Tech, "LSA/ammonia/tech")
ammonia1Tech.effects = {
	{type = "unlock-recipe", recipe = "ammonia-from-wood"},
	{type = "unlock-recipe", recipe = "niter"},
}
extend{ammonia1Tech}

-- Create ammonia 2 tech, for ammonia from syngas.
local ammonia2Tech = copy(TECH["coal-liquefaction"])
ammonia2Tech.name = "ammonia-2"
ammonia2Tech.localised_name = {"technology-name.ammonia-2"}
ammonia2Tech.localised_description = {"technology-description.ammonia-2"}
ammonia2Tech.prerequisites = {"ammonia-1", "chemical-science-pack"}
Icon.set(ammonia2Tech, "LSA/ammonia/tech")
ammonia2Tech.effects = {
	{type = "unlock-recipe", recipe = "ammonia-from-syngas"},
}
ammonia2Tech.unit = {
	count = 1000,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
	},
}
extend{ammonia2Tech}

-- Create recipe for ammonia from wood
local ammoniaFromWood = Recipe.make{
	copy = "nutrients-from-spoilage",
	recipe = "ammonia-from-wood",
	ingredients = {
		{"wood", 5},
		{"water", 20},
	},
	results = {
		{"ammonia", 10},
	},
	show_amount_in_title = false,
	category = "organic-or-chemistry",
	subgroup = "early-agriculture",
	order = "d1",
	energy_required = 30,
	allow_quality = false,
	icons = {"ammonia", "wood"},
}

-- Create recipe for ammonia from spoilage.
local ammoniaFromSpoilage = copy(ammoniaFromWood)
ammoniaFromSpoilage.name = "ammonia-from-spoilage"
ammoniaFromSpoilage.ingredients = {
	{type = "item", name = "spoilage", amount = 5},
	{type = "fluid", name = "water", amount = 20},
}
ammoniaFromSpoilage.order = "d3"
ammoniaFromSpoilage.energy_required = 30
Icon.set(ammoniaFromSpoilage, {"ammonia", "spoilage"})
extend{ammoniaFromSpoilage}
-- Will be unlocked by boompuff-cultivation tech.

-- Create recipe for spoilage from wood.
--[[ TODO not sure we want this recipe, at this stage. Increases the number of recipes and gives a way to fuel biochambers without imports from Gleba.
local woodSpoilageRecipe = copy(RECIPE["nutrients-from-spoilage"])
woodSpoilageRecipe.name = "spoilage-from-wood"
woodSpoilageRecipe.ingredients = {
	{type = "item", name = "wood", amount = 5},
	{type = "fluid", name = "water", amount = 20},
}
woodSpoilageRecipe.results = {
	{type = "item", name = "spoilage", amount = 5},
}
woodSpoilageRecipe.category = "organic-or-chemistry"
woodSpoilageRecipe.subgroup = "early-agriculture"
woodSpoilageRecipe.order = "d1"
woodSpoilageRecipe.energy_required = 30
Icon.set(woodSpoilageRecipe, {"spoilage", "wood"})
extend{woodSpoilageRecipe}
]]

-- Create recipe for niter from ammonia and sand.
local niterFromAmmoniaRecipe = copy(RECIPE["plastic-bar"])
niterFromAmmoniaRecipe.name = "niter"
niterFromAmmoniaRecipe.ingredients = {
	{type = "fluid", name = "ammonia", amount = 5},
	{type = "item", name = "sand", amount = 5},
}
niterFromAmmoniaRecipe.results = {
	{type = "item", name = "niter", amount = 10},
}
Icon.clear(niterFromAmmoniaRecipe)
niterFromAmmoniaRecipe.energy_required = 1
extend{niterFromAmmoniaRecipe}

-- Create recipe for ammonia from syngas.
local ammoniaSyngasRecipe = copy(RECIPE["plastic-bar"])
ammoniaSyngasRecipe.name = "ammonia-from-syngas"
ammoniaSyngasRecipe.ingredients = {
	{type = "fluid", name = "syngas", amount = 100},
	{type = "fluid", name = "steam", amount = 100},
}
ammoniaSyngasRecipe.results = {
	{type = "fluid", name = "ammonia", amount = 100},
}
ammoniaSyngasRecipe.show_amount_in_title = false
ammoniaSyngasRecipe.category = "chemistry-or-cryogenics"
ammoniaSyngasRecipe.subgroup = "early-agriculture"
ammoniaSyngasRecipe.order = "d2"
Icon.set(ammoniaSyngasRecipe, {"ammonia", "syngas"})
ammoniaSyngasRecipe.energy_required = 4
extend{ammoniaSyngasRecipe}

-- Aquilo should require ammonia 2 tech? Not really. Maybe if I later add tech to make fuel from ammonia, separate from the Aquilo discovery tech. TODO.
--Tech.addTechDependency("ammonia-2", "planet-discovery-aquilo")