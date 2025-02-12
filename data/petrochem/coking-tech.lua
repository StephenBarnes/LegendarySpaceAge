-- This file creates the tech for coal coking, soon after automation.
local cokingTech = copy(TECH["lamp"])
cokingTech.name = "coal-coking"
cokingTech.icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/coking-tech.png", icon_size = 256}}
cokingTech.prerequisites = {"automation-science-pack"}
cokingTech.effects = {
	{type = "unlock-recipe", recipe = "chemical-plant"},
	{type = "unlock-recipe", recipe = "coal-coking"},
}
cokingTech.unit = {
	count = 20,
	ingredients = {
		{"automation-science-pack", 1},
	},
	time = 15,
}
RECIPE["firearm-magazine"].enabled = false -- Don't enable from the start.
extend{cokingTech}