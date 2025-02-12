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
	1 red circuit + 5 microchips + 5 sulfuric acid -> 1 blue circuit

On Nauvis you first make "makeshift" circuit boards, from just stone. Then later you cut trees and put the wood in a wood-to-resin-and-rubber line and use the resin plus wood to make wooden circuit boards. There's early agricultural towers for bulk wood.
When plastic is unlocked with petrochem, you unlock a recipe for circuit boards from plastic:
	2 plastic bar + 1 resin -> 10 circuit boards
Generally on Nauvis and Gleba both wood and plastic circuit boards are viable. On Fulgora and Aquilo, only plastic circuit boards are viable. On Vulcanus there's another alternative recipe for ceramic circuit boards using calcite.
]]

-- Add circuit board item.
local circuitBoardItem = copy(ITEM["electronic-circuit"])
circuitBoardItem.name = "circuit-board"
circuitBoardItem.icons = {
	{icon = "__LegendarySpaceAge__/graphics/circuit-boards/circuit-board-generic.png", icon_size = 64, scale = .5},
}
circuitBoardItem.icon = nil
circuitBoardItem.order = "b[circuits]-0"
circuitBoardItem.subgroup = "circuit-board"
circuitBoardItem.weight = 1000000 / 4000
Item.copySoundsTo("copper-cable", circuitBoardItem)
data:extend{circuitBoardItem}

