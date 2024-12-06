local Tech = require("code.util.tech")

-- Create sludge fluid, and a recipe to separate it. Most of the code and sprites are taken from Fulgoran Sludge mod by Tatticky.
data:extend({
	{
		type = "fluid",
		name = "fulgoran-sludge",
		icon = "__LegendarySpaceAge__/graphics/fulgoran-sludge.png",
		base_color = { r = 0.24, g = 0.16, b = 0.16 },
		flow_color = { r = 0.08, g = 0.08, b = 0.08 },
		default_temperature = 5,
		auto_barrel = false,
	},
	{
		type = "recipe",
		name = "fulgoran-sludge-filtration",
		category = "chemistry",
		icons = {
			{
				icon = "__LegendarySpaceAge__/graphics/fulgoran-sludge.png",
				scale = 0.35,
				shift = { 0, -4.8 }
			},
			{
				icon = "__base__/graphics/icons/fluid/heavy-oil.png",
				scale = 0.25,
				shift = { -9, 7 }
			},
			{
				icon = "__space-age__/graphics/icons/scrap-4.png",
				scale = 0.25,
				shift = { 9, 7 }
			},
		},
		enabled = false,
		energy_required = 2,
		ingredients = {
			{ type = "fluid", name = "fulgoran-sludge", amount = 100, fluidbox_multiplier = 10 }
		},
		results = {
			{ type = "fluid", name = "heavy-oil", amount = 80 },
			{ type = "item",  name = "stone",  amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "rocs-rusting-iron-iron-gear-wheel-rusty",  amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "rocs-rusting-iron-iron-stick-rusty",  amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
			--{ type = "item",  name = "steel-plate",  amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
			--{ type = "item",  name = "stone-brick",  amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
			--{ type = "item",  name = "battery",  amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "copper-cable",  amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "holmium-ore",  amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
			{ type = "item",  name = "plastic-bar",  amount = 1, probability = 0.01, show_details_in_recipe_tooltip = false },
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
			primary = { r = 0.5, g = 0.4, b = 0.25, a = 1.000 },
			secondary = { r = 0, g = 0, b = 0, a = 1.000 },
			tertiary = { r = 0.75, g = 0.5, b = 0.5 },
			quaternary = { r = 0.24, g = 0.16, b = 0.16 }
		}
	}
})
Tech.addRecipeToTech("fulgoran-sludge-filtration", "recycling")
data.raw["tile"]["oil-ocean-shallow"].fluid = "fulgoran-sludge"
data.raw["tile"]["oil-ocean-deep"].fluid = "fulgoran-sludge"