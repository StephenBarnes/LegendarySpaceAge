-- Create hidden surface for the apprentice foundry's inserters.
data:extend{{
	type = "planet",
	name = "apprentice-foundry",
	icon = data.raw.item.foundry.icon,

	distance = 0,
	orientation = 0,

	hidden = true,
}}

-- Create beacon interface for the apprentice foundry.
local beacon_interface = table.deepcopy(data.raw["beacon"]["beacon-interface--beacon-tile"])
beacon_interface.name = "apprentice-foundry-beacon-interface"
data:extend{beacon_interface}