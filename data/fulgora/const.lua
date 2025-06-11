local Export = {}

local function addAlpha(color, alpha)
	return {color[1] * alpha, color[2] * alpha, color[3] * alpha, alpha}
end

local inWorldAlpha = .6
Export.batteryGlowTint = {.663, .922, 1}
Export.batteryGlowTintWithAlpha = addAlpha(Export.batteryGlowTint, inWorldAlpha)
Export.holmiumBatteryGlowTint = {1, .727, .955}
Export.holmiumBatteryGlowTintWithAlpha = addAlpha(Export.holmiumBatteryGlowTint, inWorldAlpha)

return Export