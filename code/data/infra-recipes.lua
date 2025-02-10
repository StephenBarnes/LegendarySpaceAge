--[[ This file changes recipes for infrastructure (belts, vehicles, buildings, etc.)
Going in order by group and subgroup.
Prefer to use numbers like: 1, 2, 5, 10, 0.5. Maybe also 4, 0.25, etc. Goal is to have the per-second rates always be simple numbers so people can do mental math easily.
]]

local Recipe = require("code.util.recipe")
local Tech = require("code.util.tech")

local recipes = data.raw.recipe

------------------------------------------------------------------------
--- GROUP: LOGISTICS

-- Remove chest recipes, instead only use the steel one, and make it from factor intermediates.
for _, chestname in pairs{"wooden-chest", "iron-chest"} do
	for _, t in pairs{"item", "recipe", "container"} do
		data.raw[t][chestname].hidden = true
		data.raw[t][chestname].hidden_in_factoriopedia = true
	end
end
recipes["steel-chest"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "panel", amount = 4},
}
recipes["steel-chest"].enabled = true
Tech.removeRecipeFromTech("steel-chest", "steel-processing")

-- Transport belts - remove the nesting in the recipes (each tier ingredient to the next), and add rubber, and change to factor intermediates.
-- I also want them to get more expensive per throughput (as in vanilla), and increase in complexity.
recipes["transport-belt"].ingredients = {
	-- Base game is 1 iron plate + 1 gear for 2 belts, so 1.5 iron plate per belt.
	-- Changing it to 1 panel + 1 mechanism = 1 iron plate + 8 machine parts + 1 frame = 1 + 1 + 4 iron plates, so 6. So doubling amount produced to 4 belts.
	{type="item", name="panel", amount=1},
	{type="item", name="mechanism", amount=1},
}
recipes["transport-belt"].results = {{type="item", name="transport-belt", amount=4}}
recipes["fast-transport-belt"].ingredients = {
	{type="item", name="panel", amount=1},
	{type="item", name="mechanism", amount=1},
	{type="item", name="rubber", amount=1},
}
recipes["fast-transport-belt"].results = {{type="item", name="fast-transport-belt", amount=2}}
recipes["express-transport-belt"].ingredients = {
	{type="item", name="mechanism", amount=2},
	{type="item", name="rubber", amount=1},
	{type="fluid", name="lubricant", amount=20},
}
recipes["express-transport-belt"].allow_decomposition = true
recipes["express-transport-belt"].allow_as_intermediate = true
recipes["turbo-transport-belt"].ingredients = {
	{type="item", name="electric-engine-unit", amount=2},
	{type="item", name="tungsten-plate", amount=4},
	{type="fluid", name="lubricant", amount=20},
}
recipes["turbo-transport-belt"].allow_decomposition = true
recipes["turbo-transport-belt"].allow_as_intermediate = true
recipes["turbo-transport-belt"].category = "crafting-with-fluid-or-metallurgy" -- Allow in non-foundry buildings.
-- Underground belts - remove nesting. For ingredients, require literally just the number of belts, plus panels. So you can even craft them by hand, and eg turn green belts into green undergrounds off-Vulcanus.
recipes["underground-belt"].ingredients = {
	{type="item", name="transport-belt", amount=6},
	{type="item", name="panel", amount=2},
}
recipes["fast-underground-belt"].ingredients = {
	{type="item", name="fast-transport-belt", amount=8},
	{type="item", name="panel", amount=2},
}
recipes["express-underground-belt"].ingredients = {
	{type="item", name="express-transport-belt", amount=10},
	{type="item", name="panel", amount=2},
}
recipes["turbo-underground-belt"].ingredients = {
	{type="item", name="turbo-transport-belt", amount=12},
	{type="item", name="panel", amount=2},
}
recipes["turbo-underground-belt"].category = "crafting-with-fluid-or-metallurgy" -- Allow in non-foundry buildings.
-- Splitters - remove nesting. For ingredients, require 2 belts of that tier, plus sensor and mechanism. Nothing else, rather put it into the transport belt recipes.
recipes["splitter"].ingredients = {
	{type="item", name="transport-belt", amount=2},
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}
recipes["fast-splitter"].ingredients = {
	{type="item", name="fast-transport-belt", amount=2},
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}
recipes["express-splitter"].ingredients = {
	{type="item", name="express-transport-belt", amount=2},
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}
recipes["turbo-splitter"].ingredients = {
	{type="item", name="turbo-transport-belt", amount=2},
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}
recipes["turbo-splitter"].category = "crafting-with-fluid-or-metallurgy" -- Allow in non-foundry buildings.

