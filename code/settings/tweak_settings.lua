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