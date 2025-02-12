--[[ This file adjusts the biochamber.
I'm basically going to treat the biochamber as a separate crafting machine with separate recipes. Not as a faster drop-in replacement for the chem plant / refinery like in vanilla.
Also adding new mechanic where they get damaged when they're not being used.
]]

local biochamber = ASSEMBLER["biochamber"]
biochamber.crafting_speed = 1
biochamber.effect_receiver = nil -- Remove base productivity bonus.

-- Lose health when not in use. Gain health when in use. Seems these values are per-tick.
local second = 60
local minute = 60*60
biochamber.production_health_effect = {
	not_producing = -(30/minute),
	producing = (100/minute),
}
biochamber.repair_speed_modifier = 0.5 -- 50% slower repair. Seems they added this for stone walls originally.

-- TODO adjust recipes - basically everything should be either in assembler or biochamber or chem plant, not in multiple, with a handful of exceptions.

-- Fruit processing is crafting recipe, not biology recipe.
for _, recipeName in pairs{"yumako-processing", "jellynut-processing"} do
	RECIPE[recipeName].category = "crafting"
end
