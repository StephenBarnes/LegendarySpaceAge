-- This file tweaks the Cargo Ships mod.
-- TODO

local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

-- Remove the oversea energy distribution tech, and the floating electric pole - removes the Fulgora power challenge, and makes Aquilo boring.
Tech.hideTech("oversea-energy-distribution")
Recipe.hide("floating-electric-pole")
data.raw.item["floating-electric-pole"].hidden = true
data.raw["electric-pole"]["floating-electric-pole"].hidden = true

-- Remove tech and recipes for automated bridges.
Tech.hideTech("automated_bridges")
Recipe.hide("bridge_base")
data.raw.item["bridge_base"].hidden = true

-- TODO move around techs - ships should be unlocked on Aquilo, probably.

-- TODO check how it interacts with the ocean-dumping stuff. Need to disable inserters when no ship docked. Although there are fluid tankers, could use those.