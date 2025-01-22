-- This file adjusts the Stirling generator building added by other mod. Also adds tech.

local Tech = require("code.util.tech")

-- Reducing efficiency 0.8 to 0.5 for more reason to prefer steam.
data.raw["burner-generator"]["stirling-generator"].burner.effectivity = 0.5

-- Move to start of row, after hand-crank.
data.raw.item["stirling-generator"].order = "a2"

-- Constructible wherever oxygen pressure is above threshold, so not on Fulgora.
data.raw["burner-generator"]["stirling-generator"].surface_conditions = {{property = "oxygen-pressure", min = 10}}

-- Create a new tech for the Stirling generator.
---@type data.TechnologyPrototype
local stirlingTech = table.deepcopy(data.raw.technology["advanced-material-processing"])
stirlingTech.name = "stirling-generator"
stirlingTech.unit = nil
stirlingTech.effects = {
	{type = "unlock-recipe", recipe = "stirling-generator"},
}
stirlingTech.research_trigger = {
	type = "craft-item",
	item = "personal-burner-generator",
}
stirlingTech.prerequisites = {"personal-burner-generator"}
data:extend{stirlingTech}
Tech.removeRecipeFromTech("stirling-generator", "electronics")