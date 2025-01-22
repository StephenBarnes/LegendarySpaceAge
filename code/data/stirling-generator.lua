-- This file adjusts the Stirling generator building added by other mod.

-- Reducing efficiency 0.8 to 0.5 for more reason to prefer steam.
data.raw["burner-generator"]["stirling-generator"].burner.effectivity = 0.5

-- Move to start of row, after hand-crank.
data.raw.item["stirling-generator"].order = "a2"

-- Constructible wherever oxygen pressure is above threshold, so not on Fulgora.
data.raw["burner-generator"]["stirling-generator"].surface_conditions = {{property = "oxygen-pressure", min = 10}}