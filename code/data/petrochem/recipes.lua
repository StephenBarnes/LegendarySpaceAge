local Tech = require("code.util.tech")
local Table = require("code.util.table")
local Recipe = require("code.util.recipe")

local constants = require("code.data.petrochem.constants")

local newData = {}

--[[ Create fractionation recipes.
Fractionation recipes turn crude oil and natural gas into the 4 fractions: heavy oil, light oil, rich gas, dry gas.
	Oil fractionation: 10 crude oil + 2 steam -> 1 tar + 4 heavy oil + 5 light oil + 1 water + 2 sulfur + 2 carbon
	Gas fractionation: 10 natural gas + 2 steam -> 5 rich gas + 5 dry gas + 1 water + 1 sulfur
	]]
local oilFractionationRecipe = table.deepcopy(data.raw.recipe["advanced-oil-processing"])
oilFractionationRecipe.name = "oil-fractionation"
oilFractionationRecipe.ingredients = {
	{type = "fluid", name = "crude-oil", amount = 100},
	{type = "fluid", name = "steam", amount = 20},
}
oilFractionationRecipe.results = {
	{type = "fluid", name = "tar", amount = 10, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "heavy-oil", amount = 40, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "light-oil", amount = 50, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "water", amount = 1, show_details_in_recipe_tooltip = false}, -- Game has water 10x denser than steam. So this gives half the steam back as water.
	{type = "item", name = "sulfur", amount = 2, show_details_in_recipe_tooltip = false},
	{type = "item", name = "carbon", amount = 2, show_details_in_recipe_tooltip = false},
}
oilFractionationRecipe.icons = {
	{icon = "__base__/graphics/icons/fluid/crude-oil.png", icon_size = 64, scale=0.3, shift={0, -3}},
	{icon = "__base__/graphics/icons/fluid/heavy-oil.png", icon_size = 64, scale=0.2, shift={-6, 4}},
	{icon = "__base__/graphics/icons/fluid/light-oil.png", icon_size = 64, scale=0.2, shift={6, 4}},
}
oilFractionationRecipe.icon = nil
oilFractionationRecipe.order = "a[oil-processing]-b1"
table.insert(newData, oilFractionationRecipe)

local gasFractionationRecipe = table.deepcopy(data.raw.recipe["advanced-oil-processing"])
gasFractionationRecipe.name = "gas-fractionation"
gasFractionationRecipe.ingredients = {
	{type = "fluid", name = "natural-gas", amount = 100},
	{type = "fluid", name = "steam", amount = 20},
}
gasFractionationRecipe.results = {
	{type = "fluid", name = "petroleum-gas", amount = 50, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "dry-gas", amount = 50, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "water", amount = 1, show_details_in_recipe_tooltip = false},
	{type = "item", name = "sulfur", amount = 1, show_details_in_recipe_tooltip = false},
}
gasFractionationRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.27, shift={0, -4}, tint=constants.natgasTint},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={-6, 5}, tint=constants.richgasColor},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={6, 5}, tint=constants.drygasColor},
}
gasFractionationRecipe.icon = nil
gasFractionationRecipe.order = "a[oil-processing]-b2"
table.insert(newData, gasFractionationRecipe)

--[[ Edit existing cracking recipes, and add the new one.
	100 heavy oil + 100 steam -> 100 light oil + 1 carbon + 1 sulfur
	100 light oil + 100 steam -> 100 rich gas + 1 sulfur
	100 rich gas + 100 steam -> 100 dry gas
]]
local heavyOilCrackingRecipe = data.raw.recipe["heavy-oil-cracking"]
heavyOilCrackingRecipe.ingredients = {
	{type = "fluid", name = "heavy-oil", amount = 100},
	{type = "fluid", name = "steam", amount = 50},
}
heavyOilCrackingRecipe.results = {
	{type = "fluid", name = "light-oil", amount = 100, show_details_in_recipe_tooltip = false},
	{type = "item", name = "carbon", amount = 1, show_details_in_recipe_tooltip = false},
	{type = "item", name = "sulfur", amount = 1, show_details_in_recipe_tooltip = false},
}
heavyOilCrackingRecipe.icon = nil
heavyOilCrackingRecipe.icons = {
	{icon = "__base__/graphics/icons/fluid/heavy-oil.png", icon_size = 64, scale=0.3, shift={0, -3}},
	{icon = "__base__/graphics/icons/fluid/light-oil.png", icon_size = 64, scale=0.2, shift={-6, 4}},
	{icon = "__base__/graphics/icons/fluid/light-oil.png", icon_size = 64, scale=0.2, shift={6, 4}},
}

