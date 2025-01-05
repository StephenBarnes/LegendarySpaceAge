local Table = require("code.util.table")

local newData = {}

local natgasColor = {r = .3, g = 0, b = .3, a = 1}
local natgasTint = {r = .5, g = .1, b = .5, a = 1}

--[[ Colors to make them grey and blue. Looks alright but interferes with steam.
local drygasColor = {r = .72, g = .83, b = .89, a = 1}
local richgasColor = {r = .54, g = .56, b = .57, a = 1}
]]

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