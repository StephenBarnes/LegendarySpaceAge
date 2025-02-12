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