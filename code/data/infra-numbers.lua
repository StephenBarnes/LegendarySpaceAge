--[[ This file adjusts speed, electricity usage, pollution, etc. for infrastructure.
Aims:
* Create more interesting tradeoffs. E.g. sometimes you should prefer assembler 1's and 2's even when you have 3's.
* Generally I want even numbers so production rates are simple numbers.
* Generally increase electricity usages to make the game a bit harder. (Formerly used PowerMultiplier mod. But rather not using that, rather just set them all separately.)
]]

-- Assemblers: Simplifying speeds to 0.5 -- 1 -- 2. Going to make the more advanced ones have higher drain when not active, and also worse electricity-per-product and pollution-per-product. But the module slots can make them worth using.
for _, vals in pairs{ -- Table of name, speed, drain kW, active energy kW, pollution.
	{ "assembling-machine-1", 0.5, 1,   100,  4 },
	{ "assembling-machine-2", 1,   20,  250,  10 },
	{ "assembling-machine-3", 2,   500, 1000, 25 },
} do
	local ent = data.raw["assembling-machine"][vals[1]]
	ent.crafting_speed = vals[2]
	ent.energy_source.drain = vals[3] .. "kW"
	ent.energy_usage = (vals[4] - vals[3]) .. "kW"
	ent.energy_source.emissions_per_minute = { pollution = vals[5] }
end

-- Furnaces
-- Make stone furnaces generally more fuel-hungry.
data.raw.furnace["stone-furnace"].energy_usage = "200kW"
-- Steel furnaces basically the same - similar fuel usage as stone furnaces, but double speed and pollution.
data.raw.furnace["steel-furnace"].energy_usage = "250kW"
data.raw.furnace["gas-furnace"].energy_usage = "300kW"
-- Electric furnaces same speed as steel furnaces, lower pollution (though electricity gen generates pollution). But make them have high drain so they're bad when not needed. Also give them higher energy consumption since they're more convenient bc no fuel needed. And note they have module slots so energy increase isn't all that bad.
data.raw.furnace["electric-furnace"].energy_usage = "400kW"
data.raw.furnace["electric-furnace"].energy_source.drain = "100kW"


-- TODO also edit modules to instead be like +25% or +20%, not e.g. +30%.