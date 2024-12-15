-- This file adds some starting equipment, intended to allow copy-paste construction from the start. Because we've all done the first 2 hours too many times to still find it interesting, and I don't want to have to click hundreds of times to build the first furnace stacks.
-- To do this, in data stage we add 4x4 equipment grids to light and heavy armor, which can only hold generator, batteries, and personal roboports. Then in control stage we put some of those in the initial player inventory.
-- (Would be nice to instead put this in the crashed spaceship. But I don't know how to do that, plus it's tricky with multiplayer etc.)

-- Some code taken from Spacesuit mod by ElAdamo.

local insertStartingItems = function(control)
	log("Trying to give starting equipment to " .. control.name .. ".")
	if control.can_insert{name = "construction-robot", count = 25} then
		control.insert{name = "construction-robot", count = 25}
		control.insert{name = "solar-panel-equipment", count = 8}
		control.insert{name = "personal-roboport-equipment", count = 2}
		control.insert{name = "battery-mk2-equipment", count = 2}
		-- TODO maybe adjust these (or equipment grid sizes) to balance charging rate vs battery capacity. Needs playtesting.
	else
		log("Error: Failed to give starting items to " .. control.name .. ".")
	end
end

local function onPlayerCreated(event)
	local player = game.players[event.player_index]
	if player.cutscene_character then
		insertStartingItems(player.cutscene_character)
	else
		insertStartingItems(player)
	end
end

return {
	onPlayerCreated = onPlayerCreated,
}