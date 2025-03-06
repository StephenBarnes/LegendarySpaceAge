
-- Edit the spent-filter-recycling recipe to have the same results as filter-recycling.
RECIPE["spent-filter-recycling"].results = RECIPE["filter-recycling"].results

-- Spidertron Enhancements
if RAW["character-corpse"]["spidertron-enhancements-corpse"] then
	RAW["character-corpse"]["spidertron-enhancements-corpse"].hidden_in_factoriopedia = true
end
if RAW["spider-vehicle"]["spidertron-enhancements-dummy-spidertron"] then
	RAW["spider-vehicle"]["spidertron-enhancements-dummy-spidertron"].hidden_in_factoriopedia = true
	RAW["spider-vehicle"]["spidertron-enhancements-dummy-spidertron"].factoriopedia_alternative = "spidertron"
end

-- Disable quality for some recipes that only produce fluids.
for _, recipeName in pairs{"make-sulfuric-acid", "holmium-solution", "ice-melting", "steam-condensation"} do
	local recipe = RECIPE[recipeName]
	recipe.allow_quality = false
end
-- Change prod for some recipes.
RECIPE["ice-melting"].allow_productivity = false
RECIPE["steam-condensation"].allow_productivity = true
RECIPE["steam-condensation"].maximum_productivity = 0.1