local lightOilCrackingRecipe = data.raw.recipe["light-oil-cracking"]
lightOilCrackingRecipe.ingredients = {
	{type = "fluid", name = "light-oil", amount = 100},
	{type = "fluid", name = "steam", amount = 50},
}
lightOilCrackingRecipe.results = {
	{type = "fluid", name = "petroleum-gas", amount = 100, show_details_in_recipe_tooltip = false},
	{type = "item", name = "sulfur", amount = 1, show_details_in_recipe_tooltip = false},
}
lightOilCrackingRecipe.icon = nil
lightOilCrackingRecipe.icons = {
	{icon = "__base__/graphics/icons/fluid/light-oil.png", icon_size = 64, scale=0.3, shift={0, -3}},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={-6, 6}, tint=constants.richgasColor},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={6, 6}, tint=constants.richgasColor},
}
local richGasCrackingRecipe = table.deepcopy(data.raw.recipe["light-oil-cracking"])
richGasCrackingRecipe.name = "rich-gas-cracking"
richGasCrackingRecipe.ingredients = {
	{type = "fluid", name = "petroleum-gas", amount = 100},
	{type = "fluid", name = "steam", amount = 50},
}
richGasCrackingRecipe.results = {
	{type = "fluid", name = "dry-gas", amount = 100, show_details_in_recipe_tooltip = false},
}
richGasCrackingRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.27, shift={0, -4}, tint=constants.richgasColor},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={-6, 5}, tint=constants.drygasColor},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.18, shift={6, 5}, tint=constants.drygasColor},
}
richGasCrackingRecipe.icon = nil
table.insert(newData, richGasCrackingRecipe)

--[[ Add recipe for tar distillation.
	Tar distillation: 10 tar -> 3 pitch + 2 heavy oil + 1 light oil + 2 carbon + 1 sulfur
		(No steam input because we want this to be usable on Fulgora for pitch, to make resin.)
]]
local tarDistillationRecipe = table.deepcopy(data.raw.recipe["advanced-oil-processing"])
tarDistillationRecipe.name = "tar-distillation"
tarDistillationRecipe.ingredients = {
	{type = "fluid", name = "tar", amount = 100},
}
tarDistillationRecipe.results = {
	{type = "item", name = "pitch", amount = 3, show_details_in_recipe_tooltip = false},
	--{type = "item", name = "carbon", amount = 2},
	{type = "item", name = "sulfur", amount = 1, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "heavy-oil", amount = 20, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "light-oil", amount = 10, show_details_in_recipe_tooltip = false},
}
tarDistillationRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/petrochem/tar.png", icon_size = 64, scale=0.3, shift={0, -3}},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/pitch-1.png", icon_size = 64, scale=0.2, shift={-6, 5}},
	{icon = "__base__/graphics/icons/fluid/heavy-oil.png", icon_size = 64, scale=0.2, shift={6, 4}},
}
tarDistillationRecipe.icon = nil
tarDistillationRecipe.order = "a[oil-processing]-b5"
tarDistillationRecipe.subgroup = "complex-fluid-recipes"
table.insert(newData, tarDistillationRecipe)

