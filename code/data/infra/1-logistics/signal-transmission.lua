-- This file edits tech/recipes for the AAI Signal Transmission mod.

-- Recipes.
data.raw.recipe["aai-signal-sender"].ingredients = {
	{type = "item", name = "frame", amount = 50},
	{type = "item", name = "panel", amount = 50},
	{type = "item", name = "electric-engine-unit", amount = 20},
	{type = "item", name = "processing-unit", amount = 20},
}
data.raw.recipe["aai-signal-receiver"].ingredients = {
	{type = "item", name = "frame", amount = 100},
	{type = "item", name = "panel", amount = 100},
	{type = "item", name = "mechanism", amount = 10},
	{type = "item", name = "sensor", amount = 10},
}

-- Seems energy usage is always only drain, no extra. Except there's a buffer that has to fill up when it's first placed. Can't set usage to zero or drain also doesn't apply. Also seems usage is equal to drain if I change usage, not sure why, might be the mod.