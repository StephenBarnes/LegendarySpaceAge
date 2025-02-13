--[[ This file allows you to rotate things under the cursor that "can't be rotated" such as turrets.
In the base game, you can't rotate turrets, even if they have a firing arc restriction that makes them not radially symmetrical. (But you can rotate them while in cursor.)
]]

local namesCanRotate = {
	["gun-turret"] = true,
	["laser-turret"] = true,
	["rocket-turret"] = true,
}

local function onRotateKey(e, dir)
	if e.player_index == nil then
		log("LSA-rotate: No player: " .. serpent.block(e))
		return
	end
	local player = game.players[e.player_index]
	if player == nil or not player.valid then
		log("LSA-rotate: Player not valid: " .. serpent.block(e))
		return
	end
	if ((player.cursor_ghost ~= nil and player.cursor_ghost.count ~= 0)
		or (player.cursor_stack ~= nil and player.cursor_stack.count ~= 0)
		or ((player.controller_type ~= defines.controllers.character) and (player.controller_type ~= defines.controllers.remote))
		) then
		return
	end

	local entity = player.selected
	if entity ~= nil and entity.valid then
		if namesCanRotate[entity.name] then
			local newOrientation = (entity.orientation + dir * 0.25) % 1
			entity.orientation = newOrientation
			return
		end
		if entity.name == "entity-ghost" then
			local ghostProto = entity.ghost_prototype
			if ghostProto ~= nil and namesCanRotate[ghostProto.name] then
				local newOrientation = (entity.orientation + dir * 0.25) % 1
				entity.orientation = newOrientation
				return
			end
		end
	end
end

script.on_event("LSA-rotate", function(e)
	onRotateKey(e, 1)
end)
script.on_event("LSA-flip", function(e)
	onRotateKey(e, 2)
end)
script.on_event("LSA-reverse-rotate", function(e)
	onRotateKey(e, -1)
end)