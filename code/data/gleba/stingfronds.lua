-- This file makes stingfronds a farmable crop, and creates recipes and items for them.
-- Some of the code here was copied from "Fluroflux: Stingfrond Agriculture" mod by LordMiguel: https://mods.factorio.com/mod/fluroflux

------------------------------------------------------------------------
--- Change stingfrond from type "tree" to type "plant", so it's farmable.

---@type data.PlantPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local stingfrondPlant = table.deepcopy(data.raw.tree.stingfrond)
stingfrondPlant.type = "plant"

stingfrondPlant.growth_ticks = 60 * 60 * 8 -- 8 minutes; compare to yumako/jellystem at 5 minutes.
stingfrondPlant.placeable_by = {item = "stingfrond-sprout", count = 1}
-- Wube's code defines the autoplace stuff twice. Second time overwrites the tile restriction. But we need a tile restriction so it's growable on some tiles. Maybe just midland turquoise, like Fluroflux. By default it spawns in other midland/highland tiles too.
stingfrondPlant.autoplace.tile_restriction = {
	"midland-turquoise-bark",
	"midland-turquoise-bark-2",
	--"midland-cracked-lichen-dark",
	--"midland-cracked-lichen-dull",
	--"highland-dark-rock-2",
}
-- Make them visible on map.
stingfrondPlant.map_color = {102, 198, 207}
-- Edit color shown in ag tower.
stingfrondPlant.agricultural_tower_tint = {
	primary = {r = 0.47, g = 0.90, b = 0.94, a = 1},
	secondary = {r = 0.40, g = 0.77, b = 0.81, a = 1},
}

-- Harvesting stingfronds produces wood, cyclosomes, and neurofibrils.
stingfrondPlant.minable.results = {
	{type = "item", name = "wood", amount = 8},
	{type = "item", name = "cyclosome-1", amount_min = 0, amount_max = 10},
	{type = "item", name = "neurofibril", amount_min = 0, amount_max = 10},
}
-- Emits spores, same as yumako/jellystem. This gives a reason to use resync recipe, rather than just planting 2x more stingfronds.
stingfrondPlant.harvest_emissions = { spores = 15 }

-- Delete old stingfrond tree, add new stingfrond plant.
data.raw.tree.stingfrond = nil
data:extend({stingfrondPlant})

------------------------------------------------------------------------
--- Create items for products of stingfrond farming.

-- Subgroup for stingfrond items and recipes.
data:extend{
	{
		type = "item-subgroup",
		name = "stingfrond-products",
		group = "intermediate-products",
		order = "n2",
	},
}

-- Create cyclosomes
---@type data.Sprite[]
local cyclosomePics = {} -- Picture variants
for i = 1, 15 do
	cyclosomePics[i] = {
		filename = "__LegendarySpaceAge__/graphics/gleba/stingfronds/cyclosomes/"..i..".png",
		size = 64,
		scale = 0.25,
		draw_as_glow = true,
	}
end
local phaseTints = { -- Tints for the 5 phases of cyclosomes.
	-- First 2 picked from the plant graphics.
	{0x57, 0x8d, 0x77},
	{0x72, 0x9f, 0xaa},

	{0x80, 0x5d, 0x93},
	{0xf4, 0x9f, 0xbc},
	{0xff, 0xd3, 0xba},
}
local cyclosomeItems = {}
for i = 1, 5 do
	local cyclosome = table.deepcopy(data.raw.item["tree-seed"])
	cyclosome.name = "cyclosome-"..i
	cyclosome.localised_name = nil
	cyclosome.localised_description = {"item-description.cyclosome"}
	cyclosome.pictures = table.deepcopy(cyclosomePics)
	for _, pic in pairs(cyclosome.pictures) do
		pic.tint = phaseTints[i]
	end
	cyclosome.spoil_ticks = 60 * 30
	cyclosome.spoil_result = "cyclosome-" .. ((i == 5 and 1) or (i + 1))
	cyclosome.icon = nil
	cyclosome.icons = {{icon = "__LegendarySpaceAge__/graphics/gleba/stingfronds/cyclosomes/"..i..".png", icon_size = 64, scale = 0.5, icon_mipmaps = 4, tint = phaseTints[i]}}
		-- Give each one a different variant as main icon.
	cyclosome.subgroup = "stingfrond-products"
	cyclosome.order = "z"..i
	cyclosome.fuel_value = nil
	cyclosomeItems[i] = cyclosome
end
data:extend(cyclosomeItems)

