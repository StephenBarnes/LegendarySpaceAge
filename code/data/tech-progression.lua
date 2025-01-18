-- This file adjusts the overall progression, by moving techs around, changing dependencies, moving recipes between techs, etc.

local Tech = require("code.util.tech")
local Table = require("code.util.table")

-- Early techs: basic electricity, then electronics, then personal burner generator, then red science, then automation, then filtration, then steam power.
Tech.setPrereqs("electronics", {"basic-electricity"})
Tech.setPrereqs("automation", {"personal-burner-generator", "electric-mining-drill"})
Tech.addTechDependency("filtration-lake-water", "steam-power")
data.raw.technology["steam-power"].unit = nil
data.raw.technology["steam-power"].research_trigger = {
	type = "craft-fluid",
	fluid = "water",
	amount = 1000,
}

-- In the gap between automation and automation-science-pack, let's have the player scale up with basic tech until they can produce like 2000 iron ingots.
data.raw.technology["automation-science-pack"].prerequisites = {"automation"}
data.raw.technology["automation-science-pack"].unit = nil
data.raw.technology["automation-science-pack"].research_trigger = {
	type = "craft-item",
	item = "electronic-circuit",
	count = 1000,
}

-- Electric mining drill should be automatically unlocked after some iron is smelted.
data.raw.technology["electric-mining-drill"].unit = nil
data.raw.technology["electric-mining-drill"].research_trigger = {
	type = "craft-item",
	item = "electronic-circuit",
	amount = 3, -- Need 3 to make an electric drill.
}
data.raw.technology["electric-mining-drill"].prerequisites = {"electronics"}

-- Military 1 now depends on coal coking, for gunpowder. Also gun turrets.
data.raw.technology["military"].prerequisites = {"coal-coking", "automation-science-pack"}
data.raw.technology["gun-turret"].prerequisites = {"coal-coking", "automation-science-pack"}

-- Red science tech should be unlocked by crafting circuits. And should unlock lab recipe.
data.raw.technology["automation"].unit = nil
data.raw.technology["automation"].research_trigger = {
	type = "craft-item",
	item = "personal-burner-generator",
	amount = 1,
}
Tech.removeRecipeFromTech("lab", "electronics")
Tech.addRecipeToTech("lab", "automation-science-pack")

-- Unlock electronics when a hand-crank is built.
data.raw.technology["electronics"].unit = nil
data.raw.technology["electronics"].research_trigger = {
	type = "build-entity",
	entity = "er-hcg",
}

-- Move pipe recipes from steam power to automation.
-- Remove offshore pump recipe from steam power, will add to filtration.
data.raw.technology["steam-power"].effects = {
	{type = "unlock-recipe", recipe = "boiler"},
	{type = "unlock-recipe", recipe = "gas-boiler"},
	{type = "unlock-recipe", recipe = "electric-boiler"},
	{type = "unlock-recipe", recipe = "steam-engine"},
}
Tech.addRecipeToTech("offshore-pump", "automation", 3)
Tech.addRecipeToTech("pipe", "automation")
Tech.addRecipeToTech("pipe-to-ground", "automation")

-- Logistics 2 depends on rubber.
Tech.addTechDependency("rubber-1", "logistics-2")

-- Car shouldn't need logistics 2, should need rubber.
Tech.setPrereqs("automobilism", {"rubber-1", "engine"})

-- Railway shouldn't depend on logistics 2.
Tech.setPrereqs("railway", {"engine"})

-- Logistics chain 2->3
Tech.addTechDependency("logistics-2", "logistics-3")

-- Move long inserter to logistics 2.
Tech.removeRecipeFromTech("long-handed-inserter", "automation")
Tech.addRecipeToTech("long-handed-inserter", "logistics-2")

-- Automation 1 should already unlock the chem plant. Especially since it's also usable for gunpowder and coal coking.
Tech.addRecipeToTech("chemical-plant", "automation", 2)
Tech.removeRecipeFromTech("chemical-plant", "oil-processing")

-- Coal liquefaction tech should be soon after oil processing.
Tech.setPrereqs("coal-liquefaction", {"oil-processing"})
Tech.setUnit("coal-liquefaction", {count = 200, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}}, time = 30})

-- Dependency from rubber to electric power distribution 1, since we'll make the transformer need rubber for insulation.
Tech.addTechDependency("rubber-1", "electric-energy-distribution-1")

-- Concrete no longer needs automation-2 since assembling machine 1 can handle fluids.
Tech.setPrereqs("concrete", {"advanced-material-processing"})
-- Same for fluid-handling.
Tech.setPrereqs("fluid-handling", {"engine", "rubber-1"})

