-- Constants for boilers.

local Export = {}

-- Indices of fluid boxes in the fluid_boxes table of the new assembling-machine boilers. NOTE this must match up with the table in boiler-entities-dff.lua.
Export.fluidBoxIndex = {
	liquidToBoil = 1,
	boiledGasOutput = 1,
	airInput = 2,
	flueOutput = 2,
}

-- Link ID for the air input fluid box for burner boiler on planets with air in the atmosphere.
Export.airLinkId = 1

return Export