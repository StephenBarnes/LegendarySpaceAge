--[[ This file creates the diesel fluid and recipe.
Also hides tech/item/recipe for "rocket fuel".
Diesel is meant to be the only good fuel for trains, cars, tanks.
Fuel values are set separately in fuel.lua reading from util/constants.lua.
]]

local brightColor = {r = .667, g = .082, b = .094}
local darkColor = {r = .361, g = .055, b = .11}

-- Create diesel fluid.
local fluid = copy(FLUID["light-oil"])
fluid.name = "diesel"
Icon.set(fluid, "LSA/petrochem/diesel")
fluid.base_color = brightColor
fluid.flow_color = darkColor
fluid.visualization_color = brightColor
extend{fluid}

-- Create diesel recipe: 100 light oil + 50 rich gas -> 100 diesel.
local recipe = copy(RECIPE["rocket-fuel"])
recipe.name = "make-diesel" -- Not just "diesel" bc that merges it with the fluid in factoriopedia.
recipe.show_amount_in_title = false
recipe.ingredients = {
	{type = "fluid", name = "light-oil", amount = 100},
	{type = "fluid", name = "petroleum-gas", amount = 50},
}
recipe.results = {{type = "fluid", name = "diesel", amount = 100}}
recipe.main_product = "diesel"
recipe.allow_productivity = false
recipe.allow_quality = false
recipe.subgroup = "complex-fluid-recipes"
recipe.order = "e"
recipe.energy_required = 1
recipe.category = "chemistry" -- Could also allow "crafting-with-fluid" but then assemblers need 2 fluid inputs.
extend{recipe}

-- Create tech for diesel.
local tech = copy(TECH["rocket-fuel"])
tech.name = "diesel"
tech.effects = {
	{type = "unlock-recipe", recipe = "make-diesel"},
}
Icon.set(tech, "LSA/petrochem/diesel-tech")
tech.prerequisites = {"oil-processing"}
tech.unit.ingredients = {
	{"automation-science-pack", 1},
	{"logistic-science-pack", 1},
}
extend{tech}

-- Hide rocket fuel stuff - recipe, item, tech.
ITEM["rocket-fuel"].hidden = true
RECIPE["rocket-fuel"].hidden = true
TECH["rocket-fuel"].hidden = true
TECH["rocket-fuel-productivity"].hidden = true
RECIPE["ammonia-rocket-fuel"].hidden = true
Tech.removeRecipeFromTech("ammonia-rocket-fuel", "planet-discovery-aquilo")