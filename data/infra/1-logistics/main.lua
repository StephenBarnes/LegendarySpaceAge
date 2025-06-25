require("transport-belts")
require("signal-transmission")
require("chests")
require("inserters")
require("power-poles")
require("fluid-stuff")
require("rail")
require("ships")
require("vehicles")
require("circuit-stuff")
require("bots")

-- Stone bricks - allow handcrafting.
Recipe.setCategories("stone-brick", {"smelting", "handcrafting"})

-- Adjust recipe times.
RECIPE["stone-brick"].energy_required = 1 -- Originally 3.2. Making low since you need to do it a lot to make early furnaces.
for _, recipeName in pairs{"hazard-concrete", "refined-hazard-concrete"} do
	RECIPE[recipeName].energy_required = 10 -- Originally 0.25.
end

-- Landfill from coarse filler.
Recipe.edit{
	recipe = "landfill",
	ingredients = {{"coarse-filler", 50}},
	time = 1,
}