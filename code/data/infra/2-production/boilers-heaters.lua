-- Remove tech for electric boiler, rather move recipe to fluid handling.
Tech.hideTech("electric-boiler")
--Tech.addRecipeToTech("electric-boiler", "steam-power", 3) -- Rather done later in tech-progression.

-- Boilers
RECIPE["boiler"].ingredients = {
	{type = "item", name = "structure", amount = 2},
	{type = "item", name = "fluid-fitting", amount = 2},
	{type = "item", name = "shielding", amount = 2},
}
RECIPE["electric-boiler"].ingredients = {
	{type = "item", name = "structure", amount = 2},
	{type = "item", name = "fluid-fitting", amount = 2},
	{type = "item", name = "shielding", amount = 1},
	{type = "item", name = "wiring", amount = 2},
}
RECIPE["gas-boiler"].ingredients = {
	{type = "item", name = "structure", amount = 2},
	{type = "item", name = "fluid-fitting", amount = 4},
	{type = "item", name = "shielding", amount = 2},
}
RECIPE["boiler"].energy_required = 4
RECIPE["electric-boiler"].energy_required = 4
RECIPE["gas-boiler"].energy_required = 4

RECIPE["steam-engine"].ingredients = {
	{type = "item", name = "wiring", amount = 4},
	{type = "item", name = "mechanism", amount = 4},
	{type = "item", name = "fluid-fitting", amount = 2},
}
RECIPE["steam-engine"].energy_required = 4

RECIPE["heating-tower"].ingredients = {
	{type = "item", name = "structure", amount = 20},
	{type = "item", name = "shielding", amount = 20},
	{type = "item", name = "heat-pipe", amount = 5},
}
RECIPE["heating-tower"].energy_required = 10
RECIPE["fluid-heating-tower"].ingredients = {
	{type = "item", name = "structure", amount = 20},
	{type = "item", name = "shielding", amount = 20},
	{type = "item", name = "heat-pipe", amount = 5},
	{type = "item", name = "fluid-fitting", amount = 2},
}
RECIPE["fluid-heating-tower"].energy_required = 10

-- Heat pipe is originally 20 copper plate + 10 steel plate for 1. That seems very expensive for the size. Would make Aquilo and Gleba annoying. So I'll make it a lot cheaper.
RECIPE["heat-pipe"].ingredients = {
	{type = "item", name = "copper-plate", amount = 2},
	{type = "item", name = "steel-plate", amount = 1},
}
RECIPE["heat-exchanger"].ingredients = {
	{type = "item", name = "structure", amount = 2},
	{type = "item", name = "shielding", amount = 2},
	{type = "item", name = "fluid-fitting", amount = 2},
	{type = "item", name = "heat-pipe", amount = 2},
}
RECIPE["heat-exchanger"].energy_required = 4
RECIPE["steam-turbine"].ingredients = {
	{type = "item", name = "wiring", amount = 8},
	{type = "item", name = "mechanism", amount = 8},
	{type = "item", name = "fluid-fitting", amount = 4},
}
RECIPE["steam-turbine"].energy_required = 4