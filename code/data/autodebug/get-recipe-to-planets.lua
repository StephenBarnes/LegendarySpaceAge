-- This file exports a function to generate a table mapping each recipe to a set of planets (and "space") where it's permitted.

local Util = require("code.data.autodebug.util")

-- Get surface properties for planet, or "space".
local function getSurfaceProperties(planetName)
	if planetName == "space" then
		return data.raw.surface["space-platform"].surface_properties
	else
		assert(data.raw.planet[planetName], "Unknown planet: " .. serpent.line(planetName))
		return data.raw.planet[planetName].surface_properties
	end
end

-- Get the value of a given property from a set of surface properties.
---@param propertyName string
---@param properties table<SurfacePropertyID, double>
local function getSurfacePropertyValue(propertyName, properties)
	if properties[propertyName] ~= nil then
		return properties[propertyName]
	else
		return data.raw["surface-property"][propertyName].default_value
	end
end

-- Check whether a given surface condition is satisfied by a given planet.
---@param condition SurfaceCondition
local function planetMatchesSurfaceCondition(planetName, condition)
	assert(condition.min ~= nil or condition.max ~= nil, "Surface condition must have min or max: " .. serpent.line(condition))
	local properties = getSurfaceProperties(planetName)
	assert(properties ~= nil, "No surface properties for planet: " .. serpent.line(planetName))
	local planetValue = getSurfacePropertyValue(condition.property, properties)
	if condition.min and planetValue < condition.min then
		return false
	end
	if condition.max and planetValue > condition.max then
		return false
	end
	return true
end

-- Check whether a recipe is permitted on a given planet.
local function recipePermittedOnPlanet(recipe, planetName)
	for _, condition in pairs(recipe.surface_conditions or {}) do
		if not planetMatchesSurfaceCondition(planetName, condition) then
			return false
		end
	end
	return true
end

-- Make a table mapping each recipe to a set of planets (and "space") where it's permitted.
local function getRecipesToPlanets()
	local result = {}
	for _, recipe in pairs(RECIPE) do
		if not recipe.parameter then
			if recipe.category == "recycling" then 
				-- Special case for recycling recipes: only consider them on Fulgora. Because they only matter for progression on Fulgora.
				result[recipe.name] = {fulgora = true}
			elseif recipe.surface_conditions == nil or #recipe.surface_conditions == 0 then
				result[recipe.name] = Util.allPlanets
			else
				for planetName, _ in pairs(Util.allPlanets) do
					local recipePlanets = {}
					if recipePermittedOnPlanet(recipe, planetName) then
						recipePlanets[planetName] = true
					end
					result[recipe.name] = recipePlanets
				end
			end
		end
	end
	return result
end

return getRecipesToPlanets