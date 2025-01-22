-- This file creates the tech for coal coking, soon after automation, which also unlocks gunpowder.

local cokingTech = table.deepcopy(data.raw.technology["lamp"])
cokingTech.name = "coal-coking"
cokingTech.icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/coking-tech.png", icon_size = 256}}
cokingTech.prerequisites = {"automation"}
cokingTech.effects = {
	{type = "unlock-recipe", recipe = "chemical-plant"},
	{type = "unlock-recipe", recipe = "coal-coking"},
	{type = "unlock-recipe", recipe = "gunpowder"},
	{type = "unlock-recipe", recipe = "firearm-magazine"},
}
cokingTech.unit = nil
cokingTech.research_trigger = {
	type = "build-entity",
	entity = "assembling-machine-1",
}
data.raw.recipe["firearm-magazine"].enabled = false -- Don't enable from the start.
data:extend{cokingTech}