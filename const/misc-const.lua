-- Returns misc constants.
return {
	-- Separator between entity name and quality suffix. Chosen to hopefully not appear in the IDs of any modded entities.
	qualitySeparator = "-LSA_",

	-- Quality suffix is quality separator followed by level of quality as a number with this many digits.
	qualityNumDigits = 5,

	-- Fluid vented by gas vents and waste pumps per second.
	gasVentRate = 100,
	wastePumpRate = 1000,
	-- Multiplier for pollution from waste pumping, which produces less pollution than gas venting.
	wastePumpPollutionMult = 0.5,
}