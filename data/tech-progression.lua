-- This file adjusts the overall progression, by moving techs around, changing dependencies, moving recipes between techs, etc.

-- Early techs: basic electricity, then electronics, then personal burner generator, then red science, then automation, then filtration, then steam power.
Tech.setPrereqs("electronics", {"basic-electricity", "char"})
Tech.setPrereqs("automation", {"electronics", "lamp"})
Tech.addTechDependency("filtration-lake-water", "steam-power")
TECH["steam-power"].unit = nil
TECH["steam-power"].research_trigger = {
	type = "craft-fluid",
	fluid = "water",
	amount = 1000,
}
TECH["automation"].unit = nil
TECH["automation"].research_trigger = {
	type = "craft-item",
	item = "electronic-circuit",
	count = 1,
}

-- In the gap between automation and automation-science-pack, player does production challenge of like 150 hot iron per minute.
TECH["automation-science-pack"].prerequisites = {"automation"}
TECH["automation-science-pack"].unit = nil
Tech.removeRecipeFromTech("lab", "electronics")
Tech.addRecipeToTech("lab", "automation-science-pack")
RECIPE["automation-science-pack"].ingredients = {
	{type = "item", name = "iron-gear-wheel", amount = 1},
	{type = "item", name = "glass", amount = 1},
}

-- Military 1 now depends on coal coking, for gunpowder. Also gun turrets.
TECH["military"].prerequisites = {"gunpowder", "automation-science-pack"}
TECH["gun-turret"].prerequisites = {"gunpowder", "automation-science-pack"}

-- Move electric inserter to automation tech.
Tech.removeRecipeFromTech("inserter", "electronics")
Tech.addRecipeToTech("inserter", "automation")

-- Unlock electronics when a hand-crank is built.
TECH["electronics"].unit = nil
TECH["electronics"].research_trigger = {
	type = "build-entity",
	entity = "er-hcg",
}

-- Move pipe recipes from steam power to automation.
-- Remove offshore pump recipe from steam power, will add to filtration.
TECH["steam-power"].effects = {
	{type = "unlock-recipe", recipe = "boiler"},
	{type = "unlock-recipe", recipe = "gas-boiler"},
	{type = "unlock-recipe", recipe = "electric-boiler"},
	{type = "unlock-recipe", recipe = "steam-engine"},
}

-- Tank ship shouldn't depend on Fluid handling 2. 
Tech.setPrereqs("tank_ship", {"automated_water_transport"})

-- Logistics 2 depends on rubber.
Tech.addTechDependency("rubber-1", "logistics-2")

-- Car shouldn't need logistics 2, should need rubber.
Tech.setPrereqs("automobilism", {"rubber-1", "engine"})

-- Railway shouldn't depend on logistics 2.
Tech.setPrereqs("railway", {"engine"})

-- Logistics chain 2->3
Tech.addTechDependency("logistics-2", "logistics-3")

-- Move chem plant to early game, since it's needed for coal coking and gunpowder.
Tech.removeRecipeFromTech("chemical-plant", "oil-processing")

-- Coal liquefaction tech should be soon after oil processing.
Tech.setPrereqs("coal-liquefaction", {"oil-processing"})
Tech.setUnit("coal-liquefaction", {count = 200, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}}, time = 30})

-- Concrete no longer needs automation-2 since assembling machine 1 can handle fluids.
Tech.setPrereqs("concrete", {"cement", "steel-processing"})
-- Same for fluid-handling.
Tech.setPrereqs("fluid-handling", {"logistic-science-pack"})

-- Plastics need syngas.
Tech.setPrereqs("plastics", {"coal-liquefaction"})

-- Sulfur tech unlocks sulfuric acid. So it needs fluid handling. But also we need sulfuric acid -> rubber-1 -> fluid-handling.
-- Could solve this by moving sulfuric acid recipe to rubber tech, removing sulfur tech.
-- But we also need sulfuric acid for eg fertilizer. So rather keep it as a separate tech.
Tech.setPrereqs("sulfur-processing", {"filtration-lake-water", "automation-science-pack"})
TECH["sulfur-processing"].unit = TECH["ammonia-1"].unit

Tech.setPrereqs("explosives", {"coal-liquefaction", "ammonia-1"}) -- Previously sulfur-processing

-- Remove pointless "gas and oil gathering" tech, merge with petrochemistry 1.
Tech.hideTech("oil-gathering")
TECH["oil-processing"].unit = TECH["oil-gathering"].unit
TECH["oil-processing"].research_trigger = nil
TECH["oil-processing"].prerequisites = {"fluid-handling"}
Tech.addRecipeToTech("pumpjack", "oil-processing", 2)

