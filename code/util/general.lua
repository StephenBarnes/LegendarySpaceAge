local Export = {}

Export.die = function(message)
	log("ERROR: "..message)
	error(message)
	assert(false)
end

Export.filterExistingItems = function(possibleItems)
	-- Given a list of possible item IDs, returns a list of item IDs that are in data.raw.
	local existingItems = {}
	for _, itemName in pairs(possibleItems) do
		if data.raw.item[itemName] ~= nil then
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

return Export