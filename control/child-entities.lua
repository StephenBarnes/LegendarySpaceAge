--[[ This file creates "child entities" that get created alongside entities, move around with them, get destroyed when the parent is destroyed, etc.
For example: this is used to create invisible entities that provide air to furnaces on planets with air in the atmosphere.
]]

local Req = require("const.child-entity-const") -- Table of required child entities for each entity.
require("util.globals")

-- Get the table of death rattles. These are set for parent entities, so that when they're destroyed, we can destroy the child entities too.
local getDeathRattles = function()
	if storage.deathRattles == nil then
		storage.deathRattles = {}
	end
	return storage.deathRattles
end

-- Set a notification for when the entity is destroyed. Note this can be called multiple times for the same entity; the ID will be the same each time, but we update the data each time (if the entity is rotated, flipped, or moved via Picker Dollies).
---@param entity LuaEntity
---@return nil
local setDeathRattle = function(entity)
	local deathrattles = getDeathRattles()
	local id = script.register_on_object_destroyed(entity)
	-- Can't store the entity itself, bc it'll become invalid.
	deathrattles[id] = {
		type = "LSA-child-entity",
		name = entity.name,
		surface = entity.surface,
		position = entity.position,
		direction = entity.direction,
	}
end

-- Check if a parent entity is on a surface where a given child-entity requirement applies.
---@param entity LuaEntity
---@param surfaceSet table<string, boolean>?
---@return boolean
local function inSurfaceSet(entity, surfaceSet)
	if surfaceSet == nil then return true end
	local surface = entity.surface
	if surface == nil or not surface.valid then return false end
	return surfaceSet[surface.name] == true
end

-- Convert a defines.direction (NORTH, SOUTH, EAST, WEST) to an orientation (0 - 1).
---@param dir defines.direction
---@return float
local function dirToOrientation(dir)
	assert(dir ~= nil)
	if dir == NORTH then return NORTH_FLOAT
	elseif dir == SOUTH then return SOUTH_FLOAT
	elseif dir == EAST then return EAST_FLOAT
	elseif dir == WEST then return WEST_FLOAT
	else
		log("Error: Unknown direction: " .. serpent.line(dir))
	end
	return NORTH_FLOAT
end

-- Function to adjust the displacement of a child entity for the parent's orientation and mirroring.
---@param displacement table
---@param orientation float? -- This is a number 0 - 1, not a direction.
---@param mirroring boolean?
---@param adjustForOrientation boolean
---@return table
local function adjustDisplacement(displacement, orientation, mirroring, direction, adjustForOrientation)
	if not adjustForOrientation then return displacement end
	if orientation == nil and direction ~= nil then -- Happens for eg mini-assemblers, since they're not square.
		orientation = dirToOrientation(direction)
	end
	if not mirroring then
		if orientation == SOUTH_FLOAT then
			return {-displacement[1], -displacement[2]}
		elseif orientation == WEST_FLOAT then
			return {displacement[2], -displacement[1]}
		elseif orientation == EAST_FLOAT then
			return {-displacement[2], displacement[1]}
		elseif orientation == NORTH_FLOAT then
			return displacement
		else
			log("Error: Unknown orientation for parent entity: " .. serpent.line(orientation))
		end
	else
		if orientation == SOUTH_FLOAT then
			return {displacement[1], -displacement[2]}
		elseif orientation == WEST_FLOAT then
			return {displacement[2], displacement[1]}
		elseif orientation == EAST_FLOAT then
			return {-displacement[2], displacement[1]}
		elseif orientation == NORTH_FLOAT then
			return {-displacement[1], displacement[2]}
		else
			log("Error: Unknown orientation for parent entity: " .. serpent.line(orientation))
		end
	end
	return displacement
end

