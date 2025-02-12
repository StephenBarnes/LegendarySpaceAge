-- Make space platform tiles more complex and expensive to produce.
-- Originally 20 steel plate + 20 copper cable.
RECIPE["space-platform-foundation"].ingredients = {
	{ type = "item", name = "low-density-structure", amount = 4 },
		-- Effectively 80 copper plate, 8 steel plate, 12 plastic, 4 resin.
	{ type = "item", name = "electric-engine-unit", amount = 1 },
		-- Effectively lubricant plus metals.
	{ type = "item", name = "processing-unit", amount = 1 },
		-- Effectively sulfuric acid + plastic + metals.
}