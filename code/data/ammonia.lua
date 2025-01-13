--[[ This file adds early ammonia tech and recipes, and later ammonia using syngas.
TODO
]]

local Table = require("code.util.table")
local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

local newData = {}

-- Create ammonia 1 tech, for ammonia from spoilage and spoilage from wood.
local ammonia1Tech = Table.copyAndEdit(data.raw.technology["automation"], {
	name = "ammonia-1",
	localised_name = {"technology-name.ammonia-1"},
	localised_description = {"technology-description.ammonia-1"},
	prerequisites = {"filtration-1"},
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/ammonia/tech.png", icon_size = 256}},
	effects = {
		{type = "unlock-recipe", recipe = "spoilage-from-wood"},
		{type = "unlock-recipe", recipe = "ammonia-from-spoilage"},
		{type = "unlock-recipe", recipe = "niter"},
	},
})
table.insert(newData, ammonia1Tech)

-- Create ammonia 2 tech, for ammonia from syngas.
local ammonia2Tech = Table.copyAndEdit(data.raw.technology["coal-liquefaction"], {
	name = "ammonia-2",
	localised_name = {"technology-name.ammonia-2"},
	localised_description = {"technology-description.ammonia-2"},
	prerequisites = {"ammonia-1", "chemical-science-pack"},
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/ammonia/tech.png", icon_size = 256}},
	effects = {
		{
			type = "unlock-recipe",
			recipe = "ammonia-from-syngas",
		},
	},
	unit = {
		count = 1000,
		time = 30,
		ingredients = {
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
		},
	},
})
table.insert(newData, ammonia2Tech)

-- Create recipe for ammonia from spoilage.
local ammoniaRecipe = Table.copyAndEdit(data.raw.recipe["nutrients-from-spoilage"], {
	name = "ammonia-from-spoilage",
	ingredients = {
		{type = "item", name = "spoilage", amount = 5},
		{type = "fluid", name = "water", amount = 20},
	},
	results = {
		{type = "fluid", name = "ammonia", amount = 10},
	},
	category = "organic-or-chemistry",
	subgroup = "early-agriculture",
	order = "d2",
	energy_required = 30,
	icons = {
		{icon = "__space-age__/graphics/icons/fluid/ammonia.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {4, 4}},
		{icon = "__space-age__/graphics/icons/spoilage.png", icon_size = 64, scale = 0.3, mipmap_count = 4, shift = {-6, -6}},
	},
})
table.insert(newData, ammoniaRecipe)

-- Create recipe for spoilage from wood.
local woodSpoilageRecipe = Table.copyAndEdit(data.raw.recipe["nutrients-from-spoilage"], {
	name = "spoilage-from-wood",
	ingredients = {
		{type = "item", name = "wood", amount = 5},
		{type = "fluid", name = "water", amount = 20},
	},
	results = {
		{type = "item", name = "spoilage", amount = 5},
	},
	category = "organic-or-chemistry",
	subgroup = "early-agriculture",
	order = "d1",
	energy_required = 30,
	icons = {
		{icon = "__space-age__/graphics/icons/spoilage.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {4, 4}},
		{icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale = 0.3, mipmap_count = 4, shift = {-6, -6}},
	},
})
table.insert(newData, woodSpoilageRecipe)

-- Create recipe for niter from ammonia and sand.
local niterFromAmmoniaRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "niter",
	ingredients = {
		{type = "fluid", name = "ammonia", amount = 5},
		{type = "item", name = "sand", amount = 4},
	},
	results = {
		{type = "item", name = "niter", amount = 8},
	},
	icon = "nil",
	icons = "nil",
	energy_required = 1,
})
table.insert(newData, niterFromAmmoniaRecipe)

-- Create recipe for ammonia from syngas.
local ammoniaSyngasRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "ammonia-from-syngas",
	ingredients = {
		{type = "fluid", name = "syngas", amount = 100},
		{type = "fluid", name = "steam", amount = 100},
	},
	results = {
		{type = "fluid", name = "ammonia", amount = 100},
	},
	category = "chemistry-or-cryogenics",
	subgroup = "raw-material",
	order = "d3",
	icons = {
		{icon = "__space-age__/graphics/icons/fluid/ammonia.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {4, 4}},
		{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=require("code.data.petrochem.constants").syngasColor, scale = 0.3, mipmap_count = 4, shift = {-6, -6}},
	},
	energy_required = 4,
})
table.insert(newData, ammoniaSyngasRecipe)

-- Aquilo should require ammonia 2 tech.
Tech.addTechDependency("ammonia-2", "planet-discovery-aquilo")

data:extend(newData)