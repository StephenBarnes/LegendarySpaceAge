-- Burner mining drill shouldn't need stone.
Recipe.edit{
	recipe = "burner-mining-drill",
	ingredients = {
		{"mechanism", 1},
		{"frame", 1},
	},
	time = 1,
}
Recipe.edit{
	recipe = "electric-mining-drill",
	ingredients = {
		{"mechanism", 2},
		{"electronic-circuit", 2},
		{"frame", 2},
	},
	time = 2,
}
Recipe.edit{
	recipe = "big-mining-drill",
	ingredients = {
		{"electric-engine-unit", 20},
		{"tungsten-carbide", 20},
		{"frame", 20},
	},
	category = "crafting", -- Not foundry.
	time = 20,
}

Recipe.edit{
	recipe = "pumpjack",
	ingredients = {
		{"mechanism", 10},
		{"frame", 5},
		{"sensor", 1},
		{"fluid-fitting", 20},
	},
	time = 10,
}

-- Ag tower - shouldn't need steel, or landfill, or spoilage. Moving it to early game on Nauvis.
Recipe.edit{
	recipe = "agricultural-tower",
	ingredients = {
		{"mechanism", 2},
		{"frame", 2},
		{"sensor", 1},
		{"glass", 2},
	},
	time = 2,
}

-- I want to edit miner speeds to be more regular and generally faster, to speed up the game, especially early game.
for minerName, vals in pairs{
	["burner-mining-drill"] = {
		speed = 0.5, -- Originally 0.25
		activeKW = 250, -- Originally 150
		pollution = 25, -- Originally 12; doubling because speed is doubled.
	},
	["electric-mining-drill"] = {
		speed = 1, -- Originally 0.5
		activeKW = 200, -- Originally 90
		pollution = 20, -- Originally 10.
	},
	["big-mining-drill"] = {
		speed = 5, -- Originally 2.5
		activeKW = 500, -- Originally 300
		pollution = 80, -- Originally 40.
	},
	["pumpjack"] = {
		activeKW = 100, -- Originally 90
	},
} do
	local ent = RAW["mining-drill"][minerName]
	if vals.speed then
		ent.mining_speed = vals.speed
	end
	if vals.activeKW then
		ent.energy_usage = vals.activeKW .. "kW"
	end
	-- No drain. Could add drain.
	if vals.pollution then
		ent.energy_source.emissions_per_minute.pollution = vals.pollution
	end
end