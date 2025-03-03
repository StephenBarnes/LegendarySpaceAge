-- Pipes
Recipe.edit{
	recipe = "pipe",
	ingredients = {
		{"fluid-fitting", 1},
		{"panel", 5},
	},
	time = 1,
	resultCount = 5,
}
Recipe.edit{
	recipe = "pipe-to-ground",
	ingredients = {{"pipe", 20}}, -- It's 12 pipes long, but making this higher so it's a regular number and since it's more convenient.
	resultCount = 2,
	time = 1,
}

Recipe.edit{
	recipe = "pump",
	ingredients = {
		{"frame", 2},
		{"fluid-fitting", 5},
		{"mechanism", 2},
	},
	time = 2,
}
local pump = RAW.pump.pump
pump.energy_usage = "40kW"
pump.energy_source.drain = "10kW"
pump.pumping_speed = 16.6667 -- This is 1000/60 per tick, so 1000 per second.

Recipe.edit{
	recipe = "offshore-pump",
	ingredients = {
		{"fluid-fitting", 5},
		{"mechanism", 2},
	},
	time = 1,
}
Recipe.edit{
	recipe = "waste-pump",
	ingredients = {
		{"fluid-fitting", 5},
		{"mechanism", 2},
	},
	time = 1,
}

-- Adjust pumping rate of offshore pump.
local newSpeed = 16.6667 --1000/60 -- Was 1200/60.
RAW["offshore-pump"]["offshore-pump"].pumping_speed = newSpeed
if RAW["offshore-pump"]["lava-pump"] ~= nil then
	-- If it's defined, change it there too. If it's not defined, lava pump will inherit the change from the above.
	RAW["offshore-pump"]["lava-pump"].pumping_speed = newSpeed
end

-- Reduce health of pipes, to encourage building walls.
RAW.pipe.pipe.max_health = 35 -- Reduced from 100 to 35. Wall is 350.