-- Create sprout item
local stingfrondSprout = table.deepcopy(data.raw.item["tree-seed"])
stingfrondSprout.name = "stingfrond-sprout"
stingfrondSprout.localised_name = nil
stingfrondSprout.plant_result = "stingfrond"
stingfrondSprout.icon = "__space-age__/graphics/icons/stingfrond.png"
stingfrondSprout.subgroup = "stingfrond-products"
stingfrondSprout.order = "a"
data:extend{stingfrondSprout}

-- Create neurofibril item
local neurofibrilPics = {}
for i = 1, 6 do
	neurofibrilPics[i] = {
		filename = "__LegendarySpaceAge__/graphics/gleba/stingfronds/neurofibrils/"..i..".png",
		size = 64,
		scale = 0.5,
	}
end
local neurofibril = table.deepcopy(data.raw.item["wood"])
neurofibril.fuel_category = "chemical"
neurofibril.fuel_value = "1MJ"
neurofibril.name = "neurofibril"
neurofibril.pictures = neurofibrilPics
neurofibril.icon = nil
neurofibril.icons = {{icon = "__LegendarySpaceAge__/graphics/gleba/stingfronds/neurofibrils/1.png", icon_size = 64, scale = 0.5, icon_mipmaps = 4}}
neurofibril.subgroup = "stingfrond-products"
neurofibril.order = "b"
data:extend{neurofibril}

data.raw.item["carbon-fiber"].subgroup = "stingfrond-products"
data.raw.item["carbon-fiber"].order = "c"

------------------------------------------------------------------------
--[[ Create techs.
There's 2 techs.
	The 1st tech lets you make sprouts so you can actually farm stingfronds, and use cyclosomes to make science packs. You can burn the neurofibrils.
	Then the 2nd tech lets you duplicate cyclosomes, and also make various products more efficiently from cyclosomes and neurofibrils. Then carbon fiber tech depends on that.
--]]

local stingfrondTech1 = table.deepcopy(data.raw.technology["biochamber"])
stingfrondTech1.name = "stingfronds-1"
stingfrondTech1.icon = "__LegendarySpaceAge__/graphics/gleba/stingfronds/tech1.png"
stingfrondTech1.prerequisites = {"planet-discovery-gleba"}
stingfrondTech1.research_trigger = {
	type = "mine-entity",
	entity = "stingfrond",
}
stingfrondTech1.effects = {
	{
		type = "unlock-recipe",
		recipe = "stingfrond-sprout",
	},
}
stingfrondTech1.localised_description = {"technology-description.stingfronds-1"}
data:extend{stingfrondTech1}

local stingfrondTech2 = table.deepcopy(data.raw.technology["biochamber"])
stingfrondTech2.name = "stingfronds-2"
stingfrondTech2.icon = "__LegendarySpaceAge__/graphics/gleba/stingfronds/tech2.png"
stingfrondTech2.prerequisites = {"stingfronds-1"}
stingfrondTech2.research_trigger = {
	type = "craft-item",
	item = "stingfrond-sprout",
	count = 20,
}
stingfrondTech2.effects = {
	{
		type = "unlock-recipe",
		recipe = "cyclosome-resynchronization",
	},
	{
		type = "unlock-recipe",
		recipe = "explosive-desynchronization",
	},
}
stingfrondTech2.localised_description = {"technology-description.stingfronds-2"}
data:extend{stingfrondTech2}

table.insert(data.raw.technology["agricultural-science-pack"].prerequisites, "stingfronds-1")
table.insert(data.raw.technology["carbon-fiber"].prerequisites, "stingfronds-2")

------------------------------------------------------------------------
--- Create recipes.

-- cyclosome 1 + 10 water + 1 bioflux -> 20% stingfrond sprout
-- So bioflux is needed, as for all "tier 2" crops, but the recipe otherwise isn't very expensive.
local sproutRecipe = table.deepcopy(data.raw.recipe["bioflux"])
sproutRecipe.name = "stingfrond-sprout"
sproutRecipe.ingredients = {
	{type = "item", name = "cyclosome-1", amount = 1},
	{type = "fluid", name = "water", amount = 10},
	{type = "item", name = "bioflux", amount = 1},
}
sproutRecipe.results = {
	{type = "item", name = "stingfrond-sprout", amount = 1, probability = 0.2},
}
sproutRecipe.icon = nil
sproutRecipe.subgroup = "stingfrond-products"
sproutRecipe.order = "a"
sproutRecipe.energy_required = 5
sproutRecipe.crafting_machine_tint = {
	primary = phaseTints[1],
	secondary = phaseTints[2],
}
data:extend{sproutRecipe}

