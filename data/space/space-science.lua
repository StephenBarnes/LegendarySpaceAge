-- This file makes tech that unlocks asteroid belts, and edits space science techs to use asteroid chunks from those belts.

-- TODO rather change existing space-science-pack tech, instead of making a new one.
local tech = copy(TECH["space-science-pack"])
tech.name = "asteroid-space-science"
tech.effects = {
	{
		type = "unlock-space-location",
		space_location = "metallic-belt",
		use_icon_overlay_constant = true,
	},
	{
		type = "unlock-space-location",
		space_location = "carbonic-belt",
		use_icon_overlay_constant = true,
	},
	{
		type = "unlock-space-location",
		space_location = "ice-belt",
		use_icon_overlay_constant = true,
	},
}
-- TODO better sprite
-- TODO rearrange the tech tree so it goes (space platform + thrusters) -> (Apollo + lunar science) -> (asteroid belts + crushers/grabbers + space science) -> planets.
extend{tech}