-- Inserter recipes - rod is now enabled from the start.
recipes["burner-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
}
recipes["inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 1},
}
recipes["long-handed-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "mechanism", amount = 2},
	{type = "item", name = "sensor", amount = 1},
}
recipes["fast-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 1},
	{type = "fluid", name = "lubricant", amount = 20},
}
recipes["fast-inserter"].category = "crafting-with-fluid"
recipes["bulk-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "electric-engine-unit", amount = 1},
	{type = "item", name = "sensor", amount = 2},
	{type = "fluid", name = "lubricant", amount = 20},
}
recipes["bulk-inserter"].category = "crafting-with-fluid"
recipes["stack-inserter"].ingredients = {
	{type = "item", name = "bulk-inserter", amount = 1},
	{type = "item", name = "processing-unit", amount = 1},
	{type = "item", name = "carbon-fiber", amount = 2},
}

-- Electric poles
recipes["small-electric-pole"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
}
recipes["medium-electric-pole"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 1},
}
recipes["big-electric-pole"].ingredients = {
	{type = "item", name = "structure", amount = 1},
	{type = "item", name = "frame", amount = 3},
	{type = "item", name = "wiring", amount = 2},
}
recipes["substation"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 4},
	{type = "item", name = "advanced-circuit", amount = 4},
}
recipes["po-transformer"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "wiring", amount = 2},
	{type = "item", name = "electronic-circuit", amount = 2},
}

-- Pipes
recipes["pipe"].ingredients = {
	{type = "item", name = "fluid-fitting", amount = 1},
	{type = "item", name = "panel", amount = 4},
}
recipes["pipe"].results = {{type = "item", name = "pipe", amount = 4}}
recipes["pipe-to-ground"].ingredients = {
	{type = "item", name = "pipe", amount = 12},
}
-- Pump
recipes["pump"].ingredients = {
	{type="item", name="frame", amount=2},
	{type="item", name="fluid-fitting", amount=4},
	{type="item", name="mechanism", amount=2},
}

-- Rail stuff
recipes["rail"].ingredients = {
	{type="item", name="structure", amount=1},
	{type="item", name="frame", amount=1},
	-- Stone in rail recipe represents the track ballast; makes sense to crush/process stone before using as ballast. So could have sand as ingredient here, but it doesn't quite work with Gleba.
}
recipes["rail-ramp"].ingredients = {
	{type="item", name="structure", amount=20},
	{type="item", name="frame", amount=20},
	{type="item", name="rail", amount=8},
}
recipes["rail-support"].ingredients = {
	{type="item", name="structure", amount=4},
	{type="item", name="frame", amount=4},
}
-- Train stop: 4 frame + 2 small-lamp + 1 wiring + 2 electronic-circuit
recipes["train-stop"].ingredients = {
	{type="item", name="frame", amount=4},
	{type="item", name="small-lamp", amount=2},
	{type="item", name="sensor", amount=1},
}
-- Rail signals should need some glass.
recipes["rail-signal"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="sensor", amount=1},
	{type="item", name="small-lamp", amount=1},
}
recipes["rail-chain-signal"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="sensor", amount=2},
	{type="item", name="small-lamp", amount=1},
}
recipes["locomotive"].ingredients = {
	{type="item", name="engine-unit", amount=4},
	{type="item", name="sensor", amount=4},
	{type="item", name="shielding", amount=4},
	{type="item", name="frame", amount=4},
}
recipes["cargo-wagon"].ingredients = {
	{type="item", name="frame", amount=4},
	{type="item", name="mechanism", amount=4},
	{type="item", name="panel", amount=8},
}
-- Artillery-wagon: 20 shielding + 20 engine-unit + 8 electric-engine-unit + 4 structure + 8 sensor
recipes["artillery-wagon"].ingredients = {
	{type="item", name="shielding", amount=20},
	{type="item", name="engine-unit", amount=4},
	{type="item", name="electric-engine-unit", amount=8},
	{type="item", name="structure", amount=4},
	{type="item", name="sensor", amount=4},
}

