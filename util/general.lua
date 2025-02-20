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
	return math.floor(x * 10^n) / 10^n
end


return Export