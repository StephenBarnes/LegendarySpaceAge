-- This file creates the recipes for the arc furnace.

-- Create recipe category.
extend{{
	name = "arc-furnace",
	type = "recipe-category",
}}

-- Placeholder recipe: nothing -> iron gear wheel.
Recipe.make{
	copy = "iron-gear-wheel",
	recipe = "alt-gears",
	category = "arc-furnace",
	enabled = true,
	ingredients = {
		{"oxygen-gas", 10, type = "fluid"},
		{"lava", 100, type = "fluid"},
	},
	results = {
		{"molten-iron", 100, type = "fluid"},
		{"molten-copper", 100, type = "fluid"},
	},
	icons = {"molten-iron", "lava"},
}

-- TODO