--[[ This file creates exclusion zones for some entities when they're built, to prevent them from being built too close to each other.
We register a death rattle for each entity, so we can destroy the exclusion zones when the entity is destroyed.
Currently used for air separators, deep drills, telescopes.
]]

local Const = require("const.exclusion-zones")
for entName, vals in pairs(Const) do
	-- Distance from center of entity to center of exclusion zone.
	vals.exclusionCenterDist = prototypes.entity[entName .. "-exclusion-1"].collision_box.right_bottom.y + vals.size / 2
end

local getDeathRattles = function()
	if storage.deathRattles == nil then
		storage.deathRattles = {}
	end
	return storage.deathRattles
end

local setDeathRattle = function(entity, entityName)
	local deathrattles = getDeathRattles()
	-- Not storing the entity itself, bc it'll become invalid.
	deathrattles[script.register_on_object_destroyed(entity)] = {entityName, entity.surface, entity.position}
end

-- Function to get positions of exclusion zones around deep drill, plus index of the exclusion zone proto to use (1 is horizontal, 2 is vertical).
---@param pos data.MapPosition
---@param entName string
---@return table<number, data.MapPosition>
local function getExclusionPositions(pos, entName)
	local x, y = pos.x, pos.y
	local exclusionCenterDist = Const[entName].exclusionCenterDist
	return {
		{1, x, y + exclusionCenterDist},
		{1, x, y - exclusionCenterDist},
		{2, x + exclusionCenterDist, y},
		{2, x - exclusionCenterDist, y},
	}
end

-- Function to create exclusion zone around entity, preventing other entities from being built close to it.
-- Also works for ghosts of entities.
---@param entity LuaEntity
---@param entityName string
local function createExclusionZone(entity, entityName)
	setDeathRattle(entity, entityName)
	local surface = entity.surface
	local position = entity.position
	for _, vals in pairs(getExclusionPositions(position, entityName)) do
		local pos = {x = vals[2], y = vals[3]}
		local proto = entityName .. "-exclusion-" .. vals[1]
		local ent = surface.create_entity{
			name = proto,
			position = pos,
			force = "neutral",
			raise_built = false,
		}
		if ent ~= nil and ent.valid then
			ent.destructible = false
		end
	end
end

-- Function to destroy exclusion zone around entity, or ghost of entity.
local function destroyExclusionZone(e)
	local deathrattles = getDeathRattles()
	local deathrattle = deathrattles[e.registration_number]
	if deathrattle == nil then return end
	local surface = deathrattle[2] ---@type LuaSurface
	local position = deathrattle[3]
	local name = deathrattle[1]
	-- Destroy the exclusion zones there, if any.
	for _, vals in pairs(getExclusionPositions(position, name)) do
		local proto = name .. "-exclusion-" .. vals[1]
		local pos = {x = vals[2], y = vals[3]}
		local exclusions = surface.find_entities_filtered{
			name = proto,
			position = pos,
		}
		-- Only destroy 1 of them, if there's multiple. Else you can cheese it by overlapping centers.
		if #exclusions > 0 then
			exclusions[1].destroy()
		end
	end
	-- Un-store the deathrattle.
	deathrattles[e.registration_number] = nil
end

-- Function to get the name of an entity, including the underlying entity's name if it's a ghost.
---@param entity LuaEntity
---@return string
local function getEntName(entity)
	local entityName = entity.name
	if entityName == "entity-ghost" then
		entityName = entity.ghost_name
	end
	return entityName
end

---@param e EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
local function onBuilt(e)
	local entity = e.entity
	if entity == nil or not entity.valid then return end
	local entityName = getEntName(entity)
	if Const[entityName] == nil then return end
	createExclusionZone(entity, entityName)
end

---@param e EventData.on_object_destroyed
local function onObjectDestroyed(e)
	destroyExclusionZone(e)
end

local function onInitOrLoad()
	-- Blacklist all exclusion-zone-using entities from picker dollies, since that doesn't work with exclusion zones.
	local epd_api = remote.interfaces['PickerDollies']
	if (epd_api) then
		for _, vals in pairs(Const) do
			remote.call('PickerDollies', 'add_blacklist_name', vals.name)
		end
	end
end

return {
	onInitOrLoad = onInitOrLoad,
	onBuilt = onBuilt,
	onObjectDestroyed = onObjectDestroyed,
}