--[[ This file sets recipes of air separators, when they're placed.
It also creates exclusion zones around air separators when they're built, preventing other air separators from being built close to it.
We register a death rattle for each air separator, so we can destroy the exclusion zones when the air separator is destroyed.
	(Maybe this would be easier to do with some events like on_player_mined_entity, etc., instead of registering death rattles? But there's multiple event types, not sure they even cover all the cases where an ent is destroyed.)
]]

-- Compute distance from center of air separator to center of exclusion zone.
local ENT_SIZE = prototypes.entity["air-separator"].tile_width
local EXCLUSION_CENTER_DIST = prototypes.entity["air-separator-exclusion-1"].collision_box.right_bottom.y + ENT_SIZE/2

local getAirSepDeathRattles = function()
	if storage.airSepDeathRattles == nil then
		storage.airSepDeathRattles = {}
	end
	return storage.airSepDeathRattles
end

local setAirSepDeathRattle = function(entity)
	local deathrattles = getAirSepDeathRattles()
	-- Not storing the entity itself, bc it'll become invalid.
	deathrattles[script.register_on_object_destroyed(entity)] = { "air-separator", entity.surface, entity.position }
end

-- Function to get positions of exclusion zones around air separator, plus index of the exclusion zone proto to use (1 is horizontal, 2 is vertical).
local function getExclusionPositions(pos)
	local x, y = pos.x, pos.y
	return {
		{1, x, y + EXCLUSION_CENTER_DIST},
		{1, x, y - EXCLUSION_CENTER_DIST},
		{2, x + EXCLUSION_CENTER_DIST, y},
		{2, x - EXCLUSION_CENTER_DIST, y},
	}
end

-- Function to set recipe of air separator when it's built.
local function setAirSeparatorRecipe(entity)
	entity.recipe_locked = true
	local surface = entity.surface
	if surface.name == "nauvis" then
		entity.set_recipe("air-separation-nauvis")
	elseif surface.name == "gleba" then
		entity.set_recipe("air-separation-gleba")
	elseif surface.name == "vulcanus" then
		entity.set_recipe("air-separation-vulcanus")
	elseif surface.name == "fulgora" then
		entity.set_recipe("air-separation-fulgora")
	elseif surface.name == "aquilo" then
		entity.set_recipe("air-separation-aquilo")
	else
		log("ERROR: Air separator placed on unknown surface: "..surface.name)
		entity.active = false
		local stack = {name = "air-separator", count = 1, quality = entity.quality}
		entity.destroy()
		surface.spill_item_stack{
			position = entity.position,
			stack = stack,
			force = entity.force,
		}
	end
end

-- Function to create exclusion zone around air separator, preventing other air separators from being built close to it.
-- Also works for ghosts of air separators.
---@param entity LuaEntity
local function createExclusionZone(entity)
	if (
		(entity.name ~= "air-separator")
		and ((entity.name ~= "entity-ghost")
		or (entity.ghost_name ~= "air-separator"))
	) then return end
	setAirSepDeathRattle(entity)
	local surface = entity.surface
	local position = entity.position
	for _, vals in pairs(getExclusionPositions(position)) do
		local pos = {x = vals[2], y = vals[3]}
		local proto = "air-separator-exclusion-" .. vals[1]
		local ent = surface.create_entity{
			name = proto,
			position = pos,
			force = "neutral",
			raise_built = false,
		}
		if ent ~= nil and ent.valid then
			ent.destructible = false -- Otherwise you can literally shoot it dead.
		end
	end
end

-- Function to destroy exclusion zone around air separator, or ghost of air separator.
local function destroyExclusionZone(e)
	local deathrattles = getAirSepDeathRattles()
	local deathrattle = deathrattles[e.registration_number]
	if deathrattle == nil then return end
	local surface = deathrattle[2] ---@type LuaSurface
	local position = deathrattle[3]
	-- Destroy the exclusion zones there, if any.
	for _, vals in pairs(getExclusionPositions(position)) do
		local proto = "air-separator-exclusion-" .. vals[1]
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

---@param e EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
local function onBuilt(e)
	local entity = e.entity
	if entity == nil or not entity.valid then return end
	if entity.name == "air-separator" then
		setAirSeparatorRecipe(entity)
	end
	createExclusionZone(entity)
end

---@param e EventData.on_object_destroyed
local function onObjectDestroyed(e)
	destroyExclusionZone(e)
end

local function onInitOrLoad()
	-- Blacklist it from picker dollies, since that doesn't work with exclusion zones.
	local epd_api = remote.interfaces['PickerDollies']
	if (epd_api) then
		remote.call('PickerDollies', 'add_blacklist_name', 'air-separator')
	end
end

return {
	onInitOrLoad = onInitOrLoad,
	onBuilt = onBuilt,
	onObjectDestroyed = onObjectDestroyed,
}