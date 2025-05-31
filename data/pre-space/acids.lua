--[[ This file makes acids and related items.
]]

-- TODO adjust colors a bit so phosphoric and fluoric are further from chloric.

local acidData = {
	nitric = {
		acidLiquidColor = {.8784, .349, .3137},
		saltName = "niter",
		saltColor = {176, 47, 40},
		gasName = "nox-gas",
	},
	sulfuric = {
		acidLiquidColor = {.9961, .8588, .3098},
		saltName = "salt-cake",
		saltColor = {184, 152, 33},
		gasName = "sulfur-dioxide",
	},
	chloric = {
		acidLiquidColor = {.651, .8078, .3686},
		saltName = "salt",
		saltColor = {121, 158, 52},
		gasName = "chlorine-gas",
	},
	phosphoric = {
		acidLiquidColor = {71, 200, 167},
		saltName = "phosphate-salt",
		saltColor = {34, 152, 121},
		gasName = "phosphine-gas",
	},
	fluoric = {
		acidLiquidColor = {79, 152, 234},
		saltName = "fluoride-salt",
		saltColor = {38, 108, 184},
		gasName = "fluorine-gas",
	},
}

local count = 0
for name, data in pairs(acidData) do
	count = count + 1

	-- Create or modify acid fluid.
	local acidName = name.."-acid"
	local acidFluid = FLUID[acidName]
	if acidFluid == nil then
		acidFluid = copy(FLUID["sulfuric-acid"])
		acidFluid.name = acidName
		acidFluid.localised_name = nil
		acidFluid.localised_description = nil
		extend{acidFluid}
		acidFluid = FLUID[acidName]
	end
	acidFluid.base_color = data.acidLiquidColor
	acidFluid.visualization_color = data.acidLiquidColor
	acidFluid.flow_color = {1, 1, 1}
	Icon.set(acidFluid, {{"LSA/fluids/tintable-drop/tintable-drop", tint = data.acidLiquidColor}, "LSA/fluids/tintable-drop/overlay-reflection"}, "overlay")

	-- Create or modify salt item.
	local saltName = data.saltName
	local saltItem = ITEM[saltName]
	if saltItem == nil then
		saltItem = copy(ITEM.sulfur)
		saltItem.name = saltName
		saltItem.localised_name = nil
		saltItem.localised_description = nil
		extend{saltItem}
		saltItem = ITEM[saltName]
	end
	Icon.set(saltItem, {{"LSA/salt/" .. count, tint = data.saltColor}}) -- Use different variant as primary icon for each salt.
	Icon.variants(saltItem, "LSA/salt/%", 5)

	-- Create or modify gas.
	local gasName = data.gasName
	local gasFluid = FLUID[gasName]
	if gasFluid == nil then
		gasFluid = copy(FLUID.steam)
		gasFluid.name = gasName
		gasFluid.localised_name = nil
		gasFluid.localised_description = nil
		Fluid.setSimpleTemp(gasFluid, 0, false)
		extend{gasFluid}
		gasFluid = FLUID[gasName]
	end
	gasFluid.base_color = data.acidLiquidColor
	gasFluid.visualization_color = data.acidLiquidColor -- TODO get lighter color for this, so it's not the same as the acid liquid.
	gasFluid.flow_color = {1, 1, 1}
	Icon.set(gasFluid, {{"LSA/fluids/gas-3", tint = data.acidLiquidColor}})
end