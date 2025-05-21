--[[ This file creates ingot items and recipes.
Ratios:
	Iron:
		5 iron ore -> 1 iron ingot (+1 stone)
		1 iron ingot -> 5 iron plate OR 5 machine parts OR 5 iron rod
		So 1 ore : 1 plate : 1 machine part : 1 rod.
			(Vanilla is 2 ore : 2 plates : 1 gear : 4 sticks.)
	Steel:
		25 iron ore -> 5 iron ingot (+2 stone) -> 1 steel ingot -> 5 steel plate
		So 5 iron ore : 1 steel plate, same as vanilla.
	Copper:
		5 copper ore -> 1 copper matte (+1 stone)
		1 copper matte -> 1 copper ingot (+1 sulfur) -> 5 plates.
		So 1 ore : 1 plate, same as vanilla.
	We could simplify all of these ratios by just making ingots 1:1 with plates etc. But:
		* The 5-to-1 ratio (plus rusting of plates) makes it much more efficient to ship ingots, but with some time pressure since they spoil to cold ingots.
		* The 5-to-1 ratio makes it easier to reheat compared to having 5x as many ingots.
		* The 5-to-1 ratio lets us have smaller amounts of stone/sulfur byproducts without probability results or bulk recipes.

Re stack sizes:
	Give ingots the same stack size as plates etc, so they're 5x more compact to transport.
	For weights for rockets, rather use correct ratios, eg 1 ingot has the same weight as 5 plates.
]]

local ORE_STACK_SIZE = 50
local INGOT_STACK_SIZE = 100

local INGOT_WEIGHT = ROCKET / 200
	-- 200 ingots per rocket. Each ingot is 5 plates, so 1000 plates per rocket. Vanilla was 1000 plates per rocket.
local ORE_WEIGHT = ROCKET / 500
	-- Same as vanilla, 500 ore per rocket.

local INGOT_TO_ITEM_SECONDS = 2.5
	-- For recipes turning ingots into plates/machine parts/rods etc. They produce 5 output items, so this means assemblers are 1/s, 2/s, 4/s.

local metalTint = {
	copper = {r = 1, g = .639, b = .483, a=1},
	iron = {r = 0.65, g = 0.65, b = 0.65, a=1},
	steel = {r = .955, g = .96, b = 1.0, a=1},
}

-- Make ingots and ingot-reheating recipes.
for i, metal in pairs{"iron", "copper", "steel"} do
	local hotIngotName = "ingot-" .. metal .. "-hot"
	local coldIngotName = "ingot-" .. metal .. "-cold"
	local tint = metalTint[metal]

	local hotIngot = copy(ITEM["iron-plate"])
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
	-- Spoil_ticks and spoil_result are handled in heat-shuttles.lua.
	hotIngot.stack_size = INGOT_STACK_SIZE
	hotIngot.weight = INGOT_WEIGHT
	extend{hotIngot}

	local coldIngot = copy(hotIngot)
	coldIngot.name = coldIngotName
	coldIngot.spoil_ticks = nil
	coldIngot.spoil_result = nil
	coldIngot.icons = {
		{icon="__LegendarySpaceAge__/graphics/metallurgy/ingot.png", icon_size=64, scale=0.5, tint=tint},
	}
	extend{coldIngot}

	---@type data.RecipePrototype
	local ingotHeatingRecipe = copy(RECIPE["stone-brick"])
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
	extend{ingotHeatingRecipe}
end

-- Make recipe for iron ingot -> steel ingot.
local steelIngotRecipe = copy(RECIPE["steel-plate"])
steelIngotRecipe.name = "ingot-steel-hot"
steelIngotRecipe.ingredients = {{type="item", name="ingot-iron-hot", amount=5}}
steelIngotRecipe.results = {{type="item", name="ingot-steel-hot", amount=1}}
steelIngotRecipe.energy_required = 10
steelIngotRecipe.allow_decomposition = true
steelIngotRecipe.hide_from_player_crafting = true
extend{steelIngotRecipe}

-- Make recipe for iron ore -> iron ingot.
local ironIngotRecipe = copy(steelIngotRecipe)
ironIngotRecipe.name = "ingot-iron-hot"
ironIngotRecipe.ingredients = {{type="item", name="iron-ore", amount=5}}
ironIngotRecipe.results = {
	{type="item", name="ingot-iron-hot", amount=1},
	{type="item", name="stone", amount=1, show_details_in_recipe_tooltip=false},
}
ironIngotRecipe.main_product = "ingot-iron-hot"
ironIngotRecipe.energy_required = 5
ironIngotRecipe.enabled = true
ironIngotRecipe.hide_from_player_crafting = true
extend{ironIngotRecipe}

