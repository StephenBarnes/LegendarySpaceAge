--[[
Green circuits:
	1 wood + 0.2 resin -> 4 circuit boards
	1 circuit board + 3 copper wire -> 1 green circuit

Red circuits are made after the player has petrochem set up:
	1 carbon + 1 plastic + 1 stone + 1 copper wire -> 1 electronic components
		This represents resistors, capacitors, transistors, etc. that are large enough to pick up by hand.
	1 green circuit + 1 copper wire + 2 electronic components -> 1 red circuit

Blue circuits are made in the late stages of Nauvis part 1, and should have a significantly more complex production process:
	2 stone + 10 sulfuric acid -> 1 silicon wafer
	1 silicon wafer + 1 carbon -> 1 doped wafer
	1 doped wafer + 1 wire + 1 plastic bar -> 20 microchips
	1 red circuit + 4 microchips + 5 sulfuric acid -> 1 blue circuit

On Nauvis you first make "improvised" circuit boards, from just stone. Then later you cut trees and put the wood in a wood-to-resin-and-rubber line and use the resin plus wood to make wooden circuit boards. There's early agricultural towers for bulk wood.
When plastic is unlocked with petrochem, you unlock a recipe for circuit boards from plastic:
	2 plastic bar + 1 resin + 1 rubber -> 8 circuit boards
Generally on Nauvis and Gleba both wood and plastic circuit boards are viable. On Fulgora and Aquilo, only plastic circuit boards are viable. On Vulcanus there's another alternative recipe for ceramic circuit boards using calcite.
]]

local Tech = require("code.util.tech")
local Table = require("code.util.table")
local Item = require("code.util.item")

-- Add circuit board item.
local circuitBoardItem = Table.copyAndEdit(data.raw.item["electronic-circuit"], {
	name = "circuit-board",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/circuit-board-generic.png", icon_size = 64, scale = .5},
	},
	icon = "nil",
	order = "b[circuits]-0",
	subgroup = "circuit-board",
	auto_recycle = false,
	weight = 1000000 / 4000,
})
Item.copySoundsTo("copper-cable", circuitBoardItem)
data:extend{circuitBoardItem}

-- Add recipe for circuit board from wood.
-- 	1 wood + 1 resin -> 4 circuit boards
local woodCircuitBoardRecipe = Table.copyAndEdit(data.raw.recipe["barrel"], {
	name = "wood-circuit-board",
	ingredients = {
		{type = "item", name = "wood", amount = 1},
		{type = "item", name = "resin", amount = 1},
	},
	results = {
		{type = "item", name = "circuit-board", amount = 8},
	},
	order = "b[circuits]-001",
	subgroup = "circuit-board",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/wood-circuit-board.png", icon_size = 64, scale = .5},
		{icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
	},
	auto_recycle = false,
})
data:extend{woodCircuitBoardRecipe}

-- Add recipe for circuit board from plastic.
-- 	2 plastic bar + 1 resin + 0.2 rubber -> 8 circuit boards
local plasticCircuitBoardRecipe = Table.copyAndEdit(data.raw.recipe["barrel"], {
	name = "plastic-circuit-board",
	ingredients = {
		{type = "item", name = "plastic-bar", amount = 2},
		{type = "item", name = "resin", amount = 1},
		--{type = "item", name = "rubber", amount = 0.2}, -- TODO after adding rubber
	},
	results = {
		{type = "item", name = "circuit-board", amount = 8},
	},
	order = "b[circuits]-002",
	subgroup = "circuit-board",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/plastic-circuit-board.png", icon_size = 64, scale = .5},
		{icon = "__base__/graphics/icons/plastic-bar.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
	},
	auto_recycle = false,
})
data:extend{plasticCircuitBoardRecipe}
Tech.addRecipeToTech("plastic-circuit-board", "plastics") -- TODO rather make a separate tech for this, using plastic circuit board sprite.

-- Add recipe for ceramic circuit board.
-- 	4 calcite + 2 resin -> 8 circuit boards
local calciteCircuitBoardRecipe = Table.copyAndEdit(data.raw.recipe["barrel"], {
	name = "calcite-circuit-board",
	ingredients = {
		{type = "item", name = "calcite", amount = 4},
		{type = "item", name = "resin", amount = 1},
	},
	results = {
		{type = "item", name = "circuit-board", amount = 8},
	},
	order = "b[circuits]-003",
	subgroup = "circuit-board",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/ceramic-circuit-board.png", icon_size = 64, scale = .5},
		{icon = "__space-age__/graphics/icons/calcite.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
	},
	category = "metallurgy",
	auto_recycle = false,
})
data:extend{calciteCircuitBoardRecipe}
Tech.addRecipeToTech("calcite-circuit-board", "calcite-processing") -- TODO rather make a separate tech for this? Unlocked by mining like 10 calcite. Use the ceramic circuit board sprite.

