--[[ This file adds circuit boards as a factor intermediate, plus multiple recipes for making them.
Generally on Nauvis and Gleba both wood and plastic circuit boards are viable. On Fulgora and Aquilo, only plastic circuit boards are viable. On Vulcanus there's an alternative recipe for ceramic circuit boards using calcite.
TODO also add more complex but efficient recipes, like fiberglass circuit boards.
]]

-- Add circuit board item.
local circuitBoardItem = copy(ITEM["electronic-circuit"])
circuitBoardItem.name = "circuit-board"
Icon.set(circuitBoardItem, "LSA/circuit-boards/circuit-board-generic")
Item.perRocket(circuitBoardItem, 4000)
Item.copySoundsTo("copper-cable", circuitBoardItem)
extend{circuitBoardItem}

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
woodCircuitBoardRecipe.allow_as_intermediate = false;
woodCircuitBoardRecipe.energy_required = 5
Icon.set(woodCircuitBoardRecipe, {"LSA/circuit-boards/wood-circuit-board", "wood"})
woodCircuitBoardRecipe.auto_recycle = false
extend{woodCircuitBoardRecipe}

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
plasticCircuitBoardRecipe.allow_as_intermediate = false;
plasticCircuitBoardRecipe.energy_required = 1
Icon.set(plasticCircuitBoardRecipe, {"LSA/circuit-boards/plastic-circuit-board", "plastic-bar"})
plasticCircuitBoardRecipe.auto_recycle = false
extend{plasticCircuitBoardRecipe}
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
calciteCircuitBoardRecipe.allow_as_intermediate = false;
calciteCircuitBoardRecipe.energy_required = 2
Icon.set(calciteCircuitBoardRecipe, {"LSA/circuit-boards/ceramic-circuit-board", "calcite"})
calciteCircuitBoardRecipe.category = "metallurgy"
calciteCircuitBoardRecipe.auto_recycle = false
extend{calciteCircuitBoardRecipe}
Tech.addRecipeToTech("calcite-circuit-board", "calcite-processing") -- TODO rather make a separate tech for this? Unlocked by mining like 10 calcite. Use the ceramic circuit board sprite.

--[[ Add "makeshift" circuit board recipe, only handcraftable.
	Makeshift circuit board: 1 stone brick -> 1 circuit board
		Needed because all ways of making circuit boards require resin, which can't be obtained on Aquilo without buildings that require electronic circuits, creating a circular dependency. Also same on Nauvis at the start.
]]
local makeshiftBoardRecipe = Recipe.make{
	copy = "electronic-circuit",
	recipe = "makeshift-circuit-board",
	ingredients = {"stone-brick"},
	results = {{"circuit-board", 2}},
	main_product = "circuit-board",
	icons = {"circuit-board", "LSA/misc/makeshift"},
	enabled = false,
	time = 0.5,
	category = "handcrafting-only",
	auto_recycle = false,
	allow_as_intermediate = true,
	allow_decomposition = false,
}
Tech.addRecipeToTech("makeshift-circuit-board", "electronics")

-- Create tech for wood circuit boards.
local woodCircuitBoardTech = copy(TECH["automation"])
woodCircuitBoardTech.name = "wood-circuit-board"
woodCircuitBoardTech.effects = {
	{type = "unlock-recipe", recipe = "wood-resin"},
	{type = "unlock-recipe", recipe = "wood-circuit-board"},
}
Icon.set(woodCircuitBoardTech, "LSA/circuit-boards/wood-circuit-board-tech")
woodCircuitBoardTech.prerequisites = {"steam-power"}
woodCircuitBoardTech.ignore_tech_cost_multiplier = true -- Since it's needed for automating circuit boards, shouldn't require much science.
woodCircuitBoardTech.unit = {
	count = 15,
	ingredients = {
		{"automation-science-pack", 1},
	},
	time = 15,
}
woodCircuitBoardTech.research_trigger = nil
extend{woodCircuitBoardTech}

Gen.order({
	circuitBoardItem,
	makeshiftBoardRecipe,
	woodCircuitBoardRecipe,
	plasticCircuitBoardRecipe,
	calciteCircuitBoardRecipe,
}, "circuit-board")