--[[ Add recipe for heavy oil coking.
	Heavy oil coking: 10 heavy oil -> 5 tar + 3 carbon
		If you intend to burn the heavy oil, you can get more heat by coking first and then burning the tar and carbon. (This is realistic, and rewards the player for the extra complexity.)
		This recipe is also useful when the player needs more tar or carbon - usually those are byproducts.
]]
local heavyOilCokingRecipe = table.deepcopy(data.raw.recipe["heavy-oil-cracking"])
heavyOilCokingRecipe.name = "heavy-oil-coking"
heavyOilCokingRecipe.ingredients = {
	{type = "fluid", name = "heavy-oil", amount = 100},
}
heavyOilCokingRecipe.results = {
	{type = "item", name = "carbon", amount = 3, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "tar", amount = 50, show_details_in_recipe_tooltip = false},
}
heavyOilCokingRecipe.icons = {
	{icon = "__base__/graphics/icons/fluid/heavy-oil.png", icon_size = 64, scale=0.3, shift={0, -3}},
	{icon = "__space-age__/graphics/icons/carbon.png", icon_size = 64, scale=0.2, shift={-6, 5}},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/tar.png", icon_size = 64, scale=0.2, shift={6, 4}},
}
heavyOilCokingRecipe.icon = nil
heavyOilCokingRecipe.order = "a[oil-processing]-b4"
heavyOilCokingRecipe.subgroup = "complex-fluid-recipes"
heavyOilCokingRecipe.energy_required = 5
table.insert(newData, heavyOilCokingRecipe)

--[[ Add recipe for coal coking.
	Coal coking: 10 coal -> 6 carbon + 1 sulfur
		This offers a route from coal to carbon that's more direct than syngas liquefaction.
		For realism, this should slightly reduce total fuel energy.
			But I'm rather making it slightly energy-positive but only if you burn the sulfur, since that's more interesting.
				Options are now:
					burn the coal
					coke the coal, burn the carbon, dump the sulfur - needs more machines and dump route, creates less pollution, same energy minus assemblers
					coke the coal, burn the carbon, burn the sulfur - needs machines, creates more pollution, gives more energy
]]
local coalCokingRecipe = table.deepcopy(data.raw.recipe["heavy-oil-cracking"])
coalCokingRecipe.name = "coal-coking"
coalCokingRecipe.ingredients = {
	{type = "item", name = "coal", amount = 2},
}
coalCokingRecipe.results = {
	{type = "item", name = "carbon", amount = 2},
	{type = "item", name = "sulfur", amount = 1},
	{type = "item", name = "pitch", amount = 1},
	--{type = "fluid", name = "tar", amount = 20}, -- Removed bc the player has no way to handle fluid waste yet, except waste pump I guess.
}
coalCokingRecipe.icons = {
	{icon = "__base__/graphics/icons/coal.png", icon_size = 64, scale=0.25, shift={0, -3}},
	{icon = "__space-age__/graphics/icons/carbon.png", icon_size = 64, scale=0.2, shift={-6, 5}},
	{icon = "__base__/graphics/icons/sulfur.png", icon_size = 64, scale=0.2, shift={6, 5}},
}
coalCokingRecipe.icon = nil
coalCokingRecipe.order = "a[oil-processing]-b3"
coalCokingRecipe.subgroup = "complex-fluid-recipes"
coalCokingRecipe.category = "chemistry"
coalCokingRecipe.energy_required = 1
coalCokingRecipe.enabled = false -- Unlocked by coal-coking tech, created in another file.
table.insert(newData, coalCokingRecipe)

--[[ Add recipe for solid fuel.
	5 heavy oil + 2 tar -> 2 solid fuel + 1 light oil
		This represents pet coke style briquettes. We tune the energy values so that this gives more heat per heavy oil than other forms of processing.
	Currently 25MJ + 4MJ -> 24MJ + 7MJ, so on net this increases energy slightly.
]]
local solidFuelRecipe = table.deepcopy(data.raw.recipe["solid-fuel-from-light-oil"])
solidFuelRecipe.name = "solid-fuel"
solidFuelRecipe.ingredients = {
	{type = "fluid", name = "heavy-oil", amount = 50},
	{type = "fluid", name = "tar", amount = 20},
}
solidFuelRecipe.results = {
	{type = "item", name = "solid-fuel", amount = 2},
	{type = "fluid", name = "light-oil", amount = 10},
}
solidFuelRecipe.main_product = "solid-fuel"
solidFuelRecipe.icons = nil
solidFuelRecipe.icon = nil
solidFuelRecipe.energy_required = 4
solidFuelRecipe.hide_from_player_crafting = false
table.insert(newData, solidFuelRecipe)

