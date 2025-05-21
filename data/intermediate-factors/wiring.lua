-- This file creates the "wiring" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local wiringItem = copy(ITEM["copper-cable"])
wiringItem.name = "wiring"
Icon.set(wiringItem, "LSA/intermediate-factors/wiring")
extend{wiringItem}

-- Make recipe for wiring: 2 copper cable + 1 resin ---5s---> 2 wiring
local resinRecipe = copy(RECIPE["copper-cable"])
resinRecipe.name = "wiring-from-resin"
resinRecipe.category = "crafting"
Icon.set(resinRecipe, {"wiring", "resin"})
resinRecipe.ingredients = {
	{type = "item", name = "copper-cable", amount = 5},
	{type = "item", name = "resin", amount = 1},
}
resinRecipe.results = {{type = "item", name = "wiring", amount = 5}}
resinRecipe.main_product = "wiring"
resinRecipe.enabled = false
resinRecipe.energy_required = 5
resinRecipe.allow_as_intermediate = false
resinRecipe.auto_recycle = false
extend{resinRecipe}
Tech.addRecipeToTech("wiring-from-resin", "basic-electricity")

-- Make recipe for makeshift wiring: 1 copper cable -> 1 wiring.
local makeshiftWiringRecipe = Recipe.make{
	copy = resinRecipe,
	recipe = "makeshift-wiring",
	ingredients = {"copper-cable"},
	results = {"wiring"},
	main_product = "wiring",
	enabled = false,
	allow_as_intermediate = true,
	allow_decomposition = false,
	auto_recycle = false, -- otherwise you can turn neurofibrils into copper cable.
	icons = {"wiring", "LSA/misc/makeshift"},
	category = "handcrafting-only",
	time = 0.5,
}
Tech.addRecipeToTech("makeshift-wiring", "basic-electricity")

-- Create a recipe with rubber insulation: 5 copper cable + 1 rubber ---2s---> 5 wiring
local rubberRecipe = copy(resinRecipe)
rubberRecipe.name = "wiring-from-rubber"
Icon.set(rubberRecipe, {"wiring", "rubber"})
rubberRecipe.ingredients = {
	{type = "item", name = "copper-cable", amount = 5},
	{type = "item", name = "rubber", amount = 2},
}
rubberRecipe.results = {{type = "item", name = "wiring", amount = 5}}
rubberRecipe.enabled = false
rubberRecipe.allow_as_intermediate = false
rubberRecipe.energy_required = 2
extend{rubberRecipe}
Tech.addRecipeToTech("wiring-from-rubber", "rubber-1")

-- Create a recipe with plastic insulation: 10 copper cable + 1 plastic ---5s---> 10 wiring
local plasticRecipe = copy(resinRecipe)
plasticRecipe.name = "wiring-from-plastic"
Icon.set(plasticRecipe, {"wiring", "plastic-bar"})
plasticRecipe.ingredients = {
	{type = "item", name = "copper-cable", amount = 10},
	{type = "item", name = "plastic-bar", amount = 1},
}
plasticRecipe.results = {{type = "item", name = "wiring", amount = 10}}
plasticRecipe.enabled = false
plasticRecipe.allow_as_intermediate = false
plasticRecipe.energy_required = 5
extend{plasticRecipe}
Tech.addRecipeToTech("wiring-from-plastic", "plastics")

-- Create a recipe using neurofibrils: 8 neurofibril + 1 rubber -> 8 wiring
local neurofibrilRecipe = copy(resinRecipe)
neurofibrilRecipe.name = "wiring-from-neurofibril"
Icon.set(neurofibrilRecipe, {"wiring", "LSA/gleba/stingfronds/neurofibrils/4"})
neurofibrilRecipe.ingredients = {
	{type = "item", name = "neurofibril", amount = 10},
	{type = "item", name = "rubber", amount = 1},
}
neurofibrilRecipe.results = {{type = "item", name = "wiring", amount = 10}}
neurofibrilRecipe.enabled = false
neurofibrilRecipe.allow_as_intermediate = false
extend{neurofibrilRecipe}
-- Will be added to the tech by stingfronds.lua.