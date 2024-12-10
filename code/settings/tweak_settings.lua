local u = require("code.settings.util")

-- Set power multipliers for PowerMultiplier mod.
u.setDefaultOrForce("PowerMultiplier-electrical", "double", 2)
u.setDefaultOrForce("PowerMultiplier-burner", "double", 2)
u.setDefaultOrForce("PowerMultiplier-nutrient", "double", 1)
u.setDefaultOrForce("PowerMultiplier-heating", "double", 2)
u.setDefaultOrForce("PowerMultiplier-solar", "double", 1)

-- Set options for Ocean Dumping mod.
u.setDefaultOrForce("enable-nauvis-dumping", "bool", false)
u.setDefaultOrForce("enable-gleba-dumping", "bool", false)
u.setDefaultOrForce("enable-fulgora-dumping", "bool", true)
u.setDefaultOrForce("enable-aquilo-dumping", "bool", true)

-- Set options for the Diurnal Dynamics mod.
u.setDefaultOrForce("data-dd-dark-perc", "double", 100.)
u.setDefaultOrForce("data-dd-dark-platform", "bool", true)
u.setDefaultOrForce("data-dd-diurnal-cycle-mult", "double", 4)
u.setDefaultOrForce("data-dd-accum-mult", "double", 1)
u.setDefaultOrForce("data-dd-night-only", "bool", true) -- Attacks only at night
u.setDefaultOrForce("data-dd-night-mode", "bool", false) -- Not always night
u.setDefaultOrForce("data-dd-dusk", "double", 0.25)
u.setDefaultOrForce("data-dd-evening", "double", 0.35) -- Adjusted to be earlier, 0.45->0.35, for longer night.
u.setDefaultOrForce("data-dd-morning", "double", 0.65) -- Adjusted to be later, 0.55->0.65, for longer night.
u.setDefaultOrForce("data-dd-dawn", "double", 0.75)

-- For Power Overload
-- TODO set pole maxes
-- TODO set transformer efficiency to 98% and hide it.