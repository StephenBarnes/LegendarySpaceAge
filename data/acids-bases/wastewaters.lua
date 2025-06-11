--[[ This file creates wastewaters, and recipes for them.
There's an acidic wastewater for each acid: chloric, sulfuric, nitric, fluoric, and phosphoric.
There's 2 alkaline wastewaters: lime and alkali.
Also ammonia water.
Maybe also heavy-metal wastewater, and organic wastewater.
]]

local Const = require("const.chemistry-const")

-- Create acidic wastewaters.
for name, data in pairs(Const.acids) do
	local wastewaterName = name.."-wastewater"
	local fluid = FLUID[wastewaterName]
	if fluid == nil then
		fluid = copy(FLUID["sulfuric-acid"])
		fluid.name = wastewaterName
		extend{fluid}
		fluid = FLUID[wastewaterName]
	end
	fluid.localised_name = {"fluid-name.X-wastewater", {"acid-prefix-cap."..name}}
	fluid.localised_description = nil
	fluid.auto_barrel = true
	fluid.base_color = data.saltColor
	fluid.flow_color = data.acidLightColor
	fluid.visualization_color = data.saltColor
	Icon.set(fluid, {
		{"LSA/wastewater/drop-tintable-layer", tint = data.acidLiquidColor},
		{"LSA/wastewater/gleam-layer"},
		{"LSA/wastewater/solid-layer", tint = data.saltColor},
	}, "overlay")
end

-- Create alkaline wastewaters.
for name, data in pairs(Const.baseWastewaters) do
	local wastewaterName = name.."-wastewater"
	local fluid = FLUID[wastewaterName]
	if fluid == nil then
		fluid = copy(FLUID["sulfuric-acid"])
		fluid.name = wastewaterName
		extend{fluid}
		fluid = FLUID[wastewaterName]
	end
	fluid.localised_name = {"fluid-name.X-wastewater", {"base-prefix-cap."..name}}
	fluid.localised_description = nil
	fluid.auto_barrel = true
	fluid.base_color = data.darkerColor
	fluid.flow_color = data.color
	fluid.visualization_color = data.darkerColor
	Icon.set(fluid, {
		{"LSA/wastewater/drop-tintable-layer", tint = data.color},
		{"LSA/wastewater/gleam-layer"},
		{"LSA/wastewater/solid-layer", tint = data.darkerColor},
	}, "overlay")
end