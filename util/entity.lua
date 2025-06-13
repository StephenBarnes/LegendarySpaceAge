-- Utilities for working with entities.

local Export = {}

---@param typeOrEnt any
---@param name string?
local function getEnt(typeOrEnt, name)
	if type(typeOrEnt) == "string" then
		local ent = RAW[typeOrEnt][name]
		assert(ent, "Entity " .. name .. " not found in " .. typeOrEnt)
		return ent
	else
		assert(typeOrEnt, "Entity is nil")
		return typeOrEnt
	end
end

---@param typeOrEnt any
---@param name string?
Export.hide = function(typeOrEnt, name, alternative)
	local ent = getEnt(typeOrEnt, name)
	ent.hidden = true
	ent.hidden_in_factoriopedia = true
	if alternative then
		ent.factoriopedia_alternative = alternative
	end
end

---@param entOrType any
---@param name string?
Export.unhide = function(entOrType, name)
	local ent = getEnt(entOrType, name)
	ent.hidden = false
	ent.hidden_in_factoriopedia = false
end

return Export