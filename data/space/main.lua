-- This folder makes changes to space stuff.

require("data.space.cargo-bays")
require("data.space.thruster-liquids")

-- File asteroid-belts.lua creates asteroid belts but doesn't set their orientation/distance. Then arrange-space-map.lua sets distance and orientation for everything, and creates space connections (including for Charon). Then charon.lua creates Charon, setting distance and orientation based on values already set in arrange-space-map.lua.
require("data.space.asteroid-belts")
require("data.space.arrange-space-map")
require("data.space.charon.main")