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
	10 molten iron + 1 water -> 1 iron plate + 10 steam
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
]]

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
Tech.removeRecipeFromTech("casting-low-density-structure", "foundry")
Tech.addRecipeToTech("casting-low-density-structure", "foundry-2")

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

-- Hide default tungsten-steel recipe.
Recipe.hide("tungsten-plate")
Tech.removeRecipeFromTech("tungsten-plate", "tungsten-steel")

-- Remove default concrete recipe.
Recipe.hide("concrete-from-molten-iron")
Tech.removeRecipeFromTech("concrete-from-molten-iron", "foundry")

-- Adjust stats of foundry.
local foundry = ASSEMBLER["foundry"]
foundry.crafting_speed = 1 -- Instead of 4, set it to base 1, since it doesn't share recipes with anything else anyway.
foundry.effect_receiver.base_effect = nil -- Remove base productivity bonus.
	-- Considered giving it a starting -50% prod. But negative productivity doesn't actually work, gets coerced to 0.
foundry.energy_source.emissions_per_minute = { pollution = 10 }
foundry.energy_source.drain = "200kW"
foundry.energy_usage = "800kW"