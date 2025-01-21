-- This file tweaks the Cargo Ships mod.
-- TODO

local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

-- Remove the oversea energy distribution tech, and the floating electric pole - removes the Fulgora power challenge, and makes Aquilo boring.
Tech.hideTech("oversea-energy-distribution")
Recipe.hide("floating-electric-pole")

-- TODO move around techs - ships should be unlocked after Aquilo.

-- TODO check how it interacts with the ocean-dumping stuff. Need to disable inserters when no ship docked. Although there are fluid tankers, could use those.