-- When an entity requiring child entities is built, also build the child entities for it.
---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
local function onBuilt(event)
	local ent = event.entity
	if ent == nil or not ent.valid then return end
	local reqs = Req[ent.name]
	if reqs == nil then return end
	local surface = ent.surface
	if ((surface == nil)
		or (not surface.valid))
	then return end

	for reqName, reqSet in pairs(reqs) do
		for _, req in pairs(reqSet) do
			if not inSurfaceSet(ent, req.surfaceSet) then goto continue end
			assert(ent.orientation ~= nil)
			assert(ent.mirroring ~= nil)
			local disp = adjustDisplacement(req.pos, ent.orientation, ent.mirroring, ent.direction, req.adjustForOrientation)
			local info = {
				name = reqName,
				position = {ent.position.x + disp[1], ent.position.y + disp[2]},
				quality = ent.quality,
				force = ent.force,
				fast_replace = true,
				player = ent.last_user,
				orientation = ent.orientation,
				direction = ent.direction,
				mirroring = ent.mirroring,
			}
			if req.preCreatedHandler ~= nil then
				req.preCreatedHandler(ent, info)
			end
			local newEnt = surface.create_entity(info)
			if newEnt == nil or not newEnt.valid then
				log("Error: Failed to create child " .. reqName .. " for " .. ent.name)
			else
				newEnt.mirroring = info.mirroring
				if req.createdHandler ~= nil then
					req.createdHandler(ent, newEnt)
				end
			end
			::continue::
		end
	end
	setDeathRattle(ent)
end

-- Handle when an entity is destroyed: check if we have a death rattle, and in that case destroy the child entities too.
---@param e EventData.on_object_destroyed
local function onObjectDestroyed(e)
	local deathrattles = getDeathRattles()
	local deathrattle = deathrattles[e.registration_number]
	if deathrattle == nil then return end
	local surface = deathrattle.surface ---@type LuaSurface
	local position = deathrattle.position
	local destroyedName = deathrattle.name
	local destroyedReqs = Req[destroyedName]
	if destroyedReqs == nil then return end
	for reqName, reqSet in pairs(destroyedReqs) do
		for _, req in pairs(reqSet) do
			if not inSurfaceSet(deathrattle, req.surfaceSet) then goto continue end
			local disp = adjustDisplacement(req.pos, nil, nil, deathrattle.direction, req.adjustForOrientation)
			local children = surface.find_entities_filtered{
				name = reqName,
				position = {position.x + disp[1], position.y + disp[2]},
			}

			if #children == 0 then
				log("Warning: No child " .. reqName .. " found at " .. serpent.line(position) .. ", this should not happen")
			else
				-- There can be multiple children at the same position, if the entity was fast-replaced; seems on-built handler runs before on-object-destroyed. So we'll delete the oldest child at this position, by checking the unit_number.
				-- Simple entities don't have unit numbers, so we just delete the first one found. Probably not an issue since they're interchangeable, unlike entities with eg linked fluid boxes.
				child = children[1]
				if child.type ~= "simple-entity" then
					for i = 2, #children do
						if children[i].unit_number < child.unit_number then
							child = children[i]
						end
					end
				end

				if req.destroyedHandler ~= nil then
					req.destroyedHandler(destroyedName, child)
				end
				child.destroy()
			end
			::continue::
		end
	end
	-- Delete the deathrattle.
	deathrattles[e.registration_number] = nil
end

-- Update the child entity's direction and mirroring to match the entity.
---@param child LuaEntity
---@param entity LuaEntity
---@param updatePos boolean
---@param req table
local function updateChild(child, entity, updatePos, req)
	child.direction = entity.direction
	child.mirroring = entity.mirroring
	child.orientation = entity.orientation
	if updatePos and (req.shouldTeleport == nil or req.shouldTeleport) then
		local newDisp = adjustDisplacement(req.pos, entity.orientation, entity.mirroring, entity.direction, req.adjustForOrientation)
		local newPos = {entity.position.x + newDisp[1], entity.position.y + newDisp[2]}
		--child.position = entity.position -- Can't, it's read-only.
		local success = child.teleport(newPos)
		if not success then
			log("Error: Failed to teleport child " .. child.name .. " to " .. serpent.line(newPos) .. ", this should not happen")
		end
	end
