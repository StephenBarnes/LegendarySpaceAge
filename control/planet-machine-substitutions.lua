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

	local entName, entType, isGhost
	if ent.name ~= "entity-ghost" then
		entName, entType, isGhost = ent.name, ent.type, false
	else
		entName, entType, isGhost = ent.ghost_name, ent.ghost_type, true
	end

	local typeSubstitutions = Substitutions[entType]
	if typeSubstitutions == nil then return end
	local substitutions = typeSubstitutions[entName]
	if substitutions == nil then return end

	local correctName = substitutions[surface.name]
	if correctName == nil then correctName = substitutions["default"] end
	assert(correctName ~= nil, "No substitution found for " .. entType .. " " .. entName .. " on surface " .. surface.name)

	if entName == correctName then return end

	local info = {
		position = ent.position,
		quality = ent.quality,
		force = ent.force,
		fast_replace = true,
		player = ent.last_user,
		orientation = ent.orientation,
		direction = ent.direction,
		mirroring = ent.mirroring,
	}
	if entType == "assembling-machine" then
		info.recipe = ent.get_recipe()
	end

	if not isGhost then
		info.name = correctName
	else
		info.name = "entity-ghost"
		info.inner_name = correctName
		info.tags = ent.tags
	end

	ent.destroy()
	local newEnt = surface.create_entity(info)
	if newEnt == nil or not newEnt.valid then return end
	newEnt.mirroring = info.mirroring
	-- Issue: this doesn't work for rocket-silo. Something weird about flipping/rotating rocket silos specifically, can't flip them once placed. So I'm rather just making rocket silos vertically symmetric.
	-- TODO when using this for furnaces etc, check if the mirroring issue appears there too.
end

return {
	onBuilt = onBuilt,
}