-- Make recipe for copper ore -> copper matte.
local copperMatteRecipe = copy(ironIngotRecipe)
copperMatteRecipe.name = "copper-matte"
--copperMatteRecipe.factoriopedia_description = {"factoriopedia-description.copper-matte"}
copperMatteRecipe.ingredients = {{type="item", name="copper-ore", amount=5}}
copperMatteRecipe.results = {
	{type="item", name="copper-matte", amount=1},
	{type="item", name="stone", amount=1, show_details_in_recipe_tooltip=false},
}
copperMatteRecipe.main_product = "copper-matte"
copperMatteRecipe.energy_required = 5
copperMatteRecipe.enabled = true
copperMatteRecipe.hide_from_player_crafting = true
extend{copperMatteRecipe}

-- Make copper-matte item.
local copperMatte = copy(ITEM["copper-ore"])
copperMatte.name = "copper-matte"
Icon.set(copperMatte, "LSA/metallurgy/matte/matte1")
Icon.variants(copperMatte, "LSA/metallurgy/matte/matte%", 12)
--copperMatte.factoriopedia_description = {"factoriopedia-description.copper-matte"}
extend{copperMatte}

-- Make recipe for copper matte -> copper ingot.
local copperIngotRecipe = copy(steelIngotRecipe)
copperIngotRecipe.name = "ingot-copper-hot"
copperIngotRecipe.ingredients = {{type="item", name="copper-matte", amount=1}}
copperIngotRecipe.results = {
	{type="item", name="ingot-copper-hot", amount=1},
	{type="item", name="sulfur", amount=1, show_details_in_recipe_tooltip=false},
}
copperIngotRecipe.category = "smelting"
copperIngotRecipe.main_product = "ingot-copper-hot"
copperIngotRecipe.energy_required = 5
copperIngotRecipe.enabled = true
extend{copperIngotRecipe}

------------------------------------------------------------------------

-- Adjust recipes for plates: steel, iron, copper.
for _, metal in pairs{"steel", "iron", "copper"} do
	local plateRecipe = RECIPE[metal .. "-plate"]
	plateRecipe.ingredients = {{type="item", name="ingot-" .. metal .. "-hot", amount=1}}
	plateRecipe.results = {{type="item", name=metal .. "-plate", amount=5}}
	plateRecipe.energy_required = INGOT_TO_ITEM_SECONDS
	plateRecipe.category = "crafting"
	plateRecipe.auto_recycle = true -- Allowing it, so that on Fulgora you can unmake plates for cold ingots, then heat those, then make parts/rods/wires/etc.
	plateRecipe.allow_as_intermediate = true
	plateRecipe.result_is_always_fresh = true
	plateRecipe.allow_decomposition = true
end

-- Adjust recipes for other stuff made out of ingots: gears, rods, cables.
for _, vals in pairs{
	{"iron", "iron-gear-wheel", 5, INGOT_TO_ITEM_SECONDS*2},
	{"iron", "iron-stick", 5, INGOT_TO_ITEM_SECONDS},
	{"copper", "copper-cable", 10, INGOT_TO_ITEM_SECONDS},
} do
	local metal, item, num, seconds = vals[1], vals[2], vals[3], vals[4]
	local recipe = RECIPE[item]
	recipe.ingredients = {{type="item", name="ingot-" .. metal .. "-hot", amount=1}}
	recipe.results = {{type="item", name=item, amount=num}}
	recipe.energy_required = seconds
	recipe.auto_recycle = true
	recipe.result_is_always_fresh = true
	recipe.category = "crafting"
	recipe.allow_decomposition = true
	recipe.allow_as_intermediate = true
	recipe.main_product = item
end

------------------------------------------------------------------------

-- Add recipes to techs.
Tech.addRecipeToTech("ingot-steel-hot", "steel-processing", 1)
Tech.addRecipeToTech("heat-ingot-steel", "steel-processing", 2)
RECIPE["heat-ingot-steel"].enabled = false

-- Adjust tech unlock triggers.
TECH["steam-power"].research_trigger.item = "ingot-iron-hot"
TECH["electronics"].research_trigger.item = "ingot-copper-hot"
TECH["steel-axe"].research_trigger.item = "ingot-steel-hot"

--[[ Adjust stack sizes and rocket capacities of basic metal products.
Stack sizes of ores are 50, ingots 100, plates 100, machine parts 100, rods 100.
So transporting ingots is 2 times better for stack size, times 4 times better from recipes, so 8x denser overall.
]]
ITEM["copper-matte"].weight = ORE_WEIGHT -- 2 ore becomes 1 copper matte and 1 sulfur
ITEM["iron-plate"].weight = INGOT_WEIGHT / 5
ITEM["copper-plate"].weight = INGOT_WEIGHT / 5
ITEM["steel-plate"].weight = INGOT_WEIGHT / 5
ITEM["iron-gear-wheel"].weight = INGOT_WEIGHT / 5
ITEM["iron-stick"].weight = INGOT_WEIGHT / 5
ITEM["copper-cable"].weight = INGOT_WEIGHT / 10
ITEM["iron-stick"].stack_size = 200

-- Move iron rod to be enabled from the start, and remove it from techs.
RECIPE["iron-stick"].enabled = true
Tech.removeRecipesFromTechs(
	{"iron-stick"},
	{"railway", "circuit-network", "electric-energy-distribution-1", "concrete"})
