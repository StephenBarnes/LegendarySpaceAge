--[[ This file creates "air" fluid (for Earth-like breathable air - nitrogen, oxygen, trace carbon dioxide).
Also "air or oxygen" fluid used as input to some recipes.
]]

local airFluid = copy(FLUID["steam"])
airFluid.name = "air"
Fluid.setSimpleTemp(airFluid, -150, false)
Icon.set(airFluid, "LSA/fluids/air")
airFluid.factoriopedia_description = {"factoriopedia-description.air"}
-- The factoriopedia_description doesn't currently work (as of 2025-05-21) for anything other than entities, but it seems they're planning to implement it: https://forums.factorio.com/viewtopic.php?t=127266
-- TODO check if they've implemented it, then check this works.
extend{airFluid}

local airOrOxygenFluid = copy(FLUID["steam"])
airOrOxygenFluid.name = "air-or-oxygen"
Fluid.setSimpleTemp(airOrOxygenFluid, -150, false)
Icon.set(airOrOxygenFluid, "LSA/fluids/air-or-oxygen")
airOrOxygenFluid.factoriopedia_description = {"factoriopedia-description.air-or-oxygen"}
extend{airOrOxygenFluid}