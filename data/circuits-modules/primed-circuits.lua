--[[ This file adds primed circuits and superclocked circuits, which are modules.

Each circuit has a different effect, corresponding to vanilla's modules - green for efficiency, red for productivity, blue for speed, and white circuits (which LSA adds) for quality.
Each circuit is just an item. Then you put it in a "primer" building to make the primed circuit.
Then you put the primed circuit in a beacon to apply the effect.
The primed circuit spoils back into the original circuit. So you have to remove spent circuits from beacons (using inserters - it works) and replace them with new primed circuits.

Then later, you get the "superclocker" building, which turns primed circuits into superclocked circuits, which have the same effect but much more powerful.
Superclocked circuits spoil back into primed circuits, fairly quickly.
The superclocker might also turn like 10 primed circuits into 9 superclocked circuits, so there's some material cost too.

The primer and superclocker buildings might have some requirement to discourage building them next to every group of beacons. Like maybe they require heat (since it's annoying to run heat pipes everywhere, or transport fuel for heating towers). Or maybe they require a fluid fuel. Or maybe they're just big, and they have high power drain (even when inactive). I think that last option is the best.

So players have lots of different options. Could use no beacons, could have one priming hub and ship primed circuits. Could do superclocking and then ship to beacons, but let them spoil in beacons and only remove them once they become completely unprimed. Etc.
]]

local PRIMED_SPOIL_TICKS = 5 * MINUTES
local SUPERCLOCKED_SPOIL_TICKS = 3 * MINUTES
local OUTLINE_PIC = "__LegendarySpaceAge__/graphics/primed-circuits/outline.png"
local WIRES_PIC = "__LegendarySpaceAge__/graphics/primed-circuits/wires.png"
local BLACK_BOARD_PIC = "__LegendarySpaceAge__/graphics/primed-circuits/black-board.png"

--[[ Table of circuits in order, with info.
	name: name of base circuit item
	icon: icon of base circuit item
	normalBrightTint: color same as boardTint but brighter
	boardTint: roughly the default color for the board of the item
	primedEffect/superclockedEffect: module effects.

In vanilla, effects are:
	efficiency-module: -30/40/50% consumption.
	speed-module: +50/60/70% consumption, +20/30/50% speed, -1/1.5/2.5% quality.
	productivity-module: +40/60/80% consumption, -5/10/15% speed, +4/6/10% prod, +5/7/10% pollution.
	quality-module: -5/5/5% speed, +1/2/2.5% quality.
So, effects I'll use:
	green: -50/100% consumption.
	red: +100/200% consumption, +10/20% prod, +10/20% pollution, no speed effect.
	blue: +100/200% consumption, +50/100% speed, no quality effect.
	white: +2.5/5% quality, no speed effect.
]]
local CIRCUITS = {
	{
		name = "electronic-circuit",
		icon = "__base__/graphics/icons/electronic-circuit.png",
		normalBrightTint = {0, 1, 0},
		boardTint = {0, .624, 0},
		copyModule = "efficiency-module",
		primedEffect = {consumption = -.5},
		superclockedEffect = {consumption = -1},
	},
	{
		name = "advanced-circuit",
		icon = "__base__/graphics/icons/advanced-circuit.png",
		normalBrightTint = {1, 0, 0},
		boardTint = {.855, 0, 0},
		copyModule = "productivity-module",
		primedEffect = {consumption = 1, productivity = .1, pollution = .1},
		superclockedEffect = {consumption = 2, productivity = .2, pollution = .2},
	},
	{
		name = "processing-unit",
		icon = "__base__/graphics/icons/processing-unit.png",
		normalBrightTint = {0, 0, 1},
		boardTint = {0, .333, 1},
		copyModule = "speed-module",
		primedEffect = {speed = .5, consumption = 1},
		superclockedEffect = {speed = 1, consumption = 2},
	},
	{
		name = "white-circuit",
		icon = "__LegendarySpaceAge__/graphics/white-circuits/item.png",
		normalBrightTint = {1, 1, 1},
		boardTint = {.839, .808, .769},
		copyModule = "quality-module",
		primedEffect = {quality = .25},
		superclockedEffect = {quality = .5},
	},
}

-- Add tints to circuit recipes. These are used in the primer and superclocker buildings.
for _, vals in pairs(CIRCUITS) do
	RECIPE[vals.name].crafting_machine_tint = {
		primary = vals.normalBrightTint,
		secondary = vals.boardTint,
	}
end

-- Create primed and superclocked circuits.
for _, vals in pairs(CIRCUITS) do
	local circName = vals.name
	local primedCircName = circName.."-primed"
	local superclockedCircName = circName.."-superclocked"

	-- Create module for primed circuit.
	local primedCirc = copy(MODULE[vals.copyModule])
	primedCirc.name = primedCircName
	primedCirc.icon = nil
	primedCirc.icons = {
		{icon = BLACK_BOARD_PIC, scale = 0.5},
		{icon = WIRES_PIC, scale = 0.5, tint = vals.normalBrightTint},
	}
	primedCirc.pictures = {{
		layers = {
			{filename = BLACK_BOARD_PIC, scale = 0.5, size = 64, mipmap_count = 4},
			{filename = WIRES_PIC, scale = 0.5, tint = vals.normalBrightTint, draw_as_glow = true, size = 64, mipmap_count = 4},
		},
	}}
	primedCirc.spoil_ticks = PRIMED_SPOIL_TICKS
	primedCirc.spoil_result = circName
	primedCirc.localised_description = nil
	primedCirc.effect = vals.primedEffect
	extend{primedCirc}

	-- Create module for superclocked circuit.
	local superclockedCirc = copy(MODULE[vals.copyModule.."-3"])
	superclockedCirc.name = superclockedCircName
	superclockedCirc.icon = nil
	superclockedCirc.icons = {
		{icon = BLACK_BOARD_PIC, scale = 0.5},
		{icon = WIRES_PIC, scale = 0.5, tint = vals.normalBrightTint},
		{icon = OUTLINE_PIC, scale = 0.5, tint = vals.boardTint},
	}
	superclockedCirc.pictures = {{
		layers = {
			{filename = BLACK_BOARD_PIC, scale = 0.5, size = 64, mipmap_count = 4},
			{filename = WIRES_PIC, scale = 0.5, tint = vals.normalBrightTint, draw_as_glow = true, size = 64, mipmap_count = 4},
			{filename = OUTLINE_PIC, scale = 0.5, tint = vals.boardTint, draw_as_glow = true, size = 64, mipmap_count = 4},
		},
	}}
	superclockedCirc.spoil_ticks = SUPERCLOCKED_SPOIL_TICKS
	superclockedCirc.spoil_result = primedCircName
	superclockedCirc.localised_description = {"item-description."..primedCircName}
	superclockedCirc.effect = vals.superclockedEffect
	extend{superclockedCirc}

	-- Create recipe for primed circuit.
	local primedRecipe = Recipe.make{
		copy = circName,
		recipe = primedCircName,
		ingredients = {circName},
		resultCount = 1,
		category = "circuit-priming",
		enabled = false,
		time = 0.5,
	}
	primedRecipe.allow_productivity = false
	primedRecipe.allow_quality = false
	primedRecipe.results[1].ignored_by_productivity = 1

	-- Create recipe for superclocked circuit.
	local superclockedRecipe = Recipe.make{
		copy = primedRecipe,
		recipe = superclockedCircName,
		ingredients = {{primedCircName, 10}},
		results = {{superclockedCircName, amount_min = 9, amount_max = 10}},
		category = "circuit-superclocking",
		time = 5,
	}
	superclockedRecipe.allow_productivity = false
	superclockedRecipe.allow_quality = false
	superclockedRecipe.results[1].ignored_by_productivity = 9
end

-- Make categories for circuit-priming and circuit-superclocking.
extend{
	{
		type = "recipe-category",
		name = "circuit-priming",
	},
	{
		type = "recipe-category",
		name = "circuit-superclocking",
	},
}

-- Add primed circuit recipes to techs.
Tech.addRecipeToTech("advanced-circuit-primed", "advanced-circuit")
Tech.addRecipeToTech("processing-unit-primed", "processing-unit")