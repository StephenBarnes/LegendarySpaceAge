-- This file swaps rocket silo on build, depending on the surface, so that silos on Apollo only need 10 parts per rocket.

local rocketSiloForSurface = {
	apollo = "rocket-silo-10parts",
}
local rocketSiloDefault = "rocket-silo"

-- When a rocket silo is built, replace it with a rocket-silo-10parts if surface is Apollo.
---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
local function onBuilt(event)
	local ent = event.entity
	if ((ent == nil)
		or (not ent.valid)
		or (ent.type ~= "rocket-silo")
	) then return end
	local surface = ent.surface
	if ((surface == nil)
		or (not surface.valid))
	then return end
	local correctName = rocketSiloForSurface[surface.name] or rocketSiloDefault
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