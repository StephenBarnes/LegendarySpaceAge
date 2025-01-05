-- Look at all recycling recipes, and change hot ingot results to cold equivalents.
local changes = {
	["ingot-iron-hot"] = "ingot-iron-cold",
	["ingot-steel-hot"] = "ingot-steel-cold",
	["ingot-copper-hot"] = "ingot-copper-cold",
}
for _, recipe in pairs(data.raw.recipe) do
	if recipe.category == "recycling" then
		for _, result in pairs(recipe.results) do
			if changes[result.name] then
				result.name = changes[result.name]
			end
		end
	end
end

-- For rusty items, make recycling recipes only delete the item.
for _, item in pairs{"iron-gear-wheel", "iron-stick"} do
	local recipe = data.raw.recipe["rocs-rusting-iron-"..item.."-rusty-recycling"]
	recipe.results = {{type = "item", name = "rocs-rusting-iron-"..item.."-rusty", amount = 1, probability = .25}}
end