--[[ This file runs code when regulators are built.
The child-entity system (see const/child-entity-const.lua) creates the hidden beacon and gives it a module.
Currently doing nothing. Might add some stuff here later, eg to make the beacon require fluid fuels.
]]

-- Function to adjust regulators when built.
---@param entity LuaEntity
local function onRegulatorBuilt(entity)
	local surface = entity.surface
	-- Set non-operable, so you can't insert modules or take them out. Although, you still get contents when mining.
	--entity.operable = false
end

---@param e EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
local function onBuilt(e)
	local entity = e.entity
	if entity == nil or not entity.valid then return end
	if entity.name == "regulator" then
		onRegulatorBuilt(entity)
	end
end

return {
	onBuilt = onBuilt,
}