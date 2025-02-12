-- This file adjusts worldgen on Vulcanus.

-- Disable coal spawns on Vulcanus.
RAW["autoplace-control"]["vulcanus_coal"] = nil
RAW.planet.vulcanus.map_gen_settings.property_expression_names["entity:coal:probability"] = nil
RAW.planet.vulcanus.map_gen_settings.property_expression_names["entity:coal:richness"] = nil
RAW.planet.vulcanus.map_gen_settings.autoplace_controls["vulcanus_coal"] = nil
RAW.planet.vulcanus.map_gen_settings.autoplace_settings.entity.settings.coal = nil
-- Also clean up noise expressions - engine should optimize them away, but just in case it doesn't.
RAW["noise-expression"]["vulcanus_starting_coal"].expression = 0
RAW["noise-expression"]["vulcanus_coal_size"].expression = 0
RAW["noise-expression"]["vulcanus_coal_region"].expression = 0
RAW["noise-expression"]["vulcanus_coal_probability"].expression = 0
RAW["noise-expression"]["vulcanus_coal_richness"].expression = 0