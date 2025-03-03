-- This file creates the sludge fluid and recipe to separate it.
-- Some code taken from Fulgoran Sludge mod by Tatticky.

-- Create sludge fluid, and a recipe to separate it.
local sludgeFlowColor = { r = 0.08, g = 0.08, b = 0.08 }
extend({
	{
		type = "fluid",
		name = "fulgoran-sludge",
		icon = "__LegendarySpaceAge__/graphics/fulgora/sludge.png",
		icon_size = 64,
		mipmap_count = 4,
		base_color = { r = 0.24, g = 0.16, b = 0.16 },
		flow_color = sludgeFlowColor,
		default_temperature = 5,
		auto_barrel = false,
		subgroup = "fluid",
		order = "b[new-fluid]-c[fulgora]-a[]",
	},
	{
		type = "recipe",
		name = "fulgoran-sludge-filtration",
		category = "filtration",
		icons = {
			{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
			{icon = "__LegendarySpaceAge__/graphics/fulgora/sludge.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
		},
		enabled = false,
		energy_required = 1,
		ingredients = {
			{ type = "fluid", name = "fulgoran-sludge", amount = 100 },
		},
		results = {
			{ type = "fluid", name = "heavy-oil",             amount = 10 },
			{ type = "item",  name = "carbon",                amount = 1, probability = 0.10,  show_details_in_recipe_tooltip = false },
				-- Crucial to have some way of getting this, since you need it for the filters.
			{ type = "item",  name = "ice",                   amount = 1, probability = 0.01,  show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "stone",                 amount = 1, probability = 0.005, show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "sand",                  amount = 1, probability = 0.005, show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "rusty-iron-gear-wheel", amount = 1, probability = 0.005, show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "rusty-iron-stick",      amount = 1, probability = 0.005, show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "copper-cable",          amount = 1, probability = 0.01,  show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "holmium-ore",           amount = 1, probability = 0.001, show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "plastic-bar",           amount = 1, probability = 0.002, show_details_in_recipe_tooltip = false },
			-- NOTE when changing this, have to check that filtration plant still has enough output slots.
		},
		main_product = "heavy-oil",
		allow_as_intermediate = false,
		subgroup = "fulgora-processes",
		order = "b[holmium]-a[fulgoran-sludge-filtration]", -- Before the recipe for holmium solution.
		allow_productivity = true,
		maximum_productivity = 3,
		---@diagnostic disable-next-line: assign-type-mismatch
		auto_recycle = false,
		crafting_machine_tint = {
			primary = FLUID["heavy-oil"].flow_color,
			secondary = sludgeFlowColor,
		}
	}
})
-- Recipe gets added to tech created in filtration.lua.
RAW["tile"]["oil-ocean-shallow"].fluid = "fulgoran-sludge"
RAW["tile"]["oil-ocean-deep"].fluid = "fulgoran-sludge"