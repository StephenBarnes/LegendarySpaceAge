-- Look at all recycling recipes, and change hot ingot results to cold equivalents.
local changes = {
	["ingot-iron-hot"] = "ingot-iron-cold",
	["ingot-steel-hot"] = "ingot-steel-cold",
	["ingot-copper-hot"] = "ingot-copper-cold",
}
for _, recipe in pairs(RECIPE) do
	if recipe.category == "recycling" then
		for _, result in pairs(recipe.results) do
			if changes[result.name] then
				result.name = changes[result.name]
			end
		end
	end
end