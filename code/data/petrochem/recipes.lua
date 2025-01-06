local Tech = require("code.util.tech")
local Table = require("code.util.table")
local Recipe = require("code.util.recipe")

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
	order = "a[oil-processing]-b1",
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
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={-6, 5}, tint=constants.richgasColor},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={6, 5}, tint=constants.drygasColor},
	},
	icon = "nil",
	order = "a[oil-processing]-b2",
})
table.insert(newData, gasFractionationRecipe)

--[[ Edit existing cracking recipes, and add the new one.
	100 heavy oil + 100 steam -> 100 light oil + 1 carbon + 1 sulfur
	100 light oil + 100 steam -> 100 rich gas + 1 sulfur
	100 rich gas + 100 steam -> 100 dry gas
]]
Table.setFields(data.raw.recipe["heavy-oil-cracking"], {
	ingredients = {
		{type = "fluid", name = "heavy-oil", amount = 100},
		{type = "fluid", name = "steam", amount = 100},
	},
	results = {
		{type = "fluid", name = "light-oil", amount = 100},
		{type = "item", name = "carbon", amount = 1},
		{type = "item", name = "sulfur", amount = 1},
	},
	icon = "nil",
	icons = {
		{icon = "__base__/graphics/icons/fluid/heavy-oil.png", icon_size = 64, scale=0.3, shift={0, -3}},
		{icon = "__base__/graphics/icons/fluid/light-oil.png", icon_size = 64, scale=0.2, shift={-6, 4}},
		{icon = "__base__/graphics/icons/fluid/light-oil.png", icon_size = 64, scale=0.2, shift={6, 4}},
	},
})
Table.setFields(data.raw.recipe["light-oil-cracking"], {
	ingredients = {
		{type = "fluid", name = "light-oil", amount = 100},
		{type = "fluid", name = "steam", amount = 100},
	},
	results = {
		{type = "fluid", name = "petroleum-gas", amount = 100},
		{type = "item", name = "sulfur", amount = 1},
	},
	icon = "nil",
	icons = {
		{icon = "__base__/graphics/icons/fluid/light-oil.png", icon_size = 64, scale=0.3, shift={0, -3}},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={-6, 6}, tint=constants.richgasColor},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={6, 6}, tint=constants.richgasColor},
	},
})
local richGasCrackingRecipe = Table.copyAndEdit(data.raw.recipe["light-oil-cracking"], {
	name = "rich-gas-cracking",
	ingredients = {
		{type = "fluid", name = "petroleum-gas", amount = 100},
		{type = "fluid", name = "steam", amount = 100},
	},
	results = {
		{type = "fluid", name = "dry-gas", amount = 100},
	},
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.27, shift={0, -4}, tint=constants.richgasColor},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={-6, 5}, tint=constants.drygasColor},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={6, 5}, tint=constants.drygasColor},
	},
})
table.insert(newData, richGasCrackingRecipe)

--[[ Add recipe for tar distillation.
	Tar distillation: 10 tar -> 3 pitch + 2 heavy oil + 1 light oil + 2 carbon + 1 sulfur
		(No steam input because we want this to be usable on Fulgora for pitch, to make resin.)
]]
local tarDistillationRecipe = Table.copyAndEdit(data.raw.recipe["advanced-oil-processing"], {
	name = "tar-distillation",
	ingredients = {
		{type = "fluid", name = "tar", amount = 100},
	},
	results = {
		{type = "item", name = "pitch", amount = 3},
		--{type = "item", name = "carbon", amount = 2},
		{type = "item", name = "sulfur", amount = 1},
		{type = "fluid", name = "heavy-oil", amount = 20},
		{type = "fluid", name = "light-oil", amount = 10},
	},
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/petrochem/tar.png", icon_size = 64, scale=0.3, shift={0, -3}},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/pitch-1.png", icon_size = 64, scale=0.2, shift={-6, 5}},
		{icon = "__base__/graphics/icons/fluid/heavy-oil.png", icon_size = 64, scale=0.2, shift={6, 4}},
	},
	icon = "nil",
	order = "a[oil-processing]-b3",
	subgroup = "complex-fluid-recipes",
})
table.insert(newData, tarDistillationRecipe)

