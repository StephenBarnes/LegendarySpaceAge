--[[ This file adds primed circuits and hyperprimed circuits, which are modules.

Each circuit has a different effect, corresponding to vanilla's modules - green for efficiency, red for productivity, blue for speed, and white circuits (which LSA adds) for quality.
Each circuit is just an item. Then you put it in a "primer" building to make the primed circuit.
Then you put the primed circuit in a beacon to apply the effect.
The primed circuit spoils back into the original circuit. So you have to remove spent circuits from beacons (using inserters - it works) and replace them with new primed circuits.

Then later, you get the "hyperprimer" building, which turns primed circuits into hyperprimed circuits, which have the same effect but much more powerful.
Hyperprimed circuits spoil back into primed circuits, fairly quickly.
The hyperprimer might also turn like 10 primed circuits into 9 hyperprimed circuits, so there's some material cost too.

The primer and hyperprimer buildings might have some requirement to discourage building them next to every group of beacons. Like maybe they require heat (since it's annoying to run heat pipes everywhere, or transport fuel for heating towers). Or maybe they require a fluid fuel. Or maybe they're just big, and they have high power drain (even when inactive). I think that last option is the best.

So players have lots of different options. Could use no beacons, could have one priming hub and ship primed circuits. Could do hyperpriming and then ship to beacons, but let them spoil in beacons and only remove them once they become completely unprimed. Etc.
]]

local PRIMED_SPOIL_TICKS = 10 * MINUTES
local HYPERPRIMED_SPOIL_TICKS = 5 * MINUTES
local OUTLINE_PIC = "__LegendarySpaceAge__/graphics/primed-circuits/outline.png"
local WIRES_PIC = "__LegendarySpaceAge__/graphics/primed-circuits/wires.png"

local CIRCUITS = {
	{
		name = "electronic-circuit",
		icon = "__base__/graphics/icons/electronic-circuit.png",
		contrastTint = {1, 0, 1, .8},
		normalTint = {0, 1, 0, 1},
	},
	{
		name = "advanced-circuit",
		icon = "__base__/graphics/icons/advanced-circuit.png",
		contrastTint = {0, 1, 1, .8},
		normalTint = {1, 0, 0, 1},
	},
	{
		name = "processing-unit",
		icon = "__base__/graphics/icons/processing-unit.png",
		contrastTint = {1, 0, 0, .8},
		normalTint = {0, 0, 1, 1},
	},
	{
		name = "white-circuit",
		icon = "__LegendarySpaceAge__/graphics/white-circuits/item.png",
		contrastTint = {0, 0, 1, .8},
		normalTint = {1, .5, 0, 1},
	},
}

-- Create primed and hyperprimed circuits.
for _, vals in pairs(CIRCUITS) do
	local circName = vals.name
	local circIcon = vals.icon
	local primedCircName = circName.."-primed"
	local hyperprimedCircName = circName.."-hyperprimed"

	-- Create module for primed circuit.
	local primedCirc = copy(MODULE["efficiency-module"])
	primedCirc.name = primedCircName
	primedCirc.icon = nil
	primedCirc.icons = {
		{icon = circIcon, scale = 0.5},
		{icon = OUTLINE_PIC, scale = 0.5, tint = vals.contrastTint},
	}
	primedCirc.pictures = {{
		layers = {
			{filename = circIcon, scale = 0.5, size = 64, mipmap_count = 4},
			{filename = OUTLINE_PIC, scale = 0.5, tint = vals.contrastTint, draw_as_glow = true, size = 64, mipmap_count = 4},
		},
	}}
	primedCirc.spoil_ticks = PRIMED_SPOIL_TICKS
	primedCirc.spoil_result = circName
	extend{primedCirc}

	-- Create module for hyperprimed circuit.
	local hyperprimedCirc = copy(MODULE["quality-module-3"])
	hyperprimedCirc.name = hyperprimedCircName
	hyperprimedCirc.icon = nil
	hyperprimedCirc.icons = {
		{icon = circIcon, scale = 0.5},
		{icon = OUTLINE_PIC, scale = 0.5, tint = vals.contrastTint},
		{icon = WIRES_PIC, scale = 0.5, tint = vals.contrastTint},
	}
	hyperprimedCirc.pictures = {{
		layers = {
			{filename = circIcon, scale = 0.5, size = 64, mipmap_count = 4},
			{filename = OUTLINE_PIC, scale = 0.5, tint = vals.contrastTint, draw_as_glow = true, size = 64, mipmap_count = 4},
			{filename = WIRES_PIC, scale = 0.5, tint = vals.contrastTint, draw_as_glow = true, size = 64, mipmap_count = 4},
		},
	}}
	hyperprimedCirc.spoil_ticks = HYPERPRIMED_SPOIL_TICKS
	hyperprimedCirc.spoil_result = primedCircName
	extend{hyperprimedCirc}

	-- Create recipe for primed circuit.
	local primedRecipe = Recipe.make{
		copy = circName,
		recipe = primedCircName,
		ingredients = {circName},
		resultCount = 1,
		-- TODO specify category
	}

	-- Create recipe for hyperprimed circuit.
	Recipe.make{
		copy = primedRecipe,
		recipe = hyperprimedCircName,
		ingredients = {primedCircName},
		resultCount = 1,
	}
end

-- TODO set module effects
-- TODO make recipes
-- TODO make furnace entity and item and recipe for the primer building and hyperprimer building
-- TODO edit item-groups stuff. Maybe 2 rows. Row 1 is beacon, primer, primed circuits. Row 2 is advanced beacon, hyperprimer, hyperprimed circuits.
-- TODO add recipes to techs