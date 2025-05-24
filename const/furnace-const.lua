local Export = {}

Export.fireGlow = {100, 19, 19}
Export.fireCore = {255, 153, 153}

-- Bounding box. Must be the same between all of them (except electric), so they can be hot-replaced. Must be symmetrical so it can be rotated.
Export.boundingBox = {{-0.9, -0.9}, {0.9, 0.9}}

Export.airLinkId = 1
Export.outputLinkId = 2

-- Fluid box indices, used by recipes.
Export.airFluidBoxIdx = 1
Export.oxygenFluidBoxIdx = 2
Export.outputGasFluidBoxIdx = 1 -- Indexes start at 1 again for output.

return Export