-- This file creates the sludge fluid and recipe to separate it.
-- Some code taken from Fulgoran Sludge mod by Tatticky.

local Tech = require("code.util.tech")

-- Create sludge fluid, and a recipe to separate it.
data:extend({
	{
		type = "fluid",
		name = "fulgoran-sludge",
		icon = "__LegendarySpaceAge__/graphics/fulgora/sludge.png",
		icon_size = 64,
		mipmap_count = 4,
		base_color = { r = 0.24, g = 0.16, b = 0.16 },
		flow_color = { r = 0.08, g = 0.08, b = 0.08 },
		default_temperature = 5,
		auto_barrel = false,
		subgroup = "fluid",
		order = "b[new-fluid]-c[fulgora]-aa[sludge]",
	},
	{
		type = "recipe",
		name = "fulgoran-sludge-filtration",
		category = "chemistry",
		icons = {
			{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
			{icon = "__LegendarySpaceAge__/graphics/fulgora/sludge.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
		},
		enabled = false,
		energy_required = 4,
		ingredients = {
			{ type = "item", name = "filter", amount = 1},
			{ type = "fluid", name = "fulgoran-sludge", amount = 100, fluidbox_multiplier = 10 },
		},
		results = {
			{ type = "item", name = "spent-filter", amount = 1},
			{ type = "fluid", name = "heavy-oil", amount = 60 },
			{ type = "fluid", name = "light-oil", amount = 20 },
			{ type = "item", name = "ice", amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
			{ type = "item", name = "stone", amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
			{ type = "item", name = "sand", amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
			{ type = "item", name = "rocs-rusting-iron-iron-gear-wheel-rusty", amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
			{ type = "item", name = "rocs-rusting-iron-iron-stick-rusty", amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
			{ type = "item", name = "copper-cable", amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
			{ type = "item", name = "holmium-ore", amount = 1, probability = 0.004, show_details_in_recipe_tooltip = false },
			{ type = "item", name = "plastic-bar", amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
		},
		main_product = "heavy-oil",
		allow_as_intermediate = false,
		subgroup = "fulgora-processes",
		order = "b[holmium]-a[fulgoran-sludge-filtration]", -- Before the recipe for holmium solution.
		allow_productivity = true,
		maximum_productivity = 3,
		---@diagnostic disable-next-line: assign-type-mismatch
		auto_recycle = false,
		crafting_machine_tint = { -- TODO check and maybe improve tints.
			primary = { r = 0.5, g = 0.4, b = 0.25, a = 1.000 },
			secondary = { r = 0, g = 0, b = 0, a = 1.000 },
			tertiary = { r = 0.75, g = 0.5, b = 0.5 },
			quaternary = { r = 0.24, g = 0.16, b = 0.16 }
		}
	}
})
-- Recipe gets added to tech created in filtration.lua.
data.raw["tile"]["oil-ocean-shallow"].fluid = "fulgoran-sludge"
data.raw["tile"]["oil-ocean-deep"].fluid = "fulgoran-sludge"