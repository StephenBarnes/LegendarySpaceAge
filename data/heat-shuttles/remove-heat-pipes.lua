--[[ This file removes heat pipes and heat exchangers.
Because we have the heat shuttle system, and I think it's ugly to have that and also have separate heat pipes that can only interact with the heat system in a handful of ways, etc.
]]

Recipe.hide("heat-pipe")
Item.hide("heat-pipe")
Entity.hide("heat-pipe", "heat-pipe")

Recipe.hide("heat-exchanger")
Item.hide("heat-exchanger")
Entity.hide("boiler", "heat-exchanger")