-- This modpack renames "iron gear wheels" to "machine parts"; this file changes sprites to match that.
-- Then this file also creates "advanced parts", which are made from like hot steel + rubber + plastic + bit of lubricant, and will generally replace steel plates in recipes for infra.

-- Update icons for iron parts.
Icon.set("iron-gear-wheel", "LSA/parts-basic/plain/pair-item")
Icon.variants("iron-gear-wheel", "LSA/parts-basic/plain/%", 5)
ITEM["iron-gear-wheel"].has_random_tint = true
ITEM["iron-gear-wheel"].random_tint_color = ITEM["iron-plate"].random_tint_color

-- Create advanced parts item.
local advancedPartsItem = copy(ITEM["iron-gear-wheel"])
advancedPartsItem.name = "advanced-parts"
Icon.variants(advancedPartsItem, "LSA/parts-advanced/%", 5)
Icon.set(advancedPartsItem, "LSA/parts-advanced/3")
advancedPartsItem.has_random_tint = true
advancedPartsItem.random_tint_color = {r = .955, g = .96, b = 1.0, a=1}
advancedPartsItem.spoil_ticks = nil
advancedPartsItem.order = "7"
extend{advancedPartsItem}

-- Create recipe for advanced parts.
local advancedPartsRecipe = copy(RECIPE["iron-gear-wheel"])
advancedPartsRecipe.name = "advanced-parts"
advancedPartsRecipe.ingredients = {
	{type="item", name="ingot-steel-hot", amount=5},
	{type="item", name="plastic-bar", amount=1},
	{type="item", name="rubber", amount=1},
	{type="item", name="resin", amount=1},
	-- No lubricant here. Rather add lubricant in the recipe for gadgets.
}
advancedPartsRecipe.results = {{type="item", name="advanced-parts", amount=20}}
advancedPartsRecipe.category = "crafting"
advancedPartsRecipe.energy_required = 10
advancedPartsRecipe.allow_decomposition = true
advancedPartsRecipe.allow_as_intermediate = true
advancedPartsRecipe.enabled = false
extend{advancedPartsRecipe}

-- Add advanced parts recipe to actuator tech.
Tech.addRecipeToTech("advanced-parts", "electric-engine")