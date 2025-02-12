-- This file will add recipes for low-density structures (which we rename to "Lightweight structure").

-- Move item and recipes into the subgroup.
ITEM["low-density-structure"].subgroup = "lightweight-structure"
RECIPE["low-density-structure"].subgroup = "lightweight-structure"
RECIPE["low-density-structure"].order = "02"
RECIPE["low-density-structure"].auto_recycle = false
RECIPE["casting-low-density-structure"].subgroup = "lightweight-structure"
RECIPE["casting-low-density-structure"].order = "03"

-- Reduce weight of low-density structure.
ITEM["low-density-structure"].weight = 500

-- Create recipe from copper and steel, copying the default recipe.
local recipeFromCopper = copy(RECIPE["low-density-structure"])
recipeFromCopper.name = "low-density-structure-standard"
recipeFromCopper.ingredients = {
	{type="item", name="ingot-copper-hot", amount=5},
	{type="item", name="ingot-steel-hot", amount=2},
	{type="item", name="plastic-bar", amount=3},
	{type="item", name="resin", amount=1},
}
recipeFromCopper.allow_as_intermediate = true
recipeFromCopper.hide_from_player_crafting = false
recipeFromCopper.icon = nil
recipeFromCopper.icons = {
	{icon = "__base__/graphics/icons/low-density-structure.png", icon_size = 64},
}
for _, icon in pairs(ITEM["ingot-copper-hot"].icons) do
	local iconCopy = copy(icon)
	iconCopy.scale = 0.25
	iconCopy.shift = {-8, -8}
	table.insert(recipeFromCopper.icons, iconCopy)
end
extend{recipeFromCopper}
Tech.addRecipeToTech("low-density-structure-standard", "low-density-structure")

-- Hide default recipe.
RECIPE["low-density-structure"].hidden = true
RECIPE["low-density-structure"].hidden_in_factoriopedia = true

-- Create a new recipe for LDS from carbon fiber.
local recipeFromCarbonFiber = copy(recipeFromCopper)
recipeFromCarbonFiber.name = "lds-from-carbon-fiber"
recipeFromCarbonFiber.ingredients = {
	{type = "item", name = "carbon-fiber", amount = 1},
	{type = "fluid", name = "chitin-broth", amount = 40},
	{type = "item", name = "slipstack-pearl", amount = 1},
	{type = "item", name = "resin", amount = 1},
}
recipeFromCarbonFiber.results = {
	{type = "item", name = "low-density-structure", amount = 1},
}
recipeFromCarbonFiber.order = "04"
recipeFromCarbonFiber.enabled = false
recipeFromCarbonFiber.allow_as_intermediate = false
recipeFromCarbonFiber.category = "organic"
recipeFromCarbonFiber.subgroup = "lightweight-structure"
recipeFromCarbonFiber.icon = nil
recipeFromCarbonFiber.icons = {
	{icon = "__base__/graphics/icons/low-density-structure.png", icon_size = 64},
	{icon = "__LegendarySpaceAge__/graphics/gleba/chitin-broth.png", icon_size = 64, scale=0.25, mipmap_count=4, shift={-8, -8}},
	{icon = "__space-age__/graphics/icons/carbon-fiber.png", icon_size = 64, scale=0.25, mipmap_count=4, shift={8, -8}},
}
extend{recipeFromCarbonFiber}

-- TODO create new recipes for lightweight-structure.