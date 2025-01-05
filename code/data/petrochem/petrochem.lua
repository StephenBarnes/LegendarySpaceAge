local Table = require("code.util.table")

local newData = {}

local natgasColor = {r = .3, g = 0, b = .3, a = 1}
local natgasTint = {r = .5, g = .1, b = .5, a = 1}
local syngasColor = {r = .8, g = .4, b = .4, a = 1}
local tarColor = {r = .2, g = .1, b = .071, a = 1}

--[[ Colors to make them grey and blue. Looks alright but interferes with steam.
local drygasColor = {r = .72, g = .83, b = .89, a = 1}
local richgasColor = {r = .54, g = .56, b = .57, a = 1} ]]
-- Colors to make them shades of green.
local drygasColor = {r = .48, g = .69, b = .50, a = 1}
local richgasColor = {r = .73, g = .86, b = .65, a = 1}

-- Create natural gas fluid.
local natgasFluid = Table.copyAndEdit(data.raw.fluid["crude-oil"], {
	name = "natural-gas",
	base_color = natgasColor,
	flow_color = natgasColor,
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=natgasTint}},
	order = "a[fluid]-b[oil]-aa[natgas]",
})
table.insert(newData, natgasFluid)

-- Create dry gas fluid.
local drygasFluid = Table.copyAndEdit(natgasFluid, {
	name = "dry-gas",
	base_color = drygasColor,
	flow_color = drygasColor,
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=drygasColor}},
	order = "a[fluid]-b[oil]-c[fractions]-4",
})
table.insert(newData, drygasFluid)

-- Change petroleum gas to "rich gas".
local richgasFluid = data.raw.fluid["petroleum-gas"]
richgasFluid.order = "a[fluid]-b[oil]-c[fractions]-3"
richgasFluid.base_color = richgasColor
richgasFluid.flow_color = richgasColor
richgasFluid.icon = nil
richgasFluid.icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=richgasColor}}
richgasFluid.localised_name = {"fluid-name.rich-gas"} -- In case other languages are used, don't use that language's version of "petroleum gas".

-- Create syngas fluid.
local syngasFluid = Table.copyAndEdit(data.raw.fluid["heavy-oil"], {
	name = "syngas",
	base_color = syngasColor,
	flow_color = syngasColor,
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/gas.png", icon_size = 64, tint=syngasColor}},
	order = "a[fluid]-b[oil]-c[fractions]-6",
})
table.insert(newData, syngasFluid)

-- Create tar fluid.
local tarFluid = Table.copyAndEdit(data.raw.fluid["heavy-oil"], {
	name = "tar",
	base_color = tarColor,
	flow_color = tarColor,
	icon = "nil",
	icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/tar.png", icon_size = 64}},
	order = "a[fluid]-b[oil]-c[fractions]-5",
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
	icons = {
		{icon="__LegendarySpaceAge__/graphics/petrochem/pitch-1.png", icon_size=64, scale=0.5},
	},
	pictures = pitchPictures,
	--subgroup = "raw-material", -- TODO
})
table.insert(newData, pitchItem)

-- Add new prototypes to the game.
data:extend(newData)

-- Fix ordering of the rest of the petro fractions.
data.raw.fluid["heavy-oil"].order = "a[fluid]-b[oil]-c[fractions]-1"
data.raw.fluid["light-oil"].order = "a[fluid]-b[oil]-c[fractions]-2"

-- TODO change recipe icons for natgas refining too - instead of the funnel icons, use ingredients and products, like base game's oil refining.

-- TODO change recipes and icons - build them from fluid icons.

-- TODO more.

-- TODO integrate with Boompuff Agriculture mod

-- TODO rename basic/advanced oil processing to sth like "small-chain refining" and "long-chain refining"; look up appropriate names.

-- TODO should we allow heating towers in space? Same for eg boilers.