--[[ This file creates wastewaters, and recipes for them.
There's an acidic wastewater for each acid: chloric, sulfuric, nitric, fluoric, and phosphoric.
There's 2 alkaline wastewaters: lime and alkali.
Also ammonia water.
Maybe also heavy-metal wastewater, and organic wastewater.
]]

local acidData = require("const.chemistry-const").acids

-- Create acidic wastewaters.
for name, data in pairs(acidData) do
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
	fluid.visualization_color = data.saltColor
	fluid.flow_color = data.acidLightColor
	Icon.set(fluid, {
		{"LSA/wastewater/drop-tintable-layer", tint = data.acidLiquidColor},
		{"LSA/wastewater/gleam-layer"},
		{"LSA/wastewater/solid-layer", tint = data.saltColor},
	}, "overlay")
end

-- TODO create the 2 alkaline wastewaters.
-- TODO create cross-neutralization recipes (acids with bases, OR acid/base with wastewaters, OR two wastewaters with each other)
-- TODO create other recipes, eg alkali wastewater with CO2, or with flue gas.