-- This file changes tech costs to encourage scaling in the late game while not making early game too slow.

local techRates = require("util.const.tech-rates")

local multByPack = {
	["automation-science-pack"] = 1,
	["logistic-science-pack"] = 2,
	["military-science-pack"] = 2,
	["chemical-science-pack"] = 5,
	["production-science-pack"] = 10,
	["utility-science-pack"] = 10,

	["space-science-pack"] = 5,
	["asteroid-science-pack"] = 5,
	["metallurgic-science-pack"] = 10,
	["agricultural-science-pack"] = 10,
	["electromagnetic-science-pack"] = 10,
	["nuclear-science-pack"] = 20,
	["cryogenic-science-pack"] = 20,
	["promethium-science-pack"] = 50,
}

for _, tech in pairs(TECH) do
	if tech.unit ~= nil and techRates[tech.name] == nil then
		local maxMult = 1
		for _, ingredient in pairs(tech.unit.ingredients) do
			local mult = multByPack[ingredient[1]]
			if mult == nil then
				log("ERROR: No mult for " .. ingredient[1])
			else
				maxMult = math.max(maxMult, mult)
			end
		end
		if maxMult ~= 1 then
			if tech.unit.count ~= nil then
				tech.unit.count = tech.unit.count * maxMult
			elseif tech.unit.count_formula ~= nil then
				tech.unit.count_formula = tech.unit.count_formula .. "*" .. maxMult
			else
				log("ERROR: No count or count formula for " .. tech.name .. " : " .. serpent.block(tech))
			end
		end
	end
end