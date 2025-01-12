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
	prerequisites = {"automation"},
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/ammonia/tech.png", icon_size = 256}},
	effects = {
		{
			type = "unlock-recipe",
			recipe = "ammonia-from-spoilage",
		},
		{
			type = "unlock-recipe",
			recipe = "spoilage-from-wood",
		},
	},
})
table.insert(newData, ammonia1Tech)

-- Create ammonia 2 tech, for ammonia from syngas.
local ammonia2Tech = Table.copyAndEdit(data.raw.technology["coal-liquefaction"], {
	name = "ammonia-2",
	localised_name = {"technology-name.ammonia-2"},
	localised_description = {"technology-description.ammonia-2"},
	prerequisites = {"ammonia-1", "coal-liquefaction"},
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/ammonia/tech.png", icon_size = 256}},
	effects = {
		{
			type = "unlock-recipe",
			recipe = "ammonia-from-syngas",
		},
	},
})
table.insert(newData, ammonia2Tech)

-- Create recipe for ammonia from spoilage.
-- TODO this is maybe incorrect.
local ammoniaRecipe = Table.copyAndEdit(data.raw.recipe["nutrients-from-spoilage"], {
	name = "ammonia-from-spoilage",
	ingredients = {
		{type = "item", name = "spoilage", amount = 5},
		{type = "fluid", name = "water", amount = 20},
	},
	results = {
		{type = "fluid", name = "ammonia", amount = 20},
	},
	category = "chemistry",
	subgroup = "complex-fluid-recipes",
	-- TODO icons
})
table.insert(newData, ammoniaRecipe)

-- Create recipe for spoilage from wood.
-- TODO this is maybe incorrect.
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
	subgroup = "complex-fluid-recipes",
	energy_required = 30,
	-- TODO icons
})
table.insert(newData, woodSpoilageRecipe)

-- Create recipe for ammonia from syngas.
-- TODO this is maybe incorrect.
local ammoniaSyngasRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "ammonia-from-syngas",
	ingredients = {
		{type = "fluid", name = "syngas", amount = 20},
		{type = "fluid", name = "steam", amount = 20},
	},
	results = {
		{type = "fluid", name = "ammonia", amount = 20},
	},
	category = "chemistry",
	subgroup = "complex-fluid-recipes",
	-- TODO icons
})
table.insert(newData, ammoniaSyngasRecipe)

-- Aquilo should require ammonia 2 tech.
Tech.addTechDependency("ammonia-2", "planet-discovery-aquilo")

-- TODO more.

data:extend(newData)