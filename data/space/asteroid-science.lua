-- This file makes tech that unlocks asteroid belts, and adds science pack using asteroid chunks.

-- Create tech for asteroid science.
local tech = copy(TECH["space-science-pack"])
tech.name = "asteroid-science-pack"
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
	{
		type = "unlock-recipe",
		recipe = "asteroid-science-pack",
	},
}
-- TODO rearrange the tech tree so it goes (space platform + thrusters) -> (Apollo + lunar science) -> (asteroid belts + crushers/grabbers + space science) -> planets.
Icon.set(tech, "LSA/asteroid-science/tech")
extend{tech}

-- Create item for asteroid science.
local scienceItem = copy(RAW.tool["space-science-pack"])
scienceItem.name = "asteroid-science-pack"
Icon.set(scienceItem, "LSA/asteroid-science/item")
extend{scienceItem}

-- Create recipe for asteroid science.
Recipe.make{
	copy = "space-science-pack",
	recipe = "asteroid-science-pack",
	category = "crafting",
	ingredients = {
		{"metallic-asteroid-chunk", 1},
		{"carbonic-asteroid-chunk", 1},
		{"oxide-asteroid-chunk", 1},
	},
	resultCount = 1,
	clearIcons = true,
	clearSurfaceConditions = true,
	main_product = "asteroid-science-pack",
}