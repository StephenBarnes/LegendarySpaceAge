--[[ This file makes recipes for boilers.
]]

-- TODO check the energy on these - produced steam should have the same energy as boiler's usage.

local Const = require("const.boiler-const")

-- Create recipe categories.
extend{
	{ type = "recipe-category", name = "burner-boiling", },
	{ type = "recipe-category", name = "non-burner-boiling", },
}

--[[ Create pure water boiling recipes.
We want to produce up to 10/s steam (200C, so 200*(10/s)*1kJ = 2MW), to match power consumption of boilers.
But we make it slightly less than that for combustion in air, so there's a reason to use pure oxygen.
TODO maybe rather edit things so produced steam is 100C, to make math simpler.
	Would need to also edit numbers for condensing boiler, etc.
]]
local airCombustionWaterBoiling = Recipe.make{
	copy = "ice-melting",
	recipe = "air-burner-water-boiling",
	category = "burner-boiling",
	ingredients = {
		-- No fluidbox indices, so it automatically assigns them. It happens to assign them in a way that everything works out.
		-- (We can't assign one specifically and leave the rest to be assigned automatically - causes error on startup.)
		{"water", 8},
		{"air", 10, type = "fluid"},
	},
	results = {
		{"steam", 8, temperature = 200, fluidbox_index = Const.burnerFluidBoxIndex.boiledGasOutput},
		{"flue-gas", 10, type = "fluid", fluidbox_index = Const.burnerFluidBoxIndex.flueOutput},
	},
	time = 1,
	enabled = true,
	icons = {"steam", "water", "air"},
}
local oxCombustionWaterBoiling = Recipe.make{
	copy = airCombustionWaterBoiling,
	recipe = "ox-burner-water-boiling",
	category = "burner-boiling",
	ingredients = {
		{"water", 10, fluidbox_index = Const.burnerFluidBoxIndex.liquidToBoil},
		{"oxygen-gas", 10, type = "fluid", fluidbox_index = Const.burnerFluidBoxIndex.airInput},
	},
	results = {
		{"steam", 10, temperature = 200, fluidbox_index = Const.burnerFluidBoxIndex.boiledGasOutput},
		{"carbon-dioxide", 10, type = "fluid", fluidbox_index = Const.burnerFluidBoxIndex.flueOutput},
	},
	time = 1,
	enabled = true,
	icons = {"steam", "water", "oxygen-gas"},
}
Recipe.make{
	copy = airCombustionWaterBoiling,
	recipe = "non-burner-water-boiling",
	category = "non-burner-boiling",
	ingredients = {
		{"water", 10, fluidbox_index = Const.nonBurnerFluidBoxIndex.liquidToBoil},
	},
	results = {
		{"steam", 10, temperature = 200, fluidbox_index = Const.nonBurnerFluidBoxIndex.boiledGasOutput},
	},
	time = 1,
	enabled = true,
	icons = {"steam", "water"},
}

-- Create recipes for boiling clean seawater. Produces steam, rich brine, and optionally flue/CO2.
local airCombustionSeawaterBoiling = Recipe.make{
	copy = "ice-melting",
	recipe = "air-burner-seawater-boiling",
	category = "burner-boiling",
	ingredients = {
		-- No fluidbox indices, so it automatically assigns them. It happens to assign them in a way that everything works out.
		-- (We can't assign one specifically and leave the rest to be assigned automatically - causes error on startup.)
		{"clean-seawater", 10},
		{"air", 10, type = "fluid"},
	},
	results = {
		{"steam", 8, temperature = 200, fluidbox_index = Const.burnerFluidBoxIndex.boiledGasOutput},
		{"flue-gas", 10, type = "fluid", fluidbox_index = Const.burnerFluidBoxIndex.flueOutput},
		{"rich-brine", 2, type = "fluid", fluidbox_index = Const.burnerFluidBoxIndex.brineOutput},
	},
	time = 1,
	enabled = true,
	icons = {"steam", "clean-seawater", "air"},
}
local oxCombustionSeawaterBoiling = Recipe.make{
	copy = airCombustionSeawaterBoiling,
	recipe = "ox-burner-seawater-boiling",
	category = "burner-boiling",
	ingredients = {
		{"clean-seawater", 12, fluidbox_index = Const.burnerFluidBoxIndex.liquidToBoil},
		{"oxygen-gas", 10, type = "fluid", fluidbox_index = Const.burnerFluidBoxIndex.airInput},
	},
	results = {
		{"steam", 10, temperature = 200, fluidbox_index = Const.burnerFluidBoxIndex.boiledGasOutput},
		{"carbon-dioxide", 10, type = "fluid", fluidbox_index = Const.burnerFluidBoxIndex.flueOutput},
		{"rich-brine", 2, type = "fluid", fluidbox_index = Const.burnerFluidBoxIndex.brineOutput},
	},
	time = 1,
	enabled = true,
	icons = {"steam", "clean-seawater", "oxygen-gas"},
}
Recipe.make{
	copy = airCombustionSeawaterBoiling,
	recipe = "non-burner-seawater-boiling",
	category = "non-burner-boiling",
	ingredients = {
		{"clean-seawater", 12, fluidbox_index = Const.nonBurnerFluidBoxIndex.liquidToBoil},
	},
	results = {
		{"steam", 10, temperature = 200, fluidbox_index = Const.nonBurnerFluidBoxIndex.boiledGasOutput},
		{"rich-brine", 2, type = "fluid", fluidbox_index = Const.nonBurnerFluidBoxIndex.brineOutput},
	},
	time = 1,
	enabled = true,
	icons = {"steam", "clean-seawater"},
}

-- TODO assign boilers to use "no recipe" recipe by default.