-- This file adjusts worldgen on Vulcanus.

-- Disable coal spawns on Vulcanus.
data.raw["noise-expression"]["vulcanus_starting_coal"].expression = 0
data.raw["noise-expression"]["vulcanus_coal_size"].expression = 0
data.raw["noise-expression"]["vulcanus_coal_region"].expression = 0
data.raw["noise-expression"]["vulcanus_coal_probability"].expression = 0
data.raw["noise-expression"]["vulcanus_coal_richness"].expression = 0

--[[log(serpent.block(data.raw.resource["coal"].autoplace.probability_expression))
for _, v in pairs(data.raw["noise-expression"]) do
	log(v.name)
end]]