end

-- Find the child at the given position and update it to match the entity.
---@param entity LuaEntity
---@param searchPos table
---@param updatePos boolean
---@param req table
---@param reqName string
---@param oldOrientation float
---@param oldMirroring boolean
local function findAndUpdateChildren(entity, searchPos, updatePos, req, reqName, oldOrientation, oldMirroring, wasRotated, wasFlipped)
	local surface = entity.surface
	if not surface.valid then return end
	assert(oldOrientation ~= nil)
	assert(oldMirroring ~= nil)
	local oldDisp = adjustDisplacement(req.pos, oldOrientation, oldMirroring, entity.direction, req.adjustForOrientation)
	local children = surface.find_entities_filtered{
		name = reqName,
		position = {searchPos.x + oldDisp[1], searchPos.y + oldDisp[2]},
	}
	if #children ~= 1 then
		log("Warning: Expected 1 child " .. reqName .. " at " .. serpent.line(searchPos) .. ", found " .. #children .. ", this should not happen")
		if #children == 0 then return end
	end
	local child = children[1]
	if not child.valid then
		log("Error: Child " .. reqName .. " at " .. serpent.line(searchPos) .. " is invalid, this should not happen")
		return
	end
	if req.suppressRotationsAndFlips ~= true then
		updateChild(child, entity, updatePos, req)
	end
	if req.adjustedHandler ~= nil then
		req.adjustedHandler(entity, child, wasRotated, wasFlipped)
	end
end

---@param e EventData.on_player_rotated_entity|EventData.on_player_flipped_entity
---@param wasRotated boolean
local function onRotatedOrFlipped(e, wasRotated)
	local ent = e.entity
	if ent == nil or not ent.valid then return end

	local reqs = Req[ent.name]
	if reqs == nil then return end

	local previousDirection, previousMirroring
	if wasRotated then
		previousDirection = e.previous_direction
		previousMirroring = e.entity.mirroring
	else
		-- e.previous_direction is nil if it was mirrored, so should still be the same as current direction.
		previousDirection = e.entity.direction
		-- Actually east/west direction is apparently flipped by mirroring.
		if previousDirection == EAST then previousDirection = WEST
		elseif previousDirection == WEST then previousDirection = EAST end
		previousMirroring = not e.entity.mirroring
	end

	for reqName, reqSet in pairs(reqs) do
		for _, req in pairs(reqSet) do
			if inSurfaceSet(ent, req.surfaceSet) then
				---@diagnostic disable-next-line: param-type-mismatch
				findAndUpdateChildren(ent, ent.position, req.adjustForOrientation, req, reqName, dirToOrientation(previousDirection), previousMirroring, wasRotated, not wasRotated)
			end
		end
	end
end

---@param e {player_index:number, moved_entity:LuaEntity, start_pos:table}
local function onPickerDollyMoved(e)
	if e.moved_entity == nil or not e.moved_entity.valid then return end
	setDeathRattle(e.moved_entity) -- Re-set, so we store the new position, for when it's destroyed.
	local reqs = Req[e.moved_entity.name]
	if reqs == nil then return end
	for reqName, reqSet in pairs(reqs) do
		for _, req in pairs(reqSet) do
			if inSurfaceSet(e.moved_entity, req.surfaceSet) then
				assert(e.moved_entity.direction ~= nil)
				findAndUpdateChildren(e.moved_entity, e.start_pos, true, req, reqName, e.moved_entity.orientation, e.moved_entity.mirroring, false, false)
			end
		end
	end
end

return {
	onBuilt = onBuilt,
	onObjectDestroyed = onObjectDestroyed,
	onRotated = function(e) onRotatedOrFlipped(e, true) end,
	onFlipped = function(e) onRotatedOrFlipped(e, false) end,
	onPickerDollyMoved = onPickerDollyMoved,
}