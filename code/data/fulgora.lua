-- Create sludge fluid.
-- TODO

-- Create toxophage tech, recipe, item. (Mostly taken from Biochemistry mod.)
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
			--{type = "fluid", name = "sludge", amount = 5}, -- TODO
			{type = "item", name = "scrap", amount = 1},
		},
		results = {
			{ type = "item", name = "toxophage", amount = 4 },
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