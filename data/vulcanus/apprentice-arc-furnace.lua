-- Create hidden surface for the apprentice foundry's inserters.
extend{{
	type = "planet",
	name = "apprentice-arc-furnace",
	icon = ITEM["arc-furnace"].icon,

	distance = 0,
	orientation = 0,

	hidden = true,
}}

-- Create beacon interface for the apprentice arc furnace.
local beacon_interface = copy(RAW["beacon"]["beacon-interface--beacon-tile"])
beacon_interface.name = "apprentice-arc-furnace-beacon-interface"
extend{beacon_interface}