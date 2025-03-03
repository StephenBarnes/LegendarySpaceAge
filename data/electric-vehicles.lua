--[[ This file creates electric vehicles, with recipes etc.
It also changes existing burner vehicles to not be buildable on planets without oxygen.
Eg on Fulgora there's no oxygen, so burner trains don't make sense, should be battery-powered.
Also creates a tech for battery-powered vehicles, unlocked on Fulgora.

TODO not sure if all this is worth doing. Technically even bullets shouldn't work, etc. At BEST this stuff is low-priority, at worst it's ugly bloat.
]]

-- Add oxygen checks to placement conditions of trains, ships, cars.
-- Also add it to crafting recipes, so people don't accidentally craft them.
--[[
for _, recipeName in pairs{
	"locomotive",
	"car",
	"tank",
	"boat",
	"cargo_ship",
	"oil_tanker",
} do
	-- TODO
end
]]

-- TODO create tech for electric vehicles, unlocked on Fulgora.

-- TODO create electric car, and recipe

-- TODO create electric locomotive, and recipe.