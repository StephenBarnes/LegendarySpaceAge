--[[ This file sets recipes of deep drills, when they're placed.
It also creates exclusion zones around deep drills when they're built, preventing other deep drills from being built nearby.
We register a death rattle for each deep drill, so we can destroy the exclusion zones when the deep drill is destroyed.
]]

-- Compute distance from center of deep drill to center of exclusion zone.
local ENT_SIZE = prototypes.entity["deep-drill"].tile_width
local EXCLUSION_CENTER_DIST = prototypes.entity["deep-drill-exclusion-1"].collision_box.right_bottom.y + ENT_SIZE/2

local getDeepDrillDeathRattles = function()
	if storage.deepDrillDeathRattles == nil then
		storage.deepDrillDeathRattles = {}
	end
	return storage.deepDrillDeathRattles
end

local setDeepDrillDeathRattle = function(entity)
	local deathrattles = getDeepDrillDeathRattles()
	-- Not storing the entity itself, bc it'll become invalid.
	deathrattles[script.register_on_object_destroyed(entity)] = { "deep-drill", entity.surface, entity.position }
end

-- Function to get positions of exclusion zones around deep drill, plus index of the exclusion zone proto to use (1 is horizontal, 2 is vertical).
local function getExclusionPositions(pos)
	local x, y = pos.x, pos.y
	return {
		{1, x, y + EXCLUSION_CENTER_DIST},
		{1, x, y - EXCLUSION_CENTER_DIST},
		{2, x + EXCLUSION_CENTER_DIST, y},
		{2, x - EXCLUSION_CENTER_DIST, y},
	}
end

-- Function to set recipe of deep drill when it's built.
local function setDeepDrillRecipe(entity)
	entity.recipe_locked = true
	local surface = entity.surface
	if surface.name == "nauvis" then
		entity.set_recipe("deep-drill-nauvis")
	elseif surface.name == "gleba" then
		entity.set_recipe("deep-drill-gleba")
	elseif surface.name == "vulcanus" then
		entity.set_recipe("deep-drill-vulcanus")
	elseif surface.name == "fulgora" then
		entity.set_recipe("deep-drill-fulgora")
	else
		log("ERROR: Deep drill placed on unknown surface: "..surface.name)
		entity.active = false
		local stack = {name = "deep-drill", count = 1, quality = entity.quality}
		entity.destroy()
		surface.spill_item_stack{
			position = entity.position,
			stack = stack,
			force = entity.force,
		}
	end
end

-- Function to create exclusion zone around deep drill, preventing other deep drills from being built close to it.
-- Also works for ghosts of deep drills.
---@param entity LuaEntity
local function createExclusionZone(entity)
	if (
		(entity.name ~= "deep-drill")
		and ((entity.name ~= "entity-ghost")
		or (entity.ghost_name ~= "deep-drill"))
	) then return end
	setDeepDrillDeathRattle(entity)
	local surface = entity.surface
	local position = entity.position
	for _, vals in pairs(getExclusionPositions(position)) do
		local pos = {x = vals[2], y = vals[3]}
		local proto = "deep-drill-exclusion-" .. vals[1]
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

-- Function to destroy exclusion zone around deep drill, or ghost of deep drill.
local function destroyExclusionZone(e)
	local deathrattles = getDeepDrillDeathRattles()
	local deathrattle = deathrattles[e.registration_number]
	if deathrattle == nil then return end
	local surface = deathrattle[2] ---@type LuaSurface
	local position = deathrattle[3]
	-- Destroy the exclusion zones there, if any.
	for _, vals in pairs(getExclusionPositions(position)) do
		local proto = "deep-drill-exclusion-" .. vals[1]
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
	if entity.name == "deep-drill" then
		setDeepDrillRecipe(entity)
	end
	createExclusionZone(entity)
end

---@param e EventData.on_object_destroyed
local function onObjectDestroyed(e)
	destroyExclusionZone(e)
end

return {
	onBuilt = onBuilt,
	onObjectDestroyed = onObjectDestroyed,
}