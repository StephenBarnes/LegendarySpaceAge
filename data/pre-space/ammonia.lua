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
ammonia2Tech.prerequisites = {"chemical-science-pack"} -- Assume chemical science pack has prereq on ammonia-1.
Icon.set(ammonia2Tech, "LSA/ammonia/tech")
ammonia2Tech.effects = {
	{type = "unlock-recipe", recipe = "ammonia-synthesis"},
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
	time = 30,
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

-- Create recipe for ammonia synthesis.
local ammoniaSynthesisRecipe = copy(RECIPE["plastic-bar"])
ammoniaSynthesisRecipe.name = "ammonia-synthesis"
ammoniaSynthesisRecipe.ingredients = {
	{type = "fluid", name = "hydrogen-gas", amount = 100},
	{type = "fluid", name = "nitrogen-gas", amount = 100},
}
ammoniaSynthesisRecipe.results = {
	{type = "fluid", name = "ammonia", amount = 100},
}
ammoniaSynthesisRecipe.show_amount_in_title = false
ammoniaSynthesisRecipe.category = "chemistry-or-cryogenics"
ammoniaSynthesisRecipe.subgroup = "early-agriculture"
ammoniaSynthesisRecipe.order = "d2"
ammoniaSynthesisRecipe.allow_quality = false
Icon.set(ammoniaSynthesisRecipe, {"ammonia", "hydrogen-gas", "nitrogen-gas"})
ammoniaSynthesisRecipe.energy_required = 4
extend{ammoniaSynthesisRecipe}

-- Aquilo should require ammonia 2 tech? Not really. Maybe if I later add tech to make fuel from ammonia, separate from the Aquilo discovery tech. TODO.
--Tech.addTechDependency("ammonia-2", "planet-discovery-aquilo")

-- Clear temperature spam for ammonia fluid. Assume it's gas most of the time.
Fluid.setSimpleTemp(FLUID["ammonia"], -33, false, 0)