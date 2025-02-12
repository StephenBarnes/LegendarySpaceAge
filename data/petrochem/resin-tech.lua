-- This file creates the tech for petroleum resin. It's like an optional addon after basic petrochemistry. Wood resin is cheaper on Nauvis, but this is needed for Vulcanus and Fulgora.

local resinTech = table.deepcopy(TECH["lubricant"])
resinTech.name = "petroleum-resin"
resinTech.icons = {
	--{icon = "__base__/graphics/technology/advanced-oil-processing.png", icon_size = 256, scale = 1, shift = {0, -40}},
	--{icon = "__LegendarySpaceAge__/graphics/resin/tech.png", icon_size = 256, scale = .5, shift = {0, 20}},
	{icon = "__LegendarySpaceAge__/graphics/resin/tech.png", icon_size = 256},
}
resinTech.effects = {
	{type = "unlock-recipe", recipe = "pitch-resin"},
	{type = "unlock-recipe", recipe = "rich-gas-resin"},
}
resinTech.prerequisites = {"chemical-science-pack"}
data:extend{resinTech}

-- This should be required for Fulgora and Vulcanus.
Tech.addTechDependency("petroleum-resin", "planet-discovery-fulgora")
Tech.addTechDependency("petroleum-resin", "planet-discovery-vulcanus")