local Export = {}

Export.die = function(message)
	log("ERROR: "..message)
	error(message)
	assert(false)
end

Export.filterExistingItems = function(possibleItems)
	-- Given a list of possible item IDs, returns a list of item IDs that are in RAW.
	local existingItems = {}
	for _, itemName in pairs(possibleItems) do
		if ITEM[itemName] ~= nil then
			table.insert(existingItems, itemName)
		end
	end
	return existingItems
end

Export.ifThenElse = function(condition, thenValue, elseValue)
	if condition then
		return thenValue
	else
		return elseValue
	end
end

---@param s nil | string
---@param x number
---@return nil | string
Export.multWithUnits = function(s, x)
	-- Given a string `s` with a number and units, eg "100kW" or "50J" or "0.5kW", multiplies only the number part by the given real number `x`.
	-- Returns nil if the number is 0, so we can avoid changing 0 to 0 and thereby spamming the prototype change history.
	if s == nil then return nil end
	local num, units = s:match("^([%d.]+)([a-zA-Z]*)$")
	if num == 0 then return nil end
	return num * x .. units
end

---@param protos (data.ItemPrototype | data.RecipePrototype | data.FluidPrototype)[]
---@param subgroup string
Export.order = function(protos, subgroup)
	for i, proto in pairs(protos) do
		proto.order = string.format("%02d", i)
		proto.subgroup = subgroup
	end
end

---@param kind {[string]: data.Prototype}
---@param protoNames string[]
---@param subgroup string
---@param prefix string|nil
Export.orderKind = function(subgroup, kind, protoNames, prefix)
	prefix = prefix or ""
	for i, protoName in pairs(protoNames) do
		assert(kind[protoName] ~= nil, "OrderKind: kind["..protoName.."] is nil")
		kind[protoName].order = prefix..string.format("%02d", i)
		kind[protoName].subgroup = subgroup
	end
end

---@param subgroup string
---@param kinds {[string]: data.Prototype}[]
---@param protoNames string[]
---@param prefix string|nil
Export.orderKinds = function(subgroup, kinds, protoNames, prefix)
	for _, kind in pairs(kinds) do
		Export.orderKind(subgroup, kind, protoNames, prefix)
	end
end

-- Round `x` to `n` decimal places.
---@param x number
---@param n number
---@return number
Export.round = function(x, n)
	return math.ceil(x * 10^n) / 10^n
end

---@param ent data.CraftingMachinePrototype
---@param effect string
---@return boolean
Export.effectAllowed = function(ent, effect)
	if ent.allowed_effects == nil then return true end
	if type(ent.allowed_effects) == "string" then
		return ent.allowed_effects == effect
	end
	assert(type(ent.allowed_effects) == "table", "allowed_effects is not a table: "..serpent.block(ent.allowed_effects))
	---@diagnostic disable-next-line: param-type-mismatch
	for _, v in pairs(ent.allowed_effects) do
		if v == effect then return true end
	end
	return false
end

---@param jouleString string
---@return number
Export.toJoules = function(jouleString)
	-- Convert a string like "100kJ" or "100MJ" to a number of joules.
	-- Also works for "100kW", but treating "W" the same as "J".
	local num, units = jouleString:match("^([%d.]+)([a-zA-Z]*)$")
	if units == "" or units == "J" or units == "W" then
		return num
	end
	-- Get the first character of the units string, and convert it to a multiplier.
	local unitMult = 1
	if units:sub(1, 1) == "k" then
		unitMult = 1e3
	elseif units:sub(1, 1) == "M" then
		unitMult = 1e6
	elseif units:sub(1, 1) == "G" then
		unitMult = 1e9
	else
		error("toJoules: unknown unit: "..units)
	end
	return num * unitMult
end

return Export