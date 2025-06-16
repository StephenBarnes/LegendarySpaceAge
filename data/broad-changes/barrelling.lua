--[[ This file creates a new techs for barrelling and gas tanks, moves barrelling recipes to the new tech, and creates gas tanks and their recipes, etc. Also adds fuel values to barrels and tanks. ]]

local BarrelConst = require "const.barrel-const"

-- Create the new tech.
local gasTankTech = copy(TECH["oil-processing"])
gasTankTech.name = "fluid-containers"
gasTankTech.prerequisites = {"fluid-handling"}
gasTankTech.effects = {
	{type = "unlock-recipe", recipe = "barrel"},
	{type = "unlock-recipe", recipe = "gas-tank"},
}
Icon.set(gasTankTech, "LSA/gas-tanks/tech")
gasTankTech.research_trigger = nil
gasTankTech.unit = {
	count = 50,
	time = 15,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
	},
}
extend{gasTankTech}

-- Create the new empty gas tank item.
local emptyGasTankTint = {.3, .3, .3}
local emptyGasTankItem = copy(ITEM["barrel"])
emptyGasTankItem.name = "gas-tank"
emptyGasTankItem.icon = nil
emptyGasTankItem.icons = {
	{icon = "__LegendarySpaceAge__/graphics/gas-tanks/straight/tank.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/gas-tanks/straight/overlay-side.png", icon_size = 64, scale = 0.5, tint = emptyGasTankTint},
	{icon = "__LegendarySpaceAge__/graphics/gas-tanks/straight/overlay-top.png", icon_size = 64, scale = 0.5, tint = emptyGasTankTint},
}
emptyGasTankItem.order = ITEM["barrel"].order .. "-1"
extend{emptyGasTankItem}

-- Create recipe for empty gas tank.
local emptyGasTankRecipe = copy(RECIPE["barrel"])
emptyGasTankRecipe.name = "gas-tank"
emptyGasTankRecipe.ingredients = {
	{type = "item", name = "panel", amount = 1},
	{type = "item", name = "fluid-fitting", amount = 1},
}
emptyGasTankRecipe.results = {{type = "item", name = "gas-tank", amount = 1}}
extend{emptyGasTankRecipe}

-- Edit recipe for barrel - previously only 1 steel plate.
RECIPE["barrel"].ingredients = {
	{type = "item", name = "panel", amount = 1},
	{type = "item", name = "frame", amount = 1},
}

-- Fluid wagon stores 50k fluid. Cargo wagon stores 40 stacks of 10 barrels, each having 100 fluid, so 40k total.
-- So, I'll nerf fluid wagons to 20k, so there's reason to use barrels.
RAW["fluid-wagon"]["fluid-wagon"].capacity = 20000

-- Set auto-barrel field using const file.
for name, data in pairs(BarrelConst) do
	local fluid = FLUID[name]
	assert(fluid ~= nil, "Fluid "..name.." not found")
	if data.autoBarrel ~= nil then
		fluid.auto_barrel = data.autoBarrel
	end
end