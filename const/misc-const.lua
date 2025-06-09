-- Returns misc constants.
return {
	-- Fluid vented by gas vents and waste pumps per second.
	gasVentAmount = 10,
	wastePumpAmount = 100,
	gasVentTime = 0.1,
	wastePumpTime = 0.1,
	-- Multiplier for pollution from waste pumping, which produces less pollution than gas venting.
	wastePumpPollutionMult = 0.5,
}