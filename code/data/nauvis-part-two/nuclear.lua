--[[ This file will set up all the nuclear fission stuff for Nauvis part 2 (ie Nauvis after handling the 3 sister planets.
TODO
]]

local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

-- Create nuclear science pack.
local nuclearSciencePackItem = table.deepcopy(data.raw.tool["agricultural-science-pack"])
nuclearSciencePackItem.name = "nuclear-science-pack"
nuclearSciencePackItem.order = "j2"
nuclearSciencePackItem.spoil_ticks = 60 * 60 * 20 -- 20 minutes.
nuclearSciencePackItem.spoil_result = "uranium-238"
data:extend{nuclearSciencePackItem}
-- TODO add this to a tech, add new sprite, etc.

-- Allow nuclear science pack in labs.
table.insert(data.raw.lab.lab.inputs, 11, "nuclear-science-pack")
table.insert(data.raw.lab.glebalab.inputs, 11, "nuclear-science-pack")
table.insert(data.raw.lab.biolab.inputs, 11, "nuclear-science-pack")

-- Move uranium mining tech to after 3 sisters.
data.raw.technology["uranium-mining"].prerequisites = {"agricultural-science-pack", "metallurgic-science-pack", "electromagnetic-science-pack"}
local preUraniumSciencePackIngredients = {
	{"automation-science-pack", 1},
	{"logistic-science-pack", 1},
	{"chemical-science-pack", 1},
	{"production-science-pack", 1},
	{"utility-science-pack", 1},
	{"space-science-pack", 1},
	{"metallurgic-science-pack", 1},
	{"agricultural-science-pack", 1},
	{"electromagnetic-science-pack", 1},
}
for _, techNameMilitaryNuclear in pairs{
	{"uranium-mining", false, false},
	{"kovarex-enrichment-process", false, true},
	{"atomic-bomb", true, true},
	{"uranium-ammo", true, true},
	{"nuclear-power", false, false},
	{"fission-reactor-equipment", true, false},
	{"nuclear-fuel-reprocessing", false, false},
} do
	local newIngredients = table.deepcopy(preUraniumSciencePackIngredients)
	if techNameMilitaryNuclear[2] then
		table.insert(newIngredients, {"military-science-pack", 1})
	end
	if techNameMilitaryNuclear[3] then
		table.insert(newIngredients, {"nuclear-science-pack", 1})
	end
	data.raw.technology[techNameMilitaryNuclear[1]].unit.ingredients = newIngredients
end

-- Spidertron no longer requires nuclear techs first, or nuclear reactor as ingredient.
Tech.removePrereq("spidertron", "fission-reactor-equipment")