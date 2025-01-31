local Table = require("code.util.table")
local Item = require("code.util.item")

local constants = require("code.data.petrochem.constants")

local newData = {}

-- Create natural gas fluid.
local natgasFluid = Table.copyAndEdit(data.raw.fluid["crude-oil"], {
	name = "natural-gas",
	base_color = constants.natgasColor,
	flow_color = constants.natgasFlowColor,
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=constants.natgasTint}},
	order = "a[fluid]-b[oil]-aa[natgas]",
	gas_temperature = 0,
})
table.insert(newData, natgasFluid)

-- Create dry gas fluid.
local drygasFluid = Table.copyAndEdit(natgasFluid, {
	name = "dry-gas",
	base_color = constants.drygasColor,
	flow_color = constants.drygasFlowColor,
	visualization_color = constants.drygasColor,
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=constants.drygasTint}},
	order = "a[fluid]-b[oil]-c[fractions]-4",
	gas_temperature = 0,
})
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
local syngasFluid = Table.copyAndEdit(data.raw.fluid["heavy-oil"], {
	name = "syngas",
	base_color = constants.syngasColor,
	flow_color = constants.syngasFlowColor,
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=constants.syngasColor}},
	order = "a[fluid]-b[oil]-c[fractions]-6",
	gas_temperature = 0,
})
table.insert(newData, syngasFluid)

-- Create tar fluid.
local tarFluid = Table.copyAndEdit(data.raw.fluid["heavy-oil"], {
	name = "tar",
	base_color = constants.tarColor,
	flow_color = constants.tarFlowColor,
	visualization_color = constants.tarColor,
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/tar.png", icon_size = 64}},
	order = "a[fluid]-b[oil]-c[fractions]-0",
})
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
local pitchItem = Table.copyAndEdit(data.raw.item["carbon"], {
	name = "pitch",
	icons = {{icon = pitchPictures[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}},
	pictures = pitchPictures,
	order = "b[chemistry]-b[plastic-bar]-1",
})
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
local resinItem = Table.copyAndEdit(data.raw.item["plastic-bar"], {
	name = "resin",
	icons = {{icon = resinPictures[1].filename, icon_size = 64, scale=0.5, mipmap_count=4}},
	pictures = resinPictures,
	subgroup = "resin",
})
Item.copySoundsTo(data.raw.capsule["bioflux"], resinItem)
table.insert(newData, resinItem)

------------------------------------------------------------------------
-- Add new prototypes to the game.
data:extend(newData)
------------------------------------------------------------------------

-- Fix ordering of the existing petro fractions.
data.raw.fluid["heavy-oil"].order = "a[fluid]-b[oil]-c[fractions]-1"
data.raw.fluid["light-oil"].order = "a[fluid]-b[oil]-c[fractions]-2"