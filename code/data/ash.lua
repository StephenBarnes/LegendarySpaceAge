--[[ This file adds ash to the game.
Ash is produced by burning wood, coal, and organic stuff (seeds, fruits, spoilage).
	Not produced by burning carbon, sulfur, pitch, resin, barreled fluids.
Uses of ash:
	* (Can just toss it in a lake.)
	* Fertilizer - it's an ingredient.
	* Refined concrete - it's an ingredient.
	* Glass - it's an ingredient, with sand, for "batch" or "glass batch", which is then smelted into glass. This is realistic.
	* Process it for a smaller amount of carbon, plus maybe some sulfur.
		Use water + sulfuric acid + ash as ingredients.
		Produce carbon, plus small amounts of iron ore, copper ore, sand.
]]

local Tech = require("code.util.tech")

-- Create ash item.
local item = table.deepcopy(data.raw.item["sulfur"])
item.name = "ash"
local ashDir = "__LegendarySpaceAge__/graphics/ash/"
item.icon = ashDir.."1.png"
item.pictures = {}
for i = 1, 3 do
	item.pictures[i] = {filename = ashDir..i..".png", size = 64, scale = 0.5}
end
item.order = "0"
data:extend{item}