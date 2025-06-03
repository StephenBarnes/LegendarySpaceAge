--[[ This file adjusts items that are placed in the crashed ship, or given directly to player, if no ship.
Namely: some ammo, iron plates, starting equipment, etc.
These items aren't given again when player dies and respawns (checked).

This file adds some starting equipment, intended to allow copy-paste construction from the start. Because this modpack requires production on a greater scale than the vanilla game, including before bots are unlocked, and without bots you would have to click hundreds of times to build the first furnace stacks etc.
To do this, in data stage we add 4x4 equipment grids to light and heavy armor, which can only hold generator, batteries, and personal roboports. Then in control stage we put some of those in the initial player inventory.

Originally "debris_items" was 8x iron plate and 1x hand-crank (from that mod).
Originally "created_items" was 1x burner mining drill, 1x hand-crank, 10x firearm-magazine, 8x iron-plate, 1x pistol, 1x stone-furnace, 1x wood.
So it seems created_items is everything given to each player, and debris_items is the subset of that that's placed in the crashed ship debris for the first player. For subsequent players, all of the created_items are given directly, not placed in debris.
]]

local function setStartItems()
	if not remote.interfaces.freeplay or not remote.interfaces.freeplay.set_debris_items or not remote.interfaces.freeplay.set_created_items then
		log("Freeplay interface not available, skipping.")
		return
	end
	local items = {
		-- No starting pistol or firearm-magazine, because I'm rather making players begin with shotguns when they unlock gunpowder.

		["construction-robot"] = 50,
		["personal-roboport-equipment"] = 2,
		["battery-equipment"] = 2,
		-- Player has to make a personal burner generator to actually power the stuff.

		-- Prefer to give factors rather than raw materials. Seems more appropriate.
		-- Give some structures etc, so player doesn't need to chop a lot of trees for resin.
		mechanism = 10,
		frame = 20,
		wiring = 20,
		panel = 10,
		sensor = 10,
	}
	remote.call('freeplay', 'set_debris_items', items)
	remote.call('freeplay', 'set_created_items', items)
	remote.call('freeplay', 'set_respawn_items', {})
	remote.call('freeplay', 'set_ship_items', {
		photograph = 1,
		sensor = 10,
		panel = 10,
		frame = 20,
		wiring = 20,
		mechanism = 10,
		structure = 10,
	})
end

return {
	onInit = setStartItems,
	onConfigurationChanged = setStartItems,
}