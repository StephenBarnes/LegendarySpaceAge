--[[ This file creates the diesel fluid and recipe.
Also hides tech/item/recipe for "rocket fuel".
Diesel is meant to be the only good fuel for trains, cars, tanks.
Fuel values are set separately in fuel.lua reading from util/constants.lua.
]]

local Tech = require("code.util.tech")

local brightColor = {r = .667, g = .082, b = .094}
local darkColor = {r = .361, g = .055, b = .11}

-- Create diesel fluid.
local fluid = table.deepcopy(data.raw.fluid["light-oil"])
fluid.name = "diesel"
fluid.icon = "__LegendarySpaceAge__/graphics/petrochem/diesel.png"
fluid.base_color = brightColor
fluid.flow_color = darkColor
fluid.visualization_color = brightColor
data:extend{fluid}

-- Create diesel recipe: 100 light oil + 50 rich gas -> 100 diesel.
local recipe = table.deepcopy(data.raw.recipe["rocket-fuel"])
recipe.name = "make-diesel" -- Not just "diesel" bc that merges it with the fluid in factoriopedia.
recipe.ingredients = {
	{type = "fluid", name = "light-oil", amount = 100},
	{type = "fluid", name = "petroleum-gas", amount = 50},
}
recipe.results = {{type = "fluid", name = "diesel", amount = 100}}
recipe.main_product = "diesel"
recipe.maximum_productivity = 0.2
recipe.subgroup = "complex-fluid-recipes"
recipe.order = "e"
recipe.energy_required = 2
recipe.category = "chemistry-or-crafting-with-fluid"
data:extend{recipe}

-- Create tech for diesel.
local tech = table.deepcopy(data.raw.technology["rocket-fuel"])
tech.name = "diesel"
tech.effects = {
	{type = "unlock-recipe", recipe = "make-diesel"},
}
tech.icon = "__LegendarySpaceAge__/graphics/petrochem/diesel-tech.png"
tech.prerequisites = {"oil-processing", "fluid-containers"}
tech.unit.ingredients = {
	{"automation-science-pack", 1},
	{"logistic-science-pack", 1},
}
data:extend{tech}

-- Hide rocket fuel stuff - recipe, item, tech.
data.raw.item["rocket-fuel"].hidden = true
data.raw.recipe["rocket-fuel"].hidden = true
data.raw.technology["rocket-fuel"].hidden = true
data.raw.technology["rocket-fuel-productivity"].hidden = true
data.raw.recipe["ammonia-rocket-fuel"].hidden = true
Tech.removeRecipeFromTech("ammonia-rocket-fuel", "planet-discovery-aquilo")