--[[ Add recipe for heavy oil coking.
	Heavy oil coking: 10 heavy oil -> 5 tar + 3 carbon
		If you intend to burn the heavy oil, you can get more heat by coking first and then burning the tar and carbon. (This is realistic, and rewards the player for the extra complexity.)
		This recipe is also useful when the player needs more tar or carbon - usually those are byproducts.
]]
local heavyOilCokingRecipe = Table.copyAndEdit(data.raw.recipe["heavy-oil-cracking"], {
	name = "heavy-oil-coking",
	ingredients = {
		{type = "fluid", name = "heavy-oil", amount = 100},
	},
	results = {
		{type = "item", name = "carbon", amount = 3},
		{type = "fluid", name = "tar", amount = 50},
	},
	icons = {
		{icon = "__base__/graphics/icons/fluid/heavy-oil.png", icon_size = 64, scale=0.3, shift={0, -3}},
		{icon = "__space-age__/graphics/icons/carbon.png", icon_size = 64, scale=0.2, shift={-6, 5}},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/tar.png", icon_size = 64, scale=0.2, shift={6, 4}},
	},
	icon = "nil",
	order = "a[oil-processing]-b4",
	subgroup = "complex-fluid-recipes",
	energy_required = 5,
})
table.insert(newData, heavyOilCokingRecipe)

--[[ Add recipe for coal coking.
	Coal coking: 10 coal -> 5 carbon + 2 tar + 1 sulfur
		This offers a route from coal to carbon that's more direct than syngas liquefaction.
]]
local coalCokingRecipe = Table.copyAndEdit(data.raw.recipe["heavy-oil-cracking"], {
	name = "coal-coking",
	ingredients = {
		{type = "item", name = "coal", amount = 10},
	},
	results = {
		{type = "item", name = "carbon", amount = 5},
		{type = "item", name = "sulfur", amount = 1},
		{type = "fluid", name = "tar", amount = 20},
	},
	icons = {
		{icon = "__base__/graphics/icons/coal.png", icon_size = 64, scale=0.25, shift={0, -3}},
		{icon = "__space-age__/graphics/icons/carbon.png", icon_size = 64, scale=0.2, shift={-6, 5}},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/tar.png", icon_size = 64, scale=0.2, shift={6, 4}},
	},
	icon = "nil",
	order = "a[oil-processing]-b5",
	subgroup = "complex-fluid-recipes",
	energy_required = 5,
})
table.insert(newData, coalCokingRecipe)

--[[ Add recipe for solid fuel.
	5 heavy oil + 2 tar -> 2 solid fuel + 1 light oil
		This represents pet coke style briquettes. We tune the energy values so that this gives more heat per heavy oil than other forms of processing. (TODO)
]]
local solidFuelRecipe = Table.copyAndEdit(data.raw.recipe["solid-fuel-from-light-oil"], {
	name = "solid-fuel",
	ingredients = {
		{type = "fluid", name = "heavy-oil", amount = 50},
		{type = "fluid", name = "tar", amount = 20},
	},
	results = {
		{type = "item", name = "solid-fuel", amount = 2},
		{type = "fluid", name = "light-oil", amount = 10},
	},
	main_product = "solid-fuel",
	icons = "nil",
	icon = "nil",
	energy_required = 2,
	hide_from_player_crafting = false,
})
table.insert(newData, solidFuelRecipe)

--[[ Add recipes for resin.
	Wood-based resin (pyrolysis): 5 wood + 5 steam -> 2 resin + 3 carbon
	Pitch-based resin: 2 pitch + 1 sulfuric acid + 1 carbon -> 4 resin
	Rich-gas-based resin: 2 rich gas + 1 sulfuric acid + 1 carbon -> 2 resin
	]]
local woodResinRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "wood-resin",
	ingredients = {
		{type = "item", name = "wood", amount = 5},
		{type = "fluid", name = "steam", amount = 50},
	},
	results = {
		{type = "item", name = "resin", amount = 2},
		{type = "item", name = "carbon", amount = 3},
	},
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale=0.45, shift={1, 1}},
		{icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale=0.32, shift={-5, -5}},
	},
	icon = "nil",
	order = "a[basic-intermediate]-e[resin]-1",
	subgroup = "resin-and-boards",
	main_product = "resin",
})
table.insert(newData, woodResinRecipe)
local pitchResinRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "pitch-resin",
	ingredients = {
		{type = "item", name = "pitch", amount = 2},
		{type = "fluid", name = "sulfuric-acid", amount = 10},
		{type = "item", name = "carbon", amount = 1},
	},
	results = {
		{type = "item", name = "resin", amount = 4},
	},
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale=0.45, shift={1, 1}},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/pitch-1.png", icon_size = 64, scale=0.32, shift={-5, -5}},
	},
	icon = "nil",
	order = "a[basic-intermediate]-e[resin]-2",
	subgroup = "resin-and-boards",
	main_product = "resin",
})
table.insert(newData, pitchResinRecipe)
local richGasResinRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "rich-gas-resin",
	ingredients = {
		{type = "fluid", name = "petroleum-gas", amount = 20},
		{type = "fluid", name = "sulfuric-acid", amount = 10},
		{type = "item", name = "carbon", amount = 1},
	},
	results = {
		{type = "item", name = "resin", amount = 2},
	},
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale=0.45, shift={1, 1}},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.32, shift={-5, -5}, tint=constants.richgasColor},
	},
	icon = "nil",
	order = "a[basic-intermediate]-e[resin]-3",
	subgroup = "resin-and-boards",
	main_product = "resin",
})
table.insert(newData, richGasResinRecipe)

--[[ Add syngas liquefaction.
	10 syngas + 1 iron plate -> 2 heavy oil + 3 light oil + 3 rich gas + 2 dry gas + 1 water
		(Named "syngas liquefaction" for the benefit of players already familiar with "coal liquefaction" in the base game, since this effectively replaces coal liquefaction.)
]]
local syngasLiquefactionRecipe = Table.copyAndEdit(data.raw.recipe["coal-liquefaction"], {
	name = "syngas-liquefaction",
	ingredients = {
		{type = "fluid", name = "syngas", amount = 100},
		{type = "item", name = "iron-plate", amount = 1},
	},
	results = {
		{type = "fluid", name = "heavy-oil", amount = 20},
		{type = "fluid", name = "light-oil", amount = 30},
		{type = "fluid", name = "petroleum-gas", amount = 30},
		{type = "fluid", name = "dry-gas", amount = 20},
		{type = "fluid", name = "water", amount = 1},
	},
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.27, shift={0, -4}, tint=constants.syngasColor},
		{icon = "__base__/graphics/icons/fluid/heavy-oil.png", icon_size = 64, scale=0.2, shift={-6, 4}},
		{icon = "__base__/graphics/icons/fluid/light-oil.png", icon_size = 64, scale=0.2, shift={6, 4}},
	},
	icon = "nil",
	order = "a[coal-liquefaction]-b4",
	subgroup = "complex-fluid-recipes",
})
table.insert(newData, syngasLiquefactionRecipe)

--[[ Modify recipe for lubricant
	10 heavy oil + 1 sulfuric acid -> 8 lubricant + 1 tar
		Meant to resemble vacuum distillation - heavy oil is distilled, sulfuric acid is used for acid-washing impurities.
]]
Table.setFields(data.raw.recipe["lubricant"], {
	ingredients = {
		{type = "fluid", name = "heavy-oil", amount = 100},
		{type = "fluid", name = "sulfuric-acid", amount = 10},
	},
	results = {
		{type = "fluid", name = "lubricant", amount = 80},
		{type = "fluid", name = "tar", amount = 10},
	},
	main_product = "lubricant",
})

--[[ Modify recipe for vehicle fuel (rocket-fuel).
	10 light oil + 5 rich gas -> 4 vehicle fuel (items)
		These are used both to fuel cars and tanks, and for rockets launched to space.
		These 2 fractions are used so that the player can't make rocket fuel immediately after fractionating only oil or only gas - needs to fractionate both, or crack, or do syngas liquefaction.
]]
Table.setFields(data.raw.recipe["rocket-fuel"], {
	ingredients = {
		{type = "fluid", name = "light-oil", amount = 100},
		{type = "fluid", name = "petroleum-gas", amount = 50},
	},
	results = {
		{type = "item", name = "rocket-fuel", amount = 4},
	},
	category = "organic-or-chemistry",
})

--[[ Modify recipe for plastic-bar.
	5 syngas + 2 carbon + 1 sulfuric acid -> 5 plastic bars
		Syngas provides hydrogen, carbon is the backbone, and sulfuric acid helps drive polymerization.
]]
Table.setFields(data.raw.recipe["plastic-bar"], {
	ingredients = {
		{type = "item", name = "carbon", amount = 2},
		{type = "fluid", name = "syngas", amount = 50},
		{type = "fluid", name = "sulfuric-acid", amount = 10},
	},
	results = {
		{type = "item", name = "plastic-bar", amount = 5},
	},
})

