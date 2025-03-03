-- This file has utils for setting properties of fluids.

local Fluid = {}

---@param fluidName string
---@return number
Fluid.getJoules = function(fluidName, allowZero)
	local fluid = FLUID[fluidName]
	assert(fluid ~= nil, "Fluid "..fluidName.." not found.")
	if not allowZero then
		assert(fluid.fuel_value ~= nil, "Fluid "..fluidName.." has no fuel value.")
	else
		if fluid == nil or fluid.fuel_value == nil then
			return 0
		end
	end
	return Gen.toJoules(fluid.fuel_value)
end

-- Function to set temperatures of gases and liquids. Setting heat capacity and max temp to nil so they don't spam the tooltip, but setting default temp since that's shown on pipelines anyway.
Fluid.setSimpleTemp = function(fluid, boilingPoint, isLiquid, liquidDefault)
	fluid.heat_capacity = nil
	fluid.max_temperature = nil
	if isLiquid then
		fluid.default_temperature = boilingPoint
		fluid.gas_temperature = boilingPoint + 1 -- To make it a liquid.
	else
		liquidDefault = liquidDefault or 10 -- Room temperature used for liquids.
		fluid.default_temperature = liquidDefault
		fluid.gas_temperature = boilingPoint -- Since these are all lower than 10, this will make them a gas.
	end
end

Fluid.hide = function(fluidName)
	local fluid = FLUID[fluidName]
	assert(fluid ~= nil, "Fluid "..fluidName.." not found.")
	fluid.hidden = true
	fluid.hidden_in_factoriopedia = true
end

return Fluid