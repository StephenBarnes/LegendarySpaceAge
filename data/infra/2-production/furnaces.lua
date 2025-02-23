--[[ This file adjusts numbers and recipes for furnaces.
For speeds: adjusting stone furnace to 0.5, other furnaces 1. (Vanilla has stone 1, steel 2, electric 2.)
For energy usage:
	In vanilla, stone furnace was 90kW, and produced one plate in 3.2s. I'm changing it so it produces 1 ingot = 5 plates in 10s, then assembler makes that 5 plates in 5s (basic assembler), so 3s total. So, changing stone furnace to 100kW.
	In vanilla, steel furnace was 90kW, electric furnace 180kW. Changing those to 100kW and 200kW.
	Actually, vanilla furnaces use very little fuel. I've never felt fuel was the limiting factor for my furnace stacks. So rather roughly doubling all of the above.
]]

for _, vals in pairs{
	{
		name = "stone-furnace",
		ingredients = {"structure"},
		time = 1,
		energy_usage = "200kW",
		speed = 0.5,
	},
	{
		-- Steel furnaces have similar fuel usage to stone furnaces, but double speed and pollution, and much greater initial infra cost.
		name = "steel-furnace",
		ingredients = {
			{"frame", 5},
			{"structure", 5},
			{"shielding", 5},
		},
		time = 5,
		energy_usage = "200kW",
		speed = 1,
	},
	{
		name = "gas-furnace",
		ingredients = {
			{"frame", 5},
			{"structure", 5},
			{"shielding", 5},
			{"fluid-fitting", 5},
		},
		time = 5,
		energy_usage = "250kW", -- Slightly more energy than steel furnaces, to compensate for not having to put fuel in barrels/canisters.
		speed = 1,
	},
	{
		-- Electric furnaces: same speed as steel furnaces, lower pollution (though electricity gen generates pollution).
		-- But make them have high drain so they're bad when not needed.
		-- Giving them the same overall energy consumption, since energy gen from steam engines/turbines is only 50% efficient in this modpack, so that's effectively double the energy consumption unless you use nuclear or solar or lava heating etc.
		name = "electric-furnace",
		ingredients = {
			{"frame", 5},
			{"structure", 10},
			{"shielding", 10},
			{"electronic-components", 10},
		},
		time = 10,
		energy_usage = "150kW",
		drain = "50kW",
		speed = 1,
	},
} do
	Recipe.edit{
		recipe = vals.name,
		ingredients = vals.ingredients,
		time = vals.time,
	}

	local ent = FURNACE[vals.name]
	ent.energy_usage = vals.energy_usage
	if vals.drain then
		ent.energy_source.drain = vals.drain
	end
	ent.crafting_speed = vals.speed
end

-- Char furnace is technically an assembling machine.
Recipe.edit{
	recipe = "char-furnace",
	ingredients = {"structure"},
	time = 1,
}