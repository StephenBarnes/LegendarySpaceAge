-- This file adds early ammonia tech and recipes, and later ammonia using syngas.

local Tech = require("code.util.tech")

-- Create ammonia 1 tech, for ammonia from spoilage and spoilage from wood.
local ammonia1Tech = table.deepcopy(data.raw.technology["logistics"])
ammonia1Tech.name = "ammonia-1"
ammonia1Tech.localised_name = {"technology-name.ammonia-1"}
ammonia1Tech.localised_description = {"technology-description.ammonia-1"}
ammonia1Tech.prerequisites = {"filtration-lake-water"}
ammonia1Tech.icon = nil
ammonia1Tech.icons = {{icon = "__LegendarySpaceAge__/graphics/ammonia/tech.png", icon_size = 256}}
ammonia1Tech.effects = {
	{type = "unlock-recipe", recipe = "ammonia-from-wood"},
	{type = "unlock-recipe", recipe = "niter"},
}
data:extend{ammonia1Tech}

-- Create ammonia 2 tech, for ammonia from syngas.
local ammonia2Tech = table.deepcopy(data.raw.technology["coal-liquefaction"])
ammonia2Tech.name = "ammonia-2"
ammonia2Tech.localised_name = {"technology-name.ammonia-2"}
ammonia2Tech.localised_description = {"technology-description.ammonia-2"}
ammonia2Tech.prerequisites = {"ammonia-1", "chemical-science-pack"}
ammonia2Tech.icon = nil
ammonia2Tech.icons = {{icon = "__LegendarySpaceAge__/graphics/ammonia/tech.png", icon_size = 256}}
ammonia2Tech.effects = {
	{type = "unlock-recipe", recipe = "ammonia-from-syngas"},
}
ammonia2Tech.unit = {
	count = 1000,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
	},
}
data:extend{ammonia2Tech}

-- Create recipe for ammonia from wood
local ammoniaFromWood = table.deepcopy(data.raw.recipe["nutrients-from-spoilage"])
ammoniaFromWood.name = "ammonia-from-wood"
ammoniaFromWood.ingredients = {
	{type = "item", name = "wood", amount = 5},
	{type = "fluid", name = "water", amount = 20},
}
ammoniaFromWood.results = {
	{type = "fluid", name = "ammonia", amount = 10},
}
ammoniaFromWood.show_amount_in_title = false
ammoniaFromWood.category = "organic-or-chemistry"
ammoniaFromWood.subgroup = "early-agriculture"
ammoniaFromWood.order = "d2"
ammoniaFromWood.energy_required = 60
ammoniaFromWood.icons = {
	{icon = "__space-age__/graphics/icons/fluid/ammonia.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {4, 4}},
	{icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale = 0.3, mipmap_count = 4, shift = {-6, -6}},
}
data:extend{ammoniaFromWood}

-- Create recipe for ammonia from spoilage.
local ammoniaFromSpoilage = table.deepcopy(ammoniaFromWood)
ammoniaFromSpoilage.name = "ammonia-from-spoilage"
ammoniaFromSpoilage.ingredients = {
	{type = "item", name = "spoilage", amount = 5},
	{type = "fluid", name = "water", amount = 20},
}
ammoniaFromSpoilage.order = "d3"
ammoniaFromSpoilage.energy_required = 30
ammoniaFromSpoilage.icons = {
	{icon = "__space-age__/graphics/icons/fluid/ammonia.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {4, 4}},
	{icon = "__space-age__/graphics/icons/spoilage.png", icon_size = 64, scale = 0.3, mipmap_count = 4, shift = {-6, -6}},
}
data:extend{ammoniaFromSpoilage}
-- Will be unlocked by boompuff-cultivation tech.

-- Create recipe for spoilage from wood.
--[[ TODO not sure we want this recipe, at this stage. Increases the number of recipes and gives a way to fuel biochambers without imports from Gleba.
local woodSpoilageRecipe = table.deepcopy(data.raw.recipe["nutrients-from-spoilage"])
woodSpoilageRecipe.name = "spoilage-from-wood"
woodSpoilageRecipe.ingredients = {
	{type = "item", name = "wood", amount = 5},
	{type = "fluid", name = "water", amount = 20},
}
woodSpoilageRecipe.results = {
	{type = "item", name = "spoilage", amount = 5},
}
woodSpoilageRecipe.category = "organic-or-chemistry"
woodSpoilageRecipe.subgroup = "early-agriculture"
woodSpoilageRecipe.order = "d1"
woodSpoilageRecipe.energy_required = 30
woodSpoilageRecipe.icons = {
	{icon = "__space-age__/graphics/icons/spoilage.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {4, 4}},
	{icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale = 0.3, mipmap_count = 4, shift = {-6, -6}},
}
data:extend{woodSpoilageRecipe}
]]

-- Create recipe for niter from ammonia and sand.
local niterFromAmmoniaRecipe = table.deepcopy(data.raw.recipe["plastic-bar"])
niterFromAmmoniaRecipe.name = "niter"
niterFromAmmoniaRecipe.ingredients = {
	{type = "fluid", name = "ammonia", amount = 5},
	{type = "item", name = "sand", amount = 4},
}
niterFromAmmoniaRecipe.results = {
	{type = "item", name = "niter", amount = 8},
}
niterFromAmmoniaRecipe.icon = nil
niterFromAmmoniaRecipe.icons = nil
niterFromAmmoniaRecipe.energy_required = 1
data:extend{niterFromAmmoniaRecipe}

-- Create recipe for ammonia from syngas.
local ammoniaSyngasRecipe = table.deepcopy(data.raw.recipe["plastic-bar"])
ammoniaSyngasRecipe.name = "ammonia-from-syngas"
ammoniaSyngasRecipe.ingredients = {
	{type = "fluid", name = "syngas", amount = 100},
	{type = "fluid", name = "steam", amount = 100},
}
ammoniaSyngasRecipe.results = {
	{type = "fluid", name = "ammonia", amount = 100},
}
ammoniaSyngasRecipe.show_amount_in_title = false
ammoniaSyngasRecipe.category = "chemistry-or-cryogenics"
ammoniaSyngasRecipe.subgroup = "complex-fluid-recipes"
ammoniaSyngasRecipe.order = "d1"
ammoniaSyngasRecipe.icons = {
	{icon = "__space-age__/graphics/icons/fluid/ammonia.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {4, 4}},
	{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=require("code.data.petrochem.constants").syngasColor, scale = 0.3, mipmap_count = 4, shift = {-6, -6}},
}
ammoniaSyngasRecipe.energy_required = 4
data:extend{ammoniaSyngasRecipe}

-- Aquilo should require ammonia 2 tech? Not really. Maybe if I later add tech to make fuel from ammonia, separate from the Aquilo discovery tech. TODO.
--Tech.addTechDependency("ammonia-2", "planet-discovery-aquilo")