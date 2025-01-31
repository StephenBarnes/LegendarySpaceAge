-- This file creates the "fluid fitting" intermediate, and its multiple recipes. See main.lua in this folder for more info.

-- Create item.
local fluidFittingPics = {}
for i = 1, 7 do
	table.insert(fluidFittingPics, {filename = "__LegendarySpaceAge__/graphics/intermediate-factors/fluid-fitting/"..i..".png", size = 64, scale = 0.5, mipmap_count = 4})
end
local mainIcon = fluidFittingPics[1].filename
local fluidFitting = table.deepcopy(data.raw.item["plastic-bar"])
fluidFitting.name = "fluid-fitting"
fluidFitting.subgroup = "fluid-fitting"
fluidFitting.order = "01"
fluidFitting.pictures = fluidFittingPics
fluidFitting.icon = nil
fluidFitting.icons = {{icon = mainIcon, icon_size = 64, scale = 0.5}}
data:extend{fluidFitting}

-- Create recipe: 2 copper plates + 2 resin -> 1 fluid fitting
local recipeFromCopper = table.deepcopy(data.raw.recipe["iron-stick"])
recipeFromCopper.name = "fluid-fitting-from-copper"
recipeFromCopper.ingredients = {
	{type = "item", name = "copper-plate", amount = 2},
	{type = "item", name = "resin", amount = 2}
}
recipeFromCopper.results = {{type = "item", name = "fluid-fitting", amount = 1}}
recipeFromCopper.enabled = true
recipeFromCopper.subgroup = "fluid-fitting"
recipeFromCopper.order = "02"
recipeFromCopper.energy_required = 6
recipeFromCopper.icon = nil
recipeFromCopper.icons = {
	{icon = mainIcon, icon_size = 64, scale = 0.5},
	{icon = "__base__/graphics/icons/copper-plate.png", icon_size = 64, scale = 0.2, shift = {-8, -8}},
	{icon = "__LegendarySpaceAge__/graphics/resin/resin-1.png", icon_size = 64, scale = 0.2, shift = {8, -8}},
}
data:extend{recipeFromCopper}

-- TODO make more recipes, and add them to techs.