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

-- Stone bricks - allowed in foundry and handcrafting.
RECIPE["stone-brick"].category = "smelting-or-handcrafting"

-- Adjust recipe times.
RECIPE["stone-brick"].energy_required = 2 -- Originally 3.2.
for _, recipeName in pairs{"hazard-concrete", "refined-hazard-concrete"} do
	RECIPE[recipeName].energy_required = 10 -- Originally 0.25.
end