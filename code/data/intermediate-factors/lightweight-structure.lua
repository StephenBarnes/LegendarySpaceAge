-- This file will add recipes for low-density structures (which we rename to "Lightweight structure").

-- Move item and recipes into the subgroup.
data.raw.item["low-density-structure"].subgroup = "lightweight-structure"
data.raw.recipe["low-density-structure"].subgroup = "lightweight-structure"
data.raw.recipe["low-density-structure"].order = "02"
data.raw.recipe["low-density-structure"].auto_recycle = false
data.raw.recipe["casting-low-density-structure"].subgroup = "lightweight-structure"
data.raw.recipe["casting-low-density-structure"].order = "03"

-- Reduce weight of low-density structure.
data.raw.item["low-density-structure"].weight = 500

-- Create recipe from copper and steel, copying the default recipe.
local recipeFromCopper = table.deepcopy(data.raw.recipe["low-density-structure"])
recipeFromCopper.name = "low-density-structure-standard"
recipeFromCopper.ingredients = {
	{type="item", name="ingot-copper-hot", amount=5},
	{type="item", name="ingot-steel-hot", amount=2},
	{type="item", name="plastic-bar", amount=3},
	{type="item", name="resin", amount=1},
}
recipeFromCopper.allow_as_intermediate = true
recipeFromCopper.icon = nil
recipeFromCopper.icons = {
	{icon = "__base__/graphics/icons/low-density-structure.png", icon_size = 64},
}
for _, icon in pairs(data.raw.item["ingot-copper-hot"].icons) do
	local iconCopy = table.deepcopy(icon)
	iconCopy.scale = 0.25
	iconCopy.shift = {-8, -8}
	table.insert(recipeFromCopper.icons, iconCopy)
end
data:extend{recipeFromCopper}

-- Hide default recipe.
data.raw.recipe["low-density-structure"].hidden = true
data.raw.recipe["low-density-structure"].hidden_in_factoriopedia = true

-- Create a new recipe for LDS from carbon fiber.
local recipeFromCarbonFiber = table.deepcopy(recipeFromCopper)
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
	{icon = "__space-age__/graphics/icons/carbon-fiber.png", icon_size = 64, scale=0.25, mipmap_count=4, shift={-8, -8}},
}
data:extend{recipeFromCarbonFiber}

-- TODO create new recipes for lightweight-structure.