--[[ This file edits boilers, heating towers, heat exchanger, steam engine/turbine, and heat pipe.
I want to make the numbers more regular base-10 - both fluid I/O numbers and power values.
I also want to make power gen in general more difficult, by giving steam engines and turbines lower effectivity.
	(This is a lot easier than what I did in PowerMultiplier mod, where I changed energy consumptions of all entities.)

For fluid I/O, the current numbers (6/s, 60/s, 30/s) are related to 60. I want to try making them more regular to 10 instead.
	I thought they were related to 60 because the game has 60 ticks per second. But I think it might actually be due to energy math?
		The 6 water goes 15C->100C consuming (100-15)*2kJ*6 = 1020kJ. And then the 60 steam goes 100C->165C consuming (165-100)*200J*60 = 780kJ. Making total consumption 1800kJ per second, or 1.8MW, which is energy consumption of the boiler. Here 2kJ/C is heat capacity of water, and 200J/C is heat capacity of steam, and 1 water becomes 10 steam.
		Seems the split at 165C (between turbines and engines) is arbitrary? Steam at 1 atm will be 100 C, but these systems are pressurized.
		Actually, seems it's also related to 60 ticks/sec -- steam engine code sets fluid usage per tick to 0.5.
			BUT setting it to (50/60) fluid per tick works, makes it consume 50/sec, no floating-point issues.
	We can't directly edit fluid input or output rate of boilers. But we can edit the boiler's energy consumption.
	I can't see where they define the "1 water = 10 steam" thing in code, or where they specify that water becomes steam when heated.
		The water-steam could be specified by fluid boxes' filters.
	Seems like it's separately computing water consumption amount and steam production amount, so that each of them has the expected energy?
	Changing things so that:
		Water comes from lakes at 0 C, then gets boiled to 200 C by boilers, or 500 C by heat exchangers. Heat capacities halved.
		Boiler consumes 2MW and 10/s water, produces 100/s steam.
		Steam engine produces 1MW from 50/s steam.
]]

-- Boiler recipes.
Recipe.edit{
	recipe = "boiler",
	time = 5,
	ingredients = {
		{"structure", 1},
		{"fluid-fitting", 5},
		{"shielding", 1},
	},
}
Recipe.edit{
	recipe = "electric-boiler",
	time = 5,
	ingredients = {
		{"structure", 1},
		{"fluid-fitting", 5},
		{"shielding", 1},
		{"electronic-components", 2},
	},
}
Recipe.edit{
	recipe = "gas-boiler",
	time = 5,
	ingredients = {
		{"structure", 1},
		{"fluid-fitting", 10},
		{"shielding", 1},
	},
}

Recipe.edit{
	recipe = "steam-engine",
	ingredients = {
		{"frame", 1},
		{"electronic-components", 5},
		{"mechanism", 2},
		{"fluid-fitting", 5},
	},
	time = 5,
}
Recipe.edit{
	recipe = "steam-turbine",
	ingredients = { -- Steam turbine is much more efficient than steam engine, so giving it much greater material cost as the tradeoff.
		{"frame", 10},
		{"electronic-components", 20},
		{"fluid-fitting", 50},
		{"shielding", 50}, -- High-pressure and high-temperature steam.
	},
	time = 10,
}

Recipe.edit{
	recipe = "heating-tower",
	time = 10,
	ingredients = {
		{"structure", 50},
		{"shielding", 50},
		{"heat-pipe", 20},
	},
}
Recipe.edit{
	recipe = "fluid-heating-tower",
	time = 10,
	ingredients = {
		{"structure", 50},
		{"shielding", 50},
		{"heat-pipe", 20},
		{"fluid-fitting", 10},
	},
}

