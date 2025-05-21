--[[ This file creates the recipes for the arc furnace. Arc furnaces are used for making molten metals from lava or ore, or turning one molten metal into another. They're NOT used for casting molten metals into solid items, which is done in the foundry.

As a general rule, all recipes produce 100 molten metal per 10 seconds, so 10/s molten metal. Then the apprentice bonus gives 10x speed and 2x prod, so it's 200/s molten metal from 10x inputs.

Recipes:
	Molten metals from lava: 200 lava + 1 calcite + 1 carbon + 10 oxygen --10s--> 50 molten iron + 50 molten copper + 5 stone
		Produces 50 of each molten metal in 10s, so 5/s, which becomes 100/s with apprentice bonuses.
		(It might be more realistic and easy to have separate iron and copper recipes. But tying them together like this means the player will get too many of one, and have to set up a system to balance them by dumping excess into the lava.)
		This consumes 200 lava per 10s, so 20/s, which increases to 400/s with the apprentice bonus. One pump supplies 1000/s. So it's fine, unless you have a ton of speed modules on the arc furnace. There's no way to make offshore pumps (including the lava pump) benefit from beacons.
		Old recipes were:
			1 calcite + 500 lava --4s--> 10 stone + 250 molten iron
			1 calcite + 500 lava --4s--> 15 stone + 250 molten copper
			These were 16s, but foundry has speed 4, so 4s.
	Turning ores into molten metals, not used on Vulcanus:
		10 iron ore   + 1 calcite + 5 carbon + 10 oxygen --10s--> 100 molten iron + 10 stone
		10 copper ore + 1 calcite + 5 carbon + 10 oxygen --10s--> 100 molten copper + 10 stone + 10 sulfur
			Note this doesn't use copper matte. Copper matte is only involved with old normal-furnace smelting, which is realistic.
		Old recipes were:
			50 iron ore + 1 calcite --8s--> 500 molten iron
			50 copper ore + 1 calcite --8s--> 500 molten copper
			These were 32s, but foundry has speed 4, so 8s.
	Molten steel:
		200 molten iron + 1 calcite + 10 oxygen gas --10s--> 50 molten steel + 1 stone
	Making molten tungsten:
		10 tungsten ore + 1 carbon + 10 oxygen gas + 10 hydrogen gas --10s--> 100 molten tungsten (1500C) + 5 stone
	Then you can heat molten tungsten from 1500C to 2000C in a arc furnace.
		100 molten tungsten (any temp) --1s--> 100 molten tungsten (2000C)

Thinking about times and energies.
	* Advanced (steel) furnace uses 200kW to turn 5 iron ore into 1 ingot in 5s, so 1MJ. Then that turns into 5 plates in 2.5s using 250kW so 0.625MJ. Total energy is 325 kJ per iron ore or iron plate. Total time is 1.5s/plate.
	* Using arc furnace, with no apprentice bonus, you turn 10 iron ore into 100 molten iron in 10s at 5MW. Then foundry turns that into 10 iron plates in 1s at 1MW. Total energy is 50MJ + 1MJ = 5.1MJ/plate. Total time is 11s for 10 plates so 1.1s/plate. So it uses much more energy per plate than original recipe, though it's a bit faster.
	* Using arc furnace with apprentice bonus, you turn 10 iron ore into 200 molten iron in 1s at 5MW. Then foundry turns that 200 molten iron into 20 iron plates in 2s at 1MW. Total energy is 7MJ for 20 plates, so 350kJ/plate. Total time is 3s, or 0.15s per plate. So it's much faster, and uses roughly the same energy per plate as the old method, though requires half the iron ore.
]]

-- Create recipe category.
extend{{
	name = "arc-furnace",
	type = "recipe-category",
}}

-- Rename fluid recipes, so fluids go in fluids tab and recipes for making them go in different tabs.
Recipe.renameRecipe("molten-iron", "make-molten-iron", "fluid")
Recipe.renameRecipe("molten-copper", "make-molten-copper", "fluid")
Tech.replaceRecipeInTech("molten-iron", "make-molten-iron", "foundry")
Tech.replaceRecipeInTech("molten-copper", "make-molten-copper", "foundry")

-- Make recipe for metals-from-lava.
Recipe.make{
	copy = "molten-iron-from-lava",
	recipe = "metals-from-lava",
	category = "arc-furnace",
	ingredients = {
		{"lava", 200},
		{"calcite", 1},
		{"carbon", 1},
		{"oxygen-gas", 10, type="fluid"},
	},
	results = {
		{"molten-iron", 50},
		{"molten-copper", 50},
		{"stone", 5},
	},
	icon = "LSA/vulcanus/metals-from-lava",
	enabled = false,
	allow_decomposition = false,
	allow_as_intermediate = true,
	time = 10,
}
Tech.addRecipeToTech("metals-from-lava", "foundry", 3)

