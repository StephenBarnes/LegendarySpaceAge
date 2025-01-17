-- This file handles the new "toggle" hotkey that's added by this modpack.
-- The toggle key can turn offshore pumps (or lava pumps) into waste pumps, gasifiers into fluid-fuelled gasifiers, heating towers into fluid-fuelled heating towers, and maybe other stuff later.

local function getInfoForReplace(ent, newName)
	return {
		name = newName,
		position = ent.position,
		quality = ent.quality,
		force = ent.force,
		fast_replace = true,
		player = ent.last_user,
		orientation = ent.orientation,
		direction = ent.direction,
	}
end

---@param event EventData.CustomInputEvent
local function onToggleEntity(event)
	if event.player_index == nil then return end
	local player = game.get_player(event.player_index)
	if player == nil or not player.valid then return end
	local selected = player.selected
	if selected == nil or not selected.valid then return end
	local entName = selected.name
	if entName == nil then return end
	local entForce = selected.force
	local playerForce = player.force
	if entForce == nil or playerForce == nil or entForce ~= playerForce then return end
	local surface = selected.surface
	if surface == nil or not surface.valid then return end

	if entName == "offshore-pump" or entName == "lava-pump" then
		-- Create waste pump.
		local info = getInfoForReplace(selected, "waste-pump")
		selected.destroy()
		surface.create_entity(info)
	elseif entName == "waste-pump" then
		-- Create offshore pump, or lava pump.
		--   Here I'm assuming Vulcanus is always lava-pump, everywhere else is offshore-pump.
		--   Could replace it with a smarter check, or make the NoLavaInPipes mod smarter so I can just do offshore-pump here and that mod will change it to lava pump when necessary.
		local newPumpName = surface.planet.name == "vulcanus" and "lava-pump" or "offshore-pump"
		local info = getInfoForReplace(selected, newPumpName)
		selected.destroy()
		surface.create_entity(info)
	end

	-- TODO fluid-fuelled gasifier and heating tower
end

return {
	onToggleEntity = onToggleEntity
}

-- TODO add note about pump to descriptions of all 3 pumps.