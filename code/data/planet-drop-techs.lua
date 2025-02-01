-- This file creates techs that allow dropping cargo on planets. Using PlanetsLib which has this functionality built in.

local glebaTech = PlanetsLib.cargo_drops_technology_base("gleba", "__space-age__/graphics/technology/gleba.png", 256)
glebaTech.prerequisites = {"agricultural-science-pack"}
glebaTech.unit = {
	count = 1000,
	time = 60,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
		{"production-science-pack", 1},
		{"utility-science-pack", 1},
		{"space-science-pack", 1},
		{"agricultural-science-pack", 1},
	},
}
data:extend{glebaTech}

local vulcanusTech = PlanetsLib.cargo_drops_technology_base("vulcanus", "__space-age__/graphics/technology/vulcanus.png", 256)
vulcanusTech.prerequisites = {"metallurgic-science-pack"}
vulcanusTech.unit = {
	count = 1000,
	time = 60,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
		{"production-science-pack", 1},
		{"utility-science-pack", 1},
		{"space-science-pack", 1},
		{"metallurgic-science-pack", 1},
	},
}
data:extend{vulcanusTech}

local fulgoraTech = PlanetsLib.cargo_drops_technology_base("fulgora", "__space-age__/graphics/technology/fulgora.png", 256)
fulgoraTech.prerequisites = {"electromagnetic-science-pack"}
fulgoraTech.unit = {
	count = 1000,
	time = 60,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
		{"production-science-pack", 1},
		{"utility-science-pack", 1},
		{"space-science-pack", 1},
		{"electromagnetic-science-pack", 1},
	},
}
data:extend{fulgoraTech}

local aquiloTech = PlanetsLib.cargo_drops_technology_base("aquilo", "__space-age__/graphics/technology/aquilo.png", 256)
aquiloTech.prerequisites = {"cryogenic-science-pack"}
aquiloTech.unit = {
	count = 1000,
	time = 60,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
		{"production-science-pack", 1},
		{"utility-science-pack", 1},
		{"space-science-pack", 1},
		{"agricultural-science-pack", 1},
		{"metallurgic-science-pack", 1},
		{"electromagnetic-science-pack", 1},
		{"nuclear-science-pack", 1},
		{"cryogenic-science-pack", 1},
	},
}
data:extend{aquiloTech}