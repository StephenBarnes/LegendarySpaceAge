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

local recipes = data.raw.recipe

-- Stone bricks - allowed in foundry and handcrafting.
recipes["stone-brick"].category = "smelting-or-metallurgy-or-handcrafting"