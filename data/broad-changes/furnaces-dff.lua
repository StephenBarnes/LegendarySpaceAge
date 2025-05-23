--[[ Convert stone-furnace and steel-furnace to internally be assembling-machine, so that we can set eg char recipe.
Doing this in data-final-fixes stage, so that other mods are less likely to crash if they want to change these entities.
]]
for _, furnaceName in pairs{"stone-furnace", "steel-furnace", "ff-furnace", "electric-furnace"} do
	local furnace = FURNACE[furnaceName]
	furnace.type = "assembling-machine"
	extend{furnace}
	FURNACE[furnaceName] = nil
end

-- Create alternate versions of the furnaces for planets with and without air in the atmosphere.
for _, furnaceName in pairs{"stone-furnace", "steel-furnace", "ff-furnace"} do
	local furnace = ASSEMBLER[furnaceName]
	for _, suffix in pairs{"-noair", "-air"} do
		local newFurnace = copy(furnace)
		newFurnace.name = newFurnace.name..suffix
		newFurnace.localised_name = {"entity-name."..furnace.name}
		newFurnace.localised_description = {"entity-description."..furnace.name}
		newFurnace.hidden_in_factoriopedia = true
		newFurnace.hidden = true
		newFurnace.factoriopedia_alternative = furnace.name
		newFurnace.placeable_by = {item = furnace.name, count = 1}
		newFurnace.minable.result = furnace.name
		extend{newFurnace}
	end
end