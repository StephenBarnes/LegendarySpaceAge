--[[ This file will set up all the nuclear fission stuff for Nauvis part 2 (ie Nauvis after handling the 3 sister planets.
TODO
]]

-- Create nuclear science pack.
local item = copy(RAW.tool["agricultural-science-pack"])
item.name = "nuclear-science-pack"
item.order = "j2"
item.spoil_ticks = 60 * 60 * 20 -- 20 minutes.
item.spoil_result = "uranium-238"
extend{item}
-- TODO add this to a tech, add new sprite, etc.

-- Create recipe for nuclear science pack.
local recipe = copy(RECIPE["automation-science-pack"])
recipe.name = "nuclear-science-pack"
recipe.ingredients = {
	{type="item", name="uranium-235", amount=1},
}
recipe.results = {
	{type="item", name="nuclear-science-pack", amount=2},
}
recipe.icon = nil
-- TODO add to a tech, actually decide on ingredients, etc.
extend{recipe}

-- Allow nuclear science pack in labs.
table.insert(RAW.lab.lab.inputs, 11, "nuclear-science-pack")
table.insert(RAW.lab.glebalab.inputs, 11, "nuclear-science-pack")
table.insert(RAW.lab.biolab.inputs, 11, "nuclear-science-pack")

-- Move uranium mining tech to after 3 sisters.
TECH["uranium-mining"].prerequisites = {"agricultural-science-pack", "metallurgic-science-pack", "electromagnetic-science-pack"}
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
	local newIngredients = copy(preUraniumSciencePackIngredients)
	if techNameMilitaryNuclear[2] then
		table.insert(newIngredients, {"military-science-pack", 1})
	end
	if techNameMilitaryNuclear[3] then
		table.insert(newIngredients, {"nuclear-science-pack", 1})
	end
	TECH[techNameMilitaryNuclear[1]].unit.ingredients = newIngredients
end

-- Spidertron no longer requires nuclear techs first, or nuclear reactor as ingredient.
Tech.removePrereq("spidertron", "fission-reactor-equipment")