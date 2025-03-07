local constants = require("data.petrochem.constants")

-- Create natural gas fluid.
local natgasFluid = copy(FLUID["crude-oil"])
natgasFluid.name = "natural-gas"
natgasFluid.base_color = constants.natgasColor
natgasFluid.flow_color = constants.natgasFlowColor
natgasFluid.icon = nil
natgasFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/fluids/gas-2.png", icon_size = 64, tint=constants.natgasTint}}
natgasFluid.order = "a[fluid]-b[oil]-aa[natgas]"
natgasFluid.gas_temperature = 0
extend{natgasFluid}

-- Create dry gas fluid.
local drygasFluid = copy(natgasFluid)
drygasFluid.name = "dry-gas"
drygasFluid.base_color = constants.drygasColor
drygasFluid.flow_color = constants.drygasFlowColor
drygasFluid.visualization_color = constants.drygasColor
drygasFluid.icon = nil
drygasFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/fluids/gas-2.png", icon_size = 64, tint=constants.drygasTint}}
drygasFluid.order = "a[fluid]-b[oil]-c[fractions]-4"
drygasFluid.gas_temperature = 0
extend{drygasFluid}

-- Change petroleum gas to "rich gas".
local richgasFluid = FLUID["petroleum-gas"]
richgasFluid.order = "a[fluid]-b[oil]-c[fractions]-3"
richgasFluid.base_color = constants.richgasColor
richgasFluid.flow_color = constants.richgasFlowColor
richgasFluid.icon = nil
richgasFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/fluids/gas-2.png", icon_size = 64, tint=constants.richgasColor}}
richgasFluid.localised_name = {"fluid-name.rich-gas"} -- In case other languages are used, don't use that language's version of "petroleum gas".
richgasFluid.gas_temperature = 0

-- Create syngas fluid.
local syngasFluid = copy(FLUID["heavy-oil"])
syngasFluid.name = "syngas"
syngasFluid.base_color = constants.syngasColor
syngasFluid.flow_color = constants.syngasFlowColor
syngasFluid.icon = nil
syngasFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/fluids/gas-2.png", icon_size = 64, tint=constants.syngasColor}}
syngasFluid.order = "a[fluid]-b[oil]-c[fractions]-6"
syngasFluid.gas_temperature = 0
extend{syngasFluid}

-- Create tar fluid.
local tarFluid = copy(FLUID["heavy-oil"])
tarFluid.name = "tar"
tarFluid.base_color = constants.tarColor
tarFluid.flow_color = constants.tarFlowColor
tarFluid.visualization_color = constants.tarColor
Icon.set(tarFluid, "LSA/petrochem/tar")
tarFluid.order = "a[fluid]-b[oil]-c[fractions]-0"
extend{tarFluid}

-- Create pitch item.
local pitchItem = copy(ITEM["carbon"])
pitchItem.name = "pitch"
Icon.set(pitchItem, "LSA/petrochem/pitch-1")
Icon.variants(pitchItem, "LSA/petrochem/pitch-%", 3)
pitchItem.order = "b[chemistry]-b[plastic-bar]-1"
Item.copySoundsTo("plastic-bar", pitchItem)
extend{pitchItem}

------------------------------------------------------------------------

-- Fix ordering of the existing petro fractions.
FLUID["heavy-oil"].order = "a[fluid]-b[oil]-c[fractions]-1"
FLUID["light-oil"].order = "a[fluid]-b[oil]-c[fractions]-2"