-- Move advanced-oil-processing to after oil-processing.
Tech.setPrereqs("advanced-oil-processing", {"oil-processing"})
TECH["advanced-oil-processing"].unit = {
	count = 75,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
	},
}

Tech.setPrereqs("lubricant", {"chemical-science-pack"})

-- Rubber-2 is needed to make rubber from petrochems on Vulcanus and Fulgora.
Tech.addTechDependency("rubber-2", "planet-discovery-vulcanus")
Tech.addTechDependency("rubber-2", "planet-discovery-fulgora")

-- Electric mining drill shouldn't be affected by tech multiplier since it's very early-game, making it 250 science instead of 25 is just annoying because it's not high enough to justify setting up with burner miners.
TECH["electric-mining-drill"].ignore_tech_cost_multiplier = true

-- Move long inserter to logistics 2.
Tech.removeRecipeFromTech("long-handed-inserter", "automation")
Tech.addRecipeToTech("long-handed-inserter", "logistics-2")
-- Fast inserter should go after lubricant.
Tech.setPrereqs("fast-inserter", {"lubricant"})
TECH["fast-inserter"].unit = {count = 50, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}}, time = 30}
Tech.setPrereqs("bulk-inserter", {"fast-inserter", "electric-engine"})
TECH["bulk-inserter"].unit = {count = 100, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}}, time = 30}
-- Inserter capacity techs should need more advanced science packs, since they're now after chem science.
TECH["inserter-capacity-bonus-1"].unit = {count = 150, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}}, time = 30}
TECH["inserter-capacity-bonus-2"].unit = {count = 200, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}}, time = 30}

-- Remove tech for advanced combinators, and move selector combinator recipe.
Tech.hideTech("advanced-combinators")
Tech.addRecipeToTech("selector-combinator", "circuit-network", 4)

-- Add red circuit dependency to assembling machine 2 and lasers, so we can add it as ingredient.
Tech.setPrereqs("automation-2", {"advanced-circuit"})
Tech.addTechDependency("advanced-circuit", "laser")
-- Add blue circuit dependency to assembling machine 3, so we can add it as ingredient.
Tech.setPrereqs("automation-3", {"automation-2", "production-science-pack", "electric-engine", "processing-unit", "speed-module"})

-- Heating tower tech should be early.
Tech.setPrereqs("heating-tower", {"steel-processing", "logistic-science-pack"})
TECH["heating-tower"].unit = {count = 300, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}}, time = 30}
TECH["heating-tower"].research_trigger = nil

-- Nuclear is going to post-triplets, and heating tower is early, so remove heating tower stuff fom nuclear tech.
Tech.removeRecipesFromTechs({"heat-exchanger", "heat-pipe", "steam-turbine"}, {"nuclear-power"})

-- Logistic (green) science needs steam, rubber.
RECIPE["logistic-science-pack"].ingredients = {
	{type = "fluid", name = "steam", amount = 10},
	{type = "item", name = "electronic-circuit", amount = 1},
	{type = "item", name = "rubber", amount = 1},
}
RECIPE["logistic-science-pack"].category = "crafting-with-fluid"
-- Could make green science depend only on rubber and steam-power. But that's sorta guiding people in the direction of not automating circuit boards. Rather make it a prereq. That also lets us assume resin is available after green science.
Tech.setPrereqs("logistic-science-pack", {"rubber-1", "wood-circuit-board"})

-- Military stuff: move things around so military science pack can be made from poison/slowdown capsules, which now come earlier, while grenades come later.
TECH["military-science-pack"].prerequisites = {"military-2"}
RECIPE["military-science-pack"].ingredients = {
	{type = "item", name = "poison-capsule", amount = 1},
	{type = "item", name = "slowdown-capsule", amount = 1},
	{type = "item", name = "piercing-rounds-magazine", amount = 1},
}
Tech.removeRecipesFromTechs({"poison-capsule", "slowdown-capsule"}, {"military-3"})
Tech.addRecipeToTech("poison-capsule", "military-2")
Tech.addRecipeToTech("slowdown-capsule", "military-2")
Tech.removeRecipeFromTech("grenade", "military-2")
Tech.addRecipeToTech("grenade", "military-3")
TECH["military-2"].prerequisites = {"military", "oil-processing", "ammonia-1"}
Tech.addTechDependency("explosives", "military-3")
Tech.removePrereq("military-4", "explosives")
Tech.setPrereqs("stronger-explosives-1", {"military-3"})
Tech.addSciencePack("stronger-explosives-1", "military-science-pack")
Tech.setPrereqs("gate", {"stone-wall", "steel-processing", "logistic-science-pack"})

