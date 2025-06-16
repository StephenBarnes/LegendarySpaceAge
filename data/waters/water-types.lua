-- This file creates different types of water.

-- Colors and icons for fluids. TODO move to const file.
local fluidData = {
	["raw-seawater"] = {
		baseColor = {0, .44, .6},
		flowColor = {.7, .7, .7},
		visColor = {.015, .681, .682}, -- To differentiate from ordinary water.
		icon = "LSA/water-types/raw-seawater",
		autoBarrel = true,
	},
	["clean-seawater"] = {
		baseColor = {0, .44, .6},
		flowColor = {.7, .7, .7},
		visColor = {.015, .681, .682},
		icon = "LSA/water-types/clean-seawater",
		autoBarrel = true,
	},
	["rich-brine"] = {
		baseColor = {0, .44, .6},
		flowColor = {.7, .7, .7},
		visColor = {.015, .681, .682},
		icon = "LSA/water-types/rich-brine",
		autoBarrel = true,
	},
	["bitterns"] = {
		baseColor = {0, .44, .6},
		flowColor = {.7, .7, .7},
		visColor = {.015, .681, .682},
		icon = "LSA/water-types/bitterns",
		autoBarrel = true,
	},
	["mudwater"] = {
		baseColor = {0, .44, .6},
		flowColor = {.7, .7, .7},
		visColor = {.015, .681, .682},
		icon = "LSA/water-types/mudwater",
		autoBarrel = true,
	},
	-- TODO fix up these colors, they're currently placeholders.
}

-- Create fluids.
for name, data in pairs(fluidData) do
	local fluid = copy(FLUID.water)
	fluid.name = name
	Icon.set(fluid, data.icon)
	fluid.auto_barrel = data.autoBarrel
	fluid.base_color = data.baseColor
	fluid.flow_color = data.flowColor
	fluid.visualization_color = data.visColor
	fluid.max_temperature = nil
	fluid.heat_capacity = nil
	extend{fluid}
end

-- Make Nauvis water tiles yield raw seawater.
for _, tileName in pairs{
	"water",
	"deepwater",
	"water-green",
	"deepwater-green",
	"water-shallow",
	"water-mud",
} do
	RAW.tile[tileName].fluid = "raw-seawater"
end