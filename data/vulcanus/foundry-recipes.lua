--[[ This file modifies and creates recipes for the foundry. Foundries are used for processing molten metals.
Ratios:
	5 ore = 1 ingot = 1 matte = 5 plates/parts/rods = 10 cables.
	5 iron ingot = 1 steel ingot = 5 steel plates.
	10 molten metal = 1 plate = 1 ore = 1/5 ingot.
Old ratios were:
	1 ore = 10 molten metal = 1 plate (copper and iron)
	30 molten iron = 1 steel plate

General rules for recipe times:
	Recipes for making molten metal (from ore, lava, or other molten metals) deal with 100 molten metal per second.
	Casting recipes deal with 10 molten metal per second, turned into 1 plate per second.
	(All of these get 10x'd by foundry bonus.)

Basic process from lava:
	100 lava + 1 calcite + 1 carbon --1s--> 50 molten iron + 1 copper matte + 1 stone
		(It might be more realistic and easy to have separate iron and copper recipes. But tying them together like this means the player will get too many of one, and have to set up a system to balance them by dumping excess into the lava.)
	Old recipes were:
		1 calcite + 500 lava --4s--> 10 stone + 250 molten iron
		1 calcite + 500 lava --4s--> 15 stone + 250 molten copper
		These were 16s, but foundry has speed 4, so 4s.
Copper matte can be directly turned into molten copper:
	1 copper matte --1s--> 50 molten copper + 1 sulfur

Turning ores into the same metal intermediates, in a foundry (not used on Vulcanus):
	10 iron ore + 1 calcite + 2 carbon --1s--> 100 molten iron + 10 stone
	(Copper ore to matte actually has to be done in a furnace. No foundry recipe, since it's not molten.)
	Old recipes were:
		50 iron ore + 1 calcite --8s--> 500 molten iron
		50 copper ore + 1 calcite --8s--> 500 molten copper
		These were 32s, but foundry has speed 4, so 8s.

Turning molten metals into items, in a foundry:
	10 molten iron + 1 water -> 1 iron plate + 10 steam
	The water ingredient and steam byproduct represent water cooling; this adds substantial fluid management complexity to all of the foundries casting metal items.
	Similar recipes for copper plates, iron rods, iron machine parts, copper cables.
	Casting iron items makes them start 20% spoiled (from rust).

Molten steel recipes:
	100 molten iron + 1 calcite --1s--> 20 molten steel + 1 stone
	10 molten steel + 1 water --1s--> 1 steel plate + 10 steam
			Originally 30 molten iron -> 1 steel plate.

Tungsten recipes:
	You need tungsten carbide to make first foundries and big miners. So there needs to be a recipe to make tungsten carbide without using foundries.
		In chem plant: 2 tungsten ore + 5 carbon + 50 sulfuric acid --10s--> 1 tungsten carbide
		This is very slow and costs a lot of carbon, so there's reason to switch to the more efficient foundry recipes below.
	Making molten tungsten:
		1 carbon + 10 tungsten ore + 10 sulfuric acid --1s--> 100 molten tungsten (1500C) + 1 stone
		This represents acid leaching, high-temperature reduction, and foundry smelting. In gameplay terms, tungsten production is limited by carbon and water (for sulfuric acid), both of which are scarce.
	Then you can heat molten tungsten from 1500C to 2000C in a foundry:
		100 molten tungsten (any temp) --1s--> 100 molten tungsten (2000C)
	Then you use molten tungsten to cast carbide or plate, by mixing specific temperatures:
		20 molten tungsten (1600-1800C) + 1 carbon + 1 water --1s--> 2 tungsten carbide + 10 steam
		50 molten tungsten (1800-1900C) + 10 molten steel + 5 water --5s--> 5 tungsten plate + 50 steam
	There's also a casting recipe for shielding, using molten tungsten in the plate temp range.
	Note temp range of carbide is deliberately made to touch but not overlap with tungsten steel, since it allows more interesting feasible designs. (If they overlap, you can just heat up until both production lines are active. If they're disjoint then you need to build separate fluid systems for carbide vs steel. Touching but not overlapping means both approaches are sorta feasible.)
	Originally tungsten recipes were:
		In assembler only: 2 tungsten ore + 1 carbon + 10 sulfuric acid -> 1 tungsten carbide (1 second)
		In foundry: 4 tungsten ore + 10 molten iron -> 1 tungsten plate (10 seconds)
]]

-- Make recipe for metals-from-lava.
Recipe.make{
	copy = "molten-iron-from-lava",
	recipe = "metals-from-lava",
	ingredients = {
		{"lava", 100},
		{"calcite", 1},
		{"carbon", 1},
	},
	results = {
		{"molten-iron", 50},
		{"copper-matte", 1},
		{"stone", 1},
	},
	icon = "LSA/vulcanus/metals-from-lava",
	enabled = false,
	allow_decomposition = false,
	allow_as_intermediate = true,
	time = 1,
}
Tech.addRecipeToTech("metals-from-lava", "foundry", 3)

-- Hide old recipes for molten metals from lava, remove from tech, add new recipe to tech.
Recipe.hide("molten-iron-from-lava")
Recipe.hide("molten-copper-from-lava")
Tech.removeRecipesFromTechs({"molten-iron-from-lava", "molten-copper-from-lava"}, {"foundry"})
Tech.addRecipeToTech("metals-from-lava", "foundry", 3)

-- Make molten iron use new icon.
Icon.set(FLUID["molten-iron"], "LSA/vulcanus/molten-iron")
Icon.clear(RECIPE["molten-iron"])

-- Edit recipe for copper-ore-to-molten-copper to instead use copper matte.
Recipe.edit{
	recipe = "molten-copper",
	ingredients = {
		{"copper-matte", 1},
	},
	results = {
		{"molten-copper", 50},
		{"sulfur", 1},
	},
	time = 1,
}

-- Edit recipe for iron-ore-to-molten-iron.
Recipe.edit{
	recipe = "molten-iron",
	ingredients = {
		{"iron-ore", 10},
		{"calcite", 1},
		{"carbon", 2},
	},
	results = {
		{"molten-iron", 100},
		{"stone", 10},
	},
	time = 1,
	clearIcon = true, -- So that it uses the icon for the fluid, which I changed above to distinguish from molten steel better.
}

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
Recipe.make{
	copy = "molten-iron",
	recipe = "molten-steel-making",
		-- Not naming it the same as the fluid, so recipe shows up with the rest of them.
		-- Seems the way it works is, recipe can show up in a different subgroup as the fluid if it either has multiple products, or a different name from the fluid.
	ingredients = {
		{"molten-iron", 100},
		{"calcite", 1},
	},
	results = {
		{"molten-steel", 20},
		{"stone", 1},
	},
	time = 1,
	localised_name = {"fluid-name.molten-steel"},
	main_product = "molten-steel",
	order = "a[melting]-d[molten-steel]",
	icon = "LSA/vulcanus/molten-steel",
}
Tech.addRecipeToTech("molten-steel-making", "foundry", 7)

-- Adjust recipes for casting molten metals into items.
-- Balanced so that they have the same molten metal costs, and all of them consume ~20 molten metal and 1 water in 2 seconds.
Recipe.edit{
	recipe = "casting-iron", -- casting iron plate
	ingredients = {
		{"molten-iron", 10},
		{"water", 1},
	},
	results = {
		{"iron-plate", 1, percent_spoiled = .2},
		{"steam", 10, temperature = 500, ignored_by_productivity=10},
	},
	main_product = "iron-plate",
	time = 1,
	icons = {"iron-plate", "molten-iron"},
	iconArrangement = "casting",
}

Recipe.edit{
	recipe = "casting-copper",
	ingredients = {
		{"molten-copper", 10},
		{"water", 1},
	},
	results = {
		{"copper-plate", 1},
		{"steam", 10, temperature = 500, ignored_by_productivity=10},
	},
	main_product = "copper-plate",
	time = 1,
	icons = {"copper-plate", "molten-copper"},
	iconArrangement = "casting",
}

Recipe.edit{
	recipe = "casting-steel",
	ingredients = {
		{"molten-steel", 10},
		{"water", 1},
	},
	results = {
		{"steel-plate", 1},
		{"steam", 10, temperature = 500, ignored_by_productivity=10},
	},
	main_product = "steel-plate",
	time = 1,
	icons = {"steel-plate", "molten-steel"},
	iconArrangement = "casting",
}

Recipe.edit{
	recipe = "casting-iron-gear-wheel",
	ingredients = {
		{"molten-iron", 10},
		{"water", 1},
	},
	results = {
		{"iron-gear-wheel", 1, percent_spoiled = .2},
		{"steam", 10, temperature = 500, ignored_by_productivity=10},
	},
	main_product = "iron-gear-wheel",
	time = 1,
	icons = {"iron-gear-wheel", "molten-iron"},
	iconArrangement = "casting",
}

Recipe.edit{
	recipe = "casting-iron-stick",
	ingredients = {
		{"molten-iron", 10},
		{"water", 1},
	},
	results = {
		{"iron-stick", 1, percent_spoiled = .2},
		{"steam", 10, temperature = 500, ignored_by_productivity=10},
	},
	main_product = "iron-stick",
	time = 1,
	icons = {"iron-stick", "molten-iron"},
	iconArrangement = "casting",
}

Recipe.edit{
	recipe = "casting-low-density-structure",
	ingredients = {
		{"plastic-bar", 3},
		{"resin", 1},
		{"molten-steel", 100},
		{"molten-copper", 250},
		{"water", 10},
	},
	results = {
		{"low-density-structure", 1},
		{"steam", 100, temperature = 500, ignored_by_productivity=100},
	},
	main_product = "low-density-structure",
	time = 10,
	icons = {"low-density-structure", "molten-copper", "molten-steel"},
	iconArrangement = "casting",
}

Recipe.edit{
	recipe = "casting-copper-cable",
	ingredients = {
		{"molten-copper", 10},
		{"water", 1},
	},
	results = {
		{"copper-cable", 2},
		{"steam", 10, temperature = 500, ignored_by_productivity=10},
	},
	main_product = "copper-cable",
	time = 1,
	icons = {"copper-cable", "molten-copper"},
	iconArrangement = "casting",
}

-- Hide recipes for casting pipes and pipe-to-ground.
for _, recipe in pairs{"casting-pipe", "casting-pipe-to-ground"} do
	Recipe.hide(recipe)
	Tech.removeRecipeFromTech(recipe, "foundry")
end

-- Add recipe for casting advanced parts. (Bc can't make ingots from foundries.)
Recipe.make{
	copy = "casting-iron-gear-wheel",
	recipe = "casting-advanced-parts",
	ingredients = {
		{"molten-steel", 250},
		{"water", 25},
		{"rubber", 1},
		{"plastic-bar", 2},
	},
	results = {
		{"advanced-parts", 20},
		{"steam", 250, temperature = 500, ignored_by_productivity=250},
	},
	main_product = "advanced-parts",
	time = 10,
	icons = {"advanced-parts", "molten-steel"},
	iconArrangement = "casting",
	order = "b[casting]-f[casting-advanced-parts]",
}
Tech.addRecipeToTech("casting-advanced-parts", "foundry")

-- Adjust the default tungsten-carbide recipe to be more expensive, to create more incentive for the foundry recipes.
Recipe.edit{
	recipe = "tungsten-carbide",
	ingredients = {
		{"tungsten-ore", 2},
		{"carbon", 5},
		{"sulfuric-acid", 50},
	},
	resultCount = 1,
	category = "chemistry",
	time = 10,
}

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
Recipe.make{
	copy = "molten-iron",
	recipe = "molten-tungsten",
	ingredients = {
		{"tungsten-ore", 10},
		{"carbon", 1},
		{"sulfuric-acid", 10},
	},
	results = {
		{"molten-tungsten", 100, temperature = 1500},
		{"stone", 1},
	},
	main_product = "molten-tungsten",
	order = "a[melting]-d[molten-tungsten]",
	time = 1,
	clearIcons = true,
}
Tech.addRecipeToTech("molten-tungsten", "tungsten-steel", 1)

-- Make foundry recipes for tungsten carbide and tungsten steel. And recipe for heating molten tungsten.
Recipe.make{
	copy = "tungsten-plate",
	recipe = "tungsten-carbide-from-molten",
	ingredients = {
		{"molten-tungsten", 20, minimum_temperature = 1600, maximum_temperature = 1800},
		{"carbon", 1},
		{"water", 1},
	},
	results = {
		{"tungsten-carbide", 2},
		{"steam", 10, temperature = 500, ignored_by_productivity=10},
	},
	main_product = "tungsten-carbide",
	time = 1,
	icons = {"tungsten-carbide", "molten-tungsten"},
	iconArrangement = "casting",
}
Tech.addRecipeToTech("tungsten-carbide-from-molten", "tungsten-steel")
Recipe.make{
	copy = "tungsten-plate",
	recipe = "tungsten-steel-from-molten",
		-- Again, can't name it "tungsten-steel" or it won't show separately from the item, which is a problem bc you can't see the temperature range requirement.
	ingredients = {
		{"molten-tungsten", 50, minimum_temperature = 1800, maximum_temperature = 1900},
		{"molten-steel", 10},
		{"water", 5},
	},
	results = {
		{"tungsten-plate", 5},
		{"steam", 50, temperature = 500, ignored_by_productivity=50},
	},
	main_product = "tungsten-plate",
	time = 5,
	icons = {"tungsten-plate", "molten-tungsten"},
	iconArrangement = "casting",
}
Tech.addRecipeToTech("tungsten-steel-from-molten", "tungsten-steel")

-- Create recipe for heating molten tungsten.
Recipe.make{
	copy = "molten-iron",
	recipe = "tungsten-heating",
	ingredients = {
		{"molten-tungsten", 100, ignored_by_stats=100},
	},
	results = {
		{"molten-tungsten", 100, temperature = 2000, ignored_by_stats=100, ignored_by_productivity=100},
	},
	main_product = "molten-tungsten",
	order = "a[melting]-d[tungsten-heating]",
	time = 1,
	icon = "LSA/vulcanus/molten-tungsten-heating",
	show_amount_in_title = false,
	hide_from_stats = true,
	allow_productivity = false,
	allow_quality = false,
}
Tech.addRecipeToTech("tungsten-heating", "tungsten-steel")

-- Hide default tungsten-steel recipe.
Recipe.hide("tungsten-plate")
Tech.removeRecipeFromTech("tungsten-plate", "tungsten-steel")

-- TODO Create a recipe for casting stone bricks from cement mix? Or maybe sulfur.

-- Reorder some of the unlocks in the foundry tech.
Tech.removeRecipesFromTechs({"concrete-from-molten-iron", "casting-low-density-structure"}, {"foundry"})
Tech.addRecipeToTech("casting-low-density-structure", "foundry")
-- Foundry concrete recipe will be added to new sulfur concrete tech, in concrete file.