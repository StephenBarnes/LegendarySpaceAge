-- This file makes stingfronds a farmable crop, and creates recipes and items for them.
-- Some of the code here was copied from "Fluroflux: Stingfrond Agriculture" mod by LordMiguel: https://mods.factorio.com/mod/fluroflux

------------------------------------------------------------------------
--- Change stingfrond from type "tree" to type "plant", so it's farmable.

---@type data.PlantPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local stingfrondPlant = copy(RAW.tree.stingfrond)
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
stingfrondPlant.map_color = {.396, .667, .473}
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
RAW.tree.stingfrond = nil
extend({stingfrondPlant})

------------------------------------------------------------------------
--- Create items for products of stingfrond farming.

-- Subgroup for stingfrond items and recipes.
extend{
	{
		type = "item-subgroup",
		name = "stingfrond-products",
		group = "space",
		order = "023",
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
	local cyclosome = copy(ITEM["tree-seed"])
	cyclosome.name = "cyclosome-"..i
	cyclosome.localised_name = nil
	cyclosome.localised_description = {"item-description.cyclosome"}
	cyclosome.pictures = copy(cyclosomePics)
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
	Item.clearFuel(cyclosome)
	cyclosomeItems[i] = cyclosome
end
extend(cyclosomeItems)

-- Create sprout item
local stingfrondSprout = copy(ITEM["tree-seed"])
stingfrondSprout.name = "stingfrond-sprout"
stingfrondSprout.localised_name = nil
stingfrondSprout.plant_result = "stingfrond"
stingfrondSprout.icon = "__space-age__/graphics/icons/stingfrond.png"
stingfrondSprout.subgroup = "stingfrond-products"
stingfrondSprout.order = "a"
Item.clearFuel(stingfrondSprout)
extend{stingfrondSprout}

-- Create neurofibril item
local neurofibrilPics = {}
for i = 1, 6 do
	neurofibrilPics[i] = {
		filename = "__LegendarySpaceAge__/graphics/gleba/stingfronds/neurofibrils/"..i..".png",
		size = 64,
		scale = 0.5,
	}
end
local neurofibril = copy(ITEM["wood"])
neurofibril.fuel_category = "chemical"
neurofibril.fuel_value = "1MJ"
neurofibril.name = "neurofibril"
neurofibril.pictures = neurofibrilPics
neurofibril.icon = nil
neurofibril.icons = {{icon = "__LegendarySpaceAge__/graphics/gleba/stingfronds/neurofibrils/1.png", icon_size = 64, scale = 0.5, icon_mipmaps = 4}}
neurofibril.subgroup = "stingfrond-products"
neurofibril.order = "b"
extend{neurofibril}

ITEM["carbon-fiber"].subgroup = "stingfrond-products"
ITEM["carbon-fiber"].order = "c"

------------------------------------------------------------------------
--[[ Create techs.
There's 3 techs.
	Neural-wiring tech gives you wiring from neurofibrils.
	The 1st cultivation tech lets you make sprouts so you can actually farm stingfronds, and use cyclosomes to make science packs.
	Then the 2nd cultivation tech lets you duplicate cyclosomes, and also make various products more efficiently from cyclosomes and neurofibrils. Then carbon fiber tech depends on that.
--]]

local wiringTech = copy(TECH["biochamber"])
wiringTech.name = "neural-wiring"
wiringTech.icon = "__LegendarySpaceAge__/graphics/gleba/stingfronds/tech2.png"
wiringTech.prerequisites = {"planet-discovery-gleba"}
wiringTech.research_trigger = {
	type = "mine-entity",
	entity = "stingfrond",
}
wiringTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "wiring-from-neurofibril",
	},
}
extend{wiringTech}

local cultivationTech1 = copy(TECH["biochamber"])
cultivationTech1.name = "stingfrond-cultivation-1"
cultivationTech1.icon = "__LegendarySpaceAge__/graphics/gleba/stingfronds/tech1.png"
cultivationTech1.prerequisites = {"bioflux", "neural-wiring"}
cultivationTech1.research_trigger = {
	type = "craft-item",
	item = "biochamber",
	count = 5,
}
cultivationTech1.effects = {
	{
		type = "unlock-recipe",
		recipe = "stingfrond-sprout",
	},
}
cultivationTech1.localised_description = {"technology-description.stingfrond-cultivation-1"}
extend{cultivationTech1}

local cultivationTech2 = copy(TECH["biochamber"])
cultivationTech2.name = "stingfrond-cultivation-2"
cultivationTech2.icon = "__LegendarySpaceAge__/graphics/gleba/stingfronds/tech1.png"
cultivationTech2.prerequisites = {"stingfrond-cultivation-1"}
cultivationTech2.research_trigger = {
	type = "craft-item",
	item = "stingfrond-sprout",
	count = 20,
}
cultivationTech2.effects = {
	{
		type = "unlock-recipe",
		recipe = "cyclosome-resynchronization",
	},
	{
		type = "unlock-recipe",
		recipe = "explosive-desynchronization",
	},
}
cultivationTech2.localised_description = {"technology-description.stingfrond-cultivation-2"}
extend{cultivationTech2}

table.insert(TECH["agricultural-science-pack"].prerequisites, "stingfrond-cultivation-1")

------------------------------------------------------------------------
--- Create recipes.

-- cyclosome 1 + 10 water + 1 bioflux -> 20% stingfrond sprout
-- So bioflux is needed, as for all "tier 2" crops, but the recipe otherwise isn't very expensive.
local sproutRecipe = copy(RECIPE["bioflux"])
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
extend{sproutRecipe}

-- 4 neurofibril -> 1 carbon fiber
RECIPE["carbon-fiber"].ingredients = {
	{type = "item", name = "neurofibril", amount = 4},
}
RECIPE["carbon-fiber"].subgroup = "stingfrond-products"
RECIPE["carbon-fiber"].order = "b"
RECIPE["carbon-fiber"].category = "crafting"

-- Resynchronization: 5 cyclosome A + ... + 5 cyclosome E + 2 neurofibrils -> 50 cyclosome C
-- The neurofibrils are in this recipe to ensure cyclosome amount is still limited by farms.
local resyncRecipe = copy(RECIPE["bioflux"])
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
extend{resyncRecipe}

-- Explosive desynchronization: 10 cyclosome A + 1 explosives -> 0-3 cyclosome A + ... + 0-3 cyclosome E
-- So total 0-15, mean 7.5.
local desyncRecipe = copy(resyncRecipe)
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
desyncRecipe.icons = copy(resyncRecipe.icons)
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
extend{desyncRecipe}

-- TODO add recipes for stuff like rocket fuel, 