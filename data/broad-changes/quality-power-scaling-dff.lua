--[[ This file makes some entities scale their power consumption with quality. ]]

local QualityPowerScaling = require("const.quality-power-scaling-const")

-- First, we set all quality protos to have energy multiplier the same as their speed multiplier.
for qualityName, quality in pairs(RAW.quality) do
	local oldMultiplier = quality.crafting_machine_energy_usage_multiplier
	local newMultiplier = quality.crafting_machine_speed_multiplier
	if newMultiplier == nil then newMultiplier = quality.default_multiplier end
	if newMultiplier == nil then newMultiplier = quality.level * 0.3 + 1 end

	if oldMultiplier ~= nil and oldMultiplier ~= 1 and oldMultiplier ~= newMultiplier then
		log("WARNING: Some other mod tried to set crafting_machine_energy_usage_multiplier for "..qualityName.." to "..oldMultiplier.." but LSA needs to set it to "..serpent.line(newMultiplier))
	end
	quality.crafting_machine_energy_usage_multiplier = newMultiplier
end

-- Then, set flag on all crafting machines that need to have their power consumption scaled with quality.
for _, typeAndName in pairs(QualityPowerScaling) do
	---@diagnostic disable-next-line: assign-type-mismatch
	local ent = RAW[typeAndName[1]][typeAndName[2]]
	if ent == nil then
		log("WARNING: Entity not found: "..typeAndName[1].." "..typeAndName[2])
	else
		ent.quality_affects_energy_usage = true
	end
end