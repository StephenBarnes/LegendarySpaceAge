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
	100 molten iron + 1 calcite -> 100 molten steel + 1 stone (in a foundry)
	40 molten steel + 1 water -> 2 steel plate + 10 steam
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

-- Make recipe for metals-from-lava.
local metalsFromLavaRecipe = copy(RECIPE["molten-iron-from-lava"])
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
Icon.set(metalsFromLavaRecipe, "LSA/vulcanus/metals-from-lava")
extend{metalsFromLavaRecipe}

-- Hide old recipes for molten metals from lava, remove from tech, add new recipe to tech.
Recipe.hide("molten-iron-from-lava")
Recipe.hide("molten-copper-from-lava")
Tech.removeRecipesFromTechs({"molten-iron-from-lava", "molten-copper-from-lava"}, {"foundry"})
Tech.addRecipeToTech("metals-from-lava", "foundry", 3)

-- Edit recipe for copper-ore-to-molten-copper to instead use copper matte.
local matteMeltRecipe = RECIPE["molten-copper"]
matteMeltRecipe.ingredients = {{type = "item", name = "copper-matte", amount = 25}}
matteMeltRecipe.results = {
	{type = "fluid", name = "molten-copper", amount = 500},
	{type = "item", name = "sulfur", amount = 10},
}

-- Edit recipe for iron-ore-to-molten-iron.
local ironOreMeltRecipe = RECIPE["molten-iron"]
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
Icon.set("molten-iron", "LSA/vulcanus/molten-iron")

-- Make molten steel fluid.
local moltenSteelFluid = copy(FLUID["molten-iron"])
moltenSteelFluid.name = "molten-steel"
Icon.set(moltenSteelFluid, "LSA/vulcanus/molten-steel")
moltenSteelFluid.order = "b[new-fluid]-b[vulcanus]-c[molten-steel]"
moltenSteelFluid.base_color = {.3, .4, .4}
moltenSteelFluid.flow_color = {.5, .7, .7}
moltenSteelFluid.visualization_color = {.2, 1, 1} -- Cyan for the diagram-like lines drawn on pipes.
extend{moltenSteelFluid}

-- Make recipe for molten steel.
local moltenSteelRecipe = copy(RECIPE["molten-iron"])
moltenSteelRecipe.name = "molten-steel-making"
	-- Not naming it the same as the fluid, so recipe shows up with the rest of them.
	-- Seems the way it works is, recipe can show up in a different subgroup as the fluid if it either has multiple products, or a different name from the fluid.
moltenSteelRecipe.localised_name = {"fluid-name.molten-steel"}
moltenSteelRecipe.ingredients = {
	{type = "fluid", name = "molten-iron", amount = 100},
	{type = "item", name = "calcite", amount = 1},
}
moltenSteelRecipe.results = {
	{type = "fluid", name = "molten-steel", amount = 100},
	{type = "item", name = "stone", amount = 1},
}
moltenSteelRecipe.main_product = "molten-steel"
moltenSteelRecipe.order = "a[melting]-d[molten-steel]"
extend{moltenSteelRecipe}
Tech.addRecipeToTech("molten-steel-making", "foundry", 8)

-- Adjust recipes for casting molten metals into items.
-- Balanced so that they have the same molten metal costs, and all of them consume ~40/s molten metal and 1/s water. Note 40 molten metal is equivalent to 1 ingot. Foundry has speed 4.
-- In base Space Age they do 30 molten iron -> 1 steel plate. But we're using the extra step of molten iron -> molten steel, with the +50% prod bonus, so let's not also do 30->1.
local ironCastingRecipe = RECIPE["casting-iron"]
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

local copperCastingRecipe = RECIPE["casting-copper"]
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

