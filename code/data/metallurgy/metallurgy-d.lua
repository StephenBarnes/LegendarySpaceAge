--[[
8 iron ore -> 2 iron ingot (+2 stone) -> 1 steel ingot -> 4 steel plate
4 iron ore -> 1 iron ingot (+1 stone) -> 4 iron plate OR 4 machine parts OR 8 iron rod
4 copper ore -> 2 copper matte (+2 stone) -> 1 copper ingot (+1 sulfur) -> 4 copper plate
]]

local Tech = require("code.util.tech")

local ROCKET_MASS = 1000000
local INGOT_COOLING_TIME = 60 * 60 * 5
local INGOT_WEIGHT = ROCKET_MASS / 200
	-- 200 ingots per rocket. Each ingot is 4 plates, so 800 plates per rocket. Vanilla was 1000 plates per rocket.
local ORE_WEIGHT = ROCKET_MASS / 500
	-- Same as vanilla, 500 ore per rocket.


local metalTint = {
	--copper = {r = .831, g = .467, b = .361, a=1}, --too dull
	--copper = {r = .839, g = .557, b = .435, a=1}, --too desaturated, and not light enough
	--copper = {r = 1, g = .531, b = .329, a=1}, -- Almost right, but a bit too dark still.
	copper = {r = 1, g = .639, b = .483, a=1},
	iron = {r = 0.65, g = 0.65, b = 0.65, a=1},
	steel = {r = .955, g = .96, b = 1.0, a=1},
}

