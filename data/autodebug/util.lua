local Export = {}

---@param ingredientOrResult data.IngredientPrototype|data.ProductPrototype
---@param planet string?
Export.getCanonicalName = function(ingredientOrResult, planet)
	local prefix = ""
	if planet ~= nil then prefix = planet..":" end
	if ingredientOrResult.type == "fluid" then
		return prefix.."fluid:"..ingredientOrResult.name
	elseif ingredientOrResult.type == "item" then
		return prefix.."item:"..ingredientOrResult.name
	else
		error("Unknown ingredient/result type: "..serpent.line(ingredientOrResult))
	end
end

Export.allPlanets = {}
for planetName, _ in pairs(data.raw.planet) do
	Export.allPlanets[planetName] = true
end
Export.allPlanets.space = true
-- Ignore special surfaces.
Export.allPlanets["thruster-control-behavior"] = nil

return Export