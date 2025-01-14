require("code.data.fulgora.batteries-dff")

-- Change concrete recycling to give back stone. (Ingredient is fluid, but it solidifies.)
data.raw.recipe["concrete-recycling"].results = {
	{type = "item", name = "stone", amount = 1, extra_count_fraction = .25},
	{type = "item", name = "sand", amount = 1, extra_count_fraction = .25},
}

-- Change refined concrete recycling to give back stone and sand.
table.insert(data.raw.recipe["refined-concrete-recycling"].results, {type = "item", name = "stone", amount = 1, extra_count_fraction = .25})
table.insert(data.raw.recipe["refined-concrete-recycling"].results, {type = "item", name = "sand", amount = 1, extra_count_fraction = .25})