-- Ports, signal buoys, cargo ships.
-- Port: 1 frame + 1 small-lamp + 1 sensor
recipes["port"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="small-lamp", amount=1},
	{type="item", name="sensor", amount=1},
}
-- Buoy: 1 frame + 1 small-lamp + 1 sensor
recipes["buoy"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="small-lamp", amount=1},
	{type="item", name="sensor", amount=1},
}
-- Chain_buoy: 1 frame + 1 small-lamp + 2 sensor
recipes["chain_buoy"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="small-lamp", amount=1},
	{type="item", name="sensor", amount=2},
}
-- Boat: 10 engine-unit + 20 frame + 20 panel
recipes["boat"].ingredients = {
	{type="item", name="engine-unit", amount=2},
	{type="item", name="frame", amount=20},
	{type="item", name="panel", amount=20},
}
-- Cargo ship: 40 engine-unit + 80 frame + 80 panel
recipes["cargo_ship"].ingredients = {
	{type="item", name="engine-unit", amount=8},
	{type="item", name="frame", amount=80},
	{type="item", name="panel", amount=80},
	{type="item", name="sensor", amount=4},
}
-- Oil_tanker: 40 engine-unit + 60 frame + 60 panel + 20 fluid-fitting + 10 storage-tank
recipes["oil_tanker"].ingredients = {
	{type="item", name="engine-unit", amount=8},
	{type="item", name="frame", amount=60},
	{type="item", name="panel", amount=60},
	{type="item", name="fluid-fitting", amount=20},
	{type="item", name="storage-tank", amount=10},
}

-- Vehicles
recipes["car"].ingredients = {
	{type="item", name="engine-unit", amount=1},
	{type="item", name="rubber", amount=4},
	{type="item", name="frame", amount=4},
	{type="item", name="shielding", amount=4},
}
recipes["tank"].ingredients = {
	{type="item", name="engine-unit", amount=4},
	{type="item", name="frame", amount=8},
	{type="item", name="shielding", amount=20},
	{type="item", name="advanced-circuit", amount=20},
}
recipes["spidertron"].ingredients = {
	{type="item", name="low-density-structure", amount=20},
	{type="item", name="exoskeleton-equipment", amount=4},
	{type="item", name="radar", amount=2},
	{type="item", name="rocket-turret", amount=1},
	{type="item", name="sensor", amount=8},
	--{type="item", name="pentapod-egg", amount=1}, -- Makes sense lore-wise, but I'd rather not force players to build them on Gleba, it's a pain to ship them.
	--{type="item", name="fission-reactor-equipment", amount=2}, -- Can't require this, because nuclear is now late-game.
}

-- Robot network
-- Recipes for logistic bots, construction bots, logistic chests are all fine.
recipes["roboport"].ingredients = {
	{type="item", name="frame", amount=4},
	{type="item", name="panel", amount=8},
	{type="item", name="electric-engine-unit", amount=8},
	{type="item", name="sensor", amount=8},
	{type="item", name="wiring", amount=4},
}

-- Circuit stuff
-- Lamp
recipes["small-lamp"].ingredients = {
	{ type = "item", name = "glass",  amount = 1 },
	{ type = "item", name = "wiring", amount = 1 },
	{ type = "item", name = "frame",  amount = 1 },
}
recipes["arithmetic-combinator"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="wiring", amount=2},
	{type="item", name="electronic-circuit", amount=1},
}
recipes["decider-combinator"].ingredients = data.raw.recipe["arithmetic-combinator"].ingredients
recipes["selector-combinator"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 4},
	{type = "item", name = "electronic-circuit", amount = 4},
}
recipes["constant-combinator"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 2},
}
recipes["power-switch"].ingredients = data.raw.recipe["po-transformer"].ingredients
recipes["programmable-speaker"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "panel", amount = 1},
}
recipes["display-panel"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "glass", amount = 1},
}

------------------------------------------------------------------------
--- GROUP: PRODUCTION

-- Repair pack
recipes["repair-pack"].ingredients = {
	{type="item", name="mechanism", amount=1},
	{type="item", name="sensor", amount=1},
}