-- Make ingots and ingot-reheating recipes.
for i, metal in pairs{"iron", "copper", "steel"} do
	local hotIngotName = "ingot-" .. metal .. "-hot"
	local coldIngotName = "ingot-" .. metal .. "-cold"
	local tint = metalTint[metal]

	local hotIngot = table.deepcopy(data.raw.item["iron-plate"])
	hotIngot.name = hotIngotName
	hotIngot.icons = {
		{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot-heat.png", icon_size=64, scale=0.5},
		{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.5, tint=tint},
	}
	hotIngot.pictures = {
		{
			layers = {
				{filename = "__LegendarySpaceAge__/graphics/metallurgy/ingot-heat.png", size=64, scale=0.5, draw_as_glow=true},
				{filename = "__LegendarySpaceAge__/graphics/metallurgy/ingot.png", size=64, scale=0.5, tint=tint},
			}
		}
	}
	hotIngot.icon = nil
	hotIngot.icon_size = nil
	hotIngot.spoil_ticks = INGOT_COOLING_TIME
	hotIngot.spoil_result = coldIngotName
	hotIngot.order = "a[smelting]-0-" .. i
	hotIngot.stack_size = 100
	hotIngot.weight = INGOT_WEIGHT
	hotIngot.subgroup = "ingots"
	data:extend{hotIngot}

	local coldIngot = table.deepcopy(hotIngot)
	coldIngot.name = coldIngotName
	coldIngot.spoil_ticks = nil
	coldIngot.spoil_result = nil
	coldIngot.icons = {
		{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.5, tint=tint},
	}
	coldIngot.order = "a[smelting]-1-" .. i
	data:extend{coldIngot}

	---@type data.RecipePrototype
	local ingotHeatingRecipe = table.deepcopy(data.raw.recipe["stone-brick"])
	ingotHeatingRecipe.name = "heat-ingot-" .. metal
	ingotHeatingRecipe.ingredients = {
		{type="item", name=coldIngotName, amount=1},
	}
	ingotHeatingRecipe.results = {
		{type="item", name=hotIngotName, amount=1},
	}
	ingotHeatingRecipe.energy_required = 1
	ingotHeatingRecipe.hide_from_player_crafting = true
	ingotHeatingRecipe.category = "smelting"
	ingotHeatingRecipe.enabled = true
	ingotHeatingRecipe.icons = {
		{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot-heat.png", icon_size=64, scale=0.5},
		{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.4, tint=tint},
	}
	ingotHeatingRecipe.result_is_always_fresh = true
	data:extend{ingotHeatingRecipe}
end

-- Make recipe for iron ingot -> steel ingot.
local steelIngotRecipe = table.deepcopy(data.raw.recipe["steel-plate"])
steelIngotRecipe.name = "ingot-steel-hot"
steelIngotRecipe.ingredients = {{type="item", name="ingot-iron-hot", amount=2}}
steelIngotRecipe.results = {{type="item", name="ingot-steel-hot", amount=1}}
steelIngotRecipe.energy_required = 20
steelIngotRecipe.allow_decomposition = true
steelIngotRecipe.main_product = "ingot-steel-hot"
data:extend{steelIngotRecipe}

-- Make recipe for iron ore -> iron ingot.
local ironIngotRecipe = table.deepcopy(steelIngotRecipe)
ironIngotRecipe.name = "ingot-iron-hot"
ironIngotRecipe.ingredients = {{type="item", name="iron-ore", amount=4}}
ironIngotRecipe.results = {
	{type="item", name="ingot-iron-hot", amount=1},
	{type="item", name="stone", amount=1, show_details_in_recipe_tooltip=false},
}
ironIngotRecipe.main_product = "ingot-iron-hot"
ironIngotRecipe.energy_required = 4
ironIngotRecipe.enabled = true
data:extend{ironIngotRecipe}

-- Make recipe for copper ore -> copper matte.
local copperMatteRecipe = table.deepcopy(ironIngotRecipe)
copperMatteRecipe.name = "copper-matte"
copperMatteRecipe.ingredients = {{type="item", name="copper-ore", amount=2}}
copperMatteRecipe.results = {
	{type="item", name="copper-matte", amount=1},
	{type="item", name="stone", amount=1, show_details_in_recipe_tooltip=false},
}
copperMatteRecipe.main_product = "copper-matte"
copperMatteRecipe.energy_required = 2
copperMatteRecipe.enabled = true
data:extend{copperMatteRecipe}

-- Make copper-matte item.
local copperMattePictures = {}
for i = 1, 12 do
	table.insert(copperMattePictures, {
		filename = "__LegendarySpaceAge__/graphics/metallurgy/matte/matte" .. i .. ".png",
		size = 64,
		scale = 0.5,
		mipmap_count = 4,
	})
end
local copperMatte = table.deepcopy(data.raw.item["copper-ore"])
copperMatte.name = "copper-matte"
copperMatte.icons = {
	{icon="__LegendarySpaceAge__/graphics/metallurgy/matte/matte1.png", icon_size=64, scale=0.5},
}
copperMatte.pictures = copperMattePictures
copperMatte.subgroup = "raw-material"
copperMatte.order = "a1"
data:extend{copperMatte}

-- Make recipe for copper matte -> copper ingot.
local copperIngotRecipe = table.deepcopy(steelIngotRecipe)
copperIngotRecipe.name = "ingot-copper-hot"
copperIngotRecipe.ingredients = {{type="item", name="copper-matte", amount=2}}
copperIngotRecipe.results = {
	{type="item", name="ingot-copper-hot", amount=1},
	{type="item", name="sulfur", amount=1, show_details_in_recipe_tooltip=false},
}
copperIngotRecipe.category = "smelting"
copperIngotRecipe.main_product = "ingot-copper-hot"
copperIngotRecipe.energy_required = 4
copperIngotRecipe.enabled = true
data:extend{copperIngotRecipe}

-- Adjust steel plate recipe.
local steelPlateRecipe = data.raw.recipe["steel-plate"]
steelPlateRecipe.ingredients = {{type="item", name="ingot-steel-hot", amount=1}}
steelPlateRecipe.results = {{type="item", name="steel-plate", amount=4}}
steelPlateRecipe.category = "crafting"
steelPlateRecipe.energy_required = 1
steelPlateRecipe.auto_recycle = true
steelPlateRecipe.allow_as_intermediate = true
steelPlateRecipe.allow_decomposition = true
steelPlateRecipe.always_show_products = true
steelPlateRecipe.main_product = "steel-plate"

-- Adjust iron plate recipe.
local ironPlateRecipe = data.raw.recipe["iron-plate"]
ironPlateRecipe.ingredients = {{type="item", name="ingot-iron-hot", amount=1}}
ironPlateRecipe.results = {{type="item", name="iron-plate", amount=4}}
ironPlateRecipe.category = "crafting"
ironPlateRecipe.energy_required = 1
ironPlateRecipe.auto_recycle = true
ironPlateRecipe.allow_as_intermediate = true
ironPlateRecipe.allow_decomposition = true
ironPlateRecipe.always_show_products = true

-- Adjust copper plate recipe.
local copperPlateRecipe = data.raw.recipe["copper-plate"]
copperPlateRecipe.ingredients = {{type="item", name="ingot-copper-hot", amount=1}}
copperPlateRecipe.results = {{type="item", name="copper-plate", amount=4}}
copperPlateRecipe.category = "crafting"
copperPlateRecipe.energy_required = 1
copperPlateRecipe.auto_recycle = true
copperPlateRecipe.allow_as_intermediate = true
copperPlateRecipe.allow_decomposition = true
copperPlateRecipe.always_show_products = true

-- Adjust iron gear recipe.
local ironGearRecipe = data.raw.recipe["iron-gear-wheel"]
ironGearRecipe.ingredients = {{type="item", name="ingot-iron-hot", amount=1}}
ironGearRecipe.results = {{type="item", name="iron-gear-wheel", amount=2}}
ironGearRecipe.energy_required = 1
ironGearRecipe.auto_recycle = true
ironGearRecipe.always_show_products = true

-- Adjust recipe for iron rods.
local ironStickRecipe = data.raw.recipe["iron-stick"]
ironStickRecipe.ingredients = {{type="item", name="ingot-iron-hot", amount=1}}
ironStickRecipe.results = {{type="item", name="iron-stick", amount=8}}
ironStickRecipe.energy_required = 1
ironStickRecipe.auto_recycle = true
ironStickRecipe.always_show_products = true

-- Adjust recipe for copper cables.
local copperCableRecipe = data.raw.recipe["copper-cable"]
copperCableRecipe.ingredients = {{type="item", name="ingot-copper-hot", amount=1}}
copperCableRecipe.results = {{type="item", name="copper-cable", amount=8}}
copperCableRecipe.energy_required = 1
copperCableRecipe.auto_recycle = true
copperCableRecipe.always_show_products = true

-- Adjust recipe for low-density structures.
local lowDensityStructureRecipe = data.raw.recipe["low-density-structure"]
lowDensityStructureRecipe.ingredients = {
	{type="item", name="ingot-copper-hot", amount=5},
	{type="item", name="ingot-steel-hot", amount=2},
	{type="item", name="plastic-bar", amount=3},
	{type="item", name="resin", amount=1},
}
lowDensityStructureRecipe.auto_recycle = true

-- Put basic metal intermediates in their own subgroup.
for i, itemName in pairs{"iron-plate", "iron-gear-wheel", "iron-stick", "copper-plate", "copper-cable", "steel-plate"} do
	data.raw.item[itemName].subgroup = "basic-metal-intermediates"
	data.raw.item[itemName].order = ""..i
end

------------------------------------------------------------------------

-- Add recipes to techs.
Tech.addRecipeToTech("ingot-steel-hot", "steel-processing", 1)
Tech.addRecipeToTech("heat-ingot-steel", "steel-processing", 2)
data.raw.recipe["heat-ingot-steel"].enabled = false

-- Adjust tech unlock triggers.
data.raw.technology["steam-power"].research_trigger.item = "ingot-iron-hot"
data.raw.technology["electronics"].research_trigger.item = "ingot-copper-hot"
data.raw.technology["steel-axe"].research_trigger.item = "ingot-steel-hot"

-- Adjust stack sizes and rocket capacities of basic metal products.
data.raw.item["copper-matte"].weight = ORE_WEIGHT -- 2 ore becomes 1 copper matte and 1 sulfur
data.raw.item["iron-plate"].weight = INGOT_WEIGHT / 4
data.raw.item["copper-plate"].weight = INGOT_WEIGHT / 4
data.raw.item["steel-plate"].weight = INGOT_WEIGHT / 4
data.raw.item["iron-gear-wheel"].weight = ROCKET_MASS / 2000
data.raw.item["iron-stick"].weight = ROCKET_MASS / 8000
data.raw.item["copper-cable"].weight = ROCKET_MASS / 8000

-- Add output slots to furnaces - otherwise some recipe products just disappear, apparently.
for _, furnace in pairs{"stone-furnace", "steel-furnace", "gas-furnace", "electric-furnace"} do
	data.raw.furnace[furnace].result_inventory_size = 2
end

--[[ Stack sizes and weights:
Stack sizes of ores are 50, ingots 100, plates 100, machine parts 100, rods 100.
So transporting ingots is 2 times better for stack size, times 4 times better from recipes, so 8x denser overall.
]]
data.raw.item["copper-matte"].weight = ORE_WEIGHT -- 2 ore becomes 1 copper matte and 1 sulfur.
data.raw.item["iron-plate"].weight = INGOT_WEIGHT / 4
data.raw.item["copper-plate"].weight = INGOT_WEIGHT / 4
data.raw.item["steel-plate"].weight = INGOT_WEIGHT / 4
data.raw.item["iron-gear-wheel"].weight = INGOT_WEIGHT / 4
data.raw.item["iron-stick"].weight = INGOT_WEIGHT / 8
data.raw.item["copper-cable"].weight = INGOT_WEIGHT / 8
-- Iron rod stacks should be as dense as iron plate stacks.
data.raw.item["iron-stick"].stack_size = 200