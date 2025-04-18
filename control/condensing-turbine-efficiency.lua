--[[ This file replaces condensing-turbines placed by the player with a "condensing-turbine-evil" entity plus a steam-evilizer.
This is necessary to make the condensing turbine have efficiency 40%, because the fusion-generator prototype doesn't support efficiencies.
We also register deathrattles for the created condensing-turbine-evil, so that we can remove it and the steam-evilizer on destruction.
]]


local getDeathRattles = function()
	if storage.condensingTurbineDeathRattles == nil then
		storage.condensingTurbineDeathRattles = {}
	end
	return storage.condensingTurbineDeathRattles
end

local setCondensingTurbineDeathRattle = function(entity)
	local deathrattles = getDeathRattles()
	-- Not storing the entity itself, bc it'll become invalid.
	deathrattles[script.register_on_object_destroyed(entity)] = { "condensing-turbine-evil", entity.surface, entity.position }
end

-- When a condensing turbine is built, replace it with a condensing-turbine-evil plus a steam-evilizer.
---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
local function onBuilt(event)
	if event.entity == nil or not event.entity.valid then return end
	if event.entity.type ~= "fusion-generator" then return end
	if event.entity.name ~= "condensing-turbine" and event.entity.name ~= "condensing-turbine-evil" then return end
	local entity = event.entity
	-- The placed entity could be either a regular condensing-turbine, or a condensing-turbine-evil (via bots/blueprints).
	local surface = entity.surface
	if not surface.valid then return end
	local name = entity.name
	local info = {
		name = "condensing-turbine-evil",
		position = entity.position,
		quality = entity.quality,
		force = entity.force,
		fast_replace = true,
		player = entity.last_user,
		orientation = entity.orientation,
		direction = entity.direction,
		mirroring = entity.mirroring,
	}
	local ctEvil = nil
	if name == "condensing-turbine" then -- Regular condensing turbine: destroy it and replace with a condensing-turbine-evil.
		entity.destroy()
		ctEvil = surface.create_entity(info)
	else -- Condensing-turbine-evil: just add the evilizer.
		ctEvil = entity
	end
	if ctEvil == nil or not ctEvil.valid then return end
	ctEvil.mirroring = info.mirroring
	setCondensingTurbineDeathRattle(ctEvil)
	info.name = "steam-evilizer"
	local evilizer = surface.create_entity(info)
	if evilizer ~= nil and evilizer.valid then
		evilizer.destructible = false
		evilizer.mirroring = info.mirroring
	end
end

---@param e EventData.on_object_destroyed
local function onObjectDestroyed(e)
	local deathrattles = getDeathRattles()
	local deathrattle = deathrattles[e.registration_number]
	if deathrattle == nil then return end
	local surface = deathrattle[2] ---@type LuaSurface
	local position = deathrattle[3]
	-- Destroy the entities there, if any.
	for _, name in pairs{"condensing-turbine-evil", "steam-evilizer"} do
		local proto = name
		local ents = surface.find_entities_filtered{
			name = proto,
			position = position,
		}
		-- Only destroy 1 of them, if there's multiple.
		if #ents > 0 then
			ents[1].destroy()
			if #ents > 1 then
				log("Multiple " .. name .. " found at " .. serpent.block(position) .. ", this should not happen")
			end
		else
			log("No " .. name .. " found at " .. serpent.block(position) .. ", this should not happen")
		end
	end
	-- Un-store the deathrattle.
	deathrattles[e.registration_number] = nil
end

-- Update the evilizer's direction and mirroring to match the condensing turbine.
---@param evilizer LuaEntity
---@param condensingTurbine LuaEntity
---@param updatePos boolean
local function updateEvilizer(evilizer, condensingTurbine, updatePos)
	evilizer.direction = condensingTurbine.direction
	evilizer.mirroring = condensingTurbine.mirroring
	evilizer.orientation = condensingTurbine.orientation
	if updatePos then
		--evilizer.position = condensingTurbine.position -- Can't, it's read-only.
		local success = evilizer.teleport(condensingTurbine.position)
		if not success then
			log("Failed to teleport steam-evilizer to " .. serpent.block(condensingTurbine.position) .. ", this should not happen")
		end
	end
end

-- Find the evilizer at the given position and update it to match the condensing turbine.
---@param condensingTurbine LuaEntity
---@param searchPos table
---@param updatePos boolean
local function findAndUpdateEvilizer(condensingTurbine, searchPos, updatePos)
	local surface = condensingTurbine.surface
	if not surface.valid then return end
	local evilizers = surface.find_entities_filtered{
		name = "steam-evilizer",
		position = searchPos,
	}
	if #evilizers ~= 1 then
		log("Expected 1 steam-evilizer at " .. serpent.block(searchPos) .. ", found " .. #evilizers .. ", this should not happen")
		if #evilizers == 0 then return end
	end
	local evilizer = evilizers[1]
	if not evilizer.valid then
		log("Steam-evilizer at " .. serpent.block(searchPos) .. " is invalid, this should not happen")
		return
	end
	updateEvilizer(evilizer, condensingTurbine, updatePos)
end

---@param e EventData.on_player_rotated_entity|EventData.on_player_flipped_entity
local function onRotatedOrFlipped(e)
	local ent = e.entity
	if ent == nil or not ent.valid then return end
	if ent.type ~= "fusion-generator" then return end
	if ent.name ~= "condensing-turbine" and ent.name ~= "condensing-turbine-evil" then return end
	findAndUpdateEvilizer(ent, ent.position, false)
end

---@param e {player_index:number, moved_entity:LuaEntity, start_pos:table}
local function onPickerDollyMoved(e)
	if e.moved_entity == nil or not e.moved_entity.valid then return end
	if e.moved_entity.type ~= "fusion-generator" then return end
	if e.moved_entity.name ~= "condensing-turbine" and e.moved_entity.name ~= "condensing-turbine-evil" then return end
	findAndUpdateEvilizer(e.moved_entity, e.start_pos, true)
end

return {
	onBuilt = onBuilt,
	onObjectDestroyed = onObjectDestroyed,
	onRotated = onRotatedOrFlipped,
	onFlipped = onRotatedOrFlipped,
	onPickerDollyMoved = onPickerDollyMoved,
}