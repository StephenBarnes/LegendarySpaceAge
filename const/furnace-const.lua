local Export = {}

Export.fireGlow = {100, 19, 19}
Export.fireCore = {255, 153, 153}

-- Bounding box. Must be the same between all of them (except electric), so they can be hot-replaced. Must be symmetrical so it can be rotated.
Export.boundingBox = {{-0.95, -0.95}, {0.95, 0.95}}

return Export