-- Hide old recipes for molten metals from lava, remove from tech, add new recipe to tech.
Recipe.hide("molten-iron-from-lava")
Recipe.hide("molten-copper-from-lava")
Tech.removeRecipesFromTechs({"molten-iron-from-lava", "molten-copper-from-lava"}, {"foundry"})

-- Make molten iron use new icon.
Icon.set(FLUID["molten-iron"], "LSA/vulcanus/molten-iron")
Icon.clear(RECIPE["make-molten-iron"])

-- Edit recipe for copper-ore-to-molten-copper.
Recipe.edit{
	recipe = "make-molten-copper",
	category = "arc-furnace",
	ingredients = {
		{"copper-ore", 10},
		{"calcite", 1},
		{"carbon", 5},
		{"oxygen-gas", 10, type="fluid"},
	},
	results = {
		{"molten-copper", 100},
		{"stone", 10},
		{"sulfur", 10},
	},
	time = 10,
}

-- Edit recipe for iron-ore-to-molten-iron.
Recipe.edit{
	recipe = "make-molten-iron",
	category = "arc-furnace",
	ingredients = {
		{"iron-ore", 10},
		{"calcite", 1},
		{"carbon", 5},
		{"oxygen-gas", 10, type="fluid"},
	},
	results = {
		{"molten-iron", 100},
		{"stone", 10},
	},
	time = 10,
	clearIcons = true, -- So that it uses the icon for the fluid, which I changed above to distinguish from molten steel better.
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
	copy = "make-molten-iron",
	recipe = "make-molten-steel",
	category = "arc-furnace",
	ingredients = {
		{"molten-iron", 200},
		{"calcite", 1},
		{"oxygen-gas", 10, type="fluid"},
	},
	results = {
		{"molten-steel", 50},
		{"stone", 1},
	},
	time = 10,
	localised_name = {"fluid-name.molten-steel"},
	main_product = "molten-steel",
	order = "a[melting]-d[molten-steel]",
	icon = "LSA/vulcanus/molten-steel",
	addToTech = "foundry",
	addToTechIndex = 7,
}

-- Create molten tungsten fluid.
local moltenTungstenFluid = copy(FLUID["molten-iron"])
moltenTungstenFluid.name = "molten-tungsten"
Icon.set(moltenTungstenFluid, "LSA/vulcanus/molten-tungsten")
moltenTungstenFluid.order = "b[new-fluid]-b[vulcanus]-d[molten-tungsten]"
moltenTungstenFluid.base_color = {.259, .239, .349} -- Measured on ore
moltenTungstenFluid.flow_color = {.635, .584, .741}
moltenTungstenFluid.visualization_color = {.478, .191, .682} -- Measured on ore and boosted saturation.
moltenTungstenFluid.heat_capacity = nil
extend{moltenTungstenFluid}

-- Create recipe for molten tungsten.
Recipe.make{
	copy = "make-molten-iron",
	recipe = "make-molten-tungsten",
	category = "arc-furnace",
	ingredients = {
		{"tungsten-ore", 10},
		{"carbon", 1},
		{"oxygen-gas", 10, type="fluid"},
		{"hydrogen-gas", 10, type="fluid"},
	},
	results = {
		{"molten-tungsten", 100, temperature = 1500},
		{"stone", 5},
	},
	main_product = "molten-tungsten",
	order = "a[melting]-d[molten-tungsten]",
	time = 10,
	clearIcons = true,
}
Tech.addRecipeToTech("make-molten-tungsten", "tungsten-steel", 1)


-- Create recipe for heating molten tungsten.
Recipe.make{
	copy = "make-molten-iron",
	recipe = "tungsten-heating",
	category = "arc-furnace",
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

-- Change the science pack to be made in arc furnace, using lava.
Recipe.edit{
	recipe = "metallurgic-science-pack",
	ingredients = {
		{"tungsten-plate", 1},
		{"tungsten-carbide", 1},
		{"lava", 20},
	},
	results = {
		{"metallurgic-science-pack", 1},
	},
	clearSurfaceConditions = true, -- Remove surface condition for the science pack. But there's no lava anywhere else. TODO add recipe for artificial lava maybe?
	category = "arc-furnace",
}