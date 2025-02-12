-- This modpack renames "iron gear wheels" to "machine parts"; this file changes sprites to match that.
-- Then this file also creates "advanced parts", which are made from like hot steel + rubber + plastic + bit of lubricant, and will generally replace steel plates in recipes for infra.

local Tech = require("code.util.tech")

-- Update icons for iron parts.
data.raw.item["iron-gear-wheel"].icon = nil
data.raw.item["iron-gear-wheel"].icons = {
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-2.png", icon_size = 64, scale=0.4, mipmap_count=4, shift={-3, 3}},
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/plain/spring-2.png", icon_size = 64, scale=0.4, mipmap_count=4, shift={3, -4}},
}
data.raw.item["iron-gear-wheel"].pictures = {
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-1.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-2.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-3.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/plain/spring-1.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/plain/spring-2.png", size = 64, scale = 0.5, mipmap_count = 4},
}
data.raw.item["iron-gear-wheel"].has_random_tint = true
data.raw.item["iron-gear-wheel"].random_tint_color = data.raw.item["iron-plate"].random_tint_color

-- Update icon for casting recipe.
data.raw.recipe["casting-iron-gear-wheel"].icon = nil
data.raw.recipe["casting-iron-gear-wheel"].icons = {
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-2.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={-4, 4}},
	{icon = "__space-age__/graphics/icons/fluid/molten-iron.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={4, -4}},
}

-- Create advanced parts item.
local advancedPartsItem = table.deepcopy(data.raw.item["iron-gear-wheel"])
advancedPartsItem.name = "advanced-parts"
advancedPartsItem.icons = {
	--[[
	{icon = "__LegendarySpaceAge__/graphics/parts-advanced/flange-1.png", icon_size = 64, scale=0.2, mipmap_count=4, shift={-6, 4}},
	{icon = "__LegendarySpaceAge__/graphics/parts-advanced/gasket.png", icon_size = 64, scale=0.2, mipmap_count=4, shift={6, 4}},
	{icon = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-1.png", icon_size = 64, scale=0.3, mipmap_count=4, shift={0, -6}},
	]]
	{icon = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-3.png", icon_size = 64, scale=0.5, mipmap_count=4},
}
advancedPartsItem.pictures = {
	{filename = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-1.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-2.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-2.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-3.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-3.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-advanced/flange-1.png", size = 64, scale = 0.36, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-advanced/flange-2.png", size = 64, scale = 0.36, mipmap_count = 4},
	--{filename = "__LegendarySpaceAge__/graphics/parts-advanced/gasket.png", size = 64, scale = 0.36, mipmap_count = 4},
}
advancedPartsItem.has_random_tint = true
advancedPartsItem.random_tint_color = {r = .955, g = .96, b = 1.0, a=1}
advancedPartsItem.spoil_ticks = nil
advancedPartsItem.order = "7"
data:extend{advancedPartsItem}

-- Create recipe for advanced parts.
local advancedPartsRecipe = table.deepcopy(data.raw.recipe["iron-gear-wheel"])
advancedPartsRecipe.name = "advanced-parts"
advancedPartsRecipe.ingredients = {
	{type="item", name="ingot-steel-hot", amount=5},
	{type="item", name="plastic-bar", amount=1},
	{type="item", name="rubber", amount=1},
	{type="item", name="resin", amount=1},
	-- No lubricant here. Rather add lubricant in the recipe for gadgets.
}
advancedPartsRecipe.results = {{type="item", name="advanced-parts", amount=20}}
advancedPartsRecipe.main_product = "advanced-parts"
advancedPartsRecipe.category = "crafting"
advancedPartsRecipe.energy_required = 5
advancedPartsRecipe.allow_decomposition = true
advancedPartsRecipe.allow_as_intermediate = true
advancedPartsRecipe.enabled = false
data:extend{advancedPartsRecipe}

-- Add advanced parts recipe to actuator tech.
Tech.addRecipeToTech("advanced-parts", "electric-engine")