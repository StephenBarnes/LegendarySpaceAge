local Const = require("data.fulgora.const")

-- Create electrophage tech, recipe, item. Mostly taken from Biochemistry mod by Tenebrais.
extend({
	{
		type = "technology",
		name = "electrophages",
		icon = "__LegendarySpaceAge__/graphics/fulgora/from_biochemistry/electrophage_tech.png",
		icon_size = 256,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "electrophage-cultivation",
			},
			{
				type = "unlock-recipe",
				recipe = "electrophage-cultivation-holmium",
			},
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
		name = "electrophage-cultivation",
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
			{type = "item", name = "electrophage", amount = 1},
			{type = "item", name = "charged-battery", amount = 1},
			{type = "fluid", name = "fulgoran-sludge", amount = 40},
			{type = "fluid", name = "electrolyte", amount = 2},
		},
		results = {
			{type = "item", name = "electrophage", amount = 4},
			{type = "item", name = "battery", amount = 1, probability = 0.95, show_details_in_recipe_tooltip = false},
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
		icon = "__LegendarySpaceAge__/graphics/fulgora/from_biochemistry/electrophage-cultivation.png",
		allow_decomposition = false,
	},
	{
		-- Holmium batteries have 10x the charge, so I'm making the recipe produce 10x everything, except electrolyte required is only 5x.
		type = "recipe",
		name = "electrophage-cultivation-holmium",
		enabled = false,
		category = "organic",
		energy_required = 4,
		allow_productivity = false,
		ingredients = {
			{type = "item", name = "electrophage", amount = 1},
			{type = "item", name = "charged-holmium-battery", amount = 1},
			{type = "fluid", name = "fulgoran-sludge", amount = 400},
			{type = "fluid", name = "electrolyte", amount = 10},
		},
		results = {
			{type = "item", name = "electrophage", amount = 40},
			{type = "item", name = "holmium-battery", amount = 1, show_details_in_recipe_tooltip = false},
		},
		crafting_machine_tint = {
			-- Using similar colors to before, but brighter and more pink (since it uses holmium).
			primary = {r = 0.781, g = 0.526, b = 0.831, a = 1.000},
			secondary = {r = 0.942, g = 0.811, b = 0.960, a = 1.000},
		},
		result_is_always_fresh = true,
		icons = {
			{
				icon = "__LegendarySpaceAge__/graphics/fulgora/from_biochemistry/electrophage-cultivation.png",
			},
			{
				icon = "__LegendarySpaceAge__/graphics/fulgora/batteries/holmium_battery_short.png",
				scale = 0.3,
				shift = {7, 7},
			},
			{
				icon = "__LegendarySpaceAge__/graphics/fulgora/batteries/glow.png",
				scale = 0.3,
				shift = {7, 7},
				tint = Const.holmiumBatteryGlowTint,
				draw_as_glow = true,
			},
		},
		allow_decomposition = false,
	},
	{
		type = "item",
		name = "electrophage",
		icon = "__LegendarySpaceAge__/graphics/fulgora/from_biochemistry/electrophage.png",
		pictures = {
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/fulgora/from_biochemistry/electrophage.png",   scale = 0.5, mipmap_count = 4 },
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/fulgora/from_biochemistry/electrophage-1.png", scale = 0.5, mipmap_count = 4 },
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/fulgora/from_biochemistry/electrophage-2.png", scale = 0.5, mipmap_count = 4 },
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/fulgora/from_biochemistry/electrophage-3.png", scale = 0.5, mipmap_count = 4 },
		},
		inventory_move_sound = ITEM["battery"].inventory_move_sound,
		pick_sound = ITEM["battery"].pick_sound,
		drop_sound = ITEM["battery"].drop_sound,
		stack_size = ITEM["iron-bacteria"].stack_size,
		default_import_location = "fulgora",
		weight = ITEM["iron-bacteria"].weight,
		spoil_ticks = 3 * MINUTES,
		spoil_result = "spoilage",
		--[{"simple-entity", "fulgurite"}] = {0, 0, .5}, -- Rather don't
	},
})

-- Electrophages could spoil to nutrients, or to spoilage (which you then turn into nutrients).
-- But doesn't really fit, bc Fulgora has no ambient decomposition bacteria, so spoilage shouldn't really exist.
-- So, making a new type of nutrients that lasts longer than Gleba nutrients, and spoils to stone.
ITEM["electrophage"].spoil_result = "polysalt"
local polysaltItem = copy(ITEM["nutrients"])
polysaltItem.name = "polysalt"
Icon.set(polysaltItem, "LSA/fulgora/polysalts")
polysaltItem.spoil_ticks = 1 * HOURS
polysaltItem.spoil_result = "sand"
polysaltItem.burnt_result = "sand"
-- Copy dry powder sounds from sulfur, instead of wet nutrient sounds.
polysaltItem.drop_sound = ITEM["sulfur"].drop_sound
polysaltItem.pick_sound = ITEM["sulfur"].pick_sound
polysaltItem.inventory_move_sound = ITEM["sulfur"].inventory_move_sound
extend({polysaltItem})