-- Boilers
recipes["boiler"].ingredients = {
	{type = "item", name = "structure", amount = 2},
	{type = "item", name = "fluid-fitting", amount = 2},
	{type = "item", name = "shielding", amount = 2},
}
recipes["electric-boiler"].ingredients = {
	{type = "item", name = "structure", amount = 2},
	{type = "item", name = "fluid-fitting", amount = 2},
	{type = "item", name = "shielding", amount = 1},
	{type = "item", name = "wiring", amount = 2},
}
recipes["gas-boiler"].ingredients = {
	{type = "item", name = "structure", amount = 2},
	{type = "item", name = "fluid-fitting", amount = 4},
	{type = "item", name = "shielding", amount = 2},
}
recipes["boiler"].energy_required = 4
recipes["electric-boiler"].energy_required = 4
recipes["gas-boiler"].energy_required = 4

recipes["steam-engine"].ingredients = {
	{type = "item", name = "wiring", amount = 4},
	{type = "item", name = "mechanism", amount = 4},
	{type = "item", name = "fluid-fitting", amount = 2},
}
recipes["steam-engine"].energy_required = 4

recipes["heating-tower"].ingredients = {
	{type = "item", name = "structure", amount = 8},
	{type = "item", name = "shielding", amount = 4},
	{type = "item", name = "heat-pipe", amount = 4},
}
recipes["heating-tower"].energy_required = 8
recipes["fluid-heating-tower"].ingredients = {
	{type = "item", name = "structure", amount = 8},
	{type = "item", name = "shielding", amount = 4},
	{type = "item", name = "heat-pipe", amount = 4},
	{type = "item", name = "fluid-fitting", amount = 2},
}
recipes["fluid-heating-tower"].energy_required = 8

-- Heat pipe is originally 20 copper plate + 10 steel plate for 1. That seems very expensive for the size. Would make Aquilo and Gleba annoying. So I'll make it a lot cheaper.
recipes["heat-pipe"].ingredients = {
	{type = "item", name = "copper-plate", amount = 2},
	{type = "item", name = "steel-plate", amount = 1},
}
recipes["heat-exchanger"].ingredients = {
	{type = "item", name = "structure", amount = 2},
	{type = "item", name = "shielding", amount = 2},
	{type = "item", name = "fluid-fitting", amount = 2},
	{type = "item", name = "heat-pipe", amount = 2},
}
recipes["heat-exchanger"].energy_required = 4
recipes["steam-turbine"].ingredients = {
	{type = "item", name = "wiring", amount = 8},
	{type = "item", name = "mechanism", amount = 8},
	{type = "item", name = "fluid-fitting", amount = 4},
}
recipes["steam-turbine"].energy_required = 4

-- Solar panels.
recipes["solar-panel"].ingredients = {
	{type = "item", name = "glass", amount = 10},
	{type = "item", name = "silicon", amount = 10},
	{type = "item", name = "electronic-circuit", amount = 2},
	{type = "item", name = "frame", amount = 2},
}
recipes["solar-panel"].energy_required = 8

-- TODO stuff here

-- Furnaces
recipes["char-furnace"].ingredients = {{type="item", name="structure", amount=1}}
recipes["stone-furnace"].ingredients = {{type="item", name="structure", amount=1}}
recipes["steel-furnace"].ingredients = {
	{type="item", name="frame", amount=2},
	{type="item", name="structure", amount=2},
	{type="item", name="shielding", amount=4},
}
recipes["gas-furnace"].ingredients = {
	{type="item", name="frame", amount=2},
	{type="item", name="structure", amount=2},
	{type="item", name="shielding", amount=4},
	{type="item", name="fluid-fitting", amount=4},
}
recipes["electric-furnace"].ingredients = {
	{type="item", name="frame", amount=4},
	{type="item", name="structure", amount=4},
	{type="item", name="shielding", amount=8},
	{type="item", name="sensor", amount=2},
}
-- Foundry: 40 tungsten carbide + 40 shielding + 40 structure + 4 mechanism
recipes["foundry"].ingredients = {
	{type="item", name="tungsten-carbide", amount=40},
	{type="item", name="shielding", amount=40},
	{type="item", name="structure", amount=40},
	{type="item", name="mechanism", amount=4},
}

-- TODO stuff here

