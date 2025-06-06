--[[ This file creates wastewaters, and recipes for them.
There's an acidic wastewater for each acid: chloric, sulfuric, nitric, fluoric, and phosphoric.
There's 2 alkaline wastewaters: lime and alkali.
Also ammonia water.
Maybe also heavy-metal wastewater, and organic wastewater.
]]

local Const = require("const.chemistry-const")
local AcidData = Const.acids
local BaseWastewaters = Const.baseWastewaters


-- Create acidic wastewaters.
for name, data in pairs(AcidData) do
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
for name, data in pairs(BaseWastewaters) do
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
	fluid.base_color = data.color
	fluid.flow_color = data.darkerColor
	fluid.visualization_color = data.color
	Icon.set(fluid, {
		{"LSA/wastewater/drop-tintable-layer", tint = data.color},
		{"LSA/wastewater/gleam-layer"},
		{"LSA/wastewater/solid-layer", tint = data.darkerColor},
	}, "overlay")
end

-- Create cross-neutralization recipes between 2 wastewaters.
for acidName, acidData in pairs(AcidData) do
	for baseName, baseData in pairs(BaseWastewaters) do
		local recipeName = "neutralize-"..acidName.."-"..baseName.."-wastewaters"
		local acidWastewaterName = acidName.."-wastewater"
		local baseWastewaterName = baseName.."-wastewater"
		Recipe.make{
			recipe = recipeName,
			copy = "sulfuric-acid-from-gas",
			localised_name = {"recipe-name.neutralize-X-Y-wastewaters", {"acid-prefix-cap."..acidName}, {"base-prefix."..baseName}},
			ingredients = {
				{acidWastewaterName, 10},
				{baseWastewaterName, 10},
			},
			results = {
				{acidData.saltName, 1},
				{"steam", 10},
				{"carbon-dioxide", 10},
				-- TODO this should be more involved, eg generate gypsum or phosphate salt; carbon dioxide only for alkali wastewater, not lime?
			},
			main_product = "steam",
			icons = {
				"exo",
				acidWastewaterName,
				baseWastewaterName,
			},
			iconArrangement = "crossNeutralization",
			crafting_machine_tint = {
				primary = acidData.acidLiquidColor,
				secondary = baseData.color,
			},
		}
	end
end

-- TODO create cross-neutralization recipes (acids with bases, OR acid/base with wastewaters, OR two wastewaters with each other)
-- TODO create other recipes, eg alkali wastewater with CO2, or with flue gas.