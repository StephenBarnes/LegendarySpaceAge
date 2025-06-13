-- This file tweaks the Cargo Ships mod.
-- TODO

-- Remove the oversea energy distribution tech, and the floating electric pole - removes the Fulgora power challenge, and makes Aquilo boring.
Tech.hide("oversea-energy-distribution")
Recipe.hide("floating-electric-pole")
ITEM["floating-electric-pole"].hidden = true
RAW["electric-pole"]["floating-electric-pole"].hidden = true

-- Remove tech and recipes for automated bridges.
Tech.hide("automated_bridges")
Recipe.hide("bridge_base")
ITEM["bridge_base"].hidden = true
RAW["train-stop"]["bridge_base"].hidden = true

-- Hide indep-boat separate from regular boat.
RAW.car["indep-boat"].hidden = true
RAW.car["indep-boat"].factoriopedia_alternative = "boat"

-- TODO move around techs - ships should be unlocked on Aquilo, probably.

-- TODO check how it interacts with the ocean-dumping stuff. Need to disable inserters when no ship docked. Although there are fluid tankers, could use those.