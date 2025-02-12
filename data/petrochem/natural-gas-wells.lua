-- This file will create natural gas wells. Other files will make them autoplace on Nauvis (replacing some crude oil wells) and Aquilo (replacing all crude oil wells).
-- Some code adapted from Adamo Carbon mod.

local constants = require("data.petrochem.constants")

local gasWell = copy(RAW.resource["crude-oil"])
gasWell.name = "natural-gas-well"
gasWell.icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/natural-gas-well-icon.png", icon_size = 64, mipmap_count = 4}}
gasWell.icon = nil
gasWell.minable.results = {{
	type = "fluid",
	name = "natural-gas",
	amount_min = 30,
	amount_max = 30,
}}
gasWell.resource_patch_search_radius = 20
-- Leaving the autoplace the same as crude oil.
gasWell.map_color = constants.natgasColor
gasWell.stages = copy(RAW.resource["lithium-brine"].stages)
gasWell.stages.layers[1].filename = "__LegendarySpaceAge__/graphics/petrochem/natural-gas-well.png"
gasWell.stateless_visualisation = copy(RAW.resource["lithium-brine"].stateless_visualisation)
gasWell.stateless_visualisation[1].animation.tint = constants.natgasSmokeTint
gasWell.stateless_visualisation[2].animation.tint = constants.natgasSmokeTint
gasWell.stateless_visualisation[3].animation.tint = constants.natgasSmokeTint
gasWell.stateless_visualisation[4].animation.tint = constants.natgasSmokeTint
data:extend{gasWell}