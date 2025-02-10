--[[ This file adds the "char furnace", which is like a stone furnace but it has a fixed recipe that produces carbon. Runs on any carbon-based fuel except actual carbon.
This allows the player to get carbon early-game, to make circuits.
1 carbon is 2MJ, energy consumption will be 500kW, so for zero energy gain/loss it should produce 1 carbon every 4 seconds. But make it every 5 seconds for a bit of inefficiency.
]]

-- Create entity.
---@type data.AssemblingMachinePrototype
---@diagnostic disable-next-line: assign-type-mismatch
local charFurnace = table.deepcopy(data.raw.furnace["stone-furnace"])
charFurnace.type = "assembling-machine"
charFurnace.fixed_recipe = "char-carbon"
charFurnace.ingredient_count = 0
charFurnace.name = "char-furnace"
charFurnace.minable.result = "char-furnace"
charFurnace.placeable_by = {item = "char-furnace", count = 1}
charFurnace.crafting_speed = 1
charFurnace.energy_usage = "500kW"
charFurnace.crafting_categories = {"char-furnace"}
charFurnace.graphics_set.animation.layers[1].filename = "__LegendarySpaceAge__/graphics/char-furnace/entity.png"
charFurnace.corpse = "char-furnace-remnants"
charFurnace.allowed_effects = {"pollution"}
charFurnace.icon = "__LegendarySpaceAge__/graphics/char-furnace/item.png"
charFurnace.show_recipe_icon = false
charFurnace.show_recipe_icon_on_map = false
data:extend{charFurnace}

-- Create corpse.
local charFurnaceRemnants = table.deepcopy(data.raw.corpse["stone-furnace-remnants"])
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
data:extend{charFurnaceRemnants}

-- Create item.
local charFurnaceItem = table.deepcopy(data.raw.item["stone-furnace"])
charFurnaceItem.name = "char-furnace"
charFurnaceItem.place_result = "char-furnace"
charFurnaceItem.icon = "__LegendarySpaceAge__/graphics/char-furnace/item.png"
data:extend{charFurnaceItem}

-- Create recipe category.
local charFurnaceRecipeCategory = table.deepcopy(data.raw["recipe-category"]["smelting"])
charFurnaceRecipeCategory.name = "char-furnace"
data:extend{charFurnaceRecipeCategory}

-- Create recipe.
local charFurnaceRecipe = table.deepcopy(data.raw.recipe["stone-furnace"])
charFurnaceRecipe.name = "char-furnace"
charFurnaceRecipe.results = {{type = "item", name = "char-furnace", amount = 1}}
data:extend{charFurnaceRecipe}

-- Create recipe for char/carbon.
local charRecipe = table.deepcopy(data.raw.recipe["rocket-fuel"])
charRecipe.name = "char-carbon"
charRecipe.results = {{type = "item", name = "carbon", amount = 1}}
charRecipe.ingredients = {}
charRecipe.energy_required = 5
charRecipe.enabled = false
charRecipe.subgroup = "raw-material"
charRecipe.category = "char-furnace"
charRecipe.icon = nil
charRecipe.icons = {
	{icon = "__space-age__/graphics/icons/carbon.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/char-furnace/item.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
data:extend{charRecipe}

-- Create tech called "char", unlocking the furnace and recipe.
local charTech = table.deepcopy(data.raw.technology["automation"])
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
charTech.icon = "__LegendarySpaceAge__/graphics/char-furnace/tech.png"
data:extend{charTech}