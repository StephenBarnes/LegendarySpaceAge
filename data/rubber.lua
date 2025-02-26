--[[ This file adds rubber item and recipes, and adds rubber as ingredient to some recipes.
Rubber can be made from wood:
	In biochamber or chemical plant: 5 wood + 2 water -> 5 latex (fluid)
	Coagulation and finishing: 5 latex + 1 sulfuric acid + 1 carbon -> 5 rubber
Later, rubber can also be made from petrochems:
	In chem plant: 5 light oil + 2 steam + 1 sulfuric acid + 1 carbon -> 5 rubber + 2 tar
		Represents cracking to make butadiene, followed by rubber synthesis.
Rubber is used in many recipes like belts, tires, engines, inserters, robots, and vehicles.
]]

-- Create rubber item.
local rubberItem = copy(ITEM["plastic-bar"])
rubberItem.name = "rubber"
Icon.variants(rubberItem, "LSA/rubber/rubber-%", 3)
Icon.set(rubberItem, "LSA/rubber/rubber-1")
rubberItem.order = "b[chemistry]-a3"
extend{rubberItem}

-- Create latex fluid.
local latexColor = {r = .812, g = .761, b = .675, a=1}
local latexFluid = copy(FLUID["lubricant"])
latexFluid.name = "latex"
Icon.set(latexFluid, "LSA/rubber/latex")
latexFluid.base_color = latexColor
latexFluid.flow_color = {r = .9, g = .8, b = .7, a=1}
latexFluid.visualization_color = latexColor
extend{latexFluid}

-- Create recipe for latex fluid.
local latexRecipe = copy(RECIPE["plastic-bar"])
latexRecipe.name = "latex"
latexRecipe.ingredients = {
	{type="item", name="wood", amount=5},
	{type="fluid", name="water", amount=20},
}
latexRecipe.results = {{type="fluid", name="latex", amount=50}}
latexRecipe.category = "chemistry"
latexRecipe.subgroup = nil
latexRecipe.order = nil
latexRecipe.hide_from_player_crafting = true
latexRecipe.allow_quality = false
extend{latexRecipe}

-- Create recipe for latex to rubber.
local rubberFromLatexRecipe = copy(RECIPE["plastic-bar"])
rubberFromLatexRecipe.name = "rubber-from-latex"
rubberFromLatexRecipe.ingredients = {
	{ type = "fluid", name = "latex",         amount = 50 },
	{ type = "fluid", name = "sulfuric-acid", amount = 10 },
	{ type = "item",  name = "carbon",        amount = 1 },
}
rubberFromLatexRecipe.results = {{type="item", name="rubber", amount=5}}
rubberFromLatexRecipe.category = "chemistry"
Icon.set(rubberFromLatexRecipe, {"rubber", "latex"})
extend{rubberFromLatexRecipe}

-- Create recipe for synthetic rubber.
local rubberFromPetrochemRecipe = copy(RECIPE["plastic-bar"])
rubberFromPetrochemRecipe.name = "rubber-from-oil"
rubberFromPetrochemRecipe.ingredients = {
	{type="fluid", name="light-oil", amount=50},
	{type="fluid", name="steam", amount=20},
	{type="fluid", name="sulfuric-acid", amount=10},
	{type="item", name="carbon", amount=2},
}
rubberFromPetrochemRecipe.results = {
	{type="item", name="rubber", amount=5},
	{type="fluid", name="tar", amount=10},
}
rubberFromPetrochemRecipe.main_product = "rubber"
rubberFromPetrochemRecipe.category = "chemistry"
rubberFromPetrochemRecipe.subgroup = "raw-material"
rubberFromPetrochemRecipe.order = "f3"
Icon.set(rubberFromPetrochemRecipe, {"rubber", "light-oil"})
extend{rubberFromPetrochemRecipe}

-- Create tech for natural rubber.
local naturalRubberTech = copy(TECH["plastics"])
naturalRubberTech.name = "rubber-1"
naturalRubberTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "latex",
	},
	{
		type = "unlock-recipe",
		recipe = "rubber-from-latex",
	},
	{
		type = "unlock-recipe",
		recipe = "panel-from-rubber",
	},
}
Icon.set(naturalRubberTech, "LSA/rubber/tech")
naturalRubberTech.localised_description = {"technology-description.rubber-1"}
naturalRubberTech.prerequisites = {"sulfur-processing"}
naturalRubberTech.unit = TECH["automation"].unit
extend{naturalRubberTech}

-- Create tech for synthetic rubber.
local syntheticRubberTech = copy(TECH["plastics"])
syntheticRubberTech.name = "rubber-2"
syntheticRubberTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "rubber-from-oil",
	},
}
Icon.set(syntheticRubberTech, "LSA/rubber/tech")
syntheticRubberTech.localised_description = {"technology-description.rubber-2"}
syntheticRubberTech.prerequisites = {"oil-processing", "rubber-1"}
extend{syntheticRubberTech}