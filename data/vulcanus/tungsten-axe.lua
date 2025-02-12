-- This file creates "tungsten axe" tech analogous to steel axe tech. It increases manual mining speed.

local tungstenAxeTech = copy(TECH["steel-axe"])
tungstenAxeTech.name = "tungsten-axe"
tungstenAxeTech.prerequisites = {"tungsten-steel", "steel-axe"}
tungstenAxeTech.research_trigger = {
	type = "craft-item",
	item = "tungsten-plate",
	count = 50,
}
tungstenAxeTech.localised_description = {"technology-description.steel-axe"}
tungstenAxeTech.icon = "__LegendarySpaceAge__/graphics/vulcanus/tungsten-axe-tech.png"
extend{tungstenAxeTech}