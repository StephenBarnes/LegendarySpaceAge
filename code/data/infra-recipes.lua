--[[ This file changes recipes for infrastructure (belts, vehicles, buildings, etc.)
Going in order by group and subgroup.
]]

local Recipe = require("code.util.recipe")
local Tech = require("code.util.tech")

------------------------------------------------------------------------
--- GROUP: LOGISTICS

-- Remove chest recipes, instead only use the steel one, and make it from factor intermediates.
for _, chestname in pairs{"wooden-chest", "iron-chest"} do
	for _, t in pairs{"item", "recipe", "container"} do
		data.raw[t][chestname].hidden = true
		data.raw[t][chestname].hidden_in_factoriopedia = true
	end
end
data.raw.recipe["steel-chest"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "panel", amount = 4},
}
data.raw.recipe["steel-chest"].enabled = true
Tech.removeRecipeFromTech("steel-chest", "steel-processing")

-- Transport belts - remove the nesting in the recipes (each tier ingredient to the next), and add rubber, and change to factor intermediates.
-- I also want them to get more expensive per throughput (as in vanilla), and increase in complexity.
data.raw.recipe["transport-belt"].ingredients = {
	-- Base game is 1 iron plate + 1 gear for 2 belts, so 1.5 iron plate per belt.
	-- Changing it to 1 panel + 1 mechanism = 1 iron plate + 8 machine parts + 1 frame = 1 + 1 + 4 iron plates, so 6. So doubling amount produced to 4 belts.
	{type="item", name="panel", amount=1},
	{type="item", name="mechanism", amount=1},
}
data.raw.recipe["transport-belt"].results = {{type="item", name="transport-belt", amount=4}}
data.raw.recipe["fast-transport-belt"].ingredients = {
	{type="item", name="panel", amount=1},
	{type="item", name="mechanism", amount=1},
	{type="item", name="rubber", amount=1},
}
data.raw.recipe["fast-transport-belt"].results = {{type="item", name="fast-transport-belt", amount=2}}
data.raw.recipe["express-transport-belt"].ingredients = {
	{type="item", name="mechanism", amount=2},
	{type="item", name="rubber", amount=1},
	{type="fluid", name="lubricant", amount=20},
}
data.raw.recipe["express-transport-belt"].allow_decomposition = true
data.raw.recipe["express-transport-belt"].allow_as_intermediate = true
data.raw.recipe["turbo-transport-belt"].ingredients = {
	{type="item", name="electric-engine-unit", amount=2},
	{type="item", name="tungsten-plate", amount=4},
	{type="fluid", name="lubricant", amount=20},
}
data.raw.recipe["turbo-transport-belt"].allow_decomposition = true
data.raw.recipe["turbo-transport-belt"].allow_as_intermediate = true
data.raw.recipe["turbo-transport-belt"].category = "crafting-with-fluid-or-metallurgy" -- Allow in non-foundry buildings.
-- Underground belts - remove nesting. For ingredients, require literally just the number of belts, plus panels. So you can even craft them by hand, and eg turn green belts into green undergrounds off-Vulcanus.
data.raw.recipe["underground-belt"].ingredients = {
	{type="item", name="transport-belt", amount=6},
	{type="item", name="panel", amount=2},
}
data.raw.recipe["fast-underground-belt"].ingredients = {
	{type="item", name="fast-transport-belt", amount=8},
	{type="item", name="panel", amount=2},
}
data.raw.recipe["express-underground-belt"].ingredients = {
	{type="item", name="express-transport-belt", amount=10},
	{type="item", name="panel", amount=2},
}
data.raw.recipe["turbo-underground-belt"].ingredients = {
	{type="item", name="turbo-transport-belt", amount=12},
	{type="item", name="panel", amount=2},
}
data.raw.recipe["turbo-underground-belt"].category = "crafting-with-fluid-or-metallurgy" -- Allow in non-foundry buildings.
-- Splitters - remove nesting. For ingredients, require 2 belts of that tier, plus sensor and mechanism. Nothing else, rather put it into the transport belt recipes.
data.raw.recipe["splitter"].ingredients = {
	{type="item", name="transport-belt", amount=2},
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}
data.raw.recipe["fast-splitter"].ingredients = {
	{type="item", name="fast-transport-belt", amount=2},
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}
data.raw.recipe["express-splitter"].ingredients = {
	{type="item", name="express-transport-belt", amount=2},
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}
data.raw.recipe["turbo-splitter"].ingredients = {
	{type="item", name="turbo-transport-belt", amount=2},
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}
data.raw.recipe["turbo-splitter"].category = "crafting-with-fluid-or-metallurgy" -- Allow in non-foundry buildings.