-- Add recipe for circuit board from wood.
-- 	1 wood + 1 resin -> 4 circuit boards
local woodCircuitBoardRecipe = copy(RECIPE["barrel"])
woodCircuitBoardRecipe.name = "wood-circuit-board"
woodCircuitBoardRecipe.ingredients = {
	{type = "item", name = "wood", amount = 1},
	{type = "item", name = "resin", amount = 1},
}
woodCircuitBoardRecipe.results = {
	{type = "item", name = "circuit-board", amount = 10},
}
woodCircuitBoardRecipe.order = "b[circuits]-001"
woodCircuitBoardRecipe.subgroup = "circuit-board"
woodCircuitBoardRecipe.icon = nil
woodCircuitBoardRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/circuit-boards/wood-circuit-board.png", icon_size = 64, scale = .5},
	{icon = "__base__/graphics/icons/wood.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
woodCircuitBoardRecipe.auto_recycle = false
data:extend{woodCircuitBoardRecipe}

-- Add recipe for circuit board from plastic.
-- 	2 plastic bar + 1 resin + 0.2 rubber -> 8 circuit boards
local plasticCircuitBoardRecipe = copy(RECIPE["barrel"])
plasticCircuitBoardRecipe.name = "plastic-circuit-board"
plasticCircuitBoardRecipe.ingredients = {
	{type = "item", name = "plastic-bar", amount = 2},
	{type = "item", name = "resin", amount = 1},
	--{type = "item", name = "rubber", amount = 0.2}, -- TODO after adding rubber
}
plasticCircuitBoardRecipe.results = {
	{type = "item", name = "circuit-board", amount = 10},
}
plasticCircuitBoardRecipe.order = "b[circuits]-002"
plasticCircuitBoardRecipe.subgroup = "circuit-board"
plasticCircuitBoardRecipe.icon = nil
plasticCircuitBoardRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/circuit-boards/plastic-circuit-board.png", icon_size = 64, scale = .5},
	{icon = "__base__/graphics/icons/plastic-bar.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
plasticCircuitBoardRecipe.auto_recycle = false
data:extend{plasticCircuitBoardRecipe}
Tech.addRecipeToTech("plastic-circuit-board", "plastics") -- TODO rather make a separate tech for this, using plastic circuit board sprite.

-- Add recipe for ceramic circuit board.
-- 	4 calcite + 2 resin -> 8 circuit boards
local calciteCircuitBoardRecipe = copy(RECIPE["barrel"])
calciteCircuitBoardRecipe.name = "calcite-circuit-board"
calciteCircuitBoardRecipe.ingredients = {
	{type = "item", name = "calcite", amount = 5},
	{type = "item", name = "resin", amount = 1},
}
calciteCircuitBoardRecipe.results = {
	{type = "item", name = "circuit-board", amount = 10},
}
calciteCircuitBoardRecipe.order = "b[circuits]-003"
calciteCircuitBoardRecipe.subgroup = "circuit-board"
calciteCircuitBoardRecipe.icon = nil
calciteCircuitBoardRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/circuit-boards/ceramic-circuit-board.png", icon_size = 64, scale = .5},
	{icon = "__space-age__/graphics/icons/calcite.png", icon_size = 64, scale = 0.25, shift = {-8, -8}},
}
calciteCircuitBoardRecipe.category = "metallurgy"
calciteCircuitBoardRecipe.auto_recycle = false
data:extend{calciteCircuitBoardRecipe}
Tech.addRecipeToTech("calcite-circuit-board", "calcite-processing") -- TODO rather make a separate tech for this? Unlocked by mining like 10 calcite. Use the ceramic circuit board sprite.

--[[ Add "makeshift" circuit board recipe, only handcraftable.
	Makeshift circuit board: 1 stone brick -> 1 circuit board
		Needed because all ways of making circuit boards require resin, which can't be obtained on Aquilo without buildings that require electronic circuits, creating a circular dependency. Also same on Nauvis at the start.
]]
local makeshiftBoardRecipe = copy(RECIPE["electronic-circuit"])
makeshiftBoardRecipe.name = "makeshift-circuit-board"
makeshiftBoardRecipe.ingredients = {{type = "item", name = "stone-brick", amount = 1}}
makeshiftBoardRecipe.results = {{type = "item", name = "circuit-board", amount = 1}}
makeshiftBoardRecipe.order = "b[circuits]-004"
makeshiftBoardRecipe.subgroup = "circuit-board"
makeshiftBoardRecipe.icon = nil
makeshiftBoardRecipe.icons = {
	{icon = "__LegendarySpaceAge__/graphics/circuit-boards/circuit-board-generic.png", icon_size = 64, scale = 0.5},
	{icon = "__core__/graphics/icons/mip/slot-item-in-hand-black.png", icon_size = 64, mipmap_count = 2, scale = 0.4, shift = {5, 4}},
	--{icon = "__core__/graphics/icons/mip/slot-item-in-hand.png", icon_size = 64, mipmap_count = 2, scale = 0.33, shift = {7, 6}},
}
makeshiftBoardRecipe.enabled = false
makeshiftBoardRecipe.energy_required = 1
makeshiftBoardRecipe.category = "handcrafting-only"
makeshiftBoardRecipe.auto_recycle = false
data:extend{makeshiftBoardRecipe}
Tech.addRecipeToTech("makeshift-circuit-board", "electronics", 2)

-- Create tech for wood circuit boards.
local woodCircuitBoardTech = copy(TECH["automation"])
woodCircuitBoardTech.name = "wood-circuit-board"
woodCircuitBoardTech.effects = {
	{type = "unlock-recipe", recipe = "wood-resin"},
	{type = "unlock-recipe", recipe = "wood-circuit-board"},
}
woodCircuitBoardTech.icon = nil
woodCircuitBoardTech.icons = {
	--{icon = "__LegendarySpaceAge__/graphics/circuit-boards/wood-circuit-board-tech.png", icon_size = 256, scale = 0.8, mipmap_count = 4, shift = {10, -10}},
	--{icon = "__LegendarySpaceAge__/graphics/resin/tech.png", icon_size = 256, scale = 0.4, mipmap_count = 4, shift = {-10, 10}},
	{icon = "__LegendarySpaceAge__/graphics/circuit-boards/wood-circuit-board-tech.png", icon_size = 256, mipmap_count = 4},
}
woodCircuitBoardTech.prerequisites = {"steam-power"}
woodCircuitBoardTech.ignore_tech_cost_multiplier = false
woodCircuitBoardTech.unit = {
	count = 15,
	ingredients = {
		{"automation-science-pack", 1},
	},
	time = 15,
}
woodCircuitBoardTech.research_trigger = nil
data:extend{woodCircuitBoardTech}

-- Create item for silicon (undoped wafers).
local silicon = copy(ITEM["plastic-bar"])
silicon.name = "silicon"
silicon.icon = "__LegendarySpaceAge__/graphics/circuit-chains/silicon.png"
silicon.icon_size = 64
silicon.subgroup = "complex-circuit-intermediates"
silicon.order = "001"
silicon.stack_size = 200
data:extend{silicon}

-- Create recipe for silicon.
local siliconRecipe = copy(RECIPE["plastic-bar"])
siliconRecipe.name = "silicon"
siliconRecipe.ingredients = {
	{type = "item", name = "sand", amount = 2},
	{type = "fluid", name = "sulfuric-acid", amount = 10},
}
siliconRecipe.results = {
	{type = "item", name = "silicon", amount = 1},
}
siliconRecipe.subgroup = nil
siliconRecipe.icon = nil
siliconRecipe.icons = nil
siliconRecipe.allow_decomposition = true
siliconRecipe.allow_as_intermediate = true
data:extend{siliconRecipe}
Tech.addRecipeToTech("silicon", "processing-unit", 1)
Tech.addRecipeToTech("silicon", "solar-energy", 1)

-- Create item for doped wafers.
local dopedWafer = copy(ITEM["plastic-bar"])
dopedWafer.name = "doped-wafer"
dopedWafer.icon = "__LegendarySpaceAge__/graphics/circuit-chains/doped-wafer.png"
dopedWafer.icon_size = 64
dopedWafer.subgroup = "complex-circuit-intermediates"
dopedWafer.order = "002"
dopedWafer.stack_size = 100
data:extend{dopedWafer}

-- Create item for microchips
local microchip = copy(ITEM["processing-unit"])
microchip.name = "microchip"
microchip.icon = "__LegendarySpaceAge__/graphics/circuit-chains/microchip.png"
microchip.icon_size = 64
microchip.subgroup = "complex-circuit-intermediates"
microchip.order = "003"
microchip.stack_size = 200
data:extend{microchip}

-- Create recipe for doped wafers.
local dopedWaferRecipe = copy(RECIPE["plastic-bar"])
dopedWaferRecipe.name = "doped-wafer"
dopedWaferRecipe.ingredients = {
	{type = "item", name = "silicon", amount = 1},
	{type = "item", name = "carbon", amount = 1},
}
dopedWaferRecipe.results = {
	{type = "item", name = "doped-wafer", amount = 1},
}
dopedWaferRecipe.subgroup = nil
dopedWaferRecipe.icon = nil
dopedWaferRecipe.icons = nil
dopedWaferRecipe.category = "chemistry-or-electronics"
dopedWaferRecipe.energy_required = 20
dopedWaferRecipe.allow_decomposition = true
dopedWaferRecipe.allow_as_intermediate = true
data:extend{dopedWaferRecipe}
Tech.addRecipeToTech("doped-wafer", "processing-unit", 2)

-- Create recipe for microchips.
local microchipRecipe = copy(RECIPE["plastic-bar"])
microchipRecipe.name = "microchip"
microchipRecipe.ingredients = {
	{type = "item", name = "doped-wafer", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "plastic-bar", amount = 1},
}
microchipRecipe.results = {
	{type = "item", name = "microchip", amount = 20},
}
microchipRecipe.subgroup = nil
microchipRecipe.icon = nil
microchipRecipe.icons = nil
microchipRecipe.category = "electronics"
microchipRecipe.energy_required = 10
microchipRecipe.allow_decomposition = true
microchipRecipe.allow_as_intermediate = true
data:extend{microchipRecipe}
Tech.addRecipeToTech("microchip", "processing-unit", 3)

-- Edit recipe for blue circuits (processing-unit) to use doped wafers.
-- 1 red circuit + 4 microchips + 5 sulfuric acid -> 1 blue circuit
-- Original recipe was 5 sulfuric acid + 2 red circuit + 20 green circuit.
RECIPE["processing-unit"].ingredients = {
	{type = "item", name = "advanced-circuit", amount = 1},
	{type = "item", name = "microchip", amount = 5},
	{type = "fluid", name = "sulfuric-acid", amount = 5},
}
RECIPE["processing-unit"].allow_decomposition = true
-- Make blue circuit recipe slower, as compromise for making it cheaper in materials.
RECIPE["processing-unit"].energy_required = 5

-- Create item for electronic components.
local electronicComponents = copy(ITEM["advanced-circuit"])
electronicComponents.name = "electronic-components"
electronicComponents.icon = nil
electronicComponents.subgroup = "complex-circuit-intermediates"
electronicComponents.order = "001"
electronicComponents.stack_size = 200
electronicComponents.icons = {{icon = "__LegendarySpaceAge__/graphics/circuit-chains/electronic-components/1.png", icon_size = 64, scale = 0.5}}
electronicComponents.pictures = {
	{filename = "__LegendarySpaceAge__/graphics/circuit-chains/electronic-components/1.png", size = 64, scale = 0.5},
	{filename = "__LegendarySpaceAge__/graphics/circuit-chains/electronic-components/2.png", size = 64, scale = 0.5},
	{filename = "__LegendarySpaceAge__/graphics/circuit-chains/electronic-components/3.png", size = 64, scale = 0.5},
}
data:extend{electronicComponents}

-- Create a recipe for electronic components.
-- 1 carbon + 1 plastic + 1 sand + 1 copper wire -> 2 electronic components
local electronicComponentsRecipe = copy(RECIPE["plastic-bar"])
electronicComponentsRecipe.name = "electronic-components"
electronicComponentsRecipe.ingredients = {
	{type = "item", name = "carbon", amount = 1},
	{type = "item", name = "plastic-bar", amount = 1},
	{type = "item", name = "wiring", amount = 1},
}
electronicComponentsRecipe.results = {
	{type = "item", name = "electronic-components", amount = 5},
}
electronicComponentsRecipe.subgroup = nil
electronicComponentsRecipe.icon = nil
electronicComponentsRecipe.icons = nil
electronicComponentsRecipe.category = "electronics"
electronicComponentsRecipe.energy_required = 5
electronicComponentsRecipe.allow_decomposition = true
electronicComponentsRecipe.allow_as_intermediate = true
data:extend{electronicComponentsRecipe}
Tech.addRecipeToTech("electronic-components", "advanced-circuit", 1)

-- Edit recipe for red circuits.
-- 1 circuit board + 2 copper cable + 2 electronic components -> 1 red circuit
-- Originally 2 green circuits + 2 plastic bar + 4 copper cable.
RECIPE["advanced-circuit"].ingredients = {
	{type = "item", name = "electronic-circuit", amount = 1},
	{type = "item", name = "wiring", amount = 1},
	{type = "item", name = "electronic-components", amount = 2},
}
RECIPE["advanced-circuit"].energy_required = 2.5

-- Move circuits to complex-circuit-intermediates subgroup.
ITEM["electronic-circuit"].subgroup = "complex-circuit-intermediates"
ITEM["advanced-circuit"].subgroup = "complex-circuit-intermediates"
ITEM["processing-unit"].subgroup = "complex-circuit-intermediates"

-- Edit green circuit ingredients.
RECIPE["electronic-circuit"].ingredients = {
	{type = "item", name = "circuit-board", amount = 1},
	{type = "item", name = "wiring", amount = 2},
	{type = "item", name = "carbon", amount = 1},
}