--[[ Add "improvised" circuit board recipe, only handcraftable.
	Improvise circuit board: 1 stone brick -> 1 circuit board
		Needed because all ways of making circuit boards require resin, which can't be obtained on Aquilo without buildings that require electronic circuits, creating a circular dependency. Also same on Nauvis at the start.
]]
local improvisedCircuitBoardRecipe = Table.copyAndEdit(data.raw.recipe["electronic-circuit"], {
	name = "improvised-circuit-board",
	ingredients = {
		{type = "item", name = "stone-brick", amount = 1},
	},
	results = {
		{type = "item", name = "circuit-board", amount = 1},
	},
	order = "b[circuits]-004",
	subgroup = "circuit-board",
	icon = "nil",
	icons = {
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/circuit-board-generic.png", icon_size = 64, scale = 0.5},
		{icon = "__core__/graphics/icons/mip/slot-item-in-hand-black.png", icon_size = 64, mipmap_count = 2, scale = 0.4, shift = {5, 4}},
		--{icon = "__core__/graphics/icons/mip/slot-item-in-hand.png", icon_size = 64, mipmap_count = 2, scale = 0.33, shift = {7, 6}},
	},
	enabled = false,
	energy_required = 1,
	category = "handcrafting-only",
	auto_recycle = false,
})
data:extend{improvisedCircuitBoardRecipe}
Tech.addRecipeToTech("improvised-circuit-board", "electronics", 2)

-- Create tech for wood circuit boards.
local woodCircuitBoardTech = Table.copyAndEdit(data.raw.technology["automation"], {
	name = "wood-circuit-board",
	effects = {
		{type = "unlock-recipe", recipe = "wood-resin"},
		{type = "unlock-recipe", recipe = "wood-circuit-board"},
	},
	icon = "nil",
	icons = {
		--{icon = "__LegendarySpaceAge__/graphics/circuit-boards/wood-circuit-board-tech.png", icon_size = 256, scale = 0.8, mipmap_count = 4, shift = {10, -10}},
		--{icon = "__LegendarySpaceAge__/graphics/resin/tech.png", icon_size = 256, scale = 0.4, mipmap_count = 4, shift = {-10, 10}},
		{icon = "__LegendarySpaceAge__/graphics/circuit-boards/wood-circuit-board-tech.png", icon_size = 256, mipmap_count = 4},
	},
	prerequisites = {"steam-power"},
	ignore_tech_cost_multiplier = false,
	unit = {
		count = 15,
		ingredients = {
			{"automation-science-pack", 1},
		},
		time = 15,
	},
	research_trigger = "nil",
})
data:extend{woodCircuitBoardTech}

-- Create item for silicon (undoped wafers).
local silicon = Table.copyAndEdit(data.raw.item["plastic-bar"], {
	name = "silicon",
	icon = "__LegendarySpaceAge__/graphics/circuit-chains/silicon.png",
	icon_size = 64,
	subgroup = "complex-circuit-intermediates",
	order = "001",
	stack_size = 200,
})
data:extend{silicon}

-- Create recipe for silicon.
local siliconRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "silicon",
	ingredients = {
		{type = "item", name = "sand", amount = 2},
		{type = "fluid", name = "sulfuric-acid", amount = 10},
	},
	results = {
		{type = "item", name = "silicon", amount = 1},
	},
	subgroup = "nil",
	icon = "nil",
	icons = "nil",
})
data:extend{siliconRecipe}
Tech.addRecipeToTech("silicon", "processing-unit", 1)
Tech.addRecipeToTech("silicon", "solar-energy", 1)

-- Create item for doped wafers.
local dopedWafer = Table.copyAndEdit(data.raw.item["plastic-bar"], {
	name = "doped-wafer",
	icon = "__LegendarySpaceAge__/graphics/circuit-chains/doped-wafer.png",
	icon_size = 64,
	subgroup = "complex-circuit-intermediates",
	order = "002",
	stack_size = 100,
})
data:extend{dopedWafer}

-- Create item for microchips
local microchip = table.deepcopy(data.raw.item["processing-unit"])
microchip.name = "microchip"
microchip.icon = "__LegendarySpaceAge__/graphics/circuit-chains/microchip.png"
microchip.icon_size = 64
microchip.subgroup = "complex-circuit-intermediates"
microchip.order = "003"
microchip.stack_size = 200
data:extend{microchip}