-- Inserter recipes - rod is now enabled from the start.
data.raw.recipe["burner-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
}
data.raw.recipe["inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 1},
}
data.raw.recipe["long-handed-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "mechanism", amount = 2},
	{type = "item", name = "sensor", amount = 1},
}
data.raw.recipe["fast-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 1},
	{type = "fluid", name = "lubricant", amount = 20},
}
data.raw.recipe["fast-inserter"].category = "crafting-with-fluid"
data.raw.recipe["bulk-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "electric-engine-unit", amount = 1},
	{type = "item", name = "sensor", amount = 2},
	{type = "fluid", name = "lubricant", amount = 20},
}
data.raw.recipe["bulk-inserter"].category = "crafting-with-fluid"
data.raw.recipe["stack-inserter"].ingredients = {
	{type = "item", name = "bulk-inserter", amount = 1},
	{type = "item", name = "processing-unit", amount = 1},
	{type = "item", name = "carbon-fiber", amount = 2},
}

-- Electric poles
data.raw.recipe["small-electric-pole"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
}
data.raw.recipe["medium-electric-pole"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 1},
}
data.raw.recipe["big-electric-pole"].ingredients = {
	{type = "item", name = "frame", amount = 4},
	{type = "item", name = "wiring", amount = 2},
}
data.raw.recipe["substation"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 4},
	{type = "item", name = "advanced-circuit", amount = 4},
}

-- TODO stuff here

-- Circuit stuff
-- TODO more
data.raw.recipe["power-switch"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 2},
	{type = "item", name = "electronic-circuit", amount = 2},
}


------------------------------------------------------------------------
--- UNSORTED, TODO SORT STUFF BELOW

-- Lamp
data.raw.recipe["small-lamp"].ingredients = {
	{ type = "item", name = "glass",  amount = 1 },
	{ type = "item", name = "wiring", amount = 1 },
	{ type = "item", name = "frame",  amount = 1 },
}

-- Repair pack
data.raw.recipe["repair-pack"].ingredients = {
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}

-- Stone bricks - allowed in foundry and handcrafting.
data.raw.recipe["stone-brick"].category = "smelting-or-metallurgy-or-handcrafting"


-- Furnaces
data.raw.recipe["char-furnace"].ingredients = {{type="item", name="structure", amount=1}}
data.raw.recipe["stone-furnace"].ingredients = {{type="item", name="structure", amount=1}}
data.raw.recipe["steel-furnace"].ingredients = {
	{type="item", name="frame", amount=2},
	{type="item", name="structure", amount=2},
	{type="item", name="shielding", amount=4},
}
data.raw.recipe["gas-furnace"].ingredients = {
	{type="item", name="frame", amount=2},
	{type="item", name="shielding", amount=4},
	{type="item", name="fluid-fitting", amount=4},
}

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
	--{type="item", name="fission-reactor-equipment", amount=2},
	{type="item", name="exoskeleton-equipment", amount=4},
	{type="item", name="radar", amount=2},
	{type="item", name="rocket-turret", amount=1},
}


-- Pumps
data.raw.recipe["pump"].ingredients = {
	{type="item", name="frame", amount=2},
	{type="item", name="fluid-fitting", amount=4},
	{type="item", name="mechanism", amount=2},
}

-- Chemical plant - shouldn't require steel bc we're moving it to automation 1. Also no pipe ingredients bc it comes before pipe tech. But it should cost more than assembler 1 since it's faster.
data.raw.recipe["chemical-plant"].ingredients = {
	{type="item", name="iron-gear-wheel", amount=4},
	{type="item", name="electronic-circuit", amount=4},
	{type="item", name="iron-plate", amount=12},
	{type="item", name="glass", amount=4},
}

