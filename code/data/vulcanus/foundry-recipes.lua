--[[ This file modifies and creates recipes for the foundry.
Foundries are used for processing molten metals.
Following the standard that roughly 10 molten metal equals 1 plate. Except steel.
Basic process from lava:
	500 lava + 1 calcite + 1 carbon -> 250 molten iron + 10 copper matte + 20 stone
	(It might be more realistic and easy to have separate iron and copper recipes. But tying them together like this is interesting for gameplay, since the player will get too many of one, and have to set up a system to balance iron and copper by dumping excess into the lava. It's also realistic.)
	Old recipes were:
		1 calcite + 500 lava -> 10 stone + 250 molten iron
		1 calcite + 500 lava -> 15 stone + 250 molten copper
		And then 10 molten iron/copper is 1 plate; 30 molten iron is 1 steel plate.
	So, we're keeping it similarly difficult to produce those, since 10 copper matte = 20 ore = 5 ingots = 20 plates.
Copper matte can be directly turned into molten copper:
	25 copper matte -> 500 molten copper + 10 sulfur
Turning ores into the same metal intermediates, in a foundry (not used on Vulcanus):
	50 iron ore + 1 calcite + 2 carbon -> 500 molten iron + 25 stone
	(Copper ore to matte actually has to be done in a furnace. No foundry recipe, since it's not molten.)
	Old recipes were:
		50 iron ore + 1 calcite -> 500 molten iron
		50 copper ore + 1 calcite -> 500 molten copper
Turning molten metals into items, in a foundry:
	20 molten iron + 1 water -> 2 iron plate + 10 steam
	The water ingredient and steam byproduct represent water cooling; this adds substantial fluid management complexity to all of the foundries casting metal items.
	Similar recipes for copper plates, iron rods, iron machine parts, copper cables, and possibly more.
	Casting iron items makes them start 20% spoiled (from rust).
Molten steel recipes:
	100 molten iron + 1 carbon + 1 calcite -> 100 molten steel (in a foundry)
	30 molten steel + 1 water -> 1 steel plate + 10 steam
			Originally 30 molten iron -> 1 steel plate.

Tungsten ore is only found on Vulcanus, and is also processed in foundries:
	2 tungsten ore + 2 carbon -> 20 molten tungsten + 1 stone (representing slag)
	10 molten tungsten + 1 molten steel -> 10 molten tungsten-steel
	10 molten tungsten + 1 carbon -> 10 molten tungsten carbide
	10 molten tungsten-steel + 0.2 water -> 1 tungsten-steel plate + 0.2 steam
	10 molten tungsten carbide + 0.2 water -> 1 tungsten carbide plate + 0.2 steam
Since tungsten carbide is needed to make foundries, to avoid circular dependency we also allow smelting tungsten ore directly to tungsten carbide in a furnace. This is simple but very inefficient, consuming a lot of carbon.

Vulcanus unlocks a foundry recipe for concrete without water, using sulfur:
	10 stone brick + 5 sulfur -> 10 concrete (representing sulfur concrete)
]]

local Table = require("code.util.table")
local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

local newData = {}

-- Make recipe for metals-from-lava.
local metalsFromLavaRecipe = Table.copyAndEdit(data.raw.recipe["molten-iron-from-lava"], {
	name = "metals-from-lava",
	ingredients = {
		{type = "fluid", name = "lava", amount = 500},
		{type = "item", name = "calcite", amount = 1},
		{type = "item", name = "carbon", amount = 1},
	},
	results = {
		{type = "fluid", name = "molten-iron", amount = 250},
		{type = "item", name = "copper-matte", amount = 10},
		{type = "item", name = "stone", amount = 20},
	},
	enabled = false,
	allow_decomposition = true,
	allow_as_intermediate = true,
	icon = "nil",
	icons = {{
		icon = "__LegendarySpaceAge__/graphics/vulcanus/metals-from-lava.png",
		icon_size = 64,
		scale = 0.5,
	}},
})
table.insert(newData, metalsFromLavaRecipe)

-- Hide old recipes for molten metals from lava, remove from tech, add new recipe to tech.
Recipe.hide("molten-iron-from-lava")
Recipe.hide("molten-copper-from-lava")
Tech.removeRecipesFromTechs({"molten-iron-from-lava", "molten-copper-from-lava"}, {"foundry"})
Tech.addRecipeToTech("metals-from-lava", "foundry", 3)

-- Edit recipe for copper-ore-to-molten-copper to instead use copper matte.
local matteMeltRecipe = data.raw.recipe["molten-copper"]
matteMeltRecipe.ingredients = {{type = "item", name = "copper-matte", amount = 25}}
matteMeltRecipe.results = {
	{type = "fluid", name = "molten-copper", amount = 500},
	{type = "item", name = "sulfur", amount = 10},
}

-- Edit recipe for iron-ore-to-molten-iron.
local ironOreMeltRecipe = data.raw.recipe["molten-iron"]
ironOreMeltRecipe.ingredients = {
	{type = "item", name = "iron-ore", amount = 50},
	{type = "item", name = "calcite", amount = 1},
	{type = "item", name = "carbon", amount = 2},
}
ironOreMeltRecipe.results = {
	{type = "fluid", name = "molten-iron", amount = 500},
	{type = "item", name = "stone", amount = 25},
}

-- Adjust molten iron icon, to differentiate it from molten steel.
local ironFluidIcon = "__LegendarySpaceAge__/graphics/vulcanus/molten-iron.png"
if data.raw.fluid["molten-iron"].icon then
	data.raw.fluid["molten-iron"].icon = ironFluidIcon
else
	data.raw.fluid["molten-iron"].icons[1].icon = ironFluidIcon
end

-- Make molten steel fluid.
local moltenSteelFluid = Table.copyAndEdit(data.raw.fluid["molten-iron"], {
	name = "molten-steel",
	icon = "nil",
	icons = {{
		icon = "__LegendarySpaceAge__/graphics/vulcanus/molten-steel.png",
		icon_size = 64,
		scale = 0.5,
	}},
	order = "b[new-fluid]-b[vulcanus]-c[molten-steel]",
	base_color = {.3, .4, .4},
	flow_color = {.5, .7, .7},
	visualization_color = {.2, 1, 1}, -- Cyan for the diagram-like lines drawn on pipes.
})
table.insert(newData, moltenSteelFluid)

-- Make recipe for molten steel.
local moltenSteelRecipe = Table.copyAndEdit(data.raw.recipe["molten-iron"], {
	name = "molten-steel",
	ingredients = {
		{type = "fluid", name = "molten-iron", amount = 100},
		{type = "item", name = "carbon", amount = 1},
		{type = "item", name = "calcite", amount = 1},
	},
	results = {
		{type = "fluid", name = "molten-steel", amount = 100},
	},
	main_product = "molten-steel",
	order = "a[melting]-d[molten-steel]",
})
table.insert(newData, moltenSteelRecipe)
Tech.addRecipeToTech("molten-steel", "foundry", 8)

-- Adjust recipes for casting molten metals into items.
Table.setFields(data.raw.recipe["casting-iron"], {
	ingredients = {
		{type = "fluid", name = "molten-iron", amount = 20},
		{type = "fluid", name = "water", amount = 1},
	},
	results = {
		{type = "item", name = "iron-plate", amount = 2, percent_spoiled = .2},
		{type = "fluid", name = "steam", amount = 10, temperature = 500},
	},
	main_product = "iron-plate",
})
Table.setFields(data.raw.recipe["casting-copper"], {
	ingredients = {
		{type = "fluid", name = "molten-copper", amount = 20},
		{type = "fluid", name = "water", amount = 1},
	},
	results = {
		{type = "item", name = "copper-plate", amount = 2},
		{type = "fluid", name = "steam", amount = 10, temperature = 500},
	},
	main_product = "copper-plate",
})
Table.setFields(data.raw.recipe["casting-steel"], {
	ingredients = {
		{type = "fluid", name = "molten-steel", amount = 30},
		{type = "fluid", name = "water", amount = 1},
	},
	results = {
		{type = "item", name = "steel-plate", amount = 1},
		{type = "fluid", name = "steam", amount = 10, temperature = 500},
	},
	main_product = "steel-plate",
})
Table.setFields(data.raw.recipe["casting-iron-gear-wheel"], {
	ingredients = {
		{type = "fluid", name = "molten-iron", amount = 10},
		{type = "fluid", name = "water", amount = 1},
	},
	results = {
		{type = "item", name = "iron-gear-wheel", amount = 1, percent_spoiled = .2},
		{type = "fluid", name = "steam", amount = 10, temperature = 500},
	},
	main_product = "iron-gear-wheel",
})
Table.setFields(data.raw.recipe["casting-iron-stick"], {
	ingredients = {
		{type = "fluid", name = "molten-iron", amount = 20},
		{type = "fluid", name = "water", amount = 1},
	},
	results = {
		{type = "item", name = "iron-stick", amount = 4, percent_spoiled = .2},
		{type = "fluid", name = "steam", amount = 10, temperature = 500},
	},
	main_product = "iron-stick",
})
Table.setFields(data.raw.recipe["casting-low-density-structure"], {
	-- Originally 5 plastic bar + 80 molten iron + 250 molten copper
	ingredients = {
		{type = "item", name = "plastic-bar", amount = 5},
		{type = "fluid", name = "molten-steel", amount = 60},
		{type = "fluid", name = "molten-copper", amount = 200},
		{type = "fluid", name = "water", amount = 1},
	},
	results = {
		{type = "item", name = "low-density-structure", amount = 1},
		{type = "fluid", name = "steam", amount = 10, temperature = 500},
	},
	main_product = "low-density-structure",
})
Table.setFields(data.raw.recipe["casting-copper-cable"], {
	ingredients = {
		{type = "fluid", name = "molten-copper", amount = 20},
		{type = "fluid", name = "water", amount = 1},
	},
	results = {
		{type = "item", name = "copper-cable", amount = 8},
		{type = "fluid", name = "steam", amount = 10, temperature = 500},
	},
	main_product = "copper-cable",
})
Table.setFields(data.raw.recipe["casting-pipe"], {
	ingredients = {
		{type = "fluid", name = "molten-iron", amount = 10},
		{type = "fluid", name = "water", amount = 1},
	},
	results = {
		{type = "item", name = "pipe", amount = 1},
		{type = "fluid", name = "steam", amount = 10, temperature = 500},
	},
	main_product = "pipe",
})
Table.setFields(data.raw.recipe["casting-pipe-to-ground"], {
	ingredients = {
		{type = "item", name = "pipe", amount = 10},
		{type = "fluid", name = "molten-iron", amount = 50},
		{type = "fluid", name = "water", amount = 1},
	},
	results = {
		{type = "item", name = "pipe-to-ground", amount = 2},
		{type = "fluid", name = "steam", amount = 10, temperature = 500},
	},
	main_product = "pipe-to-ground",
})

-- Add recipe for casting advanced parts. (Bc can't make ingots from foundries.)
local castingAdvancedPartsRecipe = Table.copyAndEdit(data.raw.recipe["casting-iron-gear-wheel"], {
	name = "casting-advanced-parts",
	ingredients = {
		{type = "fluid", name = "molten-steel", amount = 80},
		{type = "fluid", name = "water", amount = 1},
		{type = "item", name = "rubber", amount = 2},
		{type = "item", name = "plastic-bar", amount = 4},
		{type = "fluid", name = "lubricant", amount = 10},
	},
	results = {
		{type = "item", name = "advanced-parts", amount = 16},
		{type = "fluid", name = "steam", amount = 10, temperature = 500},
	},
	main_product = "advanced-parts",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/parts-advanced/bearing-3.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={-4, 4}},
		{icon = "__space-age__/graphics/icons/fluid/molten-iron.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={4, -4}},
	},
	order = "b[casting]-f[casting-advanced-parts]",
})
table.insert(newData, castingAdvancedPartsRecipe)
Tech.addRecipeToTech("casting-advanced-parts", "foundry")

-- Make recipes for molten tungsten, tungsten steel, and tungsten carbide.
-- TODO

-- Add casting recipes for tungsten steel and tungsten carbide?
-- TODO

-- TODO reorder unlocks in foundry tech, currently stupid eg low-density structure is early.

------------------------------------------------------------------------
data:extend(newData)
------------------------------------------------------------------------