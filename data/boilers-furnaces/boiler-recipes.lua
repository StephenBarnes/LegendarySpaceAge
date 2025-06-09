--[[ This file makes recipes for boilers.
]]

local fluidBoxIndex = require("const.boiler-const").fluidBoxIndex

-- Create recipe categories.
extend{
	{ type = "recipe-category", name = "burner-boiling", },
	{ type = "recipe-category", name = "non-burner-boiling", },
}

--[[ Create pure water boiling recipes.
We want to boil 10/s water and produce 10/s steam.
]]
local airCombustionWaterBoiling = Recipe.make{
	copy = "ice-melting",
	recipe = "air-burner-water-boiling",
	category = "burner-boiling",
	ingredients = {
		-- No fluidbox indices, so it automatically assigns them. It happens to assign them in a way that everything works out.
		-- (We can't assign one specifically and leave the rest to be assigned automatically - causes error on startup.)
		{"water", 5},
		{"air", 10, type = "fluid"},
	},
	results = {
		{"steam", 5, temperature = 200, fluidbox_index = fluidBoxIndex.boiledGasOutput},
		{"flue-gas", 10, type = "fluid", fluidbox_index = fluidBoxIndex.flueOutput},
	},
	time = 1,
	enabled = true,
	-- TODO icons
}
local oxCombustionWaterBoiling = Recipe.make{
	copy = airCombustionWaterBoiling,
	recipe = "ox-burner-water-boiling",
	category = "burner-boiling",
	ingredients = {
		{"water", 10, fluidbox_index = fluidBoxIndex.liquidToBoil},
		{"oxygen-gas", 10, type = "fluid", fluidbox_index = fluidBoxIndex.airInput},
	},
	results = {
		{"steam", 10, temperature = 200, fluidbox_index = fluidBoxIndex.boiledGasOutput},
		{"carbon-dioxide", 10, type = "fluid", fluidbox_index = fluidBoxIndex.flueOutput},
	},
	time = 1,
	enabled = true,
	-- TODO icons
}
Recipe.make{
	copy = airCombustionWaterBoiling,
	recipe = "non-burner-water-boiling",
	category = "non-burner-boiling",
	ingredients = {
		{"water", 10, fluidbox_index = fluidBoxIndex.liquidToBoil},
	},
	results = {
		{"steam", 10, temperature = 200, fluidbox_index = fluidBoxIndex.boiledGasOutput},
	},
	time = 1,
	enabled = true,
	-- TODO icons
}
-- TODO more

-- Create recipes for boiling raw water.
-- TODO

-- TODO assign boilers to use water-heating recipe by default.