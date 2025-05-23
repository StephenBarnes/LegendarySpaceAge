--[[ Convert stone-furnace and steel-furnace to internally be assembling-machine, so that we can set eg char recipe.
Doing this in data-final-fixes stage, so that other mods are less likely to crash if they want to change these entities.
]]
for _, furnaceName in pairs{"stone-furnace", "steel-furnace", "ff-furnace", "electric-furnace"} do
	local furnace = FURNACE[furnaceName]
	furnace.type = "assembling-machine"
	extend{furnace}
	FURNACE[furnaceName] = nil
end