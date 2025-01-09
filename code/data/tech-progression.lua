-- This file adjusts the overall progression, by moving techs around, changing dependencies, moving recipes between techs, etc.

local Tech = require("code.util.tech")
local Table = require("code.util.table")

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
Tech.addEffect("automation", {type = "unlock-recipe", recipe = "chemical-plant"}, 2)

-- Coal liquefaction tech should be soon after oil processing.
Tech.setPrereqs("coal-liquefaction", {"oil-processing"})
Tech.setUnit("coal-liquefaction", {count = 200, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}}, time = 30})

-- Dependency from rubber to electric power distribution 1, since we'll make the transformer need rubber for insulation.
Tech.addTechDependency("rubber-1", "electric-energy-distribution-1")

-- Concrete no longer needs automation-2 since assembling machine 1 can handle fluids.
Tech.setPrereqs("concrete", {"automation", "advanced-material-processing"})
-- Same for fluid-handling.
Tech.setPrereqs("fluid-handling", {"engine", "rubber-1"})

-- Automation 3 should require automation 2.
Tech.addTechDependency("automation-2", "automation-3")

-- Plastics need syngas.
Tech.setPrereqs("plastics", {"coal-liquefaction"})

-- Sulfur tech unlocks sulfuric acid. So it needs fluid handling. But also we need sulfuric acid -> rubber-1 -> fluid-handling.
-- Solving this by moving sulfuric acid recipe to rubber tech, removing sulfur tech.
Tech.hideTech("sulfur-processing")
Tech.setPrereqs("battery", {"rubber-1"}) -- Previously sulfur-processing.
Tech.setPrereqs("chemical-science-pack", {"advanced-circuit"}) -- Previously also sulfur-processing; TODO later rewrite the recipe for this science pack completely.
Tech.setPrereqs("explosives", {"coal-liquefaction"}) -- Previously sulfur-processing

-- Remove pointless "gas and oil gathering" tech, merge with petrochemistry 1.
Tech.hideTech("oil-gathering")
data.raw.technology["oil-processing"].unit = data.raw.technology["oil-gathering"].unit
data.raw.technology["oil-processing"].research_trigger = nil
data.raw.technology["oil-processing"].prerequisites = {"fluid-handling"}