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

local CIRCUITS = {
	"electronic-circuit",
	"advanced-circuit",
	"processing-unit",
	"white-circuit",
}

-- Create primed and hyperprimed circuits.
for _, circName in pairs(CIRCUITS) do
	local primedCircName = circName.."-primed"
	local hyperprimedCircName = circName.."-hyperprimed"

	local primedCirc = copy(MODULE["efficiency-module"])
	primedCirc.name = primedCircName
	primedCirc.icon = ITEM[circName].icon -- TODO make icons
	extend{primedCirc}

	local hyperprimedCirc = copy(MODULE["quality-module-3"])
	hyperprimedCirc.name = hyperprimedCircName
	hyperprimedCirc.icon = ITEM[circName].icon -- TODO make icons
	extend{hyperprimedCirc}
end
-- TODO set module effects
-- TODO give modules spoilage
-- TODO make recipes
-- TODO make furnace entity and item and recipe for the primer building and hyperprimer building
-- TODO edit item-groups stuff. Maybe 2 rows. Row 1 is beacon, primer, primed circuits. Row 2 is advanced beacon, hyperprimer, hyperprimed circuits.