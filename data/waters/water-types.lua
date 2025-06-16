-- This file creates different types of water.

local WatersConst = require "const.waters-const"

-- Create fluids.
for name, data in pairs(WatersConst) do
	local fluid = copy(FLUID.water)
	fluid.name = name
	Icon.set(fluid, data.icon)
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