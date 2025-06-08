--[[ This file makes recipes for boilers.
]]

-- Create recipe categories.
extend{
	{ type = "recipe-category", name = "combustion-boiling", },
	{ type = "recipe-category", name = "electric-boiling", },
}

--[[ Create pure water boiling recipes.
We want to boil 10/s water and produce 10/s steam.
]]
local combustionWaterBoiling = Recipe.make{
	copy = "ice-melting",
	recipe = "air-burner-water-boiling",
	category = "combustion-boiling",
	ingredients = {{"water", 10}},
	results = {{"steam", 10, temperature = 200}},
	time = 1,
	enabled = true,
	-- TODO add gas I/O.
	-- TODO icons
}
-- TODO pure-oxygen combustion boiling.
Recipe.make{
	copy = combustionWaterBoiling,
	recipe = "electric-water-boiling",
	category = "electric-boiling",
	ingredients = {{"water", 10}},
	results = {{"steam", 10, temperature = 200}},
	time = 1,
	enabled = true,
	-- TODO icons
}
-- TODO more

-- Create recipes for boiling raw water.
-- TODO

-- TODO assign boilers to use water-heating recipe by default.