-- Chemical plant - shouldn't require steel bc we're moving it to automation 1. Also no pipe ingredients bc it comes before pipe tech. But it should cost more than assembler 1 since it's faster.
recipes["chemical-plant"].ingredients = {
	{type="item", name="frame", amount=2},
	{type="item", name="fluid-fitting", amount=8},
	{type="item", name="sensor", amount=2},
	{type="item", name="mechanism", amount=2},
}


------------------------------------------------------------------------
--- GROUP: SIMPLE INTERMEDIATES

-- TODO more

--[[Engine units.
Original recipe: 1 gear wheel + 1 steel plate + 2 pipe, which is around 2 + 5 + 2 = 9 iron plates.
I want a bunch of intermediates including factor intermediates.
New recipe: 1 shielding + 2 fluid fitting + 1 mechanism -> 1 engine.
Using basic recipes for the factors, that's 32 metal plate + 4 resin. So it's  like 4x the cost.
So, I've also reduced the number of engine units needed for other recipes to balance that. Which is more intuitively satisfying anyway, eg a car shouldn't need 8 combustion engines.
]]
recipes["engine-unit"].ingredients = {
	{type = "item", name = "shielding", amount = 1},
	{type = "item", name = "fluid-fitting", amount = 2},
	{type = "item", name = "mechanism", amount = 1},
}

------------------------------------------------------------------------
--- UNSORTED, TODO SORT STUFF BELOW



-- Stone bricks - allowed in foundry and handcrafting.
recipes["stone-brick"].category = "smelting-or-metallurgy-or-handcrafting"




-- Lab should need fewer circuits since they have to be handcrafted early-game.
recipes["lab"].ingredients = {
	{type="item", name="iron-gear-wheel", amount=8},
	{type="item", name="iron-plate", amount=8},
	{type="item", name="copper-cable", amount=4},
	{type="item", name="electronic-circuit", amount=4},
}

-- Assembling machines
recipes["assembling-machine-1"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="panel", amount=4},
	{type="item", name="mechanism", amount=2},
	{type="item", name="sensor", amount=1},
}
recipes["assembling-machine-2"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="panel", amount=4},
	{type="item", name="mechanism", amount=4},
	{type="item", name="sensor", amount=4},
}
recipes["assembling-machine-3"].ingredients = {
	{type="item", name="frame", amount=1},
	{type="item", name="panel", amount=4},
	{type="item", name="electric-engine-unit", amount=4},
	{type="item", name="sensor", amount=4},
}

-- Mining drills
-- Burner mining drill shouldn't need stone.
recipes["burner-mining-drill"].ingredients = {
	{type="item", name="iron-gear-wheel", amount=4},
	{type="item", name="iron-plate", amount=4},
}
recipes["big-mining-drill"].ingredients = {
	{type="item", name="electric-engine-unit", amount=8},
	{type="item", name="processing-unit", amount=10},
	{type="item", name="tungsten-carbide", amount=20},
	{type="fluid", name="molten-steel", amount=200},
}

-- Ag tower shouldn't need steel, or landfill, or spoilage.
recipes["agricultural-tower"].ingredients = {
	{type="item", name="iron-gear-wheel", amount=6},
	{type="item", name="iron-stick", amount=8},
	{type="item", name="electronic-circuit", amount=4},
	{type="item", name="glass", amount=4},
}

-- Armour should be cheaper, and require rubber.
recipes["light-armor"].ingredients = {-- Originally 40 iron plate.
	{type="item", name="iron-plate", amount=10},
}
recipes["heavy-armor"].ingredients = {-- Originally 100 copper plate, 50 steel plate.
	{type="item", name="steel-plate", amount=10},
	{type="item", name="rubber", amount=20},
}
Tech.addTechDependency("rubber-1", "heavy-armor")
recipes["modular-armor"].ingredients = {-- Originally 50 steel plate, 30 advanced circuits.
	{type="item", name="steel-plate", amount=20},
	{type="item", name="advanced-circuit", amount=20},
	{type="item", name="rubber", amount=20},
}
recipes["power-armor"].ingredients = {-- Originally 40 steel plate, 20 electric engine unit, 40 processing unit.
	{type="item", name="steel-plate", amount=20},
	{type="item", name="processing-unit", amount=20},
	{type="item", name="electric-engine-unit", amount=20},
	{type="item", name="rubber", amount=20},
}


