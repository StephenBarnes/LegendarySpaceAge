--[[ This file swaps buildings on build, depending on the surface.
For example: to make rocket silos on Apollo only need 10 parts per rocket, we swap them to rocket-silo-10parts.
]]

local Substitutions = require("const.planet-machine-substitutions-const")

-- When an entity is built, replace it with other entity.
---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
local function onBuilt(event)
	local ent = event.entity
	if ent == nil or not ent.valid then return end
	local surface = ent.surface
	if surface == nil or not surface.valid then return end

	local typeSubstitutions = Substitutions[ent.type]
	if typeSubstitutions == nil then return end
	local substitutions = typeSubstitutions[ent.name]
	if substitutions == nil then return end

	local correctName = substitutions[surface.name]
	if correctName == nil then correctName = substitutions["default"] end
	assert(correctName ~= nil, "No substitution found for " .. ent.type .. " " .. ent.name .. " on surface " .. surface.name)

	local thisName = ent.name
	if (thisName == correctName) then return end

	local info = {
		name = correctName,
		position = ent.position,
		quality = ent.quality,
		force = ent.force,
		fast_replace = true,
		player = ent.last_user,
		orientation = ent.orientation,
		direction = ent.direction,
		mirroring = ent.mirroring,
	}
	ent.destroy()
	local newEnt = surface.create_entity(info)
	if newEnt == nil or not newEnt.valid then return end
	newEnt.mirroring = info.mirroring
end

return {
	onBuilt = onBuilt,
}