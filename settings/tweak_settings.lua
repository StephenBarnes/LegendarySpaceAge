local u = require("settings.util")

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

-- For est-tiny-storage-tank.
u.setDefaultOrForce("tiny-storage-tank-unlock", "string", "with-fluid-handling")

-- For hand-crank mod.
u.setDefaultOrForce("er-hcg-run-time-in-seconds", "int", 200)
u.setDefaultOrForce("er-hcg-crank-delay-in-ticks", "int", 5)
u.setDefaultOrForce("er-hcg-run-time-per-crank-in-seconds", "int", 20)
u.setDefaultOrForce("er-hcg-power-output-in-watts", "int", 500e3) -- Default is 20kW, I'm increasing to 500kW.
u.setDefaultOrForce("er-hcg-recipe-enabled", "bool", false) -- Don't create the crank recipe or tech.

-- Settings for Cargo Ships.
u.setDefaultOrForce("floating_pole_enabled", "bool", true) -- Setting to false causes error on startup. Rather manually hiding it in data stage.
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

-- Settings for Personal Burner Generator.
u.setDefaultOrForce("personal-burner-generator-power-output", "int", 200) -- 200kW, same as default.
u.setDefaultOrForce("personal-burner-generator-pollution-output", "int", 10) -- Same as default, roughly commensurate with boilers.
u.setDefaultOrForce("personal-burner-generator-fuel-efficiency", "double", 0.5) -- So consumes 400kW, provides 200kW.
u.setDefaultOrForce("personal-burner-generator-burner-inventory-size", "int", 4)

-- For Gas Boiler.
u.setDefaultOrForce("vanilla-fluid-fuel-values", "bool", false)

-- For Gas Furnace mod.
-- No settings.

-- For Power Overload
for pole, maxPower in pairs{
	["small-electric-pole"] = "10MW",  -- Default 10MW.
	["medium-electric-pole"] = "50MW", -- Default 60MW.
	["big-electric-pole"] = "500MW", -- Default 300MW.
	["po-huge-electric-pole"] = "3GW", -- Default 3GW. Disabling.
	["po-small-electric-fuse"] = "9MW", -- Default 8MW.
	["po-medium-electric-fuse"] = "48MW", -- Default 48MW.
	["po-big-electric-fuse"] = "480MW", -- Default 240MW.
	["po-huge-electric-fuse"] = "2.4GW", -- Default 2.4GW. Disabling.
	["substation"] = "100MW", -- Default 120MW.
	["po-interface"] = "100GW", -- Default 100GW. Disabling.
	["floating-electric-pole"] = "1.5GW", -- Default 1.5GW. Disabling so it doesn't matter.
} do
	u.setDefaultOrForce("power-overload-max-power-"..pole, "string", maxPower)
end
-- Transformer efficiency
u.setDefaultOrForce("power-overload-transformer-efficiency", "double", 0.98)