-- 4 neurofibril -> 1 carbon fiber
data.raw.recipe["carbon-fiber"].ingredients = {
	{type = "item", name = "neurofibril", amount = 4},
}
data.raw.recipe["carbon-fiber"].subgroup = "stingfrond-products"
data.raw.recipe["carbon-fiber"].order = "b"

-- Resynchronization: 5 cyclosome A + ... + 5 cyclosome E + 2 neurofibrils -> 50 cyclosome C
-- The neurofibrils are in this recipe to ensure cyclosome amount is still limited by farms.
local resyncRecipe = table.deepcopy(data.raw.recipe["bioflux"])
resyncRecipe.name = "cyclosome-resynchronization"
resyncRecipe.ingredients = {
	{type = "item", name = "cyclosome-1", amount = 5},
	{type = "item", name = "cyclosome-2", amount = 5},
	{type = "item", name = "cyclosome-3", amount = 5},
	{type = "item", name = "cyclosome-4", amount = 5},
	{type = "item", name = "cyclosome-5", amount = 5},
	{type = "item", name = "neurofibril", amount = 1},
}
resyncRecipe.results = {
	{type = "item", name = "cyclosome-3", amount = 50, show_details_in_recipe_tooltip = false},
}
resyncRecipe.main_product = "cyclosome-3"
resyncRecipe.show_amount_in_title = false
resyncRecipe.allow_productivity = false
resyncRecipe.maximum_productivity = 0
resyncRecipe.subgroup = "stingfrond-products"
resyncRecipe.order = "c"
resyncRecipe.energy_required = 10
resyncRecipe.icon = nil
local fifthRoots = { -- 5th roots of unity, forming a pentagon, used to make the icons of the cyclosome recipes.
	{1, 0},
	{0.3090169944, 0.9510565163},
	{-0.8090169944, 0.5877852523},
	{-0.8090169944, -0.5877852523},
	{0.3090169944, -0.9510565163},
}
resyncRecipe.icons = {} -- The icons of the 5 cyclosome items, arranged in a pentagon.
for i = 1, 5 do
	table.insert(resyncRecipe.icons, {
		icon = "__LegendarySpaceAge__/graphics/gleba/stingfronds/cyclosomes/"..i..".png",
		icon_size = 64,
		scale = 0.2,
		shift = {fifthRoots[i][1] * 8, fifthRoots[i][2] * 8},
		tint = phaseTints[i],
	})
end
resyncRecipe.crafting_machine_tint = {
	primary = phaseTints[1],
	secondary = phaseTints[2],
	tertiary = phaseTints[3],
}
data:extend{resyncRecipe}

-- Explosive desynchronization: 10 cyclosome A + 1 explosives -> 0-3 cyclosome A + ... + 0-3 cyclosome E
-- So total 0-15, mean 7.5.
local desyncRecipe = table.deepcopy(resyncRecipe)
desyncRecipe.name = "explosive-desynchronization"
desyncRecipe.ingredients = {
	{type = "item", name = "cyclosome-1", amount = 10},
	{type = "item", name = "explosives", amount = 1},
}
desyncRecipe.results = {
	{type = "item", name = "cyclosome-1", amount_min = 0, amount_max = 3, show_details_in_recipe_tooltip = false},
	{type = "item", name = "cyclosome-2", amount_min = 0, amount_max = 3, show_details_in_recipe_tooltip = false},
	{type = "item", name = "cyclosome-3", amount_min = 0, amount_max = 3, show_details_in_recipe_tooltip = false},
	{type = "item", name = "cyclosome-4", amount_min = 0, amount_max = 3, show_details_in_recipe_tooltip = false},
	{type = "item", name = "cyclosome-5", amount_min = 0, amount_max = 3, show_details_in_recipe_tooltip = false},
}
desyncRecipe.order = "d"
desyncRecipe.icons = table.deepcopy(resyncRecipe.icons)
table.insert(desyncRecipe.icons, {
	icon = "__base__/graphics/icons/explosives.png",
	icon_size = 64,
	scale = 0.28,
})
desyncRecipe.crafting_machine_tint = {
	primary = phaseTints[1],
	secondary = phaseTints[2],
	tertiary = phaseTints[3],
}
data:extend{desyncRecipe}

-- TODO add recipes for stuff like rocket fuel, 