-- This file creates the tech for coal coking, soon after automation.
local cokingTech = copy(TECH["lamp"])
cokingTech.name = "coal-coking"
Icon.set(cokingTech, "LSA/petrochem/coking-tech")
cokingTech.prerequisites = {"filtration-raw-seawater"}
cokingTech.effects = {
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