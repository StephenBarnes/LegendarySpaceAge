-- This file changes recipes for infrastructure (belts, vehicles, buildings, etc.)

local Recipe = require("code.util.recipe")

-- Vehicles
data.raw.recipe["car"].ingredients = {
	{type="item", name="engine-unit", amount=8},
	{type="item", name="rubber", amount=4},
	{type="item", name="iron-plate", amount=20},
	{type="item", name="steel-plate", amount=20},
}
data.raw.recipe["tank"].ingredients = {
	{type="item", name="engine-unit", amount=32},
	{type="item", name="rubber", amount=16},
	{type="item", name="iron-gear-wheel", amount=20},
	{type="item", name="steel-plate", amount=60},
	{type="item", name="advanced-circuit", amount=40},
}
data.raw.recipe["spidertron"].ingredients = {
	{type="item", name="pentapod-egg", amount=1},
	{type="item", name="rubber", amount=16},
	{type="item", name="fission-reactor-equipment", amount=2},
	{type="item", name="exoskeleton-equipment", amount=4},
	{type="item", name="radar", amount=2},
	{type="item", name="rocket-turret", amount=1},
}

-- Transport belts - add rubber, and remove the nesting in the recipes (each tier ingredient to the next).
-- I also want them to get more expensive per throughput (as in vanilla), and increase in complexity.
data.raw.recipe["transport-belt"].ingredients = {
	{type="item", name="iron-plate", amount=1},
	{type="item", name="iron-gear-wheel", amount=2},
}
data.raw.recipe["fast-transport-belt"].ingredients = {
	{type="item", name="iron-plate", amount=1},
	{type="item", name="iron-gear-wheel", amount=6},
	{type="item", name="rubber", amount=1},
}
data.raw.recipe["express-transport-belt"].ingredients = {
	{type="item", name="iron-plate", amount=1},
	{type="item", name="advanced-parts", amount=6},
	{type="item", name="rubber", amount=1},
	{type="fluid", name="lubricant", amount=20},
}
data.raw.recipe["turbo-transport-belt"].ingredients = {
	{type="fluid", name="lubricant", amount=40},
	{type="item", name="tungsten-plate", amount=4},
	{type="item", name="rubber", amount=1},
	{type="item", name="advanced-parts", amount=12},
}
-- Underground belts - remove nesting. For ingredients, require literally just the number of belts, plus some extra ingredients of that belt.
data.raw.recipe["underground-belt"].ingredients = {
	{type="item", name="transport-belt", amount=6},
	{type="item", name="iron-plate", amount=2},
	{type="item", name="iron-gear-wheel", amount=2},
}
data.raw.recipe["fast-underground-belt"].ingredients = {
	{type="item", name="fast-transport-belt", amount=8},
	{type="item", name="iron-plate", amount=4},
	{type="item", name="rubber", amount=1},
}
data.raw.recipe["express-underground-belt"].ingredients = {
	{type="item", name="express-transport-belt", amount=10},
	{type="item", name="iron-plate", amount=4},
	{type="item", name="rubber", amount=2},
	{type="fluid", name="lubricant", amount=20},
}
data.raw.recipe["turbo-underground-belt"].ingredients = {
	{type="item", name="turbo-transport-belt", amount=12},
	{type="item", name="tungsten-plate", amount=4},
	{type="item", name="rubber", amount=2},
	{type="fluid", name="lubricant", amount=40},
}
-- Splitters - remove nesting. For ingredients, require 2 belts of that tier, plus some circuits and ingredients of that belt tier.
data.raw.recipe["splitter"].ingredients = {
	{type="item", name="transport-belt", amount=2},
	{type="item", name="iron-plate", amount=2},
	{type="item", name="iron-gear-wheel", amount=4},
	{type="item", name="electronic-circuit", amount=2},
}
data.raw.recipe["fast-splitter"].ingredients = {
	{type="item", name="fast-transport-belt", amount=2},
	{type="item", name="iron-gear-wheel", amount=8},
	{type="item", name="rubber", amount=1},
	{type="item", name="electronic-circuit", amount=4},
}
data.raw.recipe["express-splitter"].ingredients = {
	{type="item", name="express-transport-belt", amount=2},
	{type="item", name="rubber", amount=4},
	{type="fluid", name="lubricant", amount=40},
	{type="item", name="advanced-circuit", amount=2},
}
data.raw.recipe["turbo-splitter"].ingredients = {
	{type="item", name="turbo-transport-belt", amount=2},
	{type="item", name="tungsten-plate", amount=4},
	{type="item", name="rubber", amount=4},
	{type="fluid", name="lubricant", amount=40},
	{type="item", name="processing-unit", amount=2},
}

-- Pumps
data.raw.recipe["pump"].ingredients = {
	{type="item", name="pipe", amount=2},
	{type="item", name="engine-unit", amount=1},
	{type="item", name="rubber", amount=2},
}

-- Chemical plant - shouldn't require steel, since we're moving it to automation 1.
data.raw.recipe["chemical-plant"].ingredients = {
	{type="item", name="iron-plate", amount=5},
	{type="item", name="iron-gear-wheel", amount=5},
	{type="item", name="electronic-circuit", amount=5},
	{type="item", name="pipe", amount=5},
}

-- Lab should need fewer circuits since they have to be handcrafted early-game.
data.raw.recipe["lab"].ingredients = {
	{type="item", name="iron-gear-wheel", amount=8},
	{type="item", name="iron-plate", amount=8},
	{type="item", name="copper-cable", amount=4},
	{type="item", name="electronic-circuit", amount=4},
}

-- Electric engine unit
data.raw.recipe["electric-engine-unit"].ingredients = {
	{type="fluid", name="lubricant", amount=15},
	{type="item", name="advanced-parts", amount=5},
	{type="item", name="advanced-circuit", amount=1},
}

-- Stone in rail recipe represents the track ballast; makes sense to crush/process stone before using as ballast.
Recipe.substituteIngredient("rail", "stone", "sand")

Recipe.substituteIngredient("holmium-solution", "stone", "sand")
Recipe.substituteIngredient("electrolyte", "stone", "sand")

-- Assembling machines
data.raw.recipe["assembling-machine-2"].ingredients = {
	{type="item", name="iron-gear-wheel", amount=5},
	{type="item", name="rubber", amount=1},
	{type="item", name="plastic-bar", amount=1},
	{type="item", name="advanced-circuit", amount=2},
}
data.raw.recipe["assembling-machine-3"].ingredients = {
	{type="item", name="advanced-parts", amount=12},
	{type="item", name="electric-engine-unit", amount=2},
	{type="item", name="speed-module", amount=4},
	{type="fluid", name="lubricant", amount=20},
}
data.raw.recipe["assembling-machine-3"].category = "crafting-with-fluid"

-- Burner mining drill shouldn't need stone.
data.raw.recipe["burner-mining-drill"].ingredients = {
	{type="item", name="iron-gear-wheel", amount=4},
	{type="item", name="iron-plate", amount=4},
}

-- TODO look up real-world concrete recipes; eg maybe require sand instead of stone bricks, or sand + stone; also maybe add liquid concrete as intermediate. (And sulfur-based concrete on Vulcanus.)