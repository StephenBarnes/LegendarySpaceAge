-- This file creates the tech for petroleum resin. It's like an optional addon after basic petrochemistry. Wood resin is cheaper on Nauvis, but this is needed for Vulcanus and Fulgora.

local resinTech = copy(TECH["lubricant"])
resinTech.name = "petroleum-resin"
Icon.set(resinTech, "LSA/resin/tech")
resinTech.effects = {
	{type = "unlock-recipe", recipe = "pitch-resin"},
	{type = "unlock-recipe", recipe = "rich-gas-resin"},
}
resinTech.prerequisites = {"chemical-science-pack", "advanced-oil-processing"}
extend{resinTech}

-- This should be required for Fulgora and Vulcanus.
Tech.addTechDependency("petroleum-resin", "planet-discovery-fulgora")
Tech.addTechDependency("petroleum-resin", "planet-discovery-vulcanus")