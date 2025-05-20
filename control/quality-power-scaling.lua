--[[ This file replaces built entities with the appropriate quality variant, so that we can scale power consumption with quality. This is necessary to prevent free-energy exploits using e.g. quality battery chargers that produce more energy than they consume.
See data/final-fixes/quality-power-scaling.lua for the data-side of this and more explanation.
]]

local QualityScalingPowerConsumption = require("util.const.quality-scaling-power-consumption")

local entNameScales = {}
for _, vals in pairs(QualityScalingPowerConsumption) do
	entNameScales[vals[2]] = true
end

---@param e EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
local function onBuilt(e)
	local entity = e.entity
	if entity == nil or not entity.valid then return end
	if entNameScales[entity.name] then
		-- If it's an entity that quality scaling should apply to, then replace it with the quality variant.
		if entity.quality.level == 0 then return end
		local surface = entity.surface
		local info = {
			name = entity.name.."-"..entity.quality.name,
			position = entity.position,
			quality = entity.quality,
			force = entity.force,
			fast_replace = true,
			player = entity.last_user,
		}
		entity.destroy()
		surface.create_entity(info)
	elseif entity.name == "entity-ghost" and entNameScales[entity.ghost_name] then
		-- Also replace ghosts with quality variants too, so they show power consumption etc correctly.
		if entity.quality.level == 0 then return end
		local surface = entity.surface
		local info = {
			name = "entity-ghost",
			ghost_name = entity.ghost_name .. "-" .. entity.quality.name,
			position = entity.position,
			quality = entity.quality,
			force = entity.force,
			fast_replace = true,
			player = entity.last_user,
		}
		entity.destroy()
		surface.create_entity(info)
	end
end

return {
	onBuilt = onBuilt,
}