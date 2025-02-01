-- This file sets recipes of deep drills, when they're placed.

---@param e EventData.on_built_entity|EventData.on_robot_built_entity
local function onBuiltEntity(e)
	local entity = e.entity
	if entity == nil or not entity.valid or entity.name ~= "deep-drill" then return end
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
	else -- This should be made impossible by build surface conditions of deep drill.
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

return {
	onBuiltEntity = onBuiltEntity,
	onRobotBuiltEntity = onBuiltEntity,
}