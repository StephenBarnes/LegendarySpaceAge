local Export = {}

local inWorldAlpha = .6
Export.batteryGlowTint = {.663, .922, 1}
Export.batteryGlowTintWithAlpha = Gen.addAlpha(Export.batteryGlowTint, inWorldAlpha)
Export.holmiumBatteryGlowTint = {1, .727, .955}
Export.holmiumBatteryGlowTintWithAlpha = Gen.addAlpha(Export.holmiumBatteryGlowTint, inWorldAlpha)

return Export