-- Lab should need fewer circuits since they have to be handcrafted early-game.
data.raw.recipe["lab"].ingredients = {
	{type="item", name="iron-gear-wheel", amount=8},
	{type="item", name="iron-plate", amount=8},
	{type="item", name="copper-cable", amount=4},
	{type="item", name="electronic-circuit", amount=4},
}

-- Stone in rail recipe represents the track ballast; makes sense to crush/process stone before using as ballast.
Recipe.substituteIngredient("rail", "stone", "sand")

-- Rail signals should need some glass.
data.raw.recipe["rail-signal"].ingredients = {
	{type="item", name="iron-plate", amount=2},
	{type="item", name="electronic-circuit", amount=1},
	{type="item", name="glass", amount=1},
}
data.raw.recipe["rail-chain-signal"].ingredients = {
	{type="item", name="iron-plate", amount=2},
	{type="item", name="electronic-circuit", amount=2},
	{type="item", name="glass", amount=1},
}

-- Assembling machines
data.raw.recipe["assembling-machine-1"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="panel", amount=4},
	{type="item", name="mechanism", amount=2},
	{type="item", name="sensor", amount=1},
	{type="item", name="electronic-circuit", amount=2},
}
data.raw.recipe["assembling-machine-2"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="panel", amount=4},
	{type="item", name="mechanism", amount=4},
	{type="item", name="sensor", amount=4},
	{type="item", name="advanced-circuit", amount=2},
}
data.raw.recipe["assembling-machine-3"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="panel", amount=4},
	{type="item", name="electric-engine-unit", amount=4},
	{type="item", name="sensor", amount=4},
	{type="item", name="processing-unit", amount=2},
}

-- Mining drills
-- Burner mining drill shouldn't need stone.
data.raw.recipe["burner-mining-drill"].ingredients = {
	{type="item", name="iron-gear-wheel", amount=4},
	{type="item", name="iron-plate", amount=4},
}
data.raw.recipe["big-mining-drill"].ingredients = {
	{type="item", name="electric-engine-unit", amount=8},
	{type="item", name="processing-unit", amount=10},
	{type="item", name="tungsten-carbide", amount=20},
	{type="fluid", name="molten-steel", amount=200},
}

-- Ag tower shouldn't need steel, or landfill, or spoilage.
data.raw.recipe["agricultural-tower"].ingredients = {
	{type="item", name="iron-gear-wheel", amount=6},
	{type="item", name="iron-stick", amount=8},
	{type="item", name="electronic-circuit", amount=4},
	{type="item", name="glass", amount=4},
}

-- Armour should be cheaper, and require rubber.
data.raw.recipe["light-armor"].ingredients = {-- Originally 40 iron plate.
	{type="item", name="iron-plate", amount=10},
}
data.raw.recipe["heavy-armor"].ingredients = {-- Originally 100 copper plate, 50 steel plate.
	{type="item", name="steel-plate", amount=10},
	{type="item", name="rubber", amount=20},
}
Tech.addTechDependency("rubber-1", "heavy-armor")
data.raw.recipe["modular-armor"].ingredients = {-- Originally 50 steel plate, 30 advanced circuits.
	{type="item", name="steel-plate", amount=20},
	{type="item", name="advanced-circuit", amount=20},
	{type="item", name="rubber", amount=20},
}
data.raw.recipe["power-armor"].ingredients = {-- Originally 40 steel plate, 20 electric engine unit, 40 processing unit.
	{type="item", name="steel-plate", amount=20},
	{type="item", name="processing-unit", amount=20},
	{type="item", name="electric-engine-unit", amount=20},
	{type="item", name="rubber", amount=20},
}


-- Radar.
data.raw.recipe["radar"].ingredients = {
	{type = "item", name = "iron-stick", amount = 5},
	{type = "item", name = "iron-plate", amount = 10},
	{type = "item", name = "iron-gear-wheel", amount = 5},
	{type = "item", name = "electronic-circuit", amount = 5},
}

