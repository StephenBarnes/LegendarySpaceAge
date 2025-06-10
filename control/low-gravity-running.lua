--[[ This file replaces player character when they land on low-gravity surfaces (currently only Apollo), to make them have slower run animation that looks more appropriate in low gravity.
Uses the new character "low-gravity-character" that was added in data stage. We switch to the new character, and transfer over everything like inventory etc.
]]

---@param player LuaPlayer
---@param surface LuaSurface
---@param prevChar LuaEntity
---@param newCharName string
local function swapCharacter(player, surface, prevChar, newCharName)
	---@type LuaEntity?
	local newChar = surface.create_entity{
		name = newCharName,
		position = prevChar.position,
		force = prevChar.force,
		direction = prevChar.direction,
	}
	if newChar == nil or not newChar.valid then
		log("Failed to create new character")
		return
	end

	-- Copy over misc settings.
	for _, k in pairs{
		"character_crafting_speed_modifier",
		"character_mining_speed_modifier",
		"character_additional_mining_categories",
		"character_running_speed_modifier",
		"character_build_distance_bonus",
		"character_item_drop_distance_bonus",
		"character_reach_distance_bonus",
		"character_resource_reach_distance_bonus",
		"character_item_pickup_distance_bonus",
		"character_loot_pickup_distance_bonus",
		"character_inventory_slots_bonus",
		"character_trash_slot_count_bonus",
		"character_maximum_following_robot_count_bonus",
		"character_health_bonus",
		"health",
		"allow_dispatching_robots",
		"selected_gun_index",
	} do
		newChar[k] = prevChar[k]
	end
	newChar.copy_settings(prevChar)

	-- Copy over armor and guns.
	-- (Don't need to copy main inventory or ammo since you can't land with that anyway. But copying anyway for testing.)
	for _, inventorySlot in pairs{
		defines.inventory.character_guns,
		defines.inventory.character_armor,
		defines.inventory.character_main,
		defines.inventory.character_ammo,
	} do
		local prevInv = prevChar.get_inventory(inventorySlot)
		local newInv = newChar.get_inventory(inventorySlot)
		if prevInv ~= nil and newInv ~= nil then
			for i = 1, math.min(#prevInv, #newInv) do
				local prevItem = prevInv[i]
				if prevItem.valid_for_read then
					newInv[i].swap_stack(prevItem)
				end
			end
		end
	end

	-- Copy over personal logistics.
	local prevLogistics = prevChar.get_logistic_point(defines.logistic_member_index.character_requester)
	local newLogistics = newChar.get_logistic_point(defines.logistic_member_index.character_requester)
	if prevLogistics ~= nil and newLogistics ~= nil and prevLogistics.valid and newLogistics.valid then
		newLogistics.enabled = prevLogistics.enabled
		newLogistics.trash_not_requested = prevLogistics.trash_not_requested
		-- Clear default section.
		for i = 1, newLogistics.sections_count do
			newLogistics.remove_section(i)
		end
		-- Copy over sections.
		for _, section in pairs(prevLogistics.sections) do
			local newSection = newLogistics.add_section(section.group)
			if newSection ~= nil then
				for i, filter in pairs(section.filters) do
					newSection.set_slot(i, filter)
				end
			end
			newSection.active = section.active
			newSection.multiplier = section.multiplier
		end
	end

	-- Switch to new character.
	player.set_controller{
		type = player.controller_type,
		character = newChar,
	}

	-- Destroy old character.
	if prevChar.valid then
		prevChar.destroy()
	end
end

---@param player LuaPlayer?
local function updatePlayer(player)
	if player == nil or not player.valid then return end
	if player.controller_type ~= defines.controllers.character then return end
	if player.vehicle ~= nil or player.physical_vehicle ~= nil or player.cargo_pod ~= nil then return end
	local prevCharacter = player.character
	if prevCharacter == nil or not prevCharacter.valid then return end
	local newSurface = prevCharacter.surface
	if newSurface == nil or not newSurface.valid then return end
	if newSurface.name == "apollo" and prevCharacter.name == "character" then
		swapCharacter(player, newSurface, prevCharacter, "low-gravity-character")
	elseif newSurface.name ~= "apollo" and prevCharacter.name == "low-gravity-character" then
		swapCharacter(player, newSurface, prevCharacter, "character")
	end
end

---@param e EventData.on_player_changed_surface|EventData.on_player_respawned|EventData.on_player_driving_changed_state|EventData.on_player_cheat_mode_enabled|EventData.on_player_controller_changed
local function onPlayerChange(e)
	local player = game.get_player(e.player_index)
	updatePlayer(player)
end

return {
	onPlayerChange = onPlayerChange,
}