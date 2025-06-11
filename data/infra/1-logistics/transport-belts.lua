--[[ Entity and item properties:
* Standardize stack sizes and weights.
* Make speeds 10 -- 20 -- 50 -- 100.
	Originally they were 15--30--45--60.
	Changing because I want to simplify the mental math, e.g. 7.5/s per side or 22.5/s per side is annoying.
	And I want both the items/sec/belt and the items/sec/side to be simple numbers that conform to the existing 1-2-5-10 system of round numbers.
	Also easier if you can just merge 2 yellows onto 1 red, etc. Though I'm breaking that with red-blue where the ratio is instead 2.5:1.
	Also I think it's nice to make green belts even faster.

Adjust recipes:
* Remove the nesting in the recipes (each tier ingredient to the next), and change to factor intermediates.
* Make them more expensive per throughput (as in vanilla), and increase in complexity.
* Remove them from foundry. Rather reserve foundries for bulk molten metal stuff (producting molten metals, and casting them).
* Allow handcrafting undergrounds/splitters from belts by hand anywhere, so no fluid ingredients or surface restrictions.
* For underground belts, remove nesting and simplify recipes: just the number of belts, plus panels.
* For splitter, same thing - remove nesting, simplify recipes, make them hand-craftable. For ingredients, require 2 belts of that tier, plus sensor and mechanism. Nothing else, rather put it into the transport belt recipes.

TODO: compare all these recipes to base-game, and number per belt.

TODO edit max healths of belts/undergrounds/splitters, they're very high and vary seemingly randomly.

TODO: currently the animation of the yellow belts moves a bit faster than items on the belt. Not sure why.
]]
for _, vals in pairs{
	{
		prefix = "",
		speed = 10,
		producedPerRecipe = 10,
		ingredients = {
			--[[ Base game is 1 iron plate + 1 gear for 2 belts, so 1.5 iron plate per belt.
			Changing it to 10 belts from 10 panel + 1 mechanism = 10 iron plate + 5 machine parts + 1 frame = 10 + 5 + 10 iron plates, so 25. So it comes out to 2.5 iron plate per belt. ]]
			{type="item", name="panel", amount=10},
			{type="item", name="mechanism", amount=1},
		},
		time = 5,
		animationSpeedCoefficient = 30, -- Originally 32.
	},
	{
		prefix = "fast-",
		speed = 20,
		producedPerRecipe = 2,
		ingredients = {
			{type="item", name="mechanism", amount=1},
			{type="item", name="rubber", amount=1},
		},
		time = 1,
		animationSpeedCoefficient = 30, -- Originally 32.
	},
	{
		prefix = "express-",
		speed = 50,
		producedPerRecipe = 2,
		ingredients = {
			{type="item", name="electric-engine-unit", amount=1},
			{type="item", name="rubber", amount=1},
		},
		time = 1,
		animationSpeedCoefficient = 31, -- Originally 32.
	},
	{
		prefix = "turbo-",
		speed = 100,
		producedPerRecipe = 1,
		ingredients = {
			{type="item", name="electric-engine-unit", amount=1},
			{type="item", name="tungsten-plate", amount=2},
		},
		time = 1,
		animationSpeedCoefficient = 32, -- Originally 32.
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

	-- Adjust animation speed, otherwise the belts move a bit faster than items on the belt.
	-- I have no idea why the specific values in the table above work. Base game + DLC has them all at coefficient 32, and that seems to work with base-game belt speeds, but when speeds are changed the belt looks like it's moving too fast underneath the items.
	beltEnt.animation_speed_coefficient = vals.animationSpeedCoefficient

	-- Set stack sizes and weights.
	beltItem.stack_size = 200
	Item.perRocket(beltItem, 400)
	undergroundItem.stack_size = 100
	Item.perRocket(undergroundItem, 100)
	splitterItem.stack_size = 50
	Item.perRocket(splitterItem, 100)

	-- Set belt recipes.
	beltRecipe.ingredients = vals.ingredients
	beltRecipe.results = {{type="item", name=beltName, amount=vals.producedPerRecipe}}
	beltRecipe.category = "crafting"
	beltRecipe.allow_decomposition = true
	beltRecipe.allow_as_intermediate = true
	beltRecipe.energy_required = vals.time

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