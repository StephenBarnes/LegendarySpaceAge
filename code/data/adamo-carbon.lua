-- Make the new fluids show up in the fluids tab in Factoriopedia.
data.raw.fluid["adamo-carbon-natural-gas"].subgroup = "fluid"
data.raw.fluid["adamo-carbon-methane"].subgroup = "fluid"
data.raw.fluid["adamo-carbon-syngas"].subgroup = "fluid"

-- Make the gasifier fluid input show that it takes steam, and output shows it produces syngas.
data.raw.furnace["adamo-carbon-gasifier"].fluid_boxes[1].filter = "steam"
data.raw.furnace["adamo-carbon-gasifier"].fluid_boxes[2].filter = "adamo-carbon-syngas"
-- (Note: using the option to also make oil processing recipes use steam instead of water. This also applies to this syngas-from-fuel recipe.)
-- (Considered making the gasifier take either water or steam, but fluid box filter doesn't support multiple fluids.)

-- TODO improve some recipe icons.

-- TODO lots more tweaks
-- TODO integrate with Boompuff Agriculture mod
