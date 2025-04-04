---@param entity LuaEntity
local function replaceWithLavaPump(entity)
	-- Replace this offshore pump with a "lava-pump" entity.
	local surface = entity.surface
	local info = {
		name = "lava-pump",
		position = entity.position,
		quality = entity.quality,
		force = entity.force,
		fast_replace = true,
		player = entity.last_user,
		orientation = entity.orientation,
		direction = entity.direction,
	}
	entity.destroy()
	surface.create_entity(info)
end

-- When a pump is built on Vulcanus, replace it with a lava-pump.
local function onBuilt(event)
	if event.entity == nil or not event.entity.valid then return end
	if event.entity.name ~= "offshore-pump" or event.entity.type ~= "offshore-pump" then return end
	if event.entity.surface == nil or event.entity.surface.name ~= "vulcanus" then return end
	replaceWithLavaPump(event.entity)
end

return {
	onBuilt = onBuilt,
}