local Tech = require("code.util.tech")
local Table = require("code.util.table")

local constants = require("code.data.petrochem.constants")

local newData = {}

--[[ Create fractionation recipes.
Fractionation recipes turn crude oil and natural gas into the 4 fractions: heavy oil, light oil, rich gas, dry gas.
	Oil fractionation: 10 crude oil + 2 steam -> 4 heavy oil + 5 light oil + 2 sulfur + 2 carbon
	Gas fractionation: 10 natural gas + 2 steam -> 5 rich gas + 5 dry gas + 1 sulfur
	]]
local oilFractionationRecipe = Table.copyAndEdit(data.raw.recipe["advanced-oil-processing"], {
	name = "oil-fractionation",
	ingredients = {
		{type = "fluid", name = "crude-oil", amount = 100},
		{type = "fluid", name = "steam", amount = 20},
	},
	results = {
		{type = "fluid", name = "tar", amount = 10},
		{type = "fluid", name = "heavy-oil", amount = 40},
		{type = "fluid", name = "light-oil", amount = 50},
		{type = "fluid", name = "water", amount = 1}, -- Game has water 10x denser than steam. So this gives half the steam back as water.
		{type = "item", name = "sulfur", amount = 2},
		{type = "item", name = "carbon", amount = 2},
	},
	icons = {
		{icon = "__base__/graphics/icons/fluid/crude-oil.png", icon_size = 64, scale=0.3, shift={0, -3}},
		{icon = "__base__/graphics/icons/fluid/heavy-oil.png", icon_size = 64, scale=0.2, shift={-6, 4}},
		{icon = "__base__/graphics/icons/fluid/light-oil.png", icon_size = 64, scale=0.2, shift={6, 4}},
	},
	icon = "nil",
})
table.insert(newData, oilFractionationRecipe)
local gasFractionationRecipe = Table.copyAndEdit(data.raw.recipe["advanced-oil-processing"], {
	name = "gas-fractionation",
	ingredients = {
		{type = "fluid", name = "natural-gas", amount = 100},
		{type = "fluid", name = "steam", amount = 20},
	},
	results = {
		{type = "fluid", name = "petroleum-gas", amount = 50},
		{type = "fluid", name = "dry-gas", amount = 50},
		{type = "fluid", name = "water", amount = 1},
		{type = "item", name = "sulfur", amount = 1},
	},
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.27, shift={0, -4}, tint=constants.natgasTint},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={-6, 4}, tint=constants.richgasColor},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={6, 4}, tint=constants.drygasColor},
	},
	icon = "nil",
})
table.insert(newData, gasFractionationRecipe)

------------------------------------------------------------------------
-- Add new prototypes to the game.
data:extend(newData)
------------------------------------------------------------------------

-- Add new fractionation recipes to techs.
Tech.addRecipeToTech("oil-fractionation", "oil-processing")
Tech.addRecipeToTech("gas-fractionation", "oil-processing")