local steelCastingRecipe = RECIPE["casting-steel"]
steelCastingRecipe.ingredients = {
	{type = "fluid", name = "molten-steel", amount = 40},
	{type = "fluid", name = "water", amount = 1},
}
steelCastingRecipe.results = {
	{type = "item", name = "steel-plate", amount = 2},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
steelCastingRecipe.main_product = "steel-plate"
steelCastingRecipe.energy_required = 4

local ironGearWheelCastingRecipe = RECIPE["casting-iron-gear-wheel"]
ironGearWheelCastingRecipe.ingredients = {
	{type = "fluid", name = "molten-iron", amount = 40},
	{type = "fluid", name = "water", amount = 1},
}
ironGearWheelCastingRecipe.results = {
	{type = "item", name = "iron-gear-wheel", amount = 4, percent_spoiled = .2},
	{type = "fluid", name = "steam", amount = 10, temperature = 500, ignored_by_productivity=10},
}
ironGearWheelCastingRecipe.main_product = "iron-gear-wheel"
ironGearWheelCastingRecipe.energy_required = 4

local ironStickCastingRecipe = RECIPE["casting-iron-stick"]
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
local lowDensityStructureRecipe = RECIPE["casting-low-density-structure"]
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

local copperCableRecipe = RECIPE["casting-copper-cable"]
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

-- Hide recipes for casting pipes and pipe-to-ground.
for _, recipe in pairs{"casting-pipe", "casting-pipe-to-ground"} do
	Recipe.hide(recipe)
	Tech.removeRecipeFromTech(recipe, "foundry")
end

-- Add recipe for casting advanced parts. (Bc can't make ingots from foundries.)
local castingAdvancedPartsRecipe = copy(RECIPE["casting-iron-gear-wheel"])
castingAdvancedPartsRecipe.name = "casting-advanced-parts"
castingAdvancedPartsRecipe.ingredients = {
	{ type = "fluid", name = "molten-steel", amount = 300 },
	{ type = "fluid", name = "water",        amount = 4 },
	{ type = "item",  name = "rubber",       amount = 1 },
	{ type = "item",  name = "plastic-bar",  amount = 2 },
}
castingAdvancedPartsRecipe.results = {
	{type = "item", name = "advanced-parts", amount = 4},
	{type = "fluid", name = "steam", amount = 40, temperature = 500, ignored_by_productivity=40},
}
castingAdvancedPartsRecipe.main_product = "advanced-parts"
Icon.set(castingAdvancedPartsRecipe, {"advanced-parts", "molten-iron"}, "casting")
castingAdvancedPartsRecipe.order = "b[casting]-f[casting-advanced-parts]"
castingAdvancedPartsRecipe.energy_required = 16
extend{castingAdvancedPartsRecipe}
Tech.addRecipeToTech("casting-advanced-parts", "foundry")

-- Adjust the default tungsten-carbide recipe to be more expensive, to create more incentive for the foundry recipes.
RECIPE["tungsten-carbide"].ingredients = {
	{type = "item", name = "tungsten-ore", amount = 2},
	{type = "item", name = "carbon", amount = 8},
	{type = "fluid", name = "sulfuric-acid", amount = 40},
}
RECIPE["tungsten-carbide"].category = "chemistry"
RECIPE["tungsten-carbide"].energy_required = 8

-- Create molten tungsten fluid.
local moltenTungstenFluid = copy(FLUID["molten-iron"])
moltenTungstenFluid.name = "molten-tungsten"
Icon.set(moltenTungstenFluid, "LSA/vulcanus/molten-tungsten")
moltenTungstenFluid.order = "b[new-fluid]-b[vulcanus]-d[molten-tungsten]"
moltenTungstenFluid.base_color = {.259, .239, .349} -- Measured on ore
moltenTungstenFluid.flow_color = {.635, .584, .741}
moltenTungstenFluid.visualization_color = {.478, .191, .682} -- Measured on ore and boosted saturation.
extend{moltenTungstenFluid}

-- Create recipe for molten tungsten.
local moltenTungstenRecipe = copy(RECIPE["molten-iron"])
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
moltenTungstenRecipe.icon = nil
extend{moltenTungstenRecipe}
Tech.addRecipeToTech("molten-tungsten", "tungsten-steel", 1)

-- Make foundry recipes for tungsten carbide and tungsten steel. And recipe for heating molten tungsten.
local tungstenCarbideFromMoltenRecipe = copy(RECIPE["tungsten-plate"])
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
Icon.set(tungstenCarbideFromMoltenRecipe, {"tungsten-carbide", "molten-tungsten"}, "casting")
extend{tungstenCarbideFromMoltenRecipe}
Tech.addRecipeToTech("tungsten-carbide-from-molten", "tungsten-steel")
local tungstenSteelRecipe = copy(RECIPE["tungsten-plate"])
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
Icon.set(tungstenSteelRecipe, {"tungsten-plate", "molten-tungsten"}, "casting")
extend{tungstenSteelRecipe}
Tech.addRecipeToTech("tungsten-steel-from-molten", "tungsten-steel")
local tungstenHeatingRecipe = copy(RECIPE["molten-iron"])
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
Icon.set(tungstenHeatingRecipe, "LSA/vulcanus/molten-tungsten-heating")
tungstenHeatingRecipe.show_amount_in_title = false
tungstenHeatingRecipe.hide_from_stats = true
tungstenHeatingRecipe.allow_productivity = false
tungstenHeatingRecipe.maximum_productivity = 0
extend{tungstenHeatingRecipe}
Tech.addRecipeToTech("tungsten-heating", "tungsten-steel")

-- Hide default tungsten-steel recipe.
Recipe.hide("tungsten-plate")
Tech.removeRecipeFromTech("tungsten-plate", "tungsten-steel")

-- TODO Create a recipe for casting stone bricks from cement mix? Or maybe sulfur.

-- Reorder some of the unlocks in the foundry tech.
Tech.removeRecipesFromTechs({"concrete-from-molten-iron", "casting-low-density-structure"}, {"foundry"})
Tech.addRecipeToTech("casting-low-density-structure", "foundry")
-- Foundry concrete recipe will be added to new sulfur concrete tech, in concrete file.