-- Automation 3 should require automation 2.
Tech.addTechDependency("automation-2", "automation-3")

-- Plastics need syngas.
Tech.setPrereqs("plastics", {"coal-liquefaction"})

-- Sulfur tech unlocks sulfuric acid. So it needs fluid handling. But also we need sulfuric acid -> rubber-1 -> fluid-handling.
-- Could solve this by moving sulfuric acid recipe to rubber tech, removing sulfur tech.
-- But we also need sulfuric acid for eg fertilizer. So rather keep it as a separate tech.
Tech.setPrereqs("sulfur-processing", {"filtration-lake-water", "automation-science-pack"})
data.raw.technology["sulfur-processing"].unit = data.raw.technology["ammonia-1"].unit

Tech.setPrereqs("explosives", {"coal-liquefaction", "ammonia-1"}) -- Previously sulfur-processing

Tech.setPrereqs("chemical-science-pack", {"advanced-circuit"}) -- Previously also sulfur-processing; TODO later rewrite the recipe for this science pack completely.

Tech.addTechDependency("steel-processing", "battery")

-- Remove pointless "gas and oil gathering" tech, merge with petrochemistry 1.
Tech.hideTech("oil-gathering")
data.raw.technology["oil-processing"].unit = data.raw.technology["oil-gathering"].unit
data.raw.technology["oil-processing"].research_trigger = nil
data.raw.technology["oil-processing"].prerequisites = {"fluid-handling", "steam-power"}
Tech.addRecipeToTech("pumpjack", "oil-processing", 2)
-- TODO: add the wellhead here.

-- Elimininate the now-pointless "advanced oil processing" tech.
Tech.hideTech("advanced-oil-processing")
Tech.setPrereqs("lubricant", {"chemical-science-pack"})

-- Rubber-2 is needed to make rubber from petrochems on Vulcanus and Fulgora.
Tech.addTechDependency("rubber-2", "planet-discovery-vulcanus")
Tech.addTechDependency("rubber-2", "planet-discovery-fulgora")

-- Electric mining drill shouldn't be affected by tech multiplier since it's very early-game, making it 250 science instead of 25 is just annoying because it's not high enough to justify setting up with burner miners.
data.raw.technology["electric-mining-drill"].ignore_tech_cost_multiplier = true

-- Fast inserter should go after green science.
Tech.setPrereqs("fast-inserter", {"logistic-science-pack"})
data.raw.technology["fast-inserter"].unit = {count = 30, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}}, time = 15}

-- Remove tech for advanced combinators. And move selector combinator recipe, and change recipe to not need red circuits.
Tech.hideTech("advanced-combinators")
Tech.addRecipeToTech("selector-combinator", "circuit-network", 3)
data.raw.recipe["selector-combinator"].ingredients = {
	{type = "item", name = "electronic-circuit", amount = 2},
	{type = "item", name = "decider-combinator", amount = 5},
}

-- Add red circuit dependency to assembling machine 2, so we can add it as ingredient.
Tech.setPrereqs("automation-2", {"advanced-circuit"})

-- Heating tower tech should be early.
Tech.setPrereqs("heating-tower", {"steam-power", "concrete"})
data.raw.technology["heating-tower"].unit = {count = 300, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}}, time = 30}
data.raw.technology["heating-tower"].research_trigger = nil

-- Nuclear is going to post-triplets, and heating tower is early, so remove heating tower stuff fom nuclear tech.
Tech.removeRecipesFromTechs({"heat-exchanger", "heat-pipe", "steam-turbine"}, {"nuclear-power"})

-- Set science pack ingredients.
data.raw.recipe["automation-science-pack"].ingredients = {
	{type = "item", name = "iron-gear-wheel", amount = 1},
	{type = "item", name = "electronic-circuit", amount = 1},
	{type = "item", name = "glass", amount = 1},
}
-- TODO other science packs.



-- TODO lubricant should come earlier, so that we can unlock advanced parts early, and then put it in many recipes.

-- TODO rather unlock automation 1 early, before red science. Then red science should take as ingredients machine parts + green circuits.




-- TODO later, instead of using a tech multiplier in the map preset, rather just go through and set units (counts, times, ingredients) for all techs individually. Otherwise there's weird stuff like mismatches in science times (ie number of labs vs science assemblers), weird counts that don't make sense, etc.

-- TODO should engines need rubber? If so, need to add rubber=>engine dependency.

-- TODO write some code to toposort the whole tech tree and then assign order strings.