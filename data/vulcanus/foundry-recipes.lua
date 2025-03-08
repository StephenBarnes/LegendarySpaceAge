--[[ This file modifies and creates recipes for the foundry. Foundries are used for casting molten metals into solid items. They're NOT used for making molten metals, that's been moved to the arc furnace.
Ratios:
	5 ore = 1 ingot = 1 matte = 5 plates/parts/rods = 10 cables.
	5 iron ingot = 1 steel ingot = 5 steel plates.
	10 molten metal = 1 plate = 1 ore = 1/5 ingot.
Old ratios were:
	1 ore = 10 molten metal = 1 plate (copper and iron)
	30 molten iron = 1 steel plate

Recipe times: Casting recipes deal with 100 molten metal per second, turned into 10 plate per second.

Turning molten metals into items, in a foundry:
	100 molten iron + 1 water -> 10 iron plate + 10 steam
	The water ingredient and steam byproduct represent water cooling; this adds substantial fluid management complexity to all of the foundries casting metal items.
	Similar recipes for copper plates, iron rods, iron machine parts, copper cables.
	Casting iron items makes them start 20% spoiled (from rust).
	Casting steel:
		10 molten steel + 1 water --1s--> 1 steel plate + 10 steam
		Originally 30 molten iron -> 1 steel plate.

Tungsten recipes:
	You need tungsten carbide to make first foundries and big miners. So there needs to be a recipe to make tungsten carbide without using foundries.
		In chem plant: 2 tungsten ore + 5 carbon + 50 sulfuric acid --10s--> 1 tungsten carbide
		This is very slow and costs a lot of carbon, so there's reason to switch to the more efficient foundry recipes below.
	Making and heating molten tungsten - see arc furnace file.
	Then you use molten tungsten to cast carbide or plate, by mixing specific temperatures:
		20 molten tungsten (1600-1800C) + 1 carbon + 1 water --1s--> 2 tungsten carbide + 10 steam
		50 molten tungsten (1800-1900C) + 10 molten steel + 5 water --5s--> 5 tungsten plate + 50 steam
	There's also a casting recipe for shielding, using molten tungsten in the plate temp range.
	Note temp range of carbide is deliberately made to touch but not overlap with tungsten steel, since it allows more interesting feasible designs. (If they overlap, you can just heat up until both production lines are active. If they're disjoint then you need to build separate fluid systems for carbide vs steel. Touching but not overlapping means both approaches are sorta feasible.)
	Originally tungsten recipes were:
		In assembler only: 2 tungsten ore + 1 carbon + 10 sulfuric acid -> 1 tungsten carbide (1 second)
		In foundry: 4 tungsten ore + 10 molten iron -> 1 tungsten plate (10 seconds)

Re avoiding infinite energy from the steam:
	First, it requires ore or lava, so inherently limited.
		Lava giving unlimited water->steam is intentional, not as issue. Only concerned with other planets using ore to get molten metals and steam.
	You can turn 10 iron/copper ore into 100 molten, with +100% prod from arc furnace, and +300% prod from modules, so total +400% prod for 500 molten iron.
		This costs 5 carbon = 5 MJ and at least 1.8MW for like 1 second (assuming speed bonuses too).
		Ignore the potential speed bonuses etc, just assume you can do it instantly and for free.
		Gives you 50x the recipe to cast iron plates, so 5 steam at 500C.
		That 5 steam in a turbine lasts 1 second, generates 2MW, so ~2MJ.
			Although that also costs water. If you use condensing turbine, it's 1MJ.
		So, the carbon alone is enough to make it not infinite energy.
]]

-- Re fluidbox indexes, we don't need to assign anything explicitly, since we want some output fluids to take multiple fluidboxes.

-- Adjust recipes for casting molten metals into items.
-- Balanced so that they have the same molten metal costs, and all of them consume ~20 molten metal and 1 water in 2 seconds.
Recipe.edit{
	recipe = "casting-iron", -- casting iron plate
	ingredients = {
		{"molten-iron", 100},
		{"water", 1},
	},
	results = {
		{"iron-plate", 10, percent_spoiled = .2},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
	},
	main_product = "iron-plate",
	time = 1,
	icons = {"iron-plate", "molten-iron"},
	iconArrangement = "casting",
}

Recipe.edit{
	recipe = "casting-copper",
	ingredients = {
		{"molten-copper", 100},
		{"water", 1},
	},
	results = {
		{"copper-plate", 10},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
	},
	main_product = "copper-plate",
	time = 1,
	icons = {"copper-plate", "molten-copper"},
	iconArrangement = "casting",
}

Recipe.edit{
	recipe = "casting-steel",
	ingredients = {
		{"molten-steel", 100},
		{"water", 1},
	},
	results = {
		{"steel-plate", 10},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
	},
	main_product = "steel-plate",
	time = 1,
	icons = {"steel-plate", "molten-steel"},
	iconArrangement = "casting",
}

-- Add recipe for casting bricks from lava.
Recipe.make{
	copy = "casting-steel",
	recipe = "casting-brick",
	ingredients = {
		{"lava", 100},
		{"water", 1},
	},
	results = {
		{"stone-brick", 10},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
	},
	main_product = "stone-brick",
	time = 1,
	icons = {"stone-brick", "LSA/vulcanus/lava-cast"},
	iconArrangement = "casting",
	addToTech = "foundry-2",
}

Recipe.edit{
	recipe = "casting-iron-gear-wheel",
	ingredients = {
		{"molten-iron", 100},
		{"water", 1},
	},
	results = {
		{"iron-gear-wheel", 10, percent_spoiled = .2},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
	},
	main_product = "iron-gear-wheel",
	time = 1,
	icons = {"iron-gear-wheel", "molten-iron"},
	iconArrangement = "casting",
}

Recipe.edit{
	recipe = "casting-iron-stick",
	ingredients = {
		{"molten-iron", 100},
		{"water", 1},
	},
	results = {
		{"iron-stick", 10, percent_spoiled = .2},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
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
		{"water", 1},
	},
	results = {
		{"low-density-structure", 1},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
	},
	main_product = "low-density-structure",
	time = 1,
	icons = {"low-density-structure", "molten-copper", "molten-steel"},
	iconArrangement = "casting",
}
Tech.removeRecipeFromTech("casting-low-density-structure", "foundry")
Tech.addRecipeToTech("casting-low-density-structure", "foundry-2")

Recipe.edit{
	recipe = "casting-copper-cable",
	ingredients = {
		{"molten-copper", 100},
		{"water", 1},
	},
	results = {
		{"copper-cable", 20},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
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
		{"molten-steel", 100},
		{"water", 1},
		{"rubber", 1},
		{"plastic-bar", 1},
	},
	results = {
		{"advanced-parts", 10},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
	},
	main_product = "advanced-parts",
	time = 1,
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

-- Make foundry recipes for tungsten carbide and tungsten steel. And recipe for heating molten tungsten.
Recipe.make{
	copy = "tungsten-plate",
	recipe = "tungsten-carbide-from-molten",
	ingredients = {
		{"molten-tungsten", 100, minimum_temperature = 1600, maximum_temperature = 1800},
		{"carbon", 1},
		{"water", 1},
	},
	results = {
		{"tungsten-carbide", 10},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
	},
	main_product = "tungsten-carbide",
	time = 1,
	icons = {"tungsten-carbide", "molten-tungsten"},
	iconArrangement = "casting",
	addToTech = "tungsten-steel",
}

Recipe.make{
	copy = "tungsten-plate",
	recipe = "tungsten-steel-from-molten",
		-- Again, can't name it "tungsten-steel" or it won't show separately from the item, which is a problem bc you can't see the temperature range requirement.
	ingredients = {
		{"molten-tungsten", 100, minimum_temperature = 1800, maximum_temperature = 1900},
		{"molten-steel", 20},
		{"water", 1},
	},
	results = {
		{"tungsten-plate", 10},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
	},
	main_product = "tungsten-plate",
	time = 1,
	icons = {"tungsten-plate", "molten-tungsten"},
	iconArrangement = "casting",
	addToTech = "tungsten-steel",
}

-- Hide default tungsten-steel recipe.
Recipe.hide("tungsten-plate")
Tech.removeRecipeFromTech("tungsten-plate", "tungsten-steel")

-- Forbid holmium plates in foundry. Doesn't really give any benefit since foundries no longer have a prod bonus.
RECIPE["holmium-plate"].category = "crafting-with-fluid"

-- Create sulfur concrete recipes.
Recipe.make{
	copy = "concrete-from-molten-iron",
	recipe = "sulfur-concrete",
	ingredients = {
		{"sulfur", 10},
		{"sand", 10},
		{"molten-iron", 50},
		{"water", 1},
	},
	results = {
		{"concrete", 10},
		{"steam", 1, temperature = 500, ignored_by_productivity=1},
	},
	icons = {"concrete", "LSA/vulcanus/sulfur-cast"},
	iconArrangement = "casting",
	time = 1,
}
Recipe.make{
	copy = "concrete-from-molten-iron",
	recipe = "sulfur-refined-concrete",
	ingredients = {
		{"sulfur", 10},
		{"sand", 10},
		{"resin", 1},
		{"molten-steel", 50, type="fluid"},
		{"water", 2},
	},
	results = {
		{"refined-concrete", 10},
		{"steam", 2, temperature = 500, ignored_by_productivity=2},
	},
	icons = {"refined-concrete", "LSA/vulcanus/sulfur-cast"},
	iconArrangement = "casting",
	time = 2,
}

-- Remove default concrete recipe.
Recipe.hide("concrete-from-molten-iron")
Tech.removeRecipeFromTech("concrete-from-molten-iron", "foundry")

-- Create sulfur concrete tech.
local sulfurConcreteTech = copy(TECH["concrete"])
sulfurConcreteTech.name = "sulfur-concrete"
sulfurConcreteTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "sulfur-concrete",
	},
	{
		type = "unlock-recipe",
		recipe = "sulfur-refined-concrete",
	},
}
sulfurConcreteTech.prerequisites = {
	"foundry-2",
}
sulfurConcreteTech.icon = nil
sulfurConcreteTech.icons = {
	{icon = "__base__/graphics/technology/concrete.png", icon_size = 256, scale = 1},
	{icon = "__base__/graphics/technology/sulfur-processing.png", icon_size = 256, scale = 0.7, shift = {0, -40}},
}
sulfurConcreteTech.unit = {
	count = 250,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
	},
}
extend{sulfurConcreteTech}