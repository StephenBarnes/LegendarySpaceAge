-- This file allows dumping items into water tiles on most planets.
-- Originally had dependency on this mod: https://mods.factorio.com/mod/oceandump
-- But that mod doesn't allow dumping on some tiles (shallow water, Gleba marshes, brash-ice on Aquilo) so I'm rather just redoing it here.

for _, tile in pairs(RAW.tile) do
	if tile.fluid ~= nil then
		tile.destroys_dropped_items = true
	end
end