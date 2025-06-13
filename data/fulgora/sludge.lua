-- This file creates the sludge fluid, pumped from Fulgoran oceans, and filtration recipe. Idea from Fulgoran Sludge mod by Tatticky.

-- Create sludge fluid.
local mainColor = {.396, .212, .227}
local secondColor = {.169, .098, .078}
local sludgeFluid = copy(FLUID["water"])
sludgeFluid.name = "fulgoran-sludge"
Icon.set(sludgeFluid, "LSA/fulgora/sludge")
sludgeFluid.base_color = mainColor
sludgeFluid.flow_color = secondColor
sludgeFluid.visualization_color = mainColor
Fluid.setSimpleTemp(sludgeFluid, 50, true, -10) -- Default temp -10 since Fulgora has ice.
auto_barrel = true
extend{sludgeFluid}

RAW["tile"]["oil-ocean-shallow"].fluid = "fulgoran-sludge"
RAW["tile"]["oil-ocean-deep"].fluid = "fulgoran-sludge"

-- Create recipe to filter sludge.

local filtrationResults = {
	{"heavy-oil", 20, type="fluid"},
	{"tar", 20, type="fluid"},
	{ type = "item",  name = "carbon",                amount = 1, probability = 0.10,  show_details_in_recipe_tooltip = false },
		-- Crucial to have some way of getting this, since you need it for the filters.
	{ type = "item",  name = "ash",                   amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
		-- Needed so there's a way to make glass on Fulgora.
	-- No stone or sand. Can still get it from recycling concrete.
	{ type = "item",  name = "ice",                   amount = 1, probability = 0.01,  show_details_in_recipe_tooltip = false },
	{ type = "item",  name = "copper-cable",          amount = 1, probability = 0.01,  show_details_in_recipe_tooltip = false },
	{ type = "item",  name = "rusty-iron-gear-wheel", amount = 1, probability = 0.005, show_details_in_recipe_tooltip = false },
	{ type = "item",  name = "rusty-iron-stick",      amount = 1, probability = 0.005, show_details_in_recipe_tooltip = false },
	{ type = "item",  name = "plastic-bar",           amount = 1, probability = 0.002, show_details_in_recipe_tooltip = false },
	{ type = "item",  name = "holmium-ore",           amount = 1, probability = 0.001, show_details_in_recipe_tooltip = false },
}
assert(#filtrationResults <= FURNACE["filtration-plant"].result_inventory_size, "Filtration plant needs more result slots for sludge.")
local recipe = Recipe.make{
	copy = "sulfuric-acid",
	recipe = "fulgoran-sludge-filtration",
	category = "filtration",
	enabled = false,
	unhide = true,
	time = 1,
	ingredients = {
		{"fulgoran-sludge", 100, type="fluid"},
	},
	results = filtrationResults,
	main_product = "heavy-oil",
	allow_as_intermediate = false,
	allow_productivity = true,
	maximum_productivity = 3,
	auto_recycle = false,
	crafting_machine_tint = {
		primary = mainColor,
		secondary = secondColor,
	}
}
recipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
	{icon = "__LegendarySpaceAge__/graphics/fulgora/sludge.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
}
-- Recipe gets added to tech created in filtration.lua.

-- Create tech.
local filtrationFulgoranSludgeTech = copy(TECH["recycling"])
filtrationFulgoranSludgeTech.name = "filtration-fulgoran-sludge"
filtrationFulgoranSludgeTech.icon = nil
filtrationFulgoranSludgeTech.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/tech.png", icon_size = 256, scale = 0.5, shift = {-25, 0}},
	{icon = "__LegendarySpaceAge__/graphics/fulgora/sludge-tech.png", icon_size = 256, scale = 0.4, shift = {25, 0}},
}
filtrationFulgoranSludgeTech.prerequisites = {"planet-discovery-fulgora"}
filtrationFulgoranSludgeTech.effects = {
	{type = "unlock-recipe", recipe = "fulgoran-sludge-filtration"},
}
filtrationFulgoranSludgeTech.research_trigger = {
	type = "craft-fluid",
	fluid = "fulgoran-sludge",
	amount = 100,
}
extend{filtrationFulgoranSludgeTech}
Tech.addTechDependency("filtration-fulgoran-sludge", "holmium-processing")
TECH["holmium-processing"].research_trigger.count = 10