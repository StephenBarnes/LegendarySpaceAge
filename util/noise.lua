-- Utility functions for noise expressions.

local Export = {}

---@param old string
---@param new string
---@param noiseType string
---@param noiseName string
Export.substitute = function(old, new, noiseType, noiseName)
	---@diagnostic disable-next-line: assign-type-mismatch
	local noiseExprProto = data.raw[noiseType][noiseName]
	if noiseExprProto == nil then
		log("ERROR: No noise expression found for " .. serpent.line({noiseType, noiseName}))
		return
	end
	local expr = noiseExprProto.expression
	if type(expr) ~= "string" then
		log("ERROR: Expected string for expression, got " .. type(expr) .. " for " .. serpent.line({noiseType, noiseName}))
		return
	end
	local substituted = string.gsub(expr, old, new)
	if #substituted == #expr then
		log("ERROR: " .. old .. " not found in expression " .. serpent.line({noiseType, noiseName}))
		return
	end
	noiseExprProto.expression = substituted
end

---@param old string
---@param new string
---@param noiseTypeAndNames {[1]: string, [2]: string}[]
Export.substituteAll = function(old, new, noiseTypeAndNames)
	for _, noiseTypeAndName in pairs(noiseTypeAndNames) do
		Export.substitute(old, new, noiseTypeAndName[1], noiseTypeAndName[2])
	end
end

return Export