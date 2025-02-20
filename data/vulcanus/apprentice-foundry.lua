-- Create hidden surface for the apprentice foundry's inserters.
extend{{
	type = "planet",
	name = "apprentice-foundry",
	icon = ITEM.foundry.icon,

	distance = 0,
	orientation = 0,

	hidden = true,
}}

-- Create beacon interface for the apprentice foundry.
local beacon_interface = copy(RAW["beacon"]["beacon-interface--beacon-tile"])
beacon_interface.name = "apprentice-foundry-beacon-interface"
extend{beacon_interface}

-- Adjust stats of foundry.
local foundry = ASSEMBLER["foundry"]
foundry.crafting_speed = 1 -- Instead of 4, we set it to base 1, increasing to 10.
foundry.effect_receiver.base_effect = nil -- Remove base productivity bonus.
	-- Considered giving it a starting -50% prod. But negative productivity doesn't actually work, gets coerced to 0.
foundry.energy_source.emissions_per_minute = { pollution = 50 }
foundry.energy_source.drain = "1MW"
foundry.energy_usage = "9MW"