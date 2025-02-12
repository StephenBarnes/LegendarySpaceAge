-- This file creates the "wiring" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local wiringItem = copy(ITEM["copper-cable"])
wiringItem.name = "wiring"
wiringItem.icon = "__LegendarySpaceAge__/graphics/intermediate-factors/wiring.png"
wiringItem.subgroup = "wiring"
wiringItem.order = "01"
extend{wiringItem}

-- Make recipe for wiring: 4 copper cable + 1 resin -> 4 wiring
local resinRecipe = copy(RECIPE["copper-cable"])
resinRecipe.name = "wiring-from-resin"
resinRecipe.category = "crafting"
resinRecipe.icon = nil
resinRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/intermediate-factors/wiring.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
resinRecipe.ingredients = {
	{type = "item", name = "copper-cable", amount = 1},
	{type = "item", name = "resin", amount = 1},
}
resinRecipe.results = {{type = "item", name = "wiring", amount = 1}}
resinRecipe.enabled = false
resinRecipe.subgroup = "wiring"
resinRecipe.order = "02"
resinRecipe.energy_required = 5
resinRecipe.allow_as_intermediate = true
extend{resinRecipe}
Tech.addRecipeToTech("wiring-from-resin", "basic-electricity")

-- Create a recipe with rubber insulation: 8 copper cable + 1 rubber -> 8 wiring
local rubberRecipe = copy(resinRecipe)
rubberRecipe.name = "wiring-from-rubber"
rubberRecipe.icons[2] = {icon = "__LegendarySpaceAge__/graphics/rubber/rubber-2.png", icon_size = 64, scale = 0.25, shift = {-8, -8}}
rubberRecipe.ingredients = {
	{type = "item", name = "copper-cable", amount = 10},
	{type = "item", name = "rubber", amount = 1},
}
rubberRecipe.results = {{type = "item", name = "wiring", amount = 10}}
rubberRecipe.order = "03"
rubberRecipe.enabled = false
rubberRecipe.allow_as_intermediate = false
extend{rubberRecipe}
Tech.addRecipeToTech("wiring-from-rubber", "rubber-1")

-- Create a recipe with plastic insulation: 4 copper cable + 1 plastic -> 4 wiring
local plasticRecipe = copy(resinRecipe)
plasticRecipe.name = "wiring-from-plastic"
plasticRecipe.icons[2] = {icon = "__base__/graphics/icons/plastic-bar.png", icon_size = 64, scale = 0.25, shift = {-8, -8}}
plasticRecipe.ingredients = {
	{type = "item", name = "copper-cable", amount = 5},
	{type = "item", name = "plastic-bar", amount = 1},
}
plasticRecipe.results = {{type = "item", name = "wiring", amount = 5}}
plasticRecipe.order = "04"
plasticRecipe.enabled = false
plasticRecipe.allow_as_intermediate = false
extend{plasticRecipe}
Tech.addRecipeToTech("wiring-from-plastic", "plastics")

-- Create a recipe using neurofibrils: 8 neurofibril + 1 rubber -> 8 wiring
local neurofibrilRecipe = copy(resinRecipe)
neurofibrilRecipe.name = "wiring-from-neurofibril"
neurofibrilRecipe.icons[2] = {icon = "__LegendarySpaceAge__/graphics/gleba/stingfronds/neurofibrils/4.png", icon_size = 64, scale = 0.25, shift = {-8, -8}}
neurofibrilRecipe.ingredients = {
	{type = "item", name = "neurofibril", amount = 10},
	{type = "item", name = "rubber", amount = 1},
}
neurofibrilRecipe.results = {{type = "item", name = "wiring", amount = 10}}
neurofibrilRecipe.order = "05"
neurofibrilRecipe.enabled = false
neurofibrilRecipe.allow_as_intermediate = false
extend{neurofibrilRecipe}
-- Will be added to the tech by stingfronds.lua.