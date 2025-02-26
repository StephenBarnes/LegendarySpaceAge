--[[ This file adds the "char furnace", which is like a stone furnace but it has a fixed recipe that produces carbon. Runs on any carbon-based fuel except actual carbon.
This allows the player to get carbon early-game, to make circuits.
1 carbon is 2MJ, energy consumption will be 500kW, so for zero energy gain/loss it should produce 1 carbon every 4 seconds. But make it every 5 seconds for a bit of inefficiency.
Actually that rate is annoyingly slow (need like 50 char furnaces for 10/s plastic), so rather quintuple it. Consume 2.5MW, produce 1 carbon every 1s.
]]

-- Create entity.
---@type data.AssemblingMachinePrototype
---@diagnostic disable-next-line: assign-type-mismatch
local charFurnace = copy(FURNACE["stone-furnace"])
charFurnace.type = "assembling-machine"
charFurnace.fixed_recipe = "char-carbon"
charFurnace.ingredient_count = 0
charFurnace.name = "char-furnace"
charFurnace.minable.result = "char-furnace"
charFurnace.placeable_by = {item = "char-furnace", count = 1}
charFurnace.crafting_speed = 1
charFurnace.energy_usage = "2.5MW"
charFurnace.crafting_categories = {"char-furnace"}
charFurnace.graphics_set.animation.layers[1].filename = "__LegendarySpaceAge__/graphics/char-furnace/entity.png"
charFurnace.corpse = "char-furnace-remnants"
charFurnace.allowed_effects = {"pollution"}
charFurnace.icon = "__LegendarySpaceAge__/graphics/char-furnace/item.png"
charFurnace.show_recipe_icon = false
charFurnace.show_recipe_icon_on_map = false
charFurnace.allowed_effects = {"pollution", "speed", "quality"}
extend{charFurnace}

-- Create corpse.
local charFurnaceRemnants = copy(RAW.corpse["stone-furnace-remnants"])
charFurnaceRemnants.name = "char-furnace-remnants"
charFurnaceRemnants.animation = make_rotated_animation_variations_from_sheet(1,
	{
		filename = "__LegendarySpaceAge__/graphics/char-furnace/remnants.png",
		line_length = 1,
		width = 152,
		height = 130,
		direction_count = 1,
		shift = util.by_pixel(0, 9.5),
		scale = 0.5
	})
extend{charFurnaceRemnants}

-- Create item.
local charFurnaceItem = copy(ITEM["stone-furnace"])
charFurnaceItem.name = "char-furnace"
charFurnaceItem.place_result = "char-furnace"
Icon.set(charFurnaceItem, "LSA/char-furnace/item")
extend{charFurnaceItem}

-- Create recipe category.
local charFurnaceRecipeCategory = copy(RAW["recipe-category"]["smelting"])
charFurnaceRecipeCategory.name = "char-furnace"
extend{charFurnaceRecipeCategory}

-- Create recipe.
Recipe.make{
	copy = "stone-furnace",
	recipe = "char-furnace",
	results = {"char-furnace"},
	clearIcons = true,
}

-- Create recipe for char/carbon.
Recipe.make{
	copy = "rocket-fuel",
	recipe = "char-carbon",
	results = {"carbon"},
	ingredients = {},
	time = 1,
	enabled = false,
	subgroup = "raw-material",
	category = "char-furnace",
	icons = {"carbon", "char-furnace"},
	allow_productivity = false,
	allow_quality = true,
}

-- Create tech called "char", unlocking the furnace and recipe.
local charTech = copy(TECH["automation"])
charTech.name = "char"
charTech.effects = {
	{type = "unlock-recipe", recipe = "char-carbon"},
}
charTech.prerequisites = {}
charTech.research_trigger = {
	type = "build-entity",
	entity = "char-furnace",
}
charTech.unit = nil
Icon.set(charTech, "LSA/char-furnace/tech")
extend{charTech}