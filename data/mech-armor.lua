--[[ This file creates a new "mech armor 2" tech, unlocked by just crafting the mech armor.
Then that tech also gives a mining speed bonus, since we can't give that to the mech armor item directly.
Also make that a prereq for Aquilo, since otherwise it's too easy to softlock yourself.
]]

-- Create a "mech armor 2 tech".
local newTech = copy(TECH["mech-armor"])
newTech.name = "mech-armor-2"
newTech.prerequisites = {"mech-armor", "tungsten-axe"} -- Steel-axe prereq mostly just so players can easily see it.
newTech.unit = nil
newTech.research_trigger = {
	type = "craft-item",
	item = "mech-armor",
	count = 1,
}
newTech.localised_description = {"technology-description.mech-armor-2"}
newTech.effects = copy(TECH["steel-axe"].effects)
data:extend{newTech}

Tech.addTechDependency("mech-armor-2", "planet-discovery-aquilo")