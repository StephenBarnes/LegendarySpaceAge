-- Tweaking the Electric Boiler mod.

local Tech = require("code.util.tech")

-- Remove tech, rather move recipe to fluid handling.
Tech.hideTech("electric-boiler")
Tech.addRecipeToTech("electric-boiler", "fluid-handling", 6)