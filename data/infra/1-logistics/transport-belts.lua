--[[ Entity and item properties:
* Make speeds 10 -- 20 -- 40 -- 80. Originally 15--30--45--60. Because I want to simplify the mental math, e.g. 7.5/s per side or 22.5/s per side is annoying. Also easier if you can just merge 2 yellows onto 1 red, etc.
* Standardize stack sizes and weights.

Adjust recipes:
* Remove the nesting in the recipes (each tier ingredient to the next), and change to factor intermediates.
* Make them more expensive per throughput (as in vanilla), and increase in complexity.
* Remove them from foundry. Rather reserve foundries for bulk metal production.
* For underground belts, remove nesting and simplify recipes: just the number of belts, plus panels. So you can even craft them by hand, and eg turn green belts into green undergrounds off-Vulcanus.
* For splitter, same thing - remove nesting, simplify recipes, make them hand-craftable. For ingredients, require 2 belts of that tier, plus sensor and mechanism. Nothing else, rather put it into the transport belt recipes.

TODO: compare all these recipes to base-game, and number per belt.

TODO edit max healths of belts/undergrounds/splitters, they're very high and vary seemingly randomly.
]]
for _, vals in pairs{
	{
		prefix = "",
		speed = 10,
		producedPerRecipe = 4,
		ingredients = {
			--[[ Base game is 1 iron plate + 1 gear for 2 belts, so 1.5 iron plate per belt.
			Changing it to 1 panel + 1 mechanism = 1 iron plate + 8 machine parts + 1 frame = 1 + 1 + 4 iron plates, so 6. So doubling amount produced to 4 belts. ]]
			{type="item", name="panel", amount=1},
			{type="item", name="mechanism", amount=1},
		},
	},
	{
		prefix = "fast-",
		speed = 20,
		producedPerRecipe = 2,
		ingredients = {
			{type="item", name="mechanism", amount=1},
			{type="item", name="rubber", amount=1},
		},
	},
	{
		prefix = "express-",
		speed = 40,
		producedPerRecipe = 2,
		ingredients = {
			{type="item", name="electric-engine-unit", amount=1},
			{type="item", name="rubber", amount=1},
		},
	},
	{
		prefix = "turbo-",
		speed = 80,
		producedPerRecipe = 1,
		ingredients = {
			{type="item", name="electric-engine-unit", amount=1},
			{type="item", name="tungsten-plate", amount=2},
		},
	},
} do
	local beltName = vals.prefix .. "transport-belt"
	local undergroundName = vals.prefix .. "underground-belt"
	local splitterName = vals.prefix .. "splitter"

	local beltEnt = RAW["transport-belt"][beltName]
	local undergroundEnt = RAW["underground-belt"][undergroundName]
	local splitterEnt = RAW["splitter"][splitterName]

	local beltItem = ITEM[beltName]
	local undergroundItem = ITEM[undergroundName]
	local splitterItem = ITEM[splitterName]

	local beltRecipe = RECIPE[beltName]
	local undergroundRecipe = RECIPE[undergroundName]
	local splitterRecipe = RECIPE[splitterName]

	-- Set speeds.
	for _, ent in pairs{beltEnt, undergroundEnt, splitterEnt} do
		ent.speed = vals.speed / (60 * 8)
	end

	-- Set stack sizes and weights.
	beltItem.stack_size = 200
	beltItem.weight = ROCKET / 400
	undergroundItem.stack_size = 100
	undergroundItem.weight = ROCKET / 200
	splitterItem.stack_size = 50
	splitterItem.weight = ROCKET / 100

	-- Set belt recipes.
	beltRecipe.ingredients = vals.ingredients
	beltRecipe.results = {{type="item", name=beltName, amount=vals.producedPerRecipe}}
	beltRecipe.category = "crafting"
	beltRecipe.allow_decomposition = true
	beltRecipe.allow_as_intermediate = true
	beltRecipe.energy_required = 0.5

	-- Set underground recipes.
	undergroundRecipe.ingredients = {
		{type="item", name=beltName, amount=undergroundEnt.max_distance + 1}, -- TODO check 
		{type="item", name="panel", amount=2},
	}
	undergroundRecipe.results = {{type="item", name=undergroundName, amount=2}}
	undergroundRecipe.category = "crafting"
	undergroundRecipe.allow_decomposition = true
	undergroundRecipe.allow_as_intermediate = true
	undergroundRecipe.energy_required = 1

	-- Set splitter recipes.
	splitterRecipe.ingredients = {
		{type="item", name=beltName, amount=2},
		{type="item", name="mechanism", amount=1},
		{type="item", name="sensor", amount=1},
	}
	splitterRecipe.results = {{type="item", name=splitterName, amount=1}}
	splitterRecipe.category = "crafting"
	splitterRecipe.allow_decomposition = true
	splitterRecipe.allow_as_intermediate = true
	splitterRecipe.energy_required = 2
end