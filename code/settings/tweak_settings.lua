local u = require("code.settings.util")

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
u.setDefaultOrForce("data-dd-enable-flares", "bool", false)
u.setDefaultOrForce("data-dd-lampon", "double", 0.5)
u.setDefaultOrForce("data-dd-lampoff", "double", 0.3)

-- For Large Storage Tank and inline storage tanks.
-- Regular 3x3 tank is 25k. Making large 5x5 tank 100k, and small 1x1 tank 2k.
u.setDefaultOrForce("large-storage-tank-fluid-size", "int", 100000)
u.setDefaultOrForce("tiny-storage-tank-volume", "int", 2000)

-- For hand-crank mod.
u.setDefaultOrForce("er-hcg-run-time-in-seconds", "int", 30)
u.setDefaultOrForce("er-hcg-crank-delay-in-ticks", "int", 5)
u.setDefaultOrForce("er-hcg-run-time-per-crank-in-seconds", "int", 20)
u.setDefaultOrForce("er-hcg-power-output-in-watts", "int", 500e3) -- Default is 20kW, I'm increasing to 500kW.
u.setDefaultOrForce("er-hcg-recipe-enabled", "bool", false) -- Don't create the crank recipe or tech.

-- Settings for Cargo Ships.
u.setDefaultOrForce("offshore_oil_enabled", "bool", false) -- Disable the offshore oil and oil rig.
u.setDefaultOrForce("oil_rig_capacity", "int", 100) -- Irrelevant bc no oil rigs.
u.setDefaultOrForce("oil_rigs_require_external_power", "string", "disabled") -- Irrelevant bc no oil rigs.
u.setDefaultOrForce("no_oil_for_oil_rig", "bool", false) -- Irrelevant bc no oil rigs.
u.setDefaultOrForce("no_shallow_oil", "bool", false) -- Irrelevant bc no oil rigs.
u.setDefaultOrForce("speed_modifier", "double", 1)
u.setDefaultOrForce("fuel_modifier", "double", 2)
u.setDefaultOrForce("tanker_capacity", "int", 250) -- Irrelevant, they're disabled.
u.setDefaultOrForce("no_catching_fish", "bool", false) -- Allow catching fish. No fish on Aquilo anyway.
u.setDefaultOrForce("use_dark_blue_waterways", "bool", false) -- Irrelevant, only for legacy waterways.

-- For Gas Furnace mod.
-- No settings.

-- For Power Overload
-- TODO set pole maxes
-- TODO set transformer efficiency to 98% and hide it.
