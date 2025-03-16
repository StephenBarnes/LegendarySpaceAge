-- This file makes players run slower on low-gravity surfaces, currently only Heimdall.

local lowGravitySpeedModifier = -.4

---@param e EventData.on_player_changed_surface
local function onPlayerChangedSurface(e)
	if e.surface_index == nil then return end
	local prevSurface = game.get_surface(e.surface_index)
	if prevSurface == nil or not prevSurface.valid then return end
	local player = game.get_player(e.player_index)
	if player == nil or not player.valid then return end
	if player.character == nil or not player.character.valid then return end
	local newSurface = player.character.surface
	if newSurface == nil or not newSurface.valid then return end

	--log("onPlayerChangedSurface: " .. prevSurface.name .. " -> " .. newSurface.name .. " speed modifier: " .. serpent.line(player.character_running_speed_modifier or "nil"))
	local oldSpeedModifier = player.character_running_speed_modifier
	if newSurface.name == "heimdall" then
		player.character_running_speed_modifier = oldSpeedModifier + lowGravitySpeedModifier
	end
	if prevSurface.name == "heimdall" then
		player.character_running_speed_modifier = oldSpeedModifier - lowGravitySpeedModifier
	end
end

return {
	onPlayerChangedSurface = onPlayerChangedSurface,
}

--[[ Thoughts on this:
Currently it kinda doesn't do what I want. It just slows running speed a bit.
	Animation should be slowed while running speed should be slightly faster than default.
		Except animations should be edited so that contact with the ground isn't slower, so we don't skid across the ground.
Ideal way to do this is probably to make a new character with different animations and running speed, then when player lands we change character to that one.
	But that's a lot of work, not sure it's worth it.
	Can check the mod "Jump" for a reference on how to do it, swapping character etc.
Or maybe I can add more animations to the existing characters, and then switch into those somewhot when on Heimdall.
Or maybe I could check for some event when the player lands? How does the vanilla code handle this?
]]