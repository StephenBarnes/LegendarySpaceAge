local Tech = require("code.util.tech")

-- Change scrap recycling outputs.
data.raw["recipe"]["scrap-recycling"].results = {
	{ type = "item", name = "processing-unit",       amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "advanced-circuit",      amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
		-- Increased 0.03 -> 0.04 for more plastic
	{ type = "item", name = "low-density-structure", amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
		-- Increased 0.01 -> 0.02 for more plastic
	{ type = "item", name = "solid-fuel",            amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
		-- Changed 0.07 -> 0.02
	{ type = "item", name = "steel-plate",           amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "concrete",              amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
		-- Reduced 0.06 -> 0.04, bc I'm adding stone bricks.
	{ type = "item", name = "stone-brick",           amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
		-- Added.
	{ type = "item", name = "battery",               amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
		-- Reduced 0.04 -> 0.02
	--{ type = "item", name = "ice",                   amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false },
		-- Removed this.
	{ type = "item", name = "stone",                 amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "holmium-ore",           amount = 1, probability = 0.005, show_details_in_recipe_tooltip = false },
		-- Reduced 0.01 -> 0.005, bc I'm adding holmium farming.
	{ type = "item", name = "rocs-rusting-iron-iron-gear-wheel-rusty",       amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
		-- Changed to rusty variant, and reduced 0.20 -> 0.08.
	{ type = "item", name = "rocs-rusting-iron-iron-stick-rusty",       amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false },
		-- Added.
	{ type = "item", name = "copper-cable",          amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false },
	{ type = "item", name = "plastic-bar",          amount = 1, probability = 0.02, show_details_in_recipe_tooltip = false },
		-- Added.
}

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
			{ type = "item",  name = "stone",  amount = 1, probability = 0.04 },
			{ type = "item",  name = "rocs-rusting-iron-iron-gear-wheel-rusty",  amount = 1, probability = 0.03 },
			{ type = "item",  name = "rocs-rusting-iron-iron-stick-rusty",  amount = 1, probability = 0.03 },
			--{ type = "item",  name = "steel-plate",  amount = 1, probability = 0.01 },
			--{ type = "item",  name = "stone-brick",  amount = 1, probability = 0.01 },
			--{ type = "item",  name = "battery",  amount = 1, probability = 0.01 },
			{ type = "item",  name = "copper-cable",  amount = 1, probability = 0.04 },
			{ type = "item",  name = "holmium-ore",  amount = 1, probability = 0.01 },
			{ type = "item",  name = "plastic-bar",  amount = 1, probability = 0.01 },
		},
		subgroup = "fulgora-processes",
		order = "b[holmium]-a[fulgoran-sludge-filtration]", -- Before the recipe for holmium solution.
		allow_productivity = true,
		maximum_productivity = 1,
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

-- Create toxophage tech, recipe, item. Mostly taken from Biochemistry mod by Tenebrais.
-- Biochamber consumes 1 nutrient every 2 seconds, and 10 toxophages => 10 spoilage => 1 half-spoiled nutrient.
-- And turning spoilage into nutrients also costs nutrients.
-- So we need to make it fairly easy to replicate them, for the process to be nutrient-positive. And also expecting people to use efficiency modules.
data:extend({
	{
		type = "technology",
		name = "toxophages",
		icon = "__LegendarySpaceAge__/graphics/from_biochemistry/toxophage_tech.png",
		icon_size = 256,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "toxophage-cultivation"
			}
		},
		prerequisites = { "agricultural-science-pack", "electromagnetic-science-pack" },
		unit = {
			count = 1000,
			ingredients =
			{
				{ "automation-science-pack",      1 },
				{ "logistic-science-pack",        1 },
				{ "chemical-science-pack",        1 },
				{ "space-science-pack",           1 },
				{ "electromagnetic-science-pack", 1 },
				{ "agricultural-science-pack",    1 }
			},
			time = 60
		}
	},
	{
		type = "recipe",
		name = "toxophage-cultivation",
		enabled = false,
		category = "organic",
		--[[surface_conditions = { -- Rather allow it anywhere, since it requires scrap and sludge anyway.
			{
				property = "magnetic-field",
				min = 99,
				max = 99
			}
		},]]
		energy_required = 4,
		allow_productivity = false,
		ingredients = {
			{type = "item", name = "toxophage", amount = 1},
			{type = "fluid", name = "fulgoran-sludge", amount = 40},
			{type = "item", name = "plastic-bar", amount = 1},
		},
		results = {
			{ type = "item", name = "toxophage", amount = 10 },
		},
		crafting_machine_tint = { -- First tint is the main chamber, second tint is the small chamber on right side.
			-- Colors from Biochemistry:
			primary = {r = 0.635, g = 0.557, b = 0.647, a = 1.000}, -- HTML #a28ea5 - lavender.
			secondary = {r = 0.855, g = 0.792, b = 0.863, a = 1.000}, -- HTML #dacadc - lighter lavender.
			-- Using those. Also tried this for brighter purple, but it looks worse:
			--primary = {r = .845, g = .076, b = .943, a=1},
			--secondary = {r = .874, g = .401, b = .934, a=1},
		},
		result_is_always_fresh = true,
		icon = "__LegendarySpaceAge__/graphics/from_biochemistry/toxophage-cultivation.png",
		subgroup = "fulgora-processes",
		order = "c[organics]-b[toxophage-cultivation]",
		allow_decomposition = false,
	},
	{
		type = "item",
		name = "toxophage",
		icon = "__LegendarySpaceAge__/graphics/from_biochemistry/toxophage.png",
		pictures = {
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/from_biochemistry/toxophage.png",   scale = 0.5, mipmap_count = 4 },
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/from_biochemistry/toxophage-1.png", scale = 0.5, mipmap_count = 4 },
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/from_biochemistry/toxophage-2.png", scale = 0.5, mipmap_count = 4 },
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/from_biochemistry/toxophage-3.png", scale = 0.5, mipmap_count = 4 },
		},
		subgroup = "agriculture-processes",
		order = "b[agriculture]-e[toxophage]",
		inventory_move_sound = data.raw.item["iron-bacteria"].inventory_move_sound,
		pick_sound = data.raw.item["iron-bacteria"].pick_sound,
		drop_sound = data.raw.item["iron-bacteria"].drop_sound,
		stack_size = data.raw.item["iron-bacteria"].stack_size,
		default_import_location = "fulgora",
		weight = data.raw.item["iron-bacteria"].weight,
		spoil_ticks = 60 * 60 * 3, -- 3 minutes.
		spoil_result = "spoilage",
	},
})

-- Scrap yields toxophages when mined, used as starter cultures.
local toxophageSources = {
	--["fulgoran-ruin-small"] = {0, .1},
	--["fulgoran-ruin-medium"] = {0, .1},
	["fulgoran-ruin-stonehenge"] = {0, .2},
	["fulgoran-ruin-big"] = {0, .3},
	["fulgoran-ruin-huge"] = {0, .5},
	["fulgoran-ruin-colossal"] = {0, .8},
	["fulgoran-ruin-vault"] = {2, nil},
	--["fulgoran-ruin-attractor"] = {0, .1},
}
for entName, amountAndChance in pairs(toxophageSources) do
	table.insert(data.raw["simple-entity"][entName].minable.results, {
		type = "item",
		name = "toxophage",
		amount = amountAndChance[1],
		extra_count_fraction = amountAndChance[2],
	})
end

-- Toxophages now spoil to spoilage, not nutrients.
data.raw.item["toxophage"].spoil_result = "spoilage"

-- Fulgoran enemies: make boss units (spawned by mining the vaults) have much lower health.
-- Mod gives them max health of 100k times level. Level is 1-10 determined by evolution.
-- For comparison, behemoth biter has 3k health.
for level = 1, 10 do
	local name = "walking-electric-unit-boss-"..level
	data.raw.unit[name].max_health = level * 1000
end

-- Fulgoran enemies: still require mining the vault ruin.
data.raw.technology["recycling"].research_trigger.entity="fulgoran-ruin-vault"

-- Fulgoran enemies: remove scrap drop from enemies.
for _, unit in pairs(data.raw.unit) do
	if unit.loot and #unit.loot == 1 and unit.loot[1].item == "scrap" then
		unit.loot = nil
	end
end

-- TODO in future, maybe allow mining and growing fulgorites?
--table.insert(data.raw["simple-entity"]["fulgurite"].minable.results, { -- The ID is fulgurite with a U, but the name is fulgorite with an O.
--table.insert(data.raw["simple-entity"]["fulgurite-small"].minable.results, {