-- Heat pipe is originally 20 copper plate + 10 steel plate for 1. That seems very expensive for the size. Would make Aquilo and Gleba annoying. So I'll make it a lot cheaper.
Recipe.edit{
	recipe = "heat-pipe",
	ingredients = {
		{"copper-plate", 2},
		{"steel-plate", 1},
	},
	time = 1,
}
Recipe.edit{
	recipe = "heat-exchanger",
	ingredients = { -- The whole system with heat exchangers is much more efficient than boilers and steam engines. So, increasing material cost as tradeoff.
		{"structure", 10},
		{"shielding", 20},
		{"fluid-fitting", 10},
		{"heat-pipe", 20},
	},
	time = 10,
}

------------------------------------------------------------------------
--- Editing entity values.

-- Edit water and steam.
FLUID.water.default_temperature = 0 -- Originally 15.
FLUID.steam.default_temperature = 0 -- Originally 15. Wanted to make this 100, but then boiler has weird nonsense readouts (like "steam 200/s out of 100/s").
FLUID.water.heat_capacity = "1kJ" -- Originally 2kJ.
FLUID.steam.heat_capacity = "0.1kJ" -- Originally 0.2kJ.
FLUID.steam.gas_temperature = 100 -- Originally 15.

-- Edit boilers.
for _, vals in pairs{
	{
		name = "boiler",
		consumption = "2MW", -- Originally 1.8MW.
		effectivity = 1, -- Originally 1.
		targetTemp = 200, -- Originally 165.
		pollution = 20, -- Originally 30.
	},
	{
		name = "electric-boiler",
		consumption = "2MW", -- Originally 1.8MW.
		effectivity = 1,
		targetTemp = 200,
		pollution = 20, -- Originally 30.
	},
	{
		name = "gas-boiler",
		consumption = "2MW", -- Originally 1.8MW.
		effectivity = 1,
		targetTemp = 200,
		pollution = 20, -- Originally 30.
	},
} do
	local ent = RAW.boiler[vals.name]
	ent.energy_consumption = vals.consumption
	ent.energy_source.effectivity = vals.effectivity
	ent.target_temperature = vals.targetTemp
	ent.energy_source.emissions_per_minute = {pollution = vals.pollution}
end

-- Edit generators (steam engines and turbine).
for _, vals in pairs{
	{
		name = "steam-engine",
		effectivity = 0.5, -- Originally 1.
		fluidUsagePerTick = 50/60, -- Originally 0.5, so 30/s.
		maxTemp = 200, -- Originally 165.
	},
	{
		name = "steam-turbine",
		effectivity = 0.8, -- Originally 1. Changing to .8, so it produces an even 2MW and it's more efficient than the steam engine.
		fluidUsagePerTick = 50/60, -- Originally 1, so 60/s.
		maxTemp = 500, -- Originally 500.
	},
} do
	local ent = RAW["generator"][vals.name]
	ent.fluid_usage_per_tick = vals.fluidUsagePerTick
	ent.maximum_temperature = vals.maxTemp
	ent.effectivity = vals.effectivity
end

-- Edit heating towers.
-- Nerf heating towers' effictivity, and reduce energy consumption. Because they're no longer late-game, and because the base game's values are just absurdly high.
for _, vals in pairs{
	{
		name = "heating-tower",
		effectivity = 1, -- Originally 2.5.
		consumption = "5MW", -- Originally 40MW. Compare 2MW for a boiler.
		pollution = 50, -- Originally 100.
	},
	{
		name = "fluid-heating-tower",
		effectivity = 1,
		consumption = "5MW",
		pollution = 50,
	},
} do
	local ent = RAW.reactor[vals.name]
	ent.energy_source.effectivity = vals.effectivity
	ent.consumption = vals.consumption
	ent.energy_source.emissions_per_minute = {pollution = vals.pollution}
end

--[[ Edit heat exchanger to have the same fluid stats as a boiler.
Could make it 2MW, which would be 4/s water -> 40/s steam.
But rather making it 5MW, for 10 water -> 100 steam (at 500C). So the ratio is 1 heating tower to 1 heat exchanger.]]
RAW.boiler["heat-exchanger"].energy_consumption = "5MW" -- Originally 10MW I think.