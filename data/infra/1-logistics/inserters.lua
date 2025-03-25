-- Inserter recipes - rod is now enabled from the start.
RECIPE["burner-inserter"].ingredients = {
	{type = "item", name = "mechanism", amount = 1},
}
RECIPE["inserter"].ingredients = {
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "electronic-circuit", amount = 1}, -- Making it require a green circuit - sensors are too expensive, since you need a lot of inserters in early game before you can actually automate wirings and circuit boards.
}
RECIPE["long-handed-inserter"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 1},
}
RECIPE["fast-inserter"].ingredients = {
	{type = "item", name = "electric-engine-unit", amount = 1},
	{type = "item", name = "sensor", amount = 1},
}
RECIPE["fast-inserter"].category = "crafting"
RECIPE["bulk-inserter"].ingredients = {
	{type = "item", name = "electric-engine-unit", amount = 2},
	{type = "item", name = "processing-unit", amount = 2},
	{type = "item", name = "sensor", amount = 1},
}
RECIPE["bulk-inserter"].category = "crafting"
RECIPE["stack-inserter"].ingredients = {
	{type = "item", name = "bulk-inserter", amount = 1},
	{type = "item", name = "neurofibril", amount = 2},
}

-- Allow burner inserters to leech. Unclear why this is off by default.
RAW.inserter["burner-inserter"].allow_burner_leech = true

-- TODO edit inserter operating characteristics, eg make yellow inserters just exactly 1 item per second.

-- TODO edit inserters' max healths, they're very high and vary seemingly randomly between inserters.