--[[ Modify recipe for explosives.
	5 light oil + 2 syngas + 1 sulfuric acid -> 3 explosives
		Light oil is the hydrocarbon base, syngas provides nitrogen (hand-waving some ammonia/nitration step; syngas has nitrogen bc it's air-blown), and sulfuric acid is the catalyst.
]]
Table.setFields(data.raw.recipe["explosives"], {
	ingredients = {
		{type = "fluid", name = "light-oil", amount = 50},
		{type = "fluid", name = "syngas", amount = 20},
		{type = "fluid", name = "sulfuric-acid", amount = 10},
	},
	results = {
		{type = "item", name = "explosives", amount = 3},
	},
})

------------------------------------------------------------------------
-- Add new prototypes to the game.
data:extend(newData)
------------------------------------------------------------------------

-- Add new fractionation recipes to techs.
Tech.addRecipeToTech("oil-fractionation", "oil-processing")
Tech.addRecipeToTech("gas-fractionation", "oil-processing")

-- Put all cracking recipes in the first oil tech.
Tech.addRecipeToTech("heavy-oil-cracking", "oil-processing")
Tech.addRecipeToTech("light-oil-cracking", "oil-processing")
Tech.addRecipeToTech("rich-gas-cracking", "oil-processing")
Tech.removeRecipeFromTech("heavy-oil-cracking", "advanced-oil-processing")
Tech.removeRecipeFromTech("light-oil-cracking", "advanced-oil-processing")

-- Add tar distillation to the 1st oil tech.
Tech.addRecipeToTech("tar-distillation", "oil-processing")

-- Add resin recipes to the 1st oil tech.
Tech.addRecipeToTech("wood-resin", "oil-processing")
Tech.addRecipeToTech("pitch-resin", "oil-processing")
Tech.addRecipeToTech("rich-gas-resin", "oil-processing")
-- TODO need to figure out where these are in progression. First one needs chem plants, so need to unlock those. Maybe a resin tech in early game.

-- Hide old recipes, and remove from techs.
Recipe.hide("basic-oil-processing")
Tech.removeRecipeFromTech("basic-oil-processing", "oil-processing")
Recipe.hide("advanced-oil-processing")
Tech.removeRecipeFromTech("advanced-oil-processing", "advanced-oil-processing")
Recipe.hide("solid-fuel-from-heavy-oil")
Tech.removeRecipeFromTech("solid-fuel-from-heavy-oil", "advanced-oil-processing")
Recipe.hide("solid-fuel-from-light-oil")
Tech.removeRecipeFromTech("solid-fuel-from-light-oil", "advanced-oil-processing")
Recipe.hide("solid-fuel-from-petroleum-gas")
Tech.removeRecipeFromTech("solid-fuel-from-petroleum-gas", "oil-processing")
Recipe.hide("simple-coal-liquefaction")
Tech.removeRecipeFromTech("simple-coal-liquefaction", "calcite-processing")
Recipe.hide("coal-liquefaction")
Tech.removeRecipeFromTech("coal-liquefaction", "coal-liquefaction")
Recipe.hide("acid-neutralisation")
Tech.removeRecipeFromTech("acid-neutralisation", "calcite-processing")
Recipe.hide("coal-synthesis")
Tech.removeRecipeFromTech("coal-synthesis", "rocket-turret")

-- Add syngas liquefaction to tech.
Tech.addRecipeToTech("syngas-liquefaction", "coal-liquefaction")

-- Add heavy oil coking to advanced-oil-processing tech.
Tech.addRecipeToTech("heavy-oil-coking", "advanced-oil-processing")

-- Add coal coking to oil-processing tech.
Tech.addRecipeToTech("coal-coking", "oil-processing")
-- TODO figure out where this should go in progression.

-- Remove default recipes for carbon, sulfur.
Recipe.hide("sulfur")
Recipe.hide("carbon")
Tech.removeRecipeFromTech("sulfur", "sulfur-processing") -- TODO figure out what to do with that tech.
Tech.removeRecipeFromTech("carbon", "tungsten-carbide") -- TODO check that tech