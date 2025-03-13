-- Graphics for asteroid belts. For some reason this MUST be set in the data-final-fixes stage, not data or data-updates, else the belts don't show up.

local C = require("data.space.constants")

local beltPic = "__LegendarySpaceAge__/graphics/asteroid-belts/belt.png"
local beltSize = 2436
-- Get utility sprites starmap_star, which holds sprite for sun. Need to add layers table since by default it's just filename, no layers.
local starmapBase = RAW["utility-sprites"]["default"]["starmap_star"]
starmapBase.layers = starmapBase.layers or {}
for _, vals in pairs(C.planetsAndBelts) do
	if vals.beltRockTint ~= nil then
		local scale = 0.033 * vals.distance -- Set scale so it overlaps with belt node. This constant is chosen bc with scale 0.93 it's at distance 29, so .94/29 is the constant.
		table.insert(starmapBase.layers, {
			filename = beltPic,
			size = beltSize,
			scale = scale,
			shift = {0, 0},
			tint = vals.beltRockTint,
		})
	end
end
RAW["utility-sprites"]["default"]["starmap_star"] = starmapBase
log(serpent.block(starmapBase))