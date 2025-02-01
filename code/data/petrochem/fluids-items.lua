local Table = require("code.util.table")
local Item = require("code.util.item")

local constants = require("code.data.petrochem.constants")

local newData = {}

-- Create natural gas fluid.
local natgasFluid = table.deepcopy(data.raw.fluid["crude-oil"])
natgasFluid.name = "natural-gas"
natgasFluid.base_color = constants.natgasColor
natgasFluid.flow_color = constants.natgasFlowColor
natgasFluid.icon = nil
natgasFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=constants.natgasTint}}
natgasFluid.order = "a[fluid]-b[oil]-aa[natgas]"
natgasFluid.gas_temperature = 0
table.insert(newData, natgasFluid)

-- Create dry gas fluid.
local drygasFluid = table.deepcopy(natgasFluid)
drygasFluid.name = "dry-gas"
drygasFluid.base_color = constants.drygasColor
drygasFluid.flow_color = constants.drygasFlowColor
drygasFluid.visualization_color = constants.drygasColor
drygasFluid.icon = nil
drygasFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=constants.drygasTint}}
drygasFluid.order = "a[fluid]-b[oil]-c[fractions]-4"
drygasFluid.gas_temperature = 0
table.insert(newData, drygasFluid)

-- Change petroleum gas to "rich gas".
local richgasFluid = data.raw.fluid["petroleum-gas"]
richgasFluid.order = "a[fluid]-b[oil]-c[fractions]-3"
richgasFluid.base_color = constants.richgasColor
richgasFluid.flow_color = constants.richgasFlowColor
richgasFluid.icon = nil
richgasFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=constants.richgasColor}}
richgasFluid.localised_name = {"fluid-name.rich-gas"} -- In case other languages are used, don't use that language's version of "petroleum gas".
richgasFluid.gas_temperature = 0

-- Create syngas fluid.
local syngasFluid = table.deepcopy(data.raw.fluid["heavy-oil"])
syngasFluid.name = "syngas"
syngasFluid.base_color = constants.syngasColor
syngasFluid.flow_color = constants.syngasFlowColor
syngasFluid.icon = nil
syngasFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=constants.syngasColor}}
syngasFluid.order = "a[fluid]-b[oil]-c[fractions]-6"
syngasFluid.gas_temperature = 0
table.insert(newData, syngasFluid)

-- Create tar fluid.
local tarFluid = table.deepcopy(data.raw.fluid["heavy-oil"])
tarFluid.name = "tar"
tarFluid.base_color = constants.tarColor
tarFluid.flow_color = constants.tarFlowColor
tarFluid.visualization_color = constants.tarColor
tarFluid.icon = nil
tarFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/tar.png", icon_size = 64}}
tarFluid.order = "a[fluid]-b[oil]-c[fractions]-0"
table.insert(newData, tarFluid)

-- Create pitch item.
local pitchPictures = {}
for i = 1, 3 do
	table.insert(pitchPictures, {
		filename = "__LegendarySpaceAge__/graphics/petrochem/pitch-" .. i .. ".png",
		size = 64,
		scale = 0.5,
		mipmap_count = 4,
	})
end
local pitchItem = table.deepcopy(data.raw.item["carbon"])
pitchItem.name = "pitch"
pitchItem.icons = {{icon = pitchPictures[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}}
pitchItem.pictures = pitchPictures
pitchItem.order = "b[chemistry]-b[plastic-bar]-1"
Item.copySoundsTo("plastic-bar", pitchItem)
table.insert(newData, pitchItem)

-- Create resin item.
local resinPictures = {}
for i = 1, 3 do
	table.insert(resinPictures, {
		filename = "__LegendarySpaceAge__/graphics/resin/resin-" .. i .. ".png",
		size = 64,
		scale = 0.5,
		mipmap_count = 4,
	})
end
local resinItem = table.deepcopy(data.raw.item["plastic-bar"])
resinItem.name = "resin"
resinItem.icons = {{icon = resinPictures[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}}
resinItem.pictures = resinPictures
resinItem.subgroup = "resin"
Item.copySoundsTo(data.raw.capsule["bioflux"], resinItem)
table.insert(newData, resinItem)

------------------------------------------------------------------------
-- Add new prototypes to the game.
data:extend(newData)
------------------------------------------------------------------------

-- Fix ordering of the existing petro fractions.
data.raw.fluid["heavy-oil"].order = "a[fluid]-b[oil]-c[fractions]-1"
data.raw.fluid["light-oil"].order = "a[fluid]-b[oil]-c[fractions]-2"