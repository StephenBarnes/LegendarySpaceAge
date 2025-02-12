-- This file moves the existing carbon fiber tech to earlier, while still on Gleba, and adds the low-density structure recipe to it.

local tech = TECH["carbon-fiber"]
tech.prerequisites = {"stingfrond-cultivation-2", "chitin-processing-2"}
tech.unit = nil
tech.research_trigger = {
	type = "craft-item",
	item = "cyclosome-3",
	count = 200,
}
table.insert(tech.effects, {type = "unlock-recipe", recipe = "lds-from-carbon-fiber"})

-- Since carbon-fiber doesn't depend on ag science packs, things that depend on it and use ag science packs should get that dependency.
Tech.addTechDependency("agricultural-science-pack", "stack-inserter")
Tech.addTechDependency("agricultural-science-pack", "toolbelt-equipment")