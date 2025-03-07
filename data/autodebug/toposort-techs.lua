---@return string[]?
local function toposortTechs()
	-- Topologically sort the techs, storing the result in toposortedTechs.
	-- If there's a cycle, return nil.
	local currToposortedTechs = {}
	local techsAdded = {} -- maps tech name to true/false for whether it's been added yet
	local numTechs = 0
	local numTechsAdded = 0
	for techName, tech in pairs(TECH) do
		if tech.enabled ~= false and not tech.hidden then
			techsAdded[techName] = false
			numTechs = numTechs + 1
		else
			--log("Skipping disabled tech "..techName)
			--log("Tech: "..serpent.block(tech))
		end
	end
	while numTechsAdded < numTechs do
		local anyAddedThisLoop = false
		for techName, beenAdded in pairs(techsAdded) do
			if not beenAdded then
				local allPrereqsAdded = true
				local tech = TECH[techName]
				local prereqs = tech.prerequisites or {}
				for _, prereqName in pairs(prereqs or {}) do
					if not techsAdded[prereqName] then
						allPrereqsAdded = false
						break
					end
				end
				if allPrereqsAdded then
					table.insert(currToposortedTechs, techName)
					numTechsAdded = numTechsAdded + 1
					anyAddedThisLoop = true
					techsAdded[techName] = true
				end
			end
		end

		if not anyAddedThisLoop then
			log("ERROR: Cycle or unreachable tech detected in tech dependency graph. This shouldn't happen.")
			for techName, beenAdded in pairs(techsAdded) do
				if not beenAdded then
					local tech = TECH[techName]
					log("Could not reach tech "..techName..", which has prereqs: "..serpent.line(tech.prerequisites or "nil"))
				end
			end
			log("Techs added: "..serpent.block(techsAdded))
			return nil
		end
	end
	return currToposortedTechs
end

return toposortTechs