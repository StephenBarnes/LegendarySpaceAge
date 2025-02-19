-- This file adds recipes and items for processing uranium.

-- Create uranium hexafluoride.
local uraniumHexafluoride = copy(FLUID["steam"])
uraniumHexafluoride.name = "uranium-hexafluoride"
Icon.set(uraniumHexafluoride, "LSA/nuclear/uranium-hexafluoride")
extend{uraniumHexafluoride}

-- Create item for yellowcake.
local yellowcake = copy(ITEM["sulfur"])
yellowcake.name = "yellowcake"
Icon.set(yellowcake, "LSA/nuclear/yellowcake-2")
Icon.variants(yellowcake, "LSA/nuclear/yellowcake-%", 3)
yellowcake.subgroup = "uranium-processing"
extend{yellowcake}

-- Create item for plutonium.
local plutonium = copy(ITEM["uranium-235"])
plutonium.name = "plutonium"
plutonium.icon = nil
plutonium.icons = {
	{icon = "__LegendarySpaceAge__/graphics/nuclear/plutonium.png", scale = 0.5, draw_as_glow = true},
	-- TODO check the glow works.
}
extend{plutonium}

-- Create item for fuel rod.
local fuelRod = copy(ITEM["uranium-fuel-cell"])
fuelRod.name = "fuel-rod"
fuelRod.spent_result = "depleted-fuel-rod"
Icon.set(fuelRod, "LSA/nuclear/fuel-rod")
extend{fuelRod}

-- Create item for depleted fuel rod.
local depletedFuelRod = copy(ITEM["depleted-uranium-fuel-cell"])
depletedFuelRod.name = "depleted-fuel-rod"
Icon.set(depletedFuelRod, "LSA/nuclear/fuel-rod-depleted")
extend{depletedFuelRod}

-- Create tech for radiochemistry.
local tech = copy(TECH["nuclear-power"])
tech.name = "radiochemistry"
Icon.set(tech, "LSA/nuclear/radiochemistry-tech")
extend{tech}

-- TODO all the recipes