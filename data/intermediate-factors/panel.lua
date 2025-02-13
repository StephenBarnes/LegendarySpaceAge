-- This file creates the "panel" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local panelItem = copy(ITEM["steel-plate"])
panelItem.name = "panel"
panelItem.subgroup = "panel"
Icon.set(panelItem, "LSA/intermediate-factors/panel/panel")
extend{panelItem}

-- Create recipe: 1 iron plate -> 1 panel
local recipeFromIron = copy(RECIPE["iron-stick"])
recipeFromIron.name = "panel-from-iron"
recipeFromIron.ingredients = {
	{type = "item", name = "iron-plate", amount = 1},
}
recipeFromIron.results = {{type = "item", name = "panel", amount = 1}}
recipeFromIron.enabled = true
recipeFromIron.subgroup = "panel"
recipeFromIron.energy_required = 0.25
recipeFromIron.category = "crafting"
recipeFromIron.icon = nil
Icon.set(recipeFromIron, {"LSA/intermediate-factors/panel/iron-panel", "iron-plate"})
recipeFromIron.allow_as_intermediate = true
extend{recipeFromIron}

-- Create recipe: 1 copper plate -> 1 panel
local recipeFromCopper = copy(recipeFromIron)
recipeFromCopper.name = "panel-from-copper"
recipeFromCopper.ingredients = {
	{type = "item", name = "copper-plate", amount = 1},
}
recipeFromCopper.allow_as_intermediate = false
Icon.set(recipeFromCopper, {"LSA/intermediate-factors/panel/copper-panel", "copper-plate"})
recipeFromCopper.allow_as_intermediate = false
extend{recipeFromCopper}

-- Create recipe: 1 wood + 1 resin -> 1 panel
local recipeFromWood = copy(recipeFromIron)
recipeFromWood.name = "panel-from-wood"
recipeFromWood.ingredients = {
	{type = "item", name = "wood", amount = 1},
	{type = "item", name = "resin", amount = 1},
}
recipeFromWood.allow_as_intermediate = false
Icon.set(recipeFromWood, {"LSA/intermediate-factors/panel/wooden-panel", "wood"})
extend{recipeFromWood}

-- Create recipe: 1 glass -> 1 panel
local recipeFromGlass = copy(recipeFromIron)
recipeFromGlass.name = "panel-from-glass"
recipeFromGlass.ingredients = {{type = "item", name = "glass", amount = 2}}
recipeFromGlass.allow_as_intermediate = false
recipeFromGlass.enabled = false
Icon.set(recipeFromGlass, {"panel", "glass"})
-- TODO get custom glass-panel icon.
extend{recipeFromGlass}

-- TODO make more recipes, and add them to techs.
-- TODO create casting recipes?

Gen.order({
	panelItem,
	recipeFromWood,
	recipeFromGlass,
	recipeFromIron,
	recipeFromCopper,
})