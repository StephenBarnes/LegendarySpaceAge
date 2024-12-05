-- Nerf heating towers' efficiency, and reduce energy consumption.
data.raw.reactor["heating-tower"].energy_source.effectivity = 1 -- 2.5 to 1
data.raw.reactor["heating-tower"].consumption = "8MW"

-- Make space platform tiles more complex and expensive to produce.
-- Originally 20 steel plate + 20 copper cable.
data.raw.recipe["space-platform-foundation"].ingredients = {
	{ type = "item", name = "low-density-structure", amount = 10 },
		-- Effectively 200 copper plate, 20 steel plate, 50 plastic.
	{ type = "item", name = "copper-cable", amount = 10 },
	{ type = "item", name = "electric-engine-unit", amount = 1 },
		-- Effectively lubricant plus metals.
	{ type = "item", name = "processing-unit", amount = 1 },
		-- Effectively sulfuric acid + plastic + metals.
}