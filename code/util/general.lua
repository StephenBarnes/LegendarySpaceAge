
local X = {} -- Exported values

X.die = function(message)
	log("ERROR: "..message)
	error(message)
	assert(false)
	return {}
end

X.filterExistingItems = function(possibleItems)
	-- Given a list of possible item IDs, returns a list of item IDs that are in data.raw.
	local existingItems = {}
	for _, itemName in pairs(possibleItems) do
		if data.raw.item[itemName] ~= nil then
			table.insert(existingItems, itemName)
		end
	end
	return existingItems
end

X.ifThenElse = function(condition, thenValue, elseValue)
	if condition then
		return thenValue
	else
		return elseValue
	end
end

X.trimAmt = function(original, trim)
	if original < 0 then
		return original + trim
	else
		return original - trim
	end
end
X.trimBox = function(box, amt)
	for i = 1, 2 do for j = 1, 2 do
		box[i][j] = X.trimAmt(box[i][j], amt)
	end end
end

return X