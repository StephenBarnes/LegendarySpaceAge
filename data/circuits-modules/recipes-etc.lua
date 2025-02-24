--[[ This file edits recipes for green/red/blue circuits, plus adds new intermediate items and their recipes: silicon, doped wafers, microchips.

Factor intermediates used to make circuits:
	Circuit boards - a factor intermediate (meaning it has multiple recipes) - initially makeshift, then wood+resin, then plastic, then later calcite.
	Wiring - initially copper cable and resin, then substitute that with rubber or plastic.
	Electronic components - initially glass plus carbon plus wiring, then later more alternate recipes using plastic, silicon, maybe others.
		This represents resistors, capacitors, transistors, etc. that are large enough to pick up by hand.
Non-factor intermediates used to make circuits:
	Silicon - from sand and sulfuric acid.
	Doped wafers - from silicon and carbon.
	Microchips - from plastic bar, doped wafer, wiring.
Note these non-factor intermediates rely on raw materials: stone, sulfuric acid (sulfur + water + iron), carbon (or carbon-based fuel), plastic.
	So, these need to be obtainable basically anywhere. And they are, though on Gleba you use the alternate route for sulfuric acid.

Circuit recipes:
	Green circuits:
		1 circuit board + 2 components -> 1 green circuit
		This is just a basic complexity check. Resources are not expensive.
		Uses only factor intermediates, so can be produced anywhere easily.
	Red circuits:
		1 green circuit + 10 components + 1 microchip -> 1 red circuit
		This is a complexity check on the components (pushing players to use more efficient recipes) plus complexity check for microchips.
	Blue circuits:
		1 red circuit + 5 microchips + 5 sulfuric acid -> 1 blue circuit
]]


-- Create new intermediate items: silicon, doped wafers, microchips.

local silicon = copy(ITEM["plastic-bar"])
silicon.name = "silicon"
Icon.set(silicon, "LSA/circuit-chains/silicon")
silicon.stack_size = 200
extend{silicon}

local dopedWafer = copy(ITEM["plastic-bar"])
dopedWafer.name = "doped-wafer"
Icon.set(dopedWafer, "LSA/circuit-chains/doped-wafer")
dopedWafer.stack_size = 100
extend{dopedWafer}

local microchip = copy(ITEM["processing-unit"])
microchip.name = "microchip"
Icon.set(microchip, "LSA/circuit-chains/microchip")
microchip.stack_size = 200
extend{microchip}


-- Create recipes for new intermediate items: silicon, doped wafers, microchips.

Recipe.make{
	copy = "plastic-bar",
	recipe = "silicon",
	ingredients = {
		{"sand", 2},
		{"sulfuric-acid", 10},
	},
	resultCount = 1,
	clearIcons = true,
	allow_decomposition = true,
	allow_as_intermediate = true,
	clearSubgroup = true,
}
Tech.addRecipeToTech("silicon", "advanced-circuit", 1)
Tech.addRecipeToTech("silicon", "solar-energy", 1)

Recipe.make{
	copy = "plastic-bar",
	recipe = "doped-wafer",
	ingredients = {"silicon", "carbon"},
	resultCount = 1,
	clearIcons = true,
	clearSubgroup = true,
	allow_decomposition = true,
	allow_as_intermediate = true,
	category = "chemistry-or-electronics",
	time = 20,
}
Tech.addRecipeToTech("doped-wafer", "advanced-circuit", 2)

Recipe.make{
	copy = "plastic-bar",
	recipe = "microchip",
	ingredients = {"doped-wafer", "wiring", "plastic-bar"},
	resultCount = 20,
	clearIcons = true,
	category = "electronics",
	time = 10,
	allow_decomposition = true,
	allow_as_intermediate = true,
}
Tech.addRecipeToTech("microchip", "advanced-circuit", 3)


-- Edit recipes for green/red/blue circuits.
Recipe.edit{
	recipe = "electronic-circuit",
	ingredients = {
		{"circuit-board", 1},
		{"electronic-components", 2},
	},
	time = .5,
}
Recipe.edit{
	recipe = "advanced-circuit",
	ingredients = { -- Originally 2 green circuits + 2 plastic bar + 4 copper cable.
		{"electronic-circuit", 1},
		{"electronic-components", 5},
		{"microchip", 1},
	},
	time = 1,
}
Recipe.edit{
	recipe = "processing-unit",
	ingredients = { -- Original recipe was 5 sulfuric acid + 2 red circuit + 20 green circuit.
		{"advanced-circuit", 1},
		{"microchip", 5},
		{"sulfuric-acid", 5},
	},
	time = 5,
	allow_decomposition = true,
}

-- Create white circuits.
local whiteCircuit = copy(ITEM["processing-unit"])
whiteCircuit.name = "white-circuit"
Icon.set(whiteCircuit, "LSA/white-circuits/item")
extend{whiteCircuit}

Recipe.make{
	recipe = "white-circuit",
	copy = "processing-unit",
	resultCount = 1,
	ingredients = {
		{"processing-unit", 1},
		{"supercapacitor", 1},
		{"superconductor", 1},
	},
	time = 2, -- Made in EM plant, with speed 2, prod bonus +50% or something.
	allow_decomposition = true,
	allow_as_intermediate = true,
	category = "electromagnetics", -- Only in EM plant.
}
-- Could make it only craftable on Fulgora. Or maybe allow anywhere, so you only need to export the supercapacitors.

-- Make tech for white circuits.
local whiteCircuitTech = copy(TECH["processing-unit"])
whiteCircuitTech.name = "white-circuit"
whiteCircuitTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "white-circuit",
	},
	{
		type = "unlock-recipe",
		recipe = "white-circuit-primed",
	},
	{
		type = "unlock-recipe",
		recipe = "white-circuit-superclocked",
	},
	
}
Icon.set(whiteCircuitTech, "LSA/white-circuits/tech")
whiteCircuitTech.prerequisites = {"electromagnetic-plant", "effect-transmission", "superclocked-circuits"}
	-- Effect-transmission prereq is to make it more discoverable when browsing beacons in tech tree.
whiteCircuitTech.unit = nil
whiteCircuitTech.research_trigger = {
	type = "craft-item",
	item = "supercapacitor",
	amount = 1,
}
extend{whiteCircuitTech}

-- Set stack sizes and weights.
ITEM["electronic-circuit"].stack_size = 200
ITEM["advanced-circuit"].stack_size = 200
ITEM["processing-unit"].stack_size = 200
whiteCircuit.stack_size = 200
local circuitWeight = ROCKET / 2000
ITEM["electronic-circuit"].weight = circuitWeight
ITEM["advanced-circuit"].weight = circuitWeight
ITEM["processing-unit"].weight = circuitWeight
whiteCircuit.weight = circuitWeight