-- Graphics for asteroid belts. For some reason this MUST be set in the data-final-fixes stage, not data or data-updates, else the belts don't show up.

local C = require("data.space.constants")

local beltPic = {
	[1] = "__LegendarySpaceAge__/graphics/asteroid-belts/belt.png",
	[2] = "__LegendarySpaceAge__/graphics/asteroid-belts/belt-alt.png",
}
local beltSize = 2210
-- Get utility sprites starmap_star, which holds sprite for sun. Need to add layers table since by default it's just filename, no layers.
local starmapBase = RAW["utility-sprites"]["default"]["starmap_star"]
starmapBase.layers = starmapBase.layers or {}
for _, vals in pairs(C.planetsAndBelts) do
	if vals.drawAsteroidBelt ~= nil then
		local scale = 0.0326 * vals.distance
			-- Set scale so it overlaps with belt node. To re-find this constant, set scale to 1 and measure distance relative to planets, eg if it's at distance 29, then 1/29 is the constant.
		for _, belt in pairs(vals.drawAsteroidBelt) do
			table.insert(starmapBase.layers, {
				filename = beltPic[belt[1]],
				size = beltSize,
				scale = scale,
				shift = {0, 0},
				tint = belt[2],
			})
		end
	end
end
RAW["utility-sprites"]["default"]["starmap_star"] = starmapBase