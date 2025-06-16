--[[ This file makes changes to water, ice, steam, and related recipes.

Should we change the 1-to-10 water-to-steam ratio to 1-to-1?
	Then just give them the same specific heat too.
	Why not?
		I think they found it was hard to get water to nuclear plants, so decided to 10x specific heat of water.
			See FF-430.
		And they didn't also 10x the specific heat of steam, so that creates the 1-to-10 ratio.
		Why not 10x the specific heat of steam too?
			Maybe they don't like steam tanks being extremely efficient stores of heat?
				That would have increased 1 tank of 500C steam from 1250MJ to 12500MJ. Both are absurd compared to accumulators at 5MJ each.
			The 1-to-10 ratio encourages people to store water tanks and fuel, then boil the water when needed, rather than storing steam, because now that's more efficient. And we want to encourage that bc storing water is more realistic.
	BUT that benefit is small compared to the benefit of a 1-to-1 ratio, namely: it allows using the fusion-reactor prototype to create condenser turbines.
		And condenser turbines are more realistic for spaceships than the current thing where you vent steam to space.
		Also makes a lot more sense for water-scarce planets like Fulgora and Vulcanus.
	Ok, giving water the same specific heat as steam, 1-to-1 ratio.
		Then what are the water ratios like?
			1 nuclear reactor generates 40MW, up to 160MW with neighbors.
			So needs 8-32 heat exchangers, consuming 800-3200 water/s.
			That's 1-3 offshore pumps. Or 16-64 barrels of water per second, plus 2-7 assembler 3's barrelling and unbarrelling.
			I think that's reasonable, especially since you could instead use the condenser turbines to get the water back.
		Hm, could get the best of both by increasing steam's specific heat 10x too, then making storage tanks smaller.
			I think I'll do that. Can't see any drawbacks, except no longer encouraging water over steam tanks, but that's small.
	Update: we don't actually need 1-to-1 for the condenser turbine, since I'm using the hidden entity with evil-steam anyway to give it lower efficiency. Could just make evil-steam have lower volume.
		So TODO: re-analyze this and maybe undo the change. Maybe even change it to 1 water = 1000 steam, to make steam tanks more realistic at 12.5MJ.
]]


-- Edit water and steam.
FLUID.water.default_temperature = 0 -- Originally 15.
FLUID.steam.default_temperature = 0 -- Originally 15. Wanted to make this 100, but then boiler has weird nonsense readouts (like "steam 200/s out of 100/s").
FLUID.water.heat_capacity = "1kJ" -- Originally 2kJ.
FLUID.steam.heat_capacity = "1kJ" -- Originally 0.2kJ.
FLUID.steam.gas_temperature = 100 -- Originally 15.

-- Change prod for some recipes.
for _, recipeName in pairs{"ice-melting", "steam-condensation"} do
	local recipe = RECIPE[recipeName]
	recipe.allow_productivity = false
	recipe.allow_quality = false
end

-- Steam condensation should just give back all the water, since there's now condenser turbines. Originally 1000 steam -> 90 water in 1 sec.
Recipe.edit{
	recipe = "steam-condensation",
	ingredients = {
		{"steam", 100},
	},
	results = {
		{"water", 100},
	},
}
-- Ice melting: change ice-to-water ratio to 1:10 instead of 1:20.
Recipe.edit{
	recipe = "ice-melting",
	ingredients = {
		{"ice", 1},
	},
	results = {
		{"water", 10},
	},
}