--[[ Add recipes for resin.
	Wood-based resin (pyrolysis): 5 wood + 5 steam -> 2 resin + 3 carbon
	Pitch-based resin: 2 pitch + 1 sulfuric acid + 1 carbon -> 4 resin
	Rich-gas-based resin: 2 rich gas + 1 sulfuric acid + 1 carbon -> 2 resin
	]]
local woodResinRecipe = table.deepcopy(data.raw.recipe["plastic-bar"])
woodResinRecipe.name = "wood-resin"
woodResinRecipe.ingredients = {
	{type = "item", name = "wood", amount = 1},
	{type = "fluid", name = "steam", amount = 100},
}
woodResinRecipe.results = {
	{type = "item", name = "resin", amount = 8},
	{type = "item", name = "carbon", amount = 1},
}
woodResinRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale=0.45, shift={1, 1}},
	{icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale=0.32, shift={-5, -5}},
}
woodResinRecipe.icon = nil
woodResinRecipe.order = "a[basic-intermediate]-e[resin]-1"
woodResinRecipe.subgroup = "resin"
woodResinRecipe.main_product = "resin"
woodResinRecipe.energy_required = 4
table.insert(newData, woodResinRecipe)

local pitchResinRecipe = table.deepcopy(data.raw.recipe["plastic-bar"])
pitchResinRecipe.name = "pitch-resin"
pitchResinRecipe.ingredients = {
	{type = "item", name = "pitch", amount = 2},
	{type = "fluid", name = "sulfuric-acid", amount = 10},
	{type = "item", name = "carbon", amount = 1},
}
pitchResinRecipe.results = {
	{type = "item", name = "resin", amount = 2},
}
pitchResinRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale=0.45, shift={1, 1}},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/pitch-1.png", icon_size = 64, scale=0.32, shift={-5, -5}},
}
pitchResinRecipe.icon = nil
pitchResinRecipe.order = "a[basic-intermediate]-e[resin]-2"
pitchResinRecipe.subgroup = "resin"
pitchResinRecipe.main_product = "resin"
pitchResinRecipe.energy_required = 2
table.insert(newData, pitchResinRecipe)

local richGasResinRecipe = table.deepcopy(data.raw.recipe["plastic-bar"])
richGasResinRecipe.name = "rich-gas-resin"
richGasResinRecipe.ingredients = {
	{type = "fluid", name = "petroleum-gas", amount = 20},
	{type = "fluid", name = "sulfuric-acid", amount = 10},
	{type = "item", name = "carbon", amount = 1},
}
richGasResinRecipe.results = {
	{type = "item", name = "resin", amount = 1},
}
richGasResinRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale=0.45, shift={1, 1}},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.32, shift={-5, -5}, tint=constants.richgasColor},
}
richGasResinRecipe.icon = nil
richGasResinRecipe.order = "a[basic-intermediate]-e[resin]-3"
richGasResinRecipe.subgroup = "resin"
richGasResinRecipe.main_product = "resin"
richGasResinRecipe.energy_required = 2
table.insert(newData, richGasResinRecipe)

--[[ Add syngas liquefaction.
	10 syngas + 1 iron plate -> 2 heavy oil + 3 light oil + 3 rich gas + 2 dry gas + 1 water
		(Named "syngas liquefaction" for the benefit of players already familiar with "coal liquefaction" in the base game, since this effectively replaces coal liquefaction.)
]]
local syngasLiquefactionRecipe = table.deepcopy(data.raw.recipe["coal-liquefaction"])
syngasLiquefactionRecipe.name = "syngas-liquefaction"
syngasLiquefactionRecipe.ingredients = {
	{type = "fluid", name = "syngas", amount = 100},
	{type = "item", name = "iron-plate", amount = 1},
}
syngasLiquefactionRecipe.results = {
	{ type = "fluid", name = "heavy-oil",     amount = 20, show_details_in_recipe_tooltip = false },
	{ type = "fluid", name = "light-oil",     amount = 30, show_details_in_recipe_tooltip = false },
	{ type = "fluid", name = "petroleum-gas", amount = 30, show_details_in_recipe_tooltip = false },
	{ type = "fluid", name = "dry-gas",       amount = 20, show_details_in_recipe_tooltip = false },
	{ type = "fluid", name = "water",         amount = 1,  show_details_in_recipe_tooltip = false },
}
syngasLiquefactionRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, scale=0.27, shift={0, -4}, tint=constants.syngasColor},
	{icon = "__base__/graphics/icons/fluid/heavy-oil.png", icon_size = 64, scale=0.2, shift={-6, 4}},
	{icon = "__base__/graphics/icons/fluid/light-oil.png", icon_size = 64, scale=0.2, shift={6, 4}},
}
syngasLiquefactionRecipe.icon = nil
syngasLiquefactionRecipe.order = "a[coal-liquefaction]-b4"
syngasLiquefactionRecipe.subgroup = "complex-fluid-recipes"
table.insert(newData, syngasLiquefactionRecipe)

