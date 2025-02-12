-- This script is to notify players that they forgot to use the correct mapgen preset.

local NOTIFY_INCORRECT_MAPGEN_PRESET = true

local function registerRepeatingMessage()
	script.on_nth_tick(60 * 15, function(event)
		game.print({"LSA-message.incorrect-mapgen-preset"})
	end)
end

local function onPlayerCreated(event)
	if not NOTIFY_INCORRECT_MAPGEN_PRESET then return end
	local player = game.players[event.player_index]
	local mapGen = player.surface.map_gen_settings

	-- Stop if elevation indicates correct mapgen preset.
	if mapGen.property_expression_names.elevation == "LSA-elevation" then return end

	-- Stop if width == height == 50, indicating test/debug world.
	if mapGen.width == 50 and mapGen.height == 50 then return end

	-- Otherwise, show message.
	registerRepeatingMessage()
end

return {
	onPlayerCreated = onPlayerCreated,
}