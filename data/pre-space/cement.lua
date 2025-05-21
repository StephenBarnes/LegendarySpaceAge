--[[ This file adds cement fluid, tech, and recipes. Cement is used to make concrete, refined concrete, shielding (with stone brick), etc.
Also adds sulfur concrete recipes.
Cement:
	5 stone + 5 sand + 100 water -> 100 cement
Main route to concrete:
	100 cement -> 10 concrete blocks
	100 cement + 1 resin + 2 hot steel -> 10 refined concrete
And then there's alternative recipes using sulfur, and no water, in a foundry:
	30 sulfur + 30 sand + -> 20 concrete
	30 sulfur + 30 sand + 1 resin + 40 molten steel -> 20 refined concrete
Original game recipes were:
	1 iron ore + 5 stone brick + 100 water -> 10 concrete
	8 iron rod + 1 steel plate + 20 concrete + 100 water -> 10 refined concrete
]]

-- Create new "cement" fluid.
local cementFluid = copy(FLUID["lubricant"])
cementFluid.name = "cement"
Icon.set(cementFluid, "LSA/fluids/cement-fluid")
cementFluid.auto_barrel = false
cementFluid.base_color = {.33, .33, .33, 1}
cementFluid.flow_color = {.6, .6, .6, 1}
cementFluid.visualization_color = {.43, .43, .43, 1}
extend{cementFluid}

-- Create recipe for cement.
Recipe.make{
	copy = "make-lubricant",
	recipe = "make-cement", -- Must be different from cement so it appears in factoriopedia correctly.
	localised_name = {"fluid-name.cement"},
	ingredients = {
		{"stone", 2},
		{"sand", 2},
		{"water", 50},
	},
	results = {
		{"cement", 50},
	},
	main_product = "cement",
	category = "crafting-with-fluid",
	allow_decomposition = true,
}

-- Create tech for cement and brick structure.
local tech = copy(TECH.concrete)
tech.name = "cement"
tech.effects = {
	{
		type = "unlock-recipe",
		recipe = "make-cement",
	},
}
tech.prerequisites = {"filtration-lake-water"}
tech.research_trigger = nil
tech.unit = {
	count = 15,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
	},
}
Icon.set(tech, "LSA/fluids/cement-tech")
extend{tech}

-- Adjust recipes for concrete and refined concrete.
Recipe.edit{
	recipe = "concrete",
	ingredients = {
		{"cement", 100},
		{"stone", 10},
		{"iron-stick", 5},
	},
	time = 10,
}
Recipe.edit{
	recipe = "refined-concrete",
	ingredients = {
		{"cement", 100},
		{"resin", 2},
		{"ash", 2},
		{"steel-plate", 5},
	},
	time = 10,
}