-- Solar panels.
data.raw.recipe["solar-panel"].ingredients = {
	{type = "item", name = "glass", amount = 10},
	{type = "item", name = "silicon", amount = 10},
	{type = "item", name = "electronic-circuit", amount = 2},
	{type = "item", name = "steel-plate", amount = 4},
}

-- Labs
data.raw.recipe.lab.ingredients = {
	{type = "item", name = "iron-gear-wheel", amount = 8},
	{type = "item", name = "electronic-circuit", amount = 4},
	{type = "item", name = "glass", amount = 2},
}
data.raw.recipe.glebalab.ingredients = {
	{type = "item", name = "steel-plate", amount = 10},
	{type = "item", name = "processing-unit", amount = 5},
	{type = "item", name = "pentapod-egg", amount = 5},
	{type = "item", name = "refined-concrete", amount = 10},
}
data.raw.recipe.biolab.ingredients = {
	{type = "item", name = "low-density-structure", amount = 20},
	{type = "item", name = "processing-unit", amount = 10},
	{type = "item", name = "uranium-fuel-cell", amount = 4},
	{type = "item", name = "biter-egg", amount = 5},
	{type = "item", name = "refined-concrete", amount = 20},
}

-- Grenades: 8 gunpowder + 4 iron plate.
data.raw.recipe["grenade"].ingredients = {
	{type = "item", name = "iron-plate", amount = 2},
	{type = "item", name = "explosives", amount = 1},
}
data.raw.recipe["cluster-grenade"].ingredients = {
	{type = "item", name = "steel-plate", amount = 1},
	{type = "item", name = "explosives", amount = 1},
	{type = "item", name = "grenade", amount = 7},
}

-- 2 pitch + 5 ammonia + 5 sulfuric acid + 2 iron plate -> 1 poison capsule
data.raw.recipe["poison-capsule"].ingredients = {
	{type = "item", name = "iron-plate", amount = 2},
	{type = "item", name = "pitch", amount = 2},
	{type = "fluid", name = "ammonia", amount = 5},
	{type = "fluid", name = "sulfuric-acid", amount = 5},
}
data.raw.recipe["poison-capsule"].category = "chemistry"
-- 2 resin + 5 tar + 5 water + 2 iron plate -> 1 slowdown capsule
data.raw.recipe["slowdown-capsule"].ingredients = {
	{type = "item", name = "iron-plate", amount = 2},
	{type = "item", name = "resin", amount = 2},
	{type = "fluid", name = "tar", amount = 5},
	{type = "fluid", name = "water", amount = 5},
}
data.raw.recipe["slowdown-capsule"].category = "chemistry"

-- Flying robot frames
data.raw.recipe["flying-robot-frame"].ingredients = {
	{type = "item", name = "battery", amount = 2},
	{type = "item", name = "electric-engine-unit", amount = 2},
}

-- Modules
for _, moduleType in pairs{"speed", "efficiency", "productivity"} do
	Recipe.addIngredients(moduleType.."-module", {{type = "item", name = "resin", amount = 1}})
end

-- Make space platform tiles more complex and expensive to produce.
-- Originally 20 steel plate + 20 copper cable.
data.raw.recipe["space-platform-foundation"].ingredients = {
	{ type = "item", name = "low-density-structure", amount = 4 },
		-- Effectively 80 copper plate, 8 steel plate, 12 plastic, 4 resin.
	{ type = "item", name = "electric-engine-unit", amount = 1 },
		-- Effectively lubricant plus metals.
	{ type = "item", name = "processing-unit", amount = 1 },
		-- Effectively sulfuric acid + plastic + metals.
}

-- Walls, gates
data.raw.recipe["stone-wall"].ingredients = {
	{type = "item", name = "structure", amount = 1},
}
data.raw.recipe["gate"].ingredients = {
	{type = "item", name = "shielding", amount = 4},
	{type = "item", name = "sensor", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
}
data.raw.recipe["gate"].results = {{type = "item", name = "gate", amount = 4}}
data.raw.recipe.gate.always_show_products = true