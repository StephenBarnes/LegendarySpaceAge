--[[ This file creates new techs for barrelling and gas tanks, moves barrelling recipes to the new barrelling tech, and creates gas tanks and their recipes, etc. Also adds fuel values to barrels and tanks. ]]

local Table = require("code.util.table")
local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

-- Create the new barrelling tech.
local barrellingTech = Table.copyAndEdit(data.raw.technology["oil-processing"], {
	name = "barrelling",
	effects = {
		-- TODO
	},
})
data:extend{barrellingTech}

-- Create the new gas tank tech.
local gasTankTech = Table.copyAndEdit(data.raw.technology["oil-processing"], {
	name = "gas-tanks",
	effects = {
		-- TODO
	},
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/gas-tanks/tech.png", icon_size = 256, scale = 0.5},
	},
})
data:extend{gasTankTech}

-- Create the new empty gas tank item.
local emptyGasTankItem = Table.copyAndEdit(data.raw.item["empty-barrel"], {
	name = "empty-gas-tank",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/gas-tanks/tank.png", icon_size = 64, scale = 0.5},
		{icon = "__LegendarySpaceAge__/graphics/gas-tanks/tank-overlay.png", icon_size = 64, scale = 0.5, tint = {1,1,1}},
	},
	order = data.raw.item["empty-barrel"].order .. "-1",
})
data:extend{emptyGasTankItem}