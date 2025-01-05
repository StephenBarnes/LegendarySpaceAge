-- Change recycling recipes so plates/gears/sticks give back cold ingots. (Otherwise there's no way to get ingots on Fulgora.)
--[[
data.raw.recipe["iron-plate-recycling"].results = {{type = "item", name = "ingot-iron-cold", amount = 1, probability = 1 / (8 * 4)}} -- 1 ingot to 8 plates, and recycling gives 1/4th of that.
data.raw.recipe["iron-stick-recycling"].results = {{type = "item", name = "ingot-iron-cold", amount = 1, probability = 1 / (16 * 4)}}
data.raw.recipe["iron-gear-wheel-recycling"].results = {{type = "item", name = "ingot-iron-cold", amount = 1, probability = 1 / (4 * 4)}}
data.raw.recipe["steel-plate-recycling"].results = {{type = "item", name = "ingot-steel-cold", amount = 1, probability = 1 / (2 * 4)}}
data.raw.recipe["copper-plate-recycling"].results = {{type = "item", name = "ingot-copper-cold", amount = 1, probability = 1 / (8 * 4)}}
data.raw.recipe["copper-cable-recycling"].results = {{type = "item", name = "ingot-copper-cold", amount = 1, probability = 1 / (16 * 4)}}
data.raw.recipe["low-density-structure-recycling"].results = {
	{type = "item", name = "ingot-copper-cold", amount = 1},
	{type = "item", name = "ingot-steel-cold", amount = 1, probability = 1 / 4},
	{type = "item", name = "plastic-bar", amount = 1, extra_count_fraction = 1/4},
}
]]
-- TODO rather rewrite this to only substitute hot ingots (in recycling recipe results) with cold ingots. Then use the auto-recycle flag to make recycling recipes for plates etc output hot ingots.

-- TODO add automatic check over all recycling recipes - none of them should give back hot ingots.