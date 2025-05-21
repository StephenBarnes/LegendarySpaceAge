-- Create resin item.
local resinItem = copy(ITEM["plastic-bar"])
resinItem.name = "resin"
Icon.set(resinItem, "LSA/resin/resin-1")
Icon.variants(resinItem, "LSA/resin/resin-%", 3)
Item.copySoundsTo(RAW.capsule["bioflux"], resinItem)
extend{resinItem}

--[[ Add recipes for resin.
	Wood-based resin (pyrolysis): 5 wood + 5 steam -> 2 resin + 3 carbon
	Pitch-based resin: 2 pitch + 1 sulfuric acid + 1 carbon -> 4 resin
	Rich-gas-based resin: 2 rich gas + 1 sulfuric acid + 1 carbon -> 2 resin
	]]
local woodResinRecipe = copy(RECIPE["plastic-bar"])
woodResinRecipe.name = "wood-resin"
woodResinRecipe.ingredients = {
	{type = "item", name = "wood", amount = 1},
	{type = "fluid", name = "steam", amount = 100},
}
woodResinRecipe.results = {
	{type = "item", name = "resin", amount = 10},
	{type = "item", name = "carbon", amount = 1},
}
Icon.set(woodResinRecipe, {"resin", "wood"})
woodResinRecipe.main_product = "resin"
woodResinRecipe.energy_required = 5
extend{woodResinRecipe}

local pitchResinRecipe = copy(RECIPE["plastic-bar"])
pitchResinRecipe.name = "pitch-resin"
pitchResinRecipe.ingredients = {
	{type = "item", name = "pitch", amount = 2},
	{type = "fluid", name = "sulfuric-acid", amount = 10},
	{type = "item", name = "carbon", amount = 1},
}
pitchResinRecipe.results = {
	{type = "item", name = "resin", amount = 2},
}
Icon.set(pitchResinRecipe, {"resin", "pitch"})
pitchResinRecipe.main_product = "resin"
pitchResinRecipe.energy_required = 2
pitchResinRecipe.allow_quality = true
pitchResinRecipe.allow_productivity = true
pitchResinRecipe.maximum_productivity = 2
extend{pitchResinRecipe}

local richGasResinRecipe = copy(RECIPE["plastic-bar"])
richGasResinRecipe.name = "rich-gas-resin"
richGasResinRecipe.ingredients = {
	{type = "fluid", name = "petroleum-gas", amount = 20},
	{type = "fluid", name = "sulfuric-acid", amount = 10},
	{type = "item", name = "carbon", amount = 1},
}
richGasResinRecipe.results = {
	{type = "item", name = "resin", amount = 1},
}
Icon.set(richGasResinRecipe, {"resin", "petroleum-gas"})
richGasResinRecipe.energy_required = 2
extend{richGasResinRecipe}