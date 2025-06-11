--[[ This file creates electrode items, and recipes for them.
Currently only graphite electrodes, TODO more later.
]]

-- Create graphite electrode item, and hot variant.
local graphiteElectrodeItem = copy(ITEM.carbon)
graphiteElectrodeItem.name = "graphite-electrode"
Icon.set(graphiteElectrodeItem, "LSA/graphite-electrodes/base-1")
Icon.variants(graphiteElectrodeItem, "LSA/graphite-electrodes/base-%", 2)
extend{graphiteElectrodeItem}

-- Create hot variant.
local hotGraphiteElectrodeItem = copy(graphiteElectrodeItem)
hotGraphiteElectrodeItem.name = "hot-graphite-electrode"
Icon.set(hotGraphiteElectrodeItem, {{"LSA/graphite-electrodes/glow-1", draw_as_glow = true}, "LSA/graphite-electrodes/base-1"}, "overlay")
hotGraphiteElectrodeItem.pictures = {
	{layers = {
		{filename = "__LegendarySpaceAge__/graphics/graphite-electrodes/base-1.png", size = 64, scale = 0.5},
		{filename = "__LegendarySpaceAge__/graphics/graphite-electrodes/glow-1.png", draw_as_glow = true, size = 64, scale = 0.5, tint = {.5, .5, .5, .5}},
	}},
	{layers = {
		{filename = "__LegendarySpaceAge__/graphics/graphite-electrodes/base-2.png", size = 64, scale = 0.5},
		{filename = "__LegendarySpaceAge__/graphics/graphite-electrodes/glow-2.png", draw_as_glow = true, size = 64, scale = 0.5, tint = {.5, .5, .5, .5}},
	}},
}
hotGraphiteElectrodeItem.spoil_ticks = 5 * MINUTES
hotGraphiteElectrodeItem.spoil_result = "graphite-electrode"
extend{hotGraphiteElectrodeItem}
-- TODO actually I'm not sure we want a hot variant. Maybe rather make a worn variant.