-- Radar.
recipes["radar"].ingredients = {
	{type = "item", name = "iron-stick", amount = 5},
	{type = "item", name = "iron-plate", amount = 10},
	{type = "item", name = "iron-gear-wheel", amount = 5},
	{type = "item", name = "electronic-circuit", amount = 5},
}


-- Labs
recipes["lab"].ingredients = {
	{type = "item", name = "iron-gear-wheel", amount = 8},
	{type = "item", name = "electronic-circuit", amount = 4},
	{type = "item", name = "glass", amount = 2},
}
recipes["glebalab"].ingredients = {
	{type = "item", name = "steel-plate", amount = 10},
	{type = "item", name = "processing-unit", amount = 5},
	{type = "item", name = "pentapod-egg", amount = 5},
	{type = "item", name = "refined-concrete", amount = 10},
}
recipes["biolab"].ingredients = {
	{type = "item", name = "low-density-structure", amount = 20},
	{type = "item", name = "processing-unit", amount = 10},
	{type = "item", name = "uranium-fuel-cell", amount = 4},
	{type = "item", name = "biter-egg", amount = 5},
	{type = "item", name = "refined-concrete", amount = 20},
}

-- Grenades: 8 gunpowder + 4 iron plate.
recipes["grenade"].ingredients = {
	{type = "item", name = "iron-plate", amount = 2},
	{type = "item", name = "explosives", amount = 1},
}
recipes["cluster-grenade"].ingredients = {
	{type = "item", name = "steel-plate", amount = 1},
	{type = "item", name = "explosives", amount = 1},
	{type = "item", name = "grenade", amount = 7},
}

-- 2 pitch + 5 ammonia + 5 sulfuric acid + 2 iron plate -> 1 poison capsule
recipes["poison-capsule"].ingredients = {
	{type = "item", name = "iron-plate", amount = 2},
	{type = "item", name = "pitch", amount = 2},
	{type = "fluid", name = "ammonia", amount = 5},
	{type = "fluid", name = "sulfuric-acid", amount = 5},
}
recipes["poison-capsule"].category = "chemistry"
-- 2 resin + 5 tar + 5 water + 2 iron plate -> 1 slowdown capsule
recipes["slowdown-capsule"].ingredients = {
	{type = "item", name = "iron-plate", amount = 2},
	{type = "item", name = "resin", amount = 2},
	{type = "fluid", name = "tar", amount = 5},
	{type = "fluid", name = "water", amount = 5},
}
recipes["slowdown-capsule"].category = "chemistry"

-- Flying robot frames
recipes["flying-robot-frame"].ingredients = {
	{type = "item", name = "battery", amount = 2},
	{type = "item", name = "electric-engine-unit", amount = 2},
}

-- Modules
for _, moduleType in pairs{"speed", "efficiency", "productivity"} do
	Recipe.addIngredients(moduleType.."-module", {{type = "item", name = "resin", amount = 1}})
end

-- Make space platform tiles more complex and expensive to produce.
-- Originally 20 steel plate + 20 copper cable.
recipes["space-platform-foundation"].ingredients = {
	{ type = "item", name = "low-density-structure", amount = 4 },
		-- Effectively 80 copper plate, 8 steel plate, 12 plastic, 4 resin.
	{ type = "item", name = "electric-engine-unit", amount = 1 },
		-- Effectively lubricant plus metals.
	{ type = "item", name = "processing-unit", amount = 1 },
		-- Effectively sulfuric acid + plastic + metals.
}

-- Walls, gates
recipes["stone-wall"].ingredients = {
	{type = "item", name = "structure", amount = 1},
}
recipes["gate"].ingredients = {
	{type = "item", name = "shielding", amount = 4},
	{type = "item", name = "sensor", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
}
recipes["gate"].results = {{type = "item", name = "gate", amount = 4}}
recipes["gate"].always_show_products = true

-- Missile turret.
recipes["rocket-turret"].ingredients = {
	{type = "item", name = "shielding", amount = 4},
	{type = "item", name = "sensor", amount = 4},
	{type = "item", name = "rocket-launcher", amount = 4},
}

recipes["flamethrower-ammo"].ingredients = {
	{type = "item", name = "fluid-fitting", amount = 1},
	{type = "fluid", name = "light-oil", amount = 20},
}
