--[[ This file creates "spore gas" which is a byproduct of the air separator on Gleba.
Spore gas has no uses, but it needs to be vented, which creates spores.
]]

-- Create spore gas.
local fluid = copy(FLUID["geoplasm"])
fluid.name = "spore-gas"
local color = {.906, .571, .884}
local secondColor = {.387, .557, .173}
fluid.fuel_value = nil
fluid.icon = nil
fluid.icons = {
	{
		icon = "__LegendarySpaceAge__/graphics/fluids/gas-1.png",
		icon_size = 64,
		scale = 0.5,
		tint = color,
	},
}
fluid.base_color = color
fluid.flow_color = secondColor
fluid.visualization_color = color
fluid.auto_barrel = true -- I think it's interesting to allow barreling. So you could make pressurized tanks of it and dump them in a lake - no spores but at the cost of materials to make the tanks. Or you could even launch it into space.
Fluid.setSimpleTemp(fluid, 0, false)
extend{fluid}