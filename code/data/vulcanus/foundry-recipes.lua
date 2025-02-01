--[[ This file modifies and creates recipes for the foundry.
Foundries are used for processing molten metals.
Following the standard that roughly 10 molten metal equals 1 plate. Except steel.
Basic process from lava:
	500 lava + 1 calcite + 1 carbon -> 250 molten iron + 10 copper matte + 20 stone
	(It might be more realistic and easy to have separate iron and copper recipes. But tying them together like this is interesting for gameplay, since the player will get too many of one, and have to set up a system to balance iron and copper by dumping excess into the lava. It's also realistic.)
	Old recipes were:
		1 calcite + 500 lava -> 10 stone + 250 molten iron
		1 calcite + 500 lava -> 15 stone + 250 molten copper
		And then 10 molten iron/copper is 1 plate; 30 molten iron is 1 steel plate.
	So, we're keeping it similarly difficult to produce those, since 10 copper matte = 20 ore = 5 ingots = 20 plates.
Copper matte can be directly turned into molten copper:
	25 copper matte -> 500 molten copper + 10 sulfur
Turning ores into the same metal intermediates, in a foundry (not used on Vulcanus):
	50 iron ore + 1 calcite + 2 carbon -> 500 molten iron + 25 stone
	(Copper ore to matte actually has to be done in a furnace. No foundry recipe, since it's not molten.)
	Old recipes were:
		50 iron ore + 1 calcite -> 500 molten iron
		50 copper ore + 1 calcite -> 500 molten copper
Turning molten metals into items, in a foundry:
	20 molten iron + 1 water -> 2 iron plate + 10 steam
	The water ingredient and steam byproduct represent water cooling; this adds substantial fluid management complexity to all of the foundries casting metal items.
	Similar recipes for copper plates, iron rods, iron machine parts, copper cables, and possibly more.
	Casting iron items makes them start 20% spoiled (from rust).
Molten steel recipes:
	100 molten iron + 1 carbon + 1 calcite -> 100 molten steel (in a foundry)
	30 molten steel + 1 water -> 1 steel plate + 10 steam
			Originally 30 molten iron -> 1 steel plate.

Tungsten ore is only found on Vulcanus.
In a foundry: 4 tungsten ore + 1 carbon + 10 sulfuric acid -> 40 molten tungsten (at 1500 degrees) + 1 stone
	This represents acid leaching, high-temperature reduction, and foundry smelting. In gameplay terms, tungsten production is limited by carbon and water (for sulfuric acid), both of which are scarce.
Molten tungsten is then converted into tungsten carbide and tungsten steel. We introduce a new challenge here by requiring the molten tungsten for carbide/steel to be in specific temperature ranges. It's produced at 1500 degrees, then we add a recipe to heat it to 2000 degrees; then the player must mix these different temperatures to get into the necessary ranges:
	In foundry: 10 molten tungsten (any temperature) -> 10 molten tungsten (2000 degrees)
	In foundry: 20 molten tungsten (1600-1800 degrees) + 1 carbon + 1 water -> 1 tungsten carbide + 10 steam
	In foundry: 40 molten tungsten (1800-1900 degrees) + 10 molten steel + 1 water -> 1 tungsten-steel plate + 10 steam
Note temp range of carbide is deliberately made to touch but not overlap with tungsten steel, since it allows more interesting feasible designs. (If they overlap, you can just heat up until both production lines are active. If they're disjoint then you need to build separate fluid systems for carbide vs steel. Touching but not overlapping means both approaches are sorta feasible.)
Since tungsten carbide is needed to make foundries, to avoid circular dependency we also allow smelting tungsten ore directly to tungsten carbide in a furnace. This is simple but very inefficient, consuming a lot of carbon.
Originally tungsten recipes were:
	In assembler only: 2 tungsten ore + 1 carbon + 10 sulfuric acid -> 1 tungsten carbide (1 second)
	In foundry: 4 tungsten ore + 10 molten iron -> 1 tungsten plate (10 seconds)

Vulcanus unlocks a foundry recipe for concrete without water, using sulfur:
	10 stone brick + 5 sulfur -> 10 concrete (representing sulfur concrete)
]]

local Table = require("code.util.table")
local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

local newData = {}

-- Make recipe for metals-from-lava.
local metalsFromLavaRecipe = table.deepcopy(data.raw.recipe["molten-iron-from-lava"])
metalsFromLavaRecipe.name = "metals-from-lava"
metalsFromLavaRecipe.ingredients = {
	{type = "fluid", name = "lava", amount = 500},
	{type = "item", name = "calcite", amount = 1},
	{type = "item", name = "carbon", amount = 1},
}
metalsFromLavaRecipe.results = {
	{type = "fluid", name = "molten-iron", amount = 250},
	{type = "item", name = "copper-matte", amount = 10},
	{type = "item", name = "stone", amount = 20},
}
metalsFromLavaRecipe.enabled = false
metalsFromLavaRecipe.allow_decomposition = true
metalsFromLavaRecipe.allow_as_intermediate = true
metalsFromLavaRecipe.icon = nil
metalsFromLavaRecipe.icons = {{
	icon = "__LegendarySpaceAge__/graphics/vulcanus/metals-from-lava.png",
	icon_size = 64,
	scale = 0.5,
}}
table.insert(newData, metalsFromLavaRecipe)

-- Hide old recipes for molten metals from lava, remove from tech, add new recipe to tech.
Recipe.hide("molten-iron-from-lava")
Recipe.hide("molten-copper-from-lava")
Tech.removeRecipesFromTechs({"molten-iron-from-lava", "molten-copper-from-lava"}, {"foundry"})
Tech.addRecipeToTech("metals-from-lava", "foundry", 3)

-- Edit recipe for copper-ore-to-molten-copper to instead use copper matte.
local matteMeltRecipe = data.raw.recipe["molten-copper"]
matteMeltRecipe.ingredients = {{type = "item", name = "copper-matte", amount = 25}}
matteMeltRecipe.results = {
	{type = "fluid", name = "molten-copper", amount = 500},
	{type = "item", name = "sulfur", amount = 10},
}

-- Edit recipe for iron-ore-to-molten-iron.
local ironOreMeltRecipe = data.raw.recipe["molten-iron"]
ironOreMeltRecipe.ingredients = {
	{type = "item", name = "iron-ore", amount = 50},
	{type = "item", name = "calcite", amount = 1},
	{type = "item", name = "carbon", amount = 2},
}
ironOreMeltRecipe.results = {
	{type = "fluid", name = "molten-iron", amount = 500},
	{type = "item", name = "stone", amount = 25},
}

-- Adjust molten iron icon, to differentiate it from molten steel.
local ironFluidIcon = "__LegendarySpaceAge__/graphics/vulcanus/molten-iron.png"
if data.raw.fluid["molten-iron"].icon then
	data.raw.fluid["molten-iron"].icon = ironFluidIcon
else
	data.raw.fluid["molten-iron"].icons[1].icon = ironFluidIcon
end

-- Make molten steel fluid.
local moltenSteelFluid = table.deepcopy(data.raw.fluid["molten-iron"])
moltenSteelFluid.name = "molten-steel"
moltenSteelFluid.icon = nil
moltenSteelFluid.icons = {{
	icon = "__LegendarySpaceAge__/graphics/vulcanus/molten-steel.png",
	icon_size = 64,
	scale = 0.5,
}}
moltenSteelFluid.order = "b[new-fluid]-b[vulcanus]-c[molten-steel]"
moltenSteelFluid.base_color = {.3, .4, .4}
moltenSteelFluid.flow_color = {.5, .7, .7}
moltenSteelFluid.visualization_color = {.2, 1, 1} -- Cyan for the diagram-like lines drawn on pipes.
table.insert(newData, moltenSteelFluid)

-- Make recipe for molten steel.
local moltenSteelRecipe = table.deepcopy(data.raw.recipe["molten-iron"])
moltenSteelRecipe.name = "molten-steel-making"
	-- Not naming it the same as the fluid, so recipe shows up with the rest of them.
	-- Seems the way it works is, recipe can show up in a different subgroup as the fluid if it either has multiple products, or a different name from the fluid.
moltenSteelRecipe.localised_name = {"fluid-name.molten-steel"}
moltenSteelRecipe.ingredients = {
	{type = "fluid", name = "molten-iron", amount = 100},
	{type = "item", name = "carbon", amount = 1},
	{type = "item", name = "calcite", amount = 1},
}
moltenSteelRecipe.results = {
	{type = "fluid", name = "molten-steel", amount = 100},
}
moltenSteelRecipe.main_product = "molten-steel"
moltenSteelRecipe.order = "a[melting]-d[molten-steel]"
table.insert(newData, moltenSteelRecipe)
Tech.addRecipeToTech("molten-steel-making", "foundry", 8)

-- Adjust recipes for casting molten metals into items.
-- Balanced so that they have the same molten metal costs, and all of them consume ~40/s molten metal and 1/s water. Note 40 molten metal is equivalent to 1 ingot. Foundry has speed 4.
-- In base Space Age they do 30 molten iron -> 1 steel plate. But we're using the extra step of molten iron -> molten steel, with the +50% prod bonus, so let's not also do 30->1.
local ironCastingRecipe = data.raw.recipe["casting-iron"]
ironCastingRecipe.ingredients = {
	{type = "fluid", name = "molten-iron", amount = 40},
	{type = "fluid", name = "water", amount = 1},
}
ironCastingRecipe.results = {
	{type = "item", name = "iron-plate", amount = 4, percent_spoiled = .2},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
ironCastingRecipe.main_product = "iron-plate"
ironCastingRecipe.energy_required = 4

local copperCastingRecipe = data.raw.recipe["casting-copper"]
copperCastingRecipe.ingredients = {
	{type = "fluid", name = "molten-copper", amount = 40},
	{type = "fluid", name = "water", amount = 1},
}
copperCastingRecipe.results = {
	{type = "item", name = "copper-plate", amount = 4},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
copperCastingRecipe.main_product = "copper-plate"
copperCastingRecipe.energy_required = 4

local steelCastingRecipe = data.raw.recipe["casting-steel"]
steelCastingRecipe.ingredients = {
	{type = "fluid", name = "molten-steel", amount = 40},
	{type = "fluid", name = "water", amount = 1},
}
steelCastingRecipe.results = {
	{type = "item", name = "steel-plate", amount = 1},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
steelCastingRecipe.main_product = "steel-plate"
steelCastingRecipe.energy_required = 4

local ironGearWheelCastingRecipe = data.raw.recipe["casting-iron-gear-wheel"]
ironGearWheelCastingRecipe.ingredients = {
	{type = "fluid", name = "molten-iron", amount = 40},
	{type = "fluid", name = "water", amount = 1},
}
ironGearWheelCastingRecipe.results = {
	{type = "item", name = "iron-gear-wheel", amount = 2, percent_spoiled = .2},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
ironGearWheelCastingRecipe.main_product = "iron-gear-wheel"
ironGearWheelCastingRecipe.energy_required = 4

local ironStickCastingRecipe = data.raw.recipe["casting-iron-stick"]
ironStickCastingRecipe.ingredients = {
	{type = "fluid", name = "molten-iron", amount = 40},
	{type = "fluid", name = "water", amount = 1},
}
ironStickCastingRecipe.results = {
	{type = "item", name = "iron-stick", amount = 8, percent_spoiled = .2},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
ironStickCastingRecipe.main_product = "iron-stick"
ironStickCastingRecipe.energy_required = 4
local lowDensityStructureRecipe = data.raw.recipe["casting-low-density-structure"]
-- Originally 5 plastic bar + 80 molten iron + 250 molten copper
lowDensityStructureRecipe.ingredients = {
	{ type = "item",  name = "plastic-bar",   amount = 3 },
	{ type = "item",  name = "resin",         amount = 1 },
	{ type = "fluid", name = "molten-steel",  amount = 80 },
	{ type = "fluid", name = "molten-copper", amount = 200 },
	{ type = "fluid", name = "water",         amount = 3 },
}
lowDensityStructureRecipe.results = {
	{type = "item", name = "low-density-structure", amount = 1},
	{type = "fluid", name = "steam", amount = 30, temperature = 500, ignored_by_productivity=30},
}
lowDensityStructureRecipe.main_product = "low-density-structure"
lowDensityStructureRecipe.energy_required = 12

local copperCableRecipe = data.raw.recipe["casting-copper-cable"]
copperCableRecipe.ingredients = {
	{type = "fluid", name = "molten-copper", amount = 40},
	{type = "fluid", name = "water", amount = 1},
}
copperCableRecipe.results = {
	{type = "item", name = "copper-cable", amount = 8},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
copperCableRecipe.main_product = "copper-cable"
copperCableRecipe.energy_required = 4

local pipeRecipe = data.raw.recipe["casting-pipe"]
pipeRecipe.ingredients = {
	{type = "fluid", name = "molten-iron", amount = 40},
	{type = "fluid", name = "water", amount = 1},
}
pipeRecipe.results = {
	{type = "item", name = "pipe", amount = 4},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
pipeRecipe.subgroup = "vulcanus-processes"
pipeRecipe.main_product = "pipe"
pipeRecipe.energy_required = 4

local pipeToGroundRecipe = data.raw.recipe["casting-pipe-to-ground"]
pipeToGroundRecipe.ingredients = {
	{ type = "item",  name = "pipe",        amount = 10 },
	{ type = "fluid", name = "molten-iron", amount = 50 },
	{ type = "fluid", name = "water",       amount = 1 },
}
pipeToGroundRecipe.results = {
	{type = "item", name = "pipe-to-ground", amount = 2},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
pipeToGroundRecipe.subgroup = "vulcanus-processes"
pipeToGroundRecipe.main_product = "pipe-to-ground"
pipeToGroundRecipe.energy_required = 4

-- Add recipe for casting advanced parts. (Bc can't make ingots from foundries.)
local castingAdvancedPartsRecipe = table.deepcopy(data.raw.recipe["casting-iron-gear-wheel"])
castingAdvancedPartsRecipe.name = "casting-advanced-parts"
castingAdvancedPartsRecipe.ingredients = {
	{ type = "fluid", name = "molten-steel", amount = 160 },
	{ type = "fluid", name = "water",        amount = 4 },
	{ type = "item",  name = "rubber",       amount = 1 },
	{ type = "item",  name = "plastic-bar",  amount = 2 },
	{ type = "fluid", name = "lubricant",    amount = 5 },
}
castingAdvancedPartsRecipe.results = {
	{type = "item", name = "advanced-parts", amount = 4},
	{type = "fluid", name = "steam", amount = 40, temperature = 500, ignored_by_productivity=40},
}
castingAdvancedPartsRecipe.main_product = "advanced-parts"
castingAdvancedPartsRecipe.icon = nil
castingAdvancedPartsRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-3.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={-4, 4}},
	{icon = "__space-age__/graphics/icons/fluid/molten-iron.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={4, -4}},
}
castingAdvancedPartsRecipe.order = "b[casting]-f[casting-advanced-parts]"
castingAdvancedPartsRecipe.energy_required = 16
table.insert(newData, castingAdvancedPartsRecipe)
Tech.addRecipeToTech("casting-advanced-parts", "foundry")

-- Adjust the default tungsten-carbide recipe to be more expensive, to create more incentive for the foundry recipes.
data.raw.recipe["tungsten-carbide"].ingredients = {
	{type = "item", name = "tungsten-ore", amount = 2},
	{type = "item", name = "carbon", amount = 8},
	{type = "fluid", name = "sulfuric-acid", amount = 40},
}
data.raw.recipe["tungsten-carbide"].category = "chemistry"
data.raw.recipe["tungsten-carbide"].energy_required = 8

-- Create molten tungsten fluid.
local moltenTungstenFluid = table.deepcopy(data.raw.fluid["molten-iron"])
moltenTungstenFluid.name = "molten-tungsten"
moltenTungstenFluid.icon = nil
moltenTungstenFluid.icons = {{
	icon = "__LegendarySpaceAge__/graphics/vulcanus/molten-tungsten.png",
	icon_size = 64,
	scale = 0.5,
}}
moltenTungstenFluid.order = "b[new-fluid]-b[vulcanus]-d[molten-tungsten]"
moltenTungstenFluid.base_color = {.259, .239, .349} -- Measured on ore
moltenTungstenFluid.flow_color = {.635, .584, .741}
moltenTungstenFluid.visualization_color = {.478, .191, .682} -- Measured on ore and boosted saturation.
table.insert(newData, moltenTungstenFluid)

-- Create recipe for molten tungsten.
local moltenTungstenRecipe = table.deepcopy(data.raw.recipe["molten-iron"])
moltenTungstenRecipe.name = "molten-tungsten"
moltenTungstenRecipe.ingredients = {
	{type = "item", name = "tungsten-ore", amount = 4},
	{type = "item", name = "carbon", amount = 1},
	{type = "fluid", name = "sulfuric-acid", amount = 10},
}
moltenTungstenRecipe.results = {
	{type = "fluid", name = "molten-tungsten", amount = 40, temperature = 1500},
	{type = "item", name = "stone", amount = 2},
}
moltenTungstenRecipe.main_product = "molten-tungsten"
moltenTungstenRecipe.order = "a[melting]-d[molten-tungsten]"
moltenTungstenRecipe.energy_required = 1
table.insert(newData, moltenTungstenRecipe)
Tech.addRecipeToTech("molten-tungsten", "tungsten-steel", 1)

-- Edit tungsten steel tech's icon, bc I have the nice molten-tungsten icon anyway.
data.raw.technology["tungsten-steel"].icon = nil
data.raw.technology["tungsten-steel"].icons = {
	{icon = "__space-age__/graphics/technology/tungsten-steel.png", icon_size = 256, scale = .6, shift={0, 50}},
	{icon = "__LegendarySpaceAge__/graphics/vulcanus/molten-tungsten-tech.png", icon_size = 256, scale = .6, shift = {0, -50}},
}

-- Make foundry recipes for tungsten carbide and tungsten steel. And recipe for heating molten tungsten.
local tungstenCarbideFromMoltenRecipe = table.deepcopy(data.raw.recipe["tungsten-plate"])
tungstenCarbideFromMoltenRecipe.name = "tungsten-carbide-from-molten"
tungstenCarbideFromMoltenRecipe.ingredients = {
	{type = "fluid", name = "molten-tungsten", amount = 40, minimum_temperature = 1600, maximum_temperature = 1800},
	{type = "item", name = "carbon", amount = 1},
	{type = "fluid", name = "water", amount = 1},
}
tungstenCarbideFromMoltenRecipe.results = {
	{type = "item", name = "tungsten-carbide", amount = 4},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
tungstenCarbideFromMoltenRecipe.main_product = "tungsten-carbide"
tungstenCarbideFromMoltenRecipe.energy_required = 4
tungstenCarbideFromMoltenRecipe.icon = nil
tungstenCarbideFromMoltenRecipe.icons = {
	{icon = "__space-age__/graphics/icons/tungsten-carbide.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={-4, 4}},
	{icon = "__LegendarySpaceAge__/graphics/vulcanus/molten-tungsten.png", icon_size = 64, scale = 0.5, mipmap_count = 4, shift = {4, -4}},
}
table.insert(newData, tungstenCarbideFromMoltenRecipe)
Tech.addRecipeToTech("tungsten-carbide-from-molten", "tungsten-steel")
local tungstenSteelRecipe = table.deepcopy(data.raw.recipe["tungsten-plate"])
tungstenSteelRecipe.name = "tungsten-steel-from-molten"
	-- Again, can't name it "tungsten-steel" or it won't show separately from the item, which is a problem bc you can't see the temperature range requirement.
tungstenSteelRecipe.ingredients = {
	{type = "fluid", name = "molten-tungsten", amount = 40, minimum_temperature = 1800, maximum_temperature = 1900},
	{type = "fluid", name = "molten-steel", amount = 10},
	{type = "fluid", name = "water", amount = 2},
}
tungstenSteelRecipe.results = {
	{type = "item", name = "tungsten-plate", amount = 1},
	{type = "fluid", name = "steam", amount = 20, temperature = 500, ignored_by_productivity=20},
}
tungstenSteelRecipe.main_product = "tungsten-plate"
tungstenSteelRecipe.energy_required = 8
tungstenSteelRecipe.icon = nil
tungstenSteelRecipe.icons = {
	{icon = "__space-age__/graphics/icons/tungsten-plate.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={-4, 4}},
	{icon = "__LegendarySpaceAge__/graphics/vulcanus/molten-tungsten.png", icon_size = 64, scale = 0.5, mipmap_count = 4, shift = {4, -4}},
}
table.insert(newData, tungstenSteelRecipe)
Tech.addRecipeToTech("tungsten-steel-from-molten", "tungsten-steel")
local tungstenHeatingRecipe = table.deepcopy(data.raw.recipe["molten-iron"])
tungstenHeatingRecipe.name = "tungsten-heating"
tungstenHeatingRecipe.ingredients = {
	{type = "fluid", name = "molten-tungsten", amount = 100, ignored_by_stats=100},
}
tungstenHeatingRecipe.results = {
	{type = "fluid", name = "molten-tungsten", amount = 100, temperature = 2000, ignored_by_stats=100, ignored_by_productivity=100},
}
tungstenHeatingRecipe.main_product = "molten-tungsten"
tungstenHeatingRecipe.order = "a[melting]-d[tungsten-heating]"
tungstenHeatingRecipe.energy_required = 1
tungstenHeatingRecipe.icon = nil
tungstenHeatingRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/vulcanus/molten-tungsten-heating.png", icon_size = 64, scale=0.5, mipmap_count=4},
}
tungstenHeatingRecipe.show_amount_in_title = false
tungstenHeatingRecipe.hide_from_stats = true
tungstenHeatingRecipe.allow_productivity = false
tungstenHeatingRecipe.maximum_productivity = 0
table.insert(newData, tungstenHeatingRecipe)
Tech.addRecipeToTech("tungsten-heating", "tungsten-steel")

-- Hide default tungsten-steel recipe.
Recipe.hide("tungsten-plate")
Tech.removeRecipeFromTech("tungsten-plate", "tungsten-steel")

-- TODO Create a recipe for casting stone bricks from cement mix? Or maybe sulfur.

-- Reorder some of the unlocks in the foundry tech.
Tech.removeRecipesFromTechs({"concrete-from-molten-iron", "casting-low-density-structure"}, {"foundry"})
Tech.addRecipeToTech("casting-low-density-structure", "foundry")
-- Foundry concrete recipe will be added to new sulfur concrete tech, in concrete file.

------------------------------------------------------------------------
data:extend(newData)
------------------------------------------------------------------------