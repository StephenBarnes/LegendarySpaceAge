-- This file modifies worldgen for Nauvis.

-- Increase aggregation range for oil/gas wells, since it seems to fail most of the time.
data.raw.resource["crude-oil"].resource_patch_search_radius = 20 -- Increased 12->20.

-- Edit name of autoplace control for crude oil, to emphasize that it's also used for natural gas wells. Can't do this with just locale strings.
data.raw["autoplace-control"]["crude-oil"].localised_name = {"autoplace-control-name.crude-oil-natgas"}