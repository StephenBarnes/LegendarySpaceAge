-- This file creates the "geoplasm" fluid, extracted using borehole drills on Gleba. And later create recipes etc. TODO.

local geoplasmFluid = table.deepcopy(data.raw.fluid["lubricant"])
geoplasmFluid.name = "geoplasm"
geoplasmFluid.icon = "__LegendarySpaceAge__/graphics/gleba/geoplasm.png"
-- TODO set colors
data:extend{geoplasmFluid}