--[[ Modify recipe for lubricant
	10 heavy oil + 1 sulfuric acid -> 8 lubricant + 1 tar
		Meant to resemble vacuum distillation - heavy oil is distilled, sulfuric acid is used for acid-washing impurities.
]]
local lubricantRecipe = data.raw.recipe["lubricant"]
lubricantRecipe.ingredients = {
	{ type = "fluid", name = "heavy-oil",     amount = 100 },
	{ type = "fluid", name = "sulfuric-acid", amount = 10 },
}
lubricantRecipe.results = {
	{ type = "fluid", name = "lubricant", amount = 80 },
	{ type = "fluid", name = "tar",       amount = 10 },
}
lubricantRecipe.main_product = "lubricant"

--[[ Modify recipe for vehicle fuel (rocket-fuel).
	10 light oil + 5 rich gas -> 4 vehicle fuel (items)
		These are used both to fuel cars and tanks, and for rockets launched to space.
		These 2 fractions are used so that the player can't make rocket fuel immediately after fractionating only oil or only gas - needs to fractionate both, or crack, or do syngas liquefaction.
]]
local rocketFuelRecipe = data.raw.recipe["rocket-fuel"]
rocketFuelRecipe.ingredients = {
	{ type = "fluid", name = "light-oil",     amount = 100 },
	{ type = "fluid", name = "petroleum-gas", amount = 50 },
}
rocketFuelRecipe.results = {
	{type = "item", name = "rocket-fuel", amount = 4},
}
rocketFuelRecipe.category = "organic-or-chemistry"

--[[ Modify recipe for plastic-bar.
	5 syngas + 2 carbon + 1 sulfuric acid -> 5 plastic bars
		Syngas provides hydrogen, carbon is the backbone, and sulfuric acid helps drive polymerization.
]]
local plasticBarRecipe = data.raw.recipe["plastic-bar"]
plasticBarRecipe.ingredients = {
	{ type = "item",  name = "carbon",        amount = 2 },
	{ type = "fluid", name = "syngas",        amount = 50 },
	{ type = "fluid", name = "sulfuric-acid", amount = 10 },
}
plasticBarRecipe.results = {
	{type = "item", name = "plastic-bar", amount = 3},
}

-- Modify recipe for explosives.
local explosivesRecipe = data.raw.recipe["explosives"]
explosivesRecipe.ingredients = {
	{ type = "item",  name = "niter",         amount = 2 },
	{ type = "fluid", name = "ammonia",       amount = 20 },
	{ type = "fluid", name = "light-oil",     amount = 10 },
	{ type = "fluid", name = "sulfuric-acid", amount = 10 },
}
explosivesRecipe.results = {{type = "item", name = "explosives", amount = 2}}

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

-- Add heavy oil coking to oil processing tech.
Tech.addRecipeToTech("heavy-oil-coking", "oil-processing")

-- Add tar distillation to the 1st oil tech.
Tech.addRecipeToTech("tar-distillation", "oil-processing")

-- Wood resin recipe will be placed in wood circuit boards tech.
-- Pitch resin and rich-gas resin will be unlocked in a special "petroleum resin" tech, after blue science.

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

-- Remove default recipes for carbon, sulfur.
Recipe.hide("sulfur")
Recipe.hide("carbon")
Tech.removeRecipeFromTech("sulfur", "sulfur-processing") -- TODO figure out what to do with that tech.
Tech.removeRecipeFromTech("carbon", "tungsten-carbide") -- TODO check that tech