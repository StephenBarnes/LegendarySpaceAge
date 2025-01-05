-- Changes to Adamo's Carbon mod.
-- NOTE there's a lot more changes in the "oil-refining.lua" file, which also changes other oil processing recipes.

--[[
-- Make the new fluids show up in the fluids tab in Factoriopedia.
data.raw.fluid["adamo-carbon-natural-gas"].subgroup = "fluid"
data.raw.fluid["adamo-carbon-methane"].subgroup = "fluid"
data.raw.fluid["adamo-carbon-syngas"].subgroup = "fluid"

-- Make the gasifier fluid input show that it takes steam, and output shows it produces syngas.
data.raw.furnace["adamo-carbon-gasifier"].fluid_boxes[1].filter = "steam"
data.raw.furnace["adamo-carbon-gasifier"].fluid_boxes[2].filter = "adamo-carbon-syngas"
-- (Note: using the option to also make oil processing recipes use steam instead of water. This also applies to this syngas-from-fuel recipe.)
-- (Considered making the gasifier take either water or steam, but fluid box filter doesn't support multiple fluids.)

-- Change icon for natural gas (since it's currently almost the same as methane).
data.raw.fluid["adamo-carbon-natural-gas"].icon = "__LegendarySpaceAge__/graphics/oil_processing/natgas.png"
data.raw.fluid["adamo-carbon-natural-gas"].icon_size = 64
-- And change tint - used for pipes, barrels.
local natgasColor = {r = .449, g = .560, b = .342} -- dark grey-green
data.raw.fluid["adamo-carbon-natural-gas"].base_color = natgasColor
data.raw.fluid["adamo-carbon-natural-gas"].flow_color = natgasColor
data.raw.fluid["adamo-carbon-natural-gas"].visualization_color = natgasColor

-- Change methane icon so it's not the same color as petrogas.
data.raw.fluid["adamo-carbon-methane"].icon = "__LegendarySpaceAge__/graphics/oil_processing/methane.png"
-- And change tint - used for pipes, barrels.
--local color = {r = .698, g = .227, b = .490} -- tried pink
local methaneColor = {r = .714, g = .796, b = .259} -- yellow-green
data.raw.fluid["adamo-carbon-methane"].base_color = methaneColor
data.raw.fluid["adamo-carbon-methane"].flow_color = methaneColor
data.raw.fluid["adamo-carbon-methane"].visualization_color = methaneColor
]]

-- TODO rewrite this to rather not depend on Adamo Carbon, bc I'm changing a lot more.