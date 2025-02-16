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
for planetName, planet in pairs(RAW.planet) do
	if not planet.hidden_in_factoriopedia and not planet.hidden then -- This check catches special surfaces like "apprentice-foundry" and "thruster-control-behavior".
		Export.allPlanets[planetName] = true
	end
end
Export.allPlanets.space = true

return Export