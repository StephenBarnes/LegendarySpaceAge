local Table = require("code.util.table")

require("code.data.petrochem.gas-furnace")
require("code.data.petrochem.gas-boiler")
require("code.data.petrochem.fluids-items")
require("code.data.petrochem.recipes")
require("code.data.petrochem.gasifier")

-- Add 2 more fluid outputs to the refinery, so we can have recipes with 5 fluid outputs.
-- Could get away with adding only 1 new output, but then it's asymmetric so we can't flip it.
local oilRefinery = data.raw["assembling-machine"]["oil-refinery"]
local newFluidBox1 = Table.copyAndEdit(oilRefinery.fluid_boxes[5], {
	pipe_connections = {
		{position = {-2, 0}, direction = defines.direction.west, flow_direction = "output"},
	},
})
local newFluidBox2 = Table.copyAndEdit(oilRefinery.fluid_boxes[5], {
	pipe_connections = {
		{position = {2, 0}, direction = defines.direction.east, flow_direction = "output"},
	},
})
-- Add fluid boxes in order chosen so that our recipes have interesting and sensible positions for outputs.
oilRefinery.fluid_boxes = {
	oilRefinery.fluid_boxes[1], -- input
	oilRefinery.fluid_boxes[2], -- input
	newFluidBox2,
	oilRefinery.fluid_boxes[3],
	oilRefinery.fluid_boxes[4],
	oilRefinery.fluid_boxes[5],
	newFluidBox1,
}
-- TODO change the pipe covers so it doesn't look like it's hovering in mid-air. Could steal it from some other machine eg assembler mk2.

-- Add 1 more fluid input to chem plant, so we can do explosives recipe.
local chemPlant = data.raw["assembling-machine"]["chemical-plant"]
local newFluidBox = Table.copyAndEdit(chemPlant.fluid_boxes[1], {
	pipe_connections = {
		{position = {1, 0}, direction = defines.direction.east, flow_direction = "input"},
	},
})
chemPlant.fluid_boxes = {
	chemPlant.fluid_boxes[1], -- input
	newFluidBox, -- Stick it between the other 2 outputs, so if a recipe has 2 fluid inputs they get distributed more conveniently.
	chemPlant.fluid_boxes[2], -- input
	chemPlant.fluid_boxes[3], -- output
	chemPlant.fluid_boxes[4], -- output
}

--[[ Add fuel values. The fuel values were chosen so that the relative numbers are realistic, meaning things that are better for burning in the real world should have higher fuel value, so that the player is encouraged to use fuels that are realistic (e.g. "rich gas" / propane over crude oil).
All fluids' values should be divided by 10, since 1 fluid is like 10 items.
	crude oil 4 MJ
	heavy oil 5 MJ
	light oil 7 MJ
	rich gas (propane/butane) 9 MJ
	dry gas (methane/ethane) 8 MJ
	natural gas (unprocessed) 8 MJ
	syngas 4 MJ
	tar 2 MJ
	sulfur (solid item) 5 MJ
	solid fuel (refined product) 12 MJ
	pitch 3MJ
	resin 4MJ
]]
local fluidFuelValues = {
	["crude-oil"] = "400kJ",
	["heavy-oil"] = "500kJ",
	["light-oil"] = "700kJ",
	["petroleum-gas"] = "900kJ",
	["dry-gas"] = "800kJ",
	["natural-gas"] = "800kJ",
	["syngas"] = "400kJ",
	["tar"] = "200kJ",
}
local itemFuelValues = {
	["sulfur"] = "1MJ",
	["solid-fuel"] = "12MJ",
	["pitch"] = "3MJ",
	["resin"] = "4MJ",
}
for fluidName, fuelValue in pairs(fluidFuelValues) do
	data.raw.fluid[fluidName].fuel_value = fuelValue
end
for itemName, fuelValue in pairs(itemFuelValues) do
	data.raw.item[itemName].fuel_value = fuelValue
	data.raw.item[itemName].fuel_category = "chemical" -- Holds carbon-based fuels.
end
data.raw.item["sulfur"].fuel_category = "non-carbon"

-- Create fuel category for non-carbon fuels like sulfur, which can't be used in some places where carbon is needed (eg furnaces need carbon as reducing agent).
local nonCarbonFuelCategory = Table.copyAndEdit(data.raw["fuel-category"]["chemical"], {
	name = "non-carbon",
})
data:extend{nonCarbonFuelCategory}

-- Set fuel categories for some entities to allow sulfur as fuel.
data.raw.reactor["heating-tower"].energy_source.fuel_categories = {"chemical", "non-carbon"}
data.raw.boiler["boiler"].energy_source.fuel_categories = {"chemical", "non-carbon"}
data.raw.inserter["burner-inserter"].energy_source.fuel_categories = {"chemical", "non-carbon"}

-- TODO for recipes, define which fluid connections to use - shouldn't use these additional fluid connections if not necessary.

-- TODO figure out what to put in the 2nd oil tech.
-- TODO figure out what to do with the sulfur tech.
-- TODO move syngas liquefaction tech since it's needed on Vulcanus.