-- Create recipe for doped wafers.
local dopedWaferRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "doped-wafer",
	ingredients = {
		{type = "item", name = "silicon", amount = 1},
		{type = "item", name = "carbon", amount = 1},
	},
	results = {
		{type = "item", name = "doped-wafer", amount = 1},
	},
	subgroup = "nil",
	icon = "nil",
	icons = "nil",
	category = "chemistry-or-electronics",
	energy_required = 24,
})
data:extend{dopedWaferRecipe}
Tech.addRecipeToTech("doped-wafer", "processing-unit", 2)

-- Create recipe for microchips.
local microchipRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "microchip",
	ingredients = {
		{type = "item", name = "doped-wafer", amount = 1},
		{type = "item", name = "wiring", amount = 1},
		{type = "item", name = "plastic-bar", amount = 1},
	},
	results = {
		{type = "item", name = "microchip", amount = 20},
	},
	subgroup = "nil",
	icon = "nil",
	icons = "nil",
	category = "electronics",
	energy_required = 12,
})
data:extend{microchipRecipe}
Tech.addRecipeToTech("microchip", "processing-unit", 3)

-- Edit recipe for blue circuits (processing-unit) to use doped wafers.
-- 1 red circuit + 4 microchips + 5 sulfuric acid -> 1 blue circuit
-- Original recipe was 5 sulfuric acid + 2 red circuit + 20 green circuit.
data.raw.recipe["processing-unit"].ingredients = {
	{type = "item", name = "advanced-circuit", amount = 1},
	{type = "item", name = "microchip", amount = 4},
	{type = "fluid", name = "sulfuric-acid", amount = 5},
}
-- Make blue circuit recipe slower, as compromise for making it cheaper in materials.
data.raw.recipe["processing-unit"].energy_required = 6

-- Create item for electronic components.
local electronicComponents = Table.copyAndEdit(data.raw.item["advanced-circuit"], {
	name = "electronic-components",
	icon = "nil",
	subgroup = "complex-circuit-intermediates",
	order = "001",
	stack_size = 200,
	icons = {{icon = "__LegendarySpaceAge__/graphics/circuit-chains/electronic-components/1.png", icon_size = 64, scale = 0.5}},
	pictures = {
		{filename = "__LegendarySpaceAge__/graphics/circuit-chains/electronic-components/1.png", size = 64, scale = 0.5},
		{filename = "__LegendarySpaceAge__/graphics/circuit-chains/electronic-components/2.png", size = 64, scale = 0.5},
		{filename = "__LegendarySpaceAge__/graphics/circuit-chains/electronic-components/3.png", size = 64, scale = 0.5},
	},
})
data:extend{electronicComponents}

-- Create a recipe for electronic components.
-- 1 carbon + 1 plastic + 1 sand + 1 copper wire -> 2 electronic components
local electronicComponentsRecipe = Table.copyAndEdit(data.raw.recipe["plastic-bar"], {
	name = "electronic-components",
	ingredients = {
		{type = "item", name = "carbon", amount = 1},
		{type = "item", name = "plastic-bar", amount = 1},
		{type = "item", name = "wiring", amount = 1},
	},
	results = {
		{type = "item", name = "electronic-components", amount = 1},
	},
	subgroup = "nil",
	icon = "nil",
	icons = "nil",
	category = "electronics",
	energy_required = 6,
})
data:extend{electronicComponentsRecipe}
Tech.addRecipeToTech("electronic-components", "advanced-circuit", 1)

-- Edit recipe for red circuits.
-- 1 circuit board + 2 copper cable + 2 electronic components -> 1 red circuit
-- Originally 2 green circuits + 2 plastic bar + 4 copper cable.
data.raw.recipe["advanced-circuit"].ingredients = {
	{type = "item", name = "electronic-circuit", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "electronic-components", amount = 2},
}

-- Move circuits to complex-circuit-intermediates subgroup.
data.raw.item["electronic-circuit"].subgroup = "complex-circuit-intermediates"
data.raw.item["advanced-circuit"].subgroup = "complex-circuit-intermediates"
data.raw.item["processing-unit"].subgroup = "complex-circuit-intermediates"

-- Edit green circuit ingredients.
data.raw.recipe["electronic-circuit"].ingredients = {
	{type = "item", name = "circuit-board", amount = 1},
	{type = "item", name = "wiring", amount = 2},
	{type = "item", name = "carbon", amount = 1},
}