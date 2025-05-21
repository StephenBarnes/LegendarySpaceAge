--[[ This file adds early ammonia tech and recipes, and later ammonia using syngas.
Our recipes are:
	5 wood + 100 water -> 5 spoilage
	5 spoilage + 100 water -> 10 ammonia
One tree gives 10 wood, so it gives 20 ammonia.
One tree requires 1 fertilizer, which needs 5 ammonia plus 0.5 niter from 0.5 ammonia.
So each tree is net 14.5 ammonia, which can be spend on niter for gunpowder, etc.
]]

-- Create ammonia 1 tech, for ammonia from spoilage and spoilage from wood.
local ammonia1Tech = copy(TECH["logistics"])
ammonia1Tech.name = "ammonia-1"
ammonia1Tech.localised_name = {"technology-name.ammonia-1"}
ammonia1Tech.localised_description = {"technology-description.ammonia-1"}
ammonia1Tech.prerequisites = {"filtration-lake-water"}
Icon.set(ammonia1Tech, "LSA/ammonia/tech")
ammonia1Tech.effects = {
	{type = "unlock-recipe", recipe = "spoilage-from-wood"},
	{type = "unlock-recipe", recipe = "ammonia-from-spoilage"},
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
	{type = "unlock-recipe", recipe = "ammonia-cracking"},
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
Recipe.make{
	copy = "nutrients-from-spoilage",
	recipe = "spoilage-from-wood",
	-- Could divide all ingredients and results by 5, and reduce time. But this is a composting recipe, so it seems more appropriate to make it longer.
	ingredients = {
		{"wood", 5},
		{"water", 100}, -- Considered making this lake-water, but then you can't do it on Gleba.
	},
	results = {
		{"spoilage", 5},
	},
	show_amount_in_title = false,
	category = "organic-or-chemistry",
	time = 20,
	allow_quality = true,
	icons = {"spoilage", "wood"},
}

-- Create recipe for ammonia from spoilage.
Recipe.make{
	recipe = "ammonia-from-spoilage",
	copy = "spoilage-from-wood",
	ingredients = {
		{"spoilage", 5},
		{"water", 100},
	},
	results = {
		{"ammonia", 10},
	},
	icons = {"ammonia", "spoilage"},
	time = 10,
}

-- Create recipe for niter from ammonia and sand.
Recipe.make{
	recipe = "niter",
	copy = "plastic-bar",
	ingredients = {
		{"ammonia", 1},
		{"sand", 1},
	},
	resultCount = 1,
	clearIcons = true,
	time = 1,
}

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
ammoniaSynthesisRecipe.main_product = "ammonia"
ammoniaSynthesisRecipe.show_amount_in_title = false
ammoniaSynthesisRecipe.category = "chemistry"
ammoniaSynthesisRecipe.allow_quality = false
ammoniaSynthesisRecipe.allow_productivity = false
Icon.set(ammoniaSynthesisRecipe, {"ammonia", "hydrogen-gas", "nitrogen-gas"})
ammoniaSynthesisRecipe.energy_required = 1
extend{ammoniaSynthesisRecipe}

-- Aquilo should require ammonia 2 tech, for the ammonia cracking recipe.
Tech.addTechDependency("ammonia-2", "planet-discovery-aquilo")

-- Clear temperature spam for ammonia fluid. Assume it's gas most of the time.
Fluid.setSimpleTemp(FLUID["ammonia"], -33, false, 0)