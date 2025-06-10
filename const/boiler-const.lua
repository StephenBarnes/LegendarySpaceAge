-- Constants for boilers.

local Export = {}

-- Indices of fluid boxes in the fluid_boxes table of the new assembling-machine boilers. NOTE this must match up with the entity definitions in boiler-entities.lua.
Export.nonBurnerFluidBoxIndex = {
	liquidToBoil = 1,

	boiledGasOutput = 1,
	brineOutput = 2,
}
Export.burnerFluidBoxIndex = {
	liquidToBoil = 1,
	airInput = 2,

	boiledGasOutput = 1,
	flueOutput = 2,
	brineOutput = 3,
}

-- Link ID for the air input fluid box for burner boiler on planets with air in the atmosphere.
Export.airLinkId = 1

return Export