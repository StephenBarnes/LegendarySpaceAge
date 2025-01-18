-- This file adjusts worldgen on Vulcanus.

-- Disable coal spawns on Vulcanus.
data.raw["autoplace-control"]["vulcanus_coal"] = nil
data.raw.planet.vulcanus.map_gen_settings.property_expression_names["entity:coal:probability"] = nil
data.raw.planet.vulcanus.map_gen_settings.property_expression_names["entity:coal:richness"] = nil
data.raw.planet.vulcanus.map_gen_settings.autoplace_controls["vulcanus_coal"] = nil
data.raw.planet.vulcanus.map_gen_settings.autoplace_settings.entity.settings.coal = nil
-- Also clean up noise expressions - engine should optimize them away, but just in case it doesn't.
data.raw["noise-expression"]["vulcanus_starting_coal"].expression = 0
data.raw["noise-expression"]["vulcanus_coal_size"].expression = 0
data.raw["noise-expression"]["vulcanus_coal_region"].expression = 0
data.raw["noise-expression"]["vulcanus_coal_probability"].expression = 0
data.raw["noise-expression"]["vulcanus_coal_richness"].expression = 0