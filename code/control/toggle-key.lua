-- This file handles the new "toggle" hotkey that's added by this modpack.
-- The toggle key can turn offshore pumps (or lava pumps) into waste pumps, gasifiers into fluid-fuelled gasifiers, heating towers into fluid-fuelled heating towers, and maybe other stuff later.

-- Table of entity names that are replaced when toggle key is pressed.
local simpleSwitches = {
	["offshore-pump"] = "waste-pump",
	["lava-pump"] = "waste-pump",
	-- Waste pump switches to either offshore or lava, depending on planet.

	["heating-tower"] = "fluid-heating-tower",
	["fluid-heating-tower"] = "heating-tower",

	["gasifier"] = "fluid-fuelled-gasifier",
	["fluid-fuelled-gasifier"] = "gasifier",
}

---@param ent LuaEntity
---@param newName string
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
		mirroring = ent.mirroring,
	}
	-- Could copy over fluidbox contents, but it seems error-prone. Rather just waste 1000 steam sometimes.
end

---@param ent LuaEntity
---@param newEntName string
local function replaceEnt(ent, newEntName)
	local info = getInfoForReplace(ent, newEntName)
	local surface = ent.surface
	ent.destroy()
	local newEnt = surface.create_entity(info)
	if newEnt == nil then return end
	newEnt.mirroring = info.mirroring
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

	local simpleSwitchTarget = simpleSwitches[entName]
	if simpleSwitchTarget ~= nil then
		replaceEnt(selected, simpleSwitchTarget)
	elseif entName == "waste-pump" then
		local newPumpName = surface.planet.name == "vulcanus" and "lava-pump" or "offshore-pump"
		replaceEnt(selected, newPumpName)
	end
end

return {
	onToggleEntity = onToggleEntity
}

-- There's a problem: you can't pipette eg the fluid-fuelled gasifier, you get regular gasifier. Can't place fluid-fuelled gasifier directly.
-- But you can copy-paste or blueprint it, and then bots build it fine.
-- So, only an issue when manually building. So not worth adding a separate item and recipe just because of that.