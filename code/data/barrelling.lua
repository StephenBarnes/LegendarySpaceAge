--[[ This file creates a new techs for barrelling and gas tanks, moves barrelling recipes to the new tech, and creates gas tanks and their recipes, etc. Also adds fuel values to barrels and tanks. ]]

local Table = require("code.util.table")
local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

-- Create the new tech.
local gasTankTech = Table.copyAndEdit(data.raw.technology["oil-processing"], {
	name = "fluid-containers",
	prerequisites = {"fluid-handling"},
	effects = {
		{type = "unlock-recipe", recipe = "barrel"},
		{type = "unlock-recipe", recipe = "gas-tank"},
	},
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/gas-tanks/tech.png", icon_size = 256, scale = 0.5},
	},
})
data:extend{gasTankTech}

-- Create the new empty gas tank item.
local emptyGasTankTint = {.3, .3, .3}
local emptyGasTankItem = Table.copyAndEdit(data.raw.item["barrel"], {
	name = "gas-tank",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/gas-tanks/straight/tank.png", icon_size = 64, scale = 0.5},
		{icon = "__LegendarySpaceAge__/graphics/gas-tanks/straight/overlay-side.png", icon_size = 64, scale = 0.5, tint = emptyGasTankTint},
		{icon = "__LegendarySpaceAge__/graphics/gas-tanks/straight/overlay-top.png", icon_size = 64, scale = 0.5, tint = emptyGasTankTint},
	},
	order = data.raw.item["barrel"].order .. "-1",
})
data:extend{emptyGasTankItem}

-- Create recipe for empty gas tank.
local emptyGasTankRecipe = Table.copyAndEdit(data.raw.recipe["barrel"], {
	name = "gas-tank",
	ingredients = {
		{type = "item", name = "panel", amount = 2},
		{type = "item", name = "fluid-fitting", amount = 2},
	},
	results = {{type = "item", name = "gas-tank", amount = 1}},
})
data:extend{emptyGasTankRecipe}

-- Edit recipe for barrel - previously only 1 steel plate.
data.raw.recipe["barrel"].ingredients = {
	{type = "item", name = "panel", amount = 3},
	{type = "item", name = "fluid-fitting", amount = 1},
}

-- Create subgroup for recipes filling and emptying gas tanks.
data:extend{
	{
		type = "item-subgroup",
		name = "fill-gas-tank",
		group = "intermediate-products",
		order = "e2",
	},
	{
		type = "item-subgroup",
		name = "empty-gas-tank",
		group = "intermediate-products",
		order = "f2",
	},
}

-- Hide fluid wagons.
Tech.hideTech("fluid-wagon")
Recipe.hide("fluid-wagon")
data.raw["item-with-entity-data"]["fluid-wagon"].hidden_in_factoriopedia = true
data.raw["fluid-wagon"]["fluid-wagon"].hidden_in_factoriopedia = true
-- Can't do .hidden = true because that crashes Factory Planner.

-- TODO look through fluids, maybe add more barrelling recipes. Eg for Gleban slime.
-- Allow more fluids in barrels and tanks.
data.raw.fluid.steam.auto_barrel = true
data.raw.fluid["holmium-solution"].auto_barrel = true
data.raw.fluid["electrolyte"].auto_barrel = true
data.raw.fluid["thruster-oxidizer"].auto_barrel = true
data.raw.fluid["thruster-fuel"].auto_barrel = true
data.raw.fluid["ammonia"].auto_barrel = true
data.raw.fluid["fluorine"].auto_barrel = true