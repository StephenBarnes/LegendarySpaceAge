--[[ For some entities, we want their energy consumption to scale with the amount they produce.
For example, battery chargers charge up (say) 1MJ worth of batteries per second, and have energy consumption 1MW. If you could make it charge 2MJ per second instead, this creates an exploit where you could make infinite energy by just making a whole bunch of battery chargers.
Similar issues apply to char furnaces and gasifiers.

Higher-quality entities have higher speed, but don't have higher energy consumption. There's no simple way to make quality also scale energy consumption, or to make quality not scale speed, or to disable quality for these entities/items.

So instead, this file makes a variant of these entities for each quality, with the same properties except different energy consumption. Then in control stage, we run a script to replace built entities with the appropriate quality variant.
]]

-- TODO add notes to ent descriptions.

local SPEED_PER_QUALITY = 0.3 -- Doesn't seem to be configurable.

local QualityScalingPowerConsumption = require("util.const.quality-scaling-power-consumption")

for _, vals in pairs(QualityScalingPowerConsumption) do
	local normalEnt = RAW[vals[1]][vals[2]]
	for _, q in pairs(RAW.quality) do
		if q.level ~= 0 then -- Skip normal quality
			local newEnt = copy(normalEnt)
			newEnt.name = newEnt.name.."-"..q.name
			newEnt.localised_name = {"entity-name."..normalEnt.name}
			newEnt.localised_description = {"entity-description."..normalEnt.name}
			newEnt.placeable_by = {item = normalEnt.name, count = 1}
				--[[ Other mods that do this kind of one-proto-per-quality thing have a quality= field here. But that field does not exist. https://lua-api.factorio.com/latest/types/ItemToPlace.html
				Despite the non-existence of that field, those other mods mostly work anyway because the player has no way to copy an XYZ-legendary with normal quality unless one has already been placed.
				But there's a way around that. Make an upgrade planner that replaces XYZ-legendary (legendary) with XYZ-legendary (normal). Then you can copy-paste that one to place unlimited XYZ-legendary (normal) using only normal quality XYZ-normal items.
				That's a minor exploit, 
				]]
			newEnt.hidden_in_factoriopedia = true
			-- TODO try to hide ent in upgrade-planner too.
			local energyUsage = Gen.multWithUnits(normalEnt.energy_usage, 1 + SPEED_PER_QUALITY * q.level)
			assert(energyUsage ~= nil, "energy_usage is nil for "..normalEnt.name) -- Returns nil if the number is 0, in which case the ent shouldn't be on the list above.
			---@diagnostic disable-next-line: assign-type-mismatch
			newEnt.energy_usage = energyUsage
			data:extend{newEnt}
		end
	end
end

--[[
	local k = q.name
	local v = 1 + 0.3 * q.level

	local heat_pipe = table.deepcopy(data.raw["heat-pipe"]["heat-pipe"])
	local heating_radius = heat_pipe.heating_radius or 1
	heat_pipe.name = k.."-"..heat_pipe.name
	heat_pipe.max_health = heat_pipe.max_health * v
	heat_pipe.heating_radius = heating_radius + q.level
	heat_pipe.localised_name = {"entity-name.heat-pipe"}
	heat_pipe.localised_description = {"entity-description.heat-pipe"}
	heat_pipe.placeable_by = {item = "heat-pipe", count = 1, quality = k}
	heat_pipe.hidden_in_factoriopedia = true

	data:extend{heat_pipe}
	]]