-- Add red circuit prereq to techs that need red circuits as ingredients.
Tech.addTechDependency("advanced-circuit", "electric-energy-distribution-2")
Tech.addTechDependency("advanced-circuit", "electric-engine")
Tech.addTechDependency("advanced-circuit", "advanced-material-processing-2")
Tech.addTechDependency("advanced-circuit", "tank")

-- Gleba science pack
RECIPE["agricultural-science-pack"].ingredients = {
	--{type = "item", name = "slipstack-pearl", amount = 1},
	{type = "item", name = "activated-pentapod-egg", amount = 1},
	{type = "item", name = "stingfrond-sprout", amount = 1},
		-- Want it to be tied to cyclosomes, not neurofibrils. And don't want to have to worry about the phase, so using sprout rather than cyclosomes.
	--{type = "item", name = "sprouted-boomnut", amount = 1},
	{type = "item", name = "petrophage", amount = 1},
	--{type = "item", name = "marrow", amount = 1},
}
TECH["agricultural-science-pack"].research_trigger = { -- TODO later this should be a rate trigger on bioflux.
	type = "craft-item",
	item = "bioflux",
	count = 1000,
}

-- Make gate tech auto-unlock, otherwise I'm going to just forgo it.
TECH["gate"].unit = nil
TECH["gate"].research_trigger = {
	type = "craft-item",
	item = "stone-wall",
	count = 100,
}
TECH["gate"].prerequisites = {"stone-wall"}

-- Wall needs red science.
Tech.setPrereqs("stone-wall", {"automation-science-pack"})

-- Lamp should be earlier.
Tech.setPrereqs("lamp", {"basic-electricity", "glass"})
TECH["lamp"].unit = nil
TECH["lamp"].research_trigger = {
	type = "craft-item",
	item = "glass",
	count = 1,
}

-- Add gas vent and waste pump to fluid-handling tech.
Tech.addRecipeToTech("waste-pump", "fluid-handling")
Tech.addRecipeToTech("gas-vent", "fluid-handling")

-- Gleba needs advanced oil processing, to turn pitch (from petrophages) into light oil for explosives etc.
Tech.addTechDependency("advanced-oil-processing", "planet-discovery-gleba")

-- Hide health techs.
Tech.hideTech("health")

-- Rocket silo shouldn't depend on rocket fuel. Should depend on hydrogen/oxygen techs.
Tech.removePrereq("rocket-silo", "rocket-fuel")
-- TODO add hydrogen/oxygen techs.

-- Remove rocket fuel from rocket part recipe. TODO later we should re-write this recipe completely maybe.
RECIPE["rocket-part"].ingredients = {
	{type = "item", name = "processing-unit", amount = 1},
	{type = "item", name = "low-density-structure", amount = 1},
}

-- Chemical science pack: 1 barrel diesel + 2 plastic -> 2 chemical science packs.
RECIPE["chemical-science-pack"].ingredients = {
	{type = "item", name = "diesel-barrel", amount = 1},
	{type = "item", name = "plastic-bar", amount = 2},
}
TECH["chemical-science-pack"].prerequisites = {"plastics", "diesel"}

-- Blue circuits need a new dependency on red circuits.
Tech.addTechDependency("advanced-circuit", "processing-unit")

-- Remove steel prereq from some techs that don't really need steel, due to our factor intermediate system.
Tech.removePrereq("electric-energy-distribution-1", "steel-processing")
Tech.removePrereq("engine", "steel-processing") -- TODO change engine recipe
Tech.removePrereq("heavy-armor", "steel-processing") -- TODO change heavy armor recipe
Tech.removePrereq("solar-energy", "steel-processing") -- TODO change solar panel recipe

-- TODO other science packs.

-- TODO lubricant should come earlier, so that we can unlock advanced parts early, and then put it in many recipes.

-- TODO later, instead of using a tech multiplier in the map preset, rather just go through and set units (counts, times, ingredients) for all techs individually. Otherwise there's weird stuff like mismatches in science times (ie number of labs vs science assemblers), weird counts that don't make sense, etc.

-- TODO should engines need rubber? If so, need to add rubber=>engine dependency.

-- TODO write some code to toposort the whole tech tree and then assign order strings.