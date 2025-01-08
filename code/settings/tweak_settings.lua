local u = require("code.settings.util")

-- Set power multipliers for PowerMultiplier mod.
u.setDefaultOrForce("PowerMultiplier-electrical", "double", 2)
u.setDefaultOrForce("PowerMultiplier-burner", "double", 2)
u.setDefaultOrForce("PowerMultiplier-nutrient", "double", 1)
u.setDefaultOrForce("PowerMultiplier-heating", "double", 1) -- Already making heating towers less efficient.
u.setDefaultOrForce("PowerMultiplier-solar", "double", 1)
u.setDefaultOrForce("PowerMultiplier-blacklist", "string", "battery-charger,battery-discharger")

-- Set options for Ocean Dumping mod.
-- Makes logical sense on Fulgora and Aquilo. Makes less sense on Nauvis and Gleba, but I need it on Gleba (eg voiding extra stone from slipstacks) and I don't want Nauvis to be the only exception.
u.setDefaultOrForce("enable-nauvis-dumping", "bool", true)
u.setDefaultOrForce("enable-gleba-dumping", "bool", true)
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

-- For Roc's Rusting Iron mod.
u.setDefaultOrForce("rocs-rusting-iron-engines-rust", "bool", false)
u.setDefaultOrForce("rocs-rusting-iron-time-minutes", "double", 20.)

-- For Large Storage Tank and inline storage tanks.
-- Regular 3x3 tank is 25k. Making large 5x5 tank 100k, and small 1x1 tank 2k.
u.setDefaultOrForce("large-storage-tank-fluid-size", "int", 100000)
u.setDefaultOrForce("tiny-storage-tank-volume", "int", 2000)

-- For Gas Furnace mod.
-- No settings.

-- For Power Overload
-- TODO set pole maxes
-- TODO set transformer efficiency to 98% and hide it.
