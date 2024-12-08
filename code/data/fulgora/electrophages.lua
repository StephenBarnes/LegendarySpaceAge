-- Create electrophage tech, recipe, item. Mostly taken from Biochemistry mod by Tenebrais.
data:extend({
	{
		type = "technology",
		name = "electrophages",
		icon = "__LegendarySpaceAge__/graphics/from_biochemistry/electrophage_tech.png",
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
			{type = "item", name = "battery", amount = 1, probability = 0.95},
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
		icon = "__LegendarySpaceAge__/graphics/from_biochemistry/electrophage-cultivation.png",
		subgroup = "fulgora-processes",
		order = "c[organics]-c[electrophage-cultivation]",
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
			{type = "item", name = "holmium-battery", amount = 1},
		},
		crafting_machine_tint = {
			-- Using similar colors to before, but brighter and more pink (since it uses holmium).
			primary = {r = 0.781, g = 0.526, b = 0.831, a = 1.000},
			secondary = {r = 0.942, g = 0.811, b = 0.960, a = 1.000},
		},
		result_is_always_fresh = true,
		icons = {
			{
				icon = "__LegendarySpaceAge__/graphics/from_biochemistry/electrophage-cultivation.png",
			},
			{
				icon = "__LegendarySpaceAge__/graphics/batteries/holmium_battery_short_charged.png",
				scale = 0.3,
				shift = {7, 7},
			},
		},
		subgroup = "fulgora-processes",
		order = "c[organics]-c[electrophage-cultivation]",
		allow_decomposition = false,
	},
	{
		type = "item",
		name = "electrophage",
		icon = "__LegendarySpaceAge__/graphics/from_biochemistry/electrophage.png",
		pictures = {
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/from_biochemistry/electrophage.png",   scale = 0.5, mipmap_count = 4 },
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/from_biochemistry/electrophage-1.png", scale = 0.5, mipmap_count = 4 },
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/from_biochemistry/electrophage-2.png", scale = 0.5, mipmap_count = 4 },
			{ size = 64, filename = "__LegendarySpaceAge__/graphics/from_biochemistry/electrophage-3.png", scale = 0.5, mipmap_count = 4 },
		},
		subgroup = "fulgora-processes",
		order = "c[organics]-b[electrophage]",
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

-- Scrap yields electrophages when mined, used as starter cultures.
local electrophageSources = {
	--[{"simple-entity", "fulgoran-ruin-small"}] = {0, .1},
	--[{"simple-entity", "fulgoran-ruin-medium"}] = {0, .1},
	[{"simple-entity", "fulgoran-ruin-stonehenge"}] = {0, 0, .2},
	[{"simple-entity", "fulgoran-ruin-big"}] = {0, 0, .3},
	[{"simple-entity", "fulgoran-ruin-huge"}] = {0, 0, .5},
	[{"simple-entity", "fulgoran-ruin-colossal"}] = {0, 0, .8},
	[{"simple-entity", "fulgoran-ruin-vault"}] = {2, 10, nil},
	--[{"simple-entity", "fulgurite"}] = {0, 0, .5}, -- Rather don't produce from fulgurites - should need electrophage cultivation, not just fulgorite farming.
	--[{"simple-entity", "fulgurite-small"}] = {0, 0, .1},
	[{"lightning-attractor", "fulgoran-ruin-attractor"}] = {6, 12, nil},
}
for entTypeName, minMaxChance in pairs(electrophageSources) do
	table.insert(data.raw[entTypeName[1]][entTypeName[2]].minable.results, {
		type = "item",
		name = "electrophage",
		amount_min = minMaxChance[1],
		amount_max = minMaxChance[2],
		extra_count_fraction = minMaxChance[3],
	})
end

-- Electrophages could spoil to spoilage or nutrients. I think to nutrients makes more sense, since there's not much other life on Fulgora to spoil the nutrients.
-- But ideally we'd have a new type of nutrients that spoils to stone, or nothing.
data.raw.item["electrophage"].spoil_result = "nutrients"
-- TODO add new type of nutrients (something like "nutritive salts" or whatever) that spoils to stone.