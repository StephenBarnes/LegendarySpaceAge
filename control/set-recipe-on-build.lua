--[[ This file sets recipes for some entities as soon as they're built.
Currently used for air separators and deep drills.
]]

-- Function to destroy entity and spill its item.
local function spillEnt(entity, itemName, surface)
	entity.active = false
	local stack = {name = itemName, count = 1, quality = entity.quality}
	local spillVals = {
		position = entity.position,
		stack = stack,
		force = entity.force,
	}
	entity.destroy()
	surface.spill_item_stack(spillVals)
end

-- Function to set recipe of air separator when it's built.
---@param entity LuaEntity
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
		spillEnt(entity, "air-separator", surface)
	end
end

-- Function to set recipe of deep drill when it's built.
local deepDrillEntSize = prototypes.entity["deep-drill"].tile_width
---@param entity LuaEntity
local function setDeepDrillRecipe(entity)
	entity.recipe_locked = true
	local surface = entity.surface
	-- First, try looking for a nearby drill node.
	local entsUnder = surface.find_entities_filtered{
		area = {
			{entity.position.x - deepDrillEntSize / 2, entity.position.y - deepDrillEntSize / 2},
			{entity.position.x + deepDrillEntSize / 2, entity.position.y + deepDrillEntSize / 2},
		},
		type = "resource",
	}
	for _, ent in pairs(entsUnder) do
		if ent.name:sub(1, 10) == "drill-node" then
			local recipeName = "recipe-" .. ent.name
			if prototypes.recipe[recipeName] == nil then
				log("ERROR: Deep drill recipe not found: "..recipeName)
			else
				entity.set_recipe(recipeName)
				return
			end
		end
	end
	-- If no drill node found, then use default recipe for the planet.
	if surface.name == "nauvis" then
		entity.set_recipe("deep-drill-nauvis")
	elseif surface.name == "gleba" then
		entity.set_recipe("deep-drill-gleba")
	elseif surface.name == "vulcanus" then
		entity.set_recipe("deep-drill-vulcanus")
	elseif surface.name == "fulgora" then
		entity.set_recipe("deep-drill-fulgora")
	elseif surface.name == "apollo" then
		entity.set_recipe("deep-drill-apollo")
	else
		log("ERROR: Deep drill placed on unknown surface: "..surface.name)
		spillEnt(entity, "deep-drill", surface)
	end
end

---@param e EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
local function onBuilt(e)
	local entity = e.entity
	if entity == nil or not entity.valid then return end
	if entity.name == "air-separator" then
		setAirSeparatorRecipe(entity)
	elseif entity.name == "deep-drill" then
		setDeepDrillRecipe(entity)
